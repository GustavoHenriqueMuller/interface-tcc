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
        i_START_SEND_PACKET: in std_logic;
        o_READY_SEND_PACKET: out std_logic;
        i_VALID_SEND_DATA  : in std_logic;
        o_READY_SEND_DATA  : out std_logic;

        i_LAST: in std_logic;

        i_WRITE_OK_BUFFER: in std_logic;
        o_FLIT_SELECTOR  : out std_logic_vector(1 downto 0);
        o_WRITE_BUFFER   : out std_logic
    );
end backend_master_packetizer_control;

architecture arch_backend_master_packetizer_control of backend_master_packetizer_control is
    type t_STATE is (S_IDLE, S_HEADER_1, S_HEADER_1_WAIT_OK,
                             S_HEADER_2, S_HEADER_2_WAIT_OK,
                             S_PAYLOAD, S_PAYLOAD_WAIT_OK_LAST, S_PAYLOAD_WAIT_OK,
                             S_TRAILER, S_TRAILER_WAIT_OK);
    signal r_CURRENT_STATE: t_STATE;
    signal r_NEXT_STATE: t_STATE;

    -- @NOTE: Seria uma boa ideia fazer um contador que conta de 0 até o comprimento do pacote,
    -- (que vem do AWLEN para escrita ou ARLEN para leitura). Desse modo, mesmo que o pacote não tenha payload,
    -- não será escrito um flit com tudo zero no buffer. Mas pra fazer esse contador é necessário saber se
    -- a XINA requer que cada pacote tenha no mínimo um flit de payload.

begin
    ---------------------------------------------------------------------------------------------
    -- Update current state on clock rising edge.
    process (ACLK, ARESETn)
    begin
        if (ARESETn = '0') then
            r_CURRENT_STATE <= S_IDLE;
        elsif (rising_edge(ACLK)) then
            r_CURRENT_STATE <= r_NEXT_STATE;
        end if;
    end process;

    ---------------------------------------------------------------------------------------------
    -- State machine.
    process (ACLK, i_START_SEND_PACKET, i_WRITE_OK_BUFFER, i_VALID_SEND_DATA, i_LAST)
    begin
        case r_CURRENT_STATE is
            when S_IDLE => if (i_START_SEND_PACKET = '1') then
                               r_NEXT_STATE <= S_HEADER_1;
                           else
                               r_NEXT_STATE <= S_IDLE;
                           end if;

            when S_HEADER_1 => r_NEXT_STATE <= S_HEADER_1_WAIT_OK;
            when S_HEADER_1_WAIT_OK => if (i_WRITE_OK_BUFFER = '1') then
                                           r_NEXT_STATE <= S_HEADER_2;
                                       else
                                           r_NEXT_STATE <= S_HEADER_1_WAIT_OK;
                                       end if;

            when S_HEADER_2 => r_NEXT_STATE <= S_HEADER_2_WAIT_OK;
            when S_HEADER_2_WAIT_OK => if (i_WRITE_OK_BUFFER = '1') then
                                           r_NEXT_STATE <= S_PAYLOAD;
                                       else
                                           r_NEXT_STATE <= S_HEADER_2_WAIT_OK;
                                       end if;

            when S_PAYLOAD => if (i_VALID_SEND_DATA = '1') then
                                 if (i_LAST = '1') then
                                    r_NEXT_STATE <= S_PAYLOAD_WAIT_OK_LAST;
                                 else
                                    r_NEXT_STATE <= S_PAYLOAD_WAIT_OK;
                                 end if;
                              else
                                 r_NEXT_STATE <= S_PAYLOAD;
                              end if;
            when S_PAYLOAD_WAIT_OK_LAST => if (i_WRITE_OK_BUFFER = '1') then
                                               r_NEXT_STATE <= S_TRAILER;
                                           else
                                               r_NEXT_STATE <= S_PAYLOAD_WAIT_OK_LAST;
                                           end if;
            when S_PAYLOAD_WAIT_OK => if (i_WRITE_OK_BUFFER = '1') then
                                          r_NEXT_STATE <= S_PAYLOAD;
                                      else
                                          r_NEXT_STATE <= S_PAYLOAD_WAIT_OK;
                                      end if;

            when S_TRAILER => r_NEXT_STATE <= S_TRAILER_WAIT_OK;
            when S_TRAILER_WAIT_OK => if (i_WRITE_OK_BUFFER = '1') then
                                          r_NEXT_STATE <= S_IDLE;
                                      else
                                          r_NEXT_STATE <= S_TRAILER_WAIT_OK;
                                      end if;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values.
    o_FLIT_SELECTOR <= "00" when (r_CURRENT_STATE = S_HEADER_1) else
                       "01" when (r_CURRENT_STATE = S_HEADER_2) else
                       "10" when (r_CURRENT_STATE = S_PAYLOAD) else
                       "11" when (r_CURRENT_STATE = S_TRAILER) else
                       "XX";

    o_WRITE_BUFFER <= '1' when (r_CURRENT_STATE = S_HEADER_1) or
                               (r_CURRENT_STATE = S_HEADER_2) or
                               (r_CURRENT_STATE = S_PAYLOAD and i_VALID_SEND_DATA = '1') or
                               (r_CURRENT_STATE  = S_TRAILER) else '0';

    o_READY_SEND_DATA <= '1' when r_CURRENT_STATE = S_PAYLOAD else '0';

    o_READY_SEND_PACKET <= '1' when r_CURRENT_STATE = S_IDLE else '0';

end arch_backend_master_packetizer_control;