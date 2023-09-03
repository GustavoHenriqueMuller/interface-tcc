library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_backend_master_packetizer_control is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_VALID          : in std_logic;
        i_LAST           : in std_logic;
        i_WRITE_OK_BUFFER: in std_logic;

        o_FLIT_SELECTOR: out std_logic_vector(1 downto 0);
        o_WRITE_BUFFER : out std_logic;
        o_READY        : out std_logic
    );
end tcc_backend_master_packetizer_control;

architecture arch_tcc_backend_master_packetizer_control of tcc_backend_master_packetizer_control is
    type t_STATE is (S_IDLE, S_HEADER_1, S_HEADER_1_WAIT_OK,
                             S_HEADER_2, S_HEADER_2_WAIT_OK,
                             S_PAYLOAD, S_PAYLOAD_WAIT_OK,
                             S_TRAILER, S_TRAILER_WAIT_OK);
    signal r_CURRENT_STATE: t_STATE;
    signal r_NEXT_STATE: t_STATE;

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
    process (ACLK, i_WRITE_OK_BUFFER, i_VALID, i_LAST)
    begin
        case r_CURRENT_STATE is
            when S_IDLE => if (i_VALID = '1') then
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

            when S_PAYLOAD => if (i_VALID = '1') then
                                 r_NEXT_STATE <= S_PAYLOAD_WAIT_OK;
                              else
                                 r_NEXT_STATE <= S_PAYLOAD;
                              end if;
            when S_PAYLOAD_WAIT_OK => if (i_WRITE_OK_BUFFER = '1') then
                                          if (i_LAST = '1') then
                                            r_NEXT_STATE <= S_TRAILER;
                                          else
                                            r_NEXT_STATE <= S_PAYLOAD;
                                          end if;
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
                               (r_CURRENT_STATE = S_PAYLOAD and i_VALID = '1') or
                               (r_CURRENT_STATE  = S_TRAILER) else '0';

    o_READY <= '1' when (r_CURRENT_STATE = S_IDLE or r_NEXT_STATE = S_IDLE) or
                        (r_NEXT_STATE = S_PAYLOAD)
                        else '0';

end arch_tcc_backend_master_packetizer_control;