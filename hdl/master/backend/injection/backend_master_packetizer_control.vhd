library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_packetizer_control is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_OPC_SEND: in std_logic;
        i_START_SEND_PACKET: in std_logic;
        i_VALID_SEND_DATA  : in std_logic;
        i_LAST_SEND_DATA   : in std_logic;

        o_READY_SEND_PACKET: out std_logic;
        o_READY_SEND_DATA  : out std_logic;
        o_FLIT_SELECTOR    : out std_logic_vector(2 downto 0);

        i_WRITE_OK_BUFFER: in std_logic;
        o_WRITE_BUFFER   : out std_logic
    );
end backend_master_packetizer_control;

architecture arch_backend_master_packetizer_control of backend_master_packetizer_control is
    type t_STATE is (S_IDLE, S_HEADER_1, S_HEADER_2, S_ADDRESS, S_PAYLOAD, S_TRAILER);
    signal r_CURRENT_STATE: t_STATE;
    signal r_NEXT_STATE: t_STATE;

begin
    ---------------------------------------------------------------------------------------------
    -- Update current state on clock rising edge.
    process (all)
    begin
        if (ARESETn = '0') then
            r_CURRENT_STATE <= S_IDLE;
        elsif (rising_edge(ACLK)) then
            r_CURRENT_STATE <= r_NEXT_STATE;
        end if;
    end process;

    ---------------------------------------------------------------------------------------------
    -- State machine.
    process (all)
    begin
        case r_CURRENT_STATE is
            when S_IDLE => r_NEXT_STATE <= S_HEADER_1 when (i_START_SEND_PACKET = '1' and i_WRITE_OK_BUFFER = '1') else S_IDLE;

            when S_HEADER_1 => r_NEXT_STATE <= S_HEADER_2 when (i_WRITE_OK_BUFFER = '1') else S_HEADER_1;

            when S_HEADER_2 => r_NEXT_STATE <= S_ADDRESS when (i_WRITE_OK_BUFFER = '1') else S_HEADER_2;

            when S_ADDRESS => if (i_WRITE_OK_BUFFER = '1') then
                                  if (i_OPC_SEND = '0') then
                                      r_NEXT_STATE <= S_PAYLOAD; -- Write packet. Next flit is payload.
                                  else
                                      r_NEXT_STATE <= S_TRAILER; -- Read packet. Next flit is trailer.
                                  end if;
                              else
                                  r_NEXT_STATE <= S_ADDRESS;
                              end if;

            when S_PAYLOAD => if (i_VALID_SEND_DATA = '1' and i_WRITE_OK_BUFFER = '1' and i_LAST_SEND_DATA = '1') then
                                 r_NEXT_STATE <= S_TRAILER;
                              else
                                 r_NEXT_STATE <= S_PAYLOAD;
                              end if;

            when S_TRAILER => r_NEXT_STATE <= S_IDLE when (i_WRITE_OK_BUFFER = '1') else S_TRAILER;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values.
    o_FLIT_SELECTOR <= "000" when (r_CURRENT_STATE = S_HEADER_1) else
                       "001" when (r_CURRENT_STATE = S_HEADER_2) else
                       "010" when (r_CURRENT_STATE = S_ADDRESS) else
                       "011" when (r_CURRENT_STATE = S_PAYLOAD) else
                       "100" when (r_CURRENT_STATE = S_TRAILER) else
                       "111";

    o_WRITE_BUFFER <= '1' when (r_CURRENT_STATE = S_HEADER_1) or
                               (r_CURRENT_STATE = S_HEADER_2) or
                               (r_CURRENT_STATE = S_ADDRESS) or
                               (r_CURRENT_STATE = S_PAYLOAD and i_VALID_SEND_DATA = '1') or
                               (r_CURRENT_STATE  = S_TRAILER) else '0';

    o_READY_SEND_DATA <= '1' when (r_CURRENT_STATE = S_PAYLOAD and i_WRITE_OK_BUFFER = '1') else '0';

    o_READY_SEND_PACKET <= '1' when (r_CURRENT_STATE = S_IDLE and i_WRITE_OK_BUFFER = '1') else '0';

end arch_backend_master_packetizer_control;