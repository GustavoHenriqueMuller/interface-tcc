library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_depacketizer_control is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_READY_RECEIVE_PACKET: in std_logic;
        i_READY_RECEIVE_DATA  : in std_logic;
        o_VALID_RECEIVE_DATA  : out std_logic;
        o_LAST_RECEIVE_DATA   : out std_logic;

        -- Buffer.
        i_FLIT          : in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        o_READ_BUFFER   : out std_logic;
        i_READ_OK_BUFFER: in std_logic;

        -- Headers.
        o_WRITE_H_INTERFACE_REG: out std_logic
    );
end backend_master_depacketizer_control;

architecture rtl of backend_master_depacketizer_control is
    type t_STATE is (S_H_DEST, S_H_SRC, S_H_INTERFACE,
                     S_READ_RESPONSE_PAYLOAD, S_WRITE_RESPONSE, S_TRAILER);
    signal r_STATE: t_STATE;
    signal r_NEXT_STATE: t_STATE;

    signal r_PAYLOAD_COUNTER: unsigned(7 downto 0) := to_unsigned(255, 8);
    signal r_SET_PAYLOAD_COUNTER: std_logic := '0';
    signal r_SUBTRACT_PAYLOAD_COUNTER: std_logic := '0';

begin
    ---------------------------------------------------------------------------------------------
    -- Update current state on clock rising edge.
    process (all)
    begin
        if (ARESETn = '0') then
            r_STATE <= S_H_DEST;
        elsif (rising_edge(ACLK)) then
            r_STATE <= r_NEXT_STATE;
        end if;
    end process;

    ---------------------------------------------------------------------------------------------
    -- State machine.
    process (all)
    begin
        case r_STATE is
            when S_H_DEST => if (i_READ_OK_BUFFER = '1') then r_NEXT_STATE <= S_H_SRC; else r_NEXT_STATE <= S_H_DEST; end if;

            when S_H_SRC => if (i_READ_OK_BUFFER = '1') then r_NEXT_STATE <= S_H_INTERFACE; else r_NEXT_STATE <= S_H_SRC; end if;

            when S_H_INTERFACE => if (i_READ_OK_BUFFER = '1') then
                                      if (i_FLIT(0) = '0') then
                                          -- Write response. Next flit is trailer.
                                          r_NEXT_STATE <= S_WRITE_RESPONSE;
                                      else
                                          -- Read response.
                                          r_NEXT_STATE <= S_READ_RESPONSE_PAYLOAD;
                                      end if;
                                  else
                                      r_NEXT_STATE <= S_H_INTERFACE;
                                  end if;

            when S_READ_RESPONSE_PAYLOAD => if (r_PAYLOAD_COUNTER = to_unsigned(1, 8) and i_READY_RECEIVE_DATA = '1' and i_READ_OK_BUFFER = '1') then
                                                r_NEXT_STATE <= S_TRAILER;
                                            else
                                                r_NEXT_STATE <= S_READ_RESPONSE_PAYLOAD;
                                            end if;

            when S_WRITE_RESPONSE => if (i_READY_RECEIVE_PACKET = '1') then r_NEXT_STATE <= S_TRAILER; else r_NEXT_STATE <= S_WRITE_RESPONSE; end if;

            when S_TRAILER => if (i_READ_OK_BUFFER = '1') then r_NEXT_STATE <= S_H_DEST; else r_NEXT_STATE <= S_TRAILER; end if;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Payload counter.
    process (all)
    begin
        if (ARESETn = '0') then
            r_PAYLOAD_COUNTER <= to_unsigned(255, 8);
        elsif (rising_edge(ACLK)) then
            if (r_SET_PAYLOAD_COUNTER = '1') then
                r_PAYLOAD_COUNTER <= unsigned(i_FLIT(15 downto 8));
            elsif (r_SUBTRACT_PAYLOAD_COUNTER = '1') then
                r_PAYLOAD_COUNTER <= r_PAYLOAD_COUNTER - 1;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Internal signals.
    r_SET_PAYLOAD_COUNTER      <= '1' when (r_STATE = S_H_INTERFACE) else '0';
    r_SUBTRACT_PAYLOAD_COUNTER <= '1' when (r_STATE = S_READ_RESPONSE_PAYLOAD and i_READ_OK_BUFFER = '1' and i_READY_RECEIVE_DATA = '1') else '0';

    ---------------------------------------------------------------------------------------------
    -- Output values.
	o_READ_BUFFER <= '1' when (r_STATE = S_H_DEST) or
                              (r_STATE = S_H_SRC) or
                              (r_STATE = S_H_INTERFACE) or
                              (r_STATE = S_READ_RESPONSE_PAYLOAD and i_READY_RECEIVE_DATA = '1') or
                              (r_STATE = S_TRAILER)
                              else '0';

    o_VALID_RECEIVE_DATA <= '1' when (r_STATE = S_WRITE_RESPONSE) or
                                     (r_STATE = S_READ_RESPONSE_PAYLOAD and i_READ_OK_BUFFER = '1')
                                     else '0';
    o_LAST_RECEIVE_DATA  <= '1' when (r_STATE = S_READ_RESPONSE_PAYLOAD and i_READ_OK_BUFFER = '1' and r_PAYLOAD_COUNTER = to_unsigned(1, 8)) else '0';

    o_WRITE_H_INTERFACE_REG <= '1' when (r_STATE = S_H_INTERFACE) else '0';
end rtl;