library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_slave_packetizer_control is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_OPC_SEND        : in std_logic;
        i_VALID_SEND_DATA : in std_logic;
        i_LAST_SEND_DATA  : in std_logic;
        o_READY_SEND_DATA : out std_logic;
        o_FLIT_SELECTOR   : out std_logic_vector(2 downto 0);

        -- Signals from reception.
        i_HAS_REQUEST_PACKET   : in std_logic;
        o_HAS_FINISHED_RESPONSE: out std_logic;

        -- Buffer.
        i_WRITE_OK_BUFFER: in std_logic;
        o_WRITE_BUFFER   : out std_logic;

        -- Integrity control.
        o_ADD: out std_logic;
        o_INTEGRITY_RESETn: out std_logic
    );
end backend_slave_packetizer_control;

architecture rtl of backend_slave_packetizer_control is
    type t_STATE is (S_IDLE, S_H_DEST, S_H_SRC, S_H_INTERFACE, S_PAYLOAD, S_TRAILER);
    signal r_STATE: t_STATE;
    signal r_NEXT_STATE: t_STATE;

begin
    ---------------------------------------------------------------------------------------------
    -- Update current state on clock rising edge.
    process (all)
    begin
        if (ARESETn = '0') then
            r_STATE <= S_IDLE;
        elsif (rising_edge(ACLK)) then
            r_STATE <= r_NEXT_STATE;
        end if;
    end process;

    ---------------------------------------------------------------------------------------------
    -- State machine.
    process (all)
    begin
        case r_STATE is
            when S_IDLE => if (i_HAS_REQUEST_PACKET = '1' and i_VALID_SEND_DATA = '1' and i_WRITE_OK_BUFFER = '1') then r_NEXT_STATE <= S_H_DEST; else r_NEXT_STATE <= S_IDLE; end if;

            when S_H_DEST => if (i_WRITE_OK_BUFFER = '1') then r_NEXT_STATE <= S_H_SRC; else r_NEXT_STATE <= S_H_DEST; end if;

            when S_H_SRC => if (i_WRITE_OK_BUFFER = '1') then r_NEXT_STATE <= S_H_INTERFACE; else r_NEXT_STATE <= S_H_SRC; end if;

            when S_H_INTERFACE => if (i_WRITE_OK_BUFFER = '1') then
                                      if (i_OPC_SEND = '0') then
                                          r_NEXT_STATE <= S_TRAILER; -- Write packet. Next flit trailer.
                                      else
                                          r_NEXT_STATE <= S_PAYLOAD; -- Read packet. Next flit is payload.
                                      end if;
                                  else
                                      r_NEXT_STATE <= S_H_INTERFACE;
                                  end if;

            when S_PAYLOAD => if (i_VALID_SEND_DATA = '1' and i_WRITE_OK_BUFFER = '1' and i_LAST_SEND_DATA = '1') then
                                  r_NEXT_STATE <= S_TRAILER;
                              else
                                  r_NEXT_STATE <= S_PAYLOAD;
                              end if;

            when S_TRAILER => if (i_WRITE_OK_BUFFER = '1') then r_NEXT_STATE <= S_IDLE; else r_NEXT_STATE <= S_TRAILER; end if;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values.
    o_READY_SEND_DATA <= '1' when (r_STATE = S_IDLE and i_OPC_SEND = '0' and i_HAS_REQUEST_PACKET = '1') or -- For writes.
                                  (r_STATE = S_PAYLOAD and i_WRITE_OK_BUFFER = '1') -- For reads.
                                  else '0';

    o_FLIT_SELECTOR <= "000" when (r_STATE = S_H_DEST) else
                       "001" when (r_STATE = S_H_SRC) else
                       "010" when (r_STATE = S_H_INTERFACE) else
                       "011" when (r_STATE = S_PAYLOAD) else
                       "100" when (r_STATE = S_TRAILER) else
                       "111";

    o_HAS_FINISHED_RESPONSE <= '1' when (r_STATE = S_TRAILER and i_WRITE_OK_BUFFER = '1') else '0';

    o_WRITE_BUFFER <= '1' when (r_STATE = S_H_DEST) or
                               (r_STATE = S_H_SRC) or
                               (r_STATE = S_H_INTERFACE) or
                               (r_STATE = S_PAYLOAD and i_VALID_SEND_DATA = '1') or
                               (r_STATE = S_TRAILER) else '0';

    o_ADD <= '1' when ((r_STATE = S_H_DEST) or
                       (r_STATE = S_H_SRC) or
                       (r_STATE = S_H_INTERFACE) or
                       (r_STATE = S_PAYLOAD and i_VALID_SEND_DATA = '1')) and i_WRITE_OK_BUFFER = '1' else '0';

    o_INTEGRITY_RESETn <= '0' when (r_STATE = S_IDLE) else '1';
end rtl;