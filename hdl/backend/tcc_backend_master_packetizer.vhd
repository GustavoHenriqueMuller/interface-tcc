library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_backend_master_packetizer is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
    	i_OPC   : in std_logic;
		i_ADDR  : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
		i_BURST : in std_logic_vector(1 downto 0);
		i_LENGTH: in std_logic_vector(7 downto 0);
		i_DATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);

        i_START_PACKET   : in std_logic;
        i_VALID          : in std_logic;
        i_LAST           : in std_logic;
        i_WRITE_OK_BUFFER: in std_logic;

		o_FLIT        : out std_logic_vector(c_DATA_WIDTH downto 0);
        o_WRITE_BUFFER: out std_logic;
        o_READY       : out std_logic
    );
end tcc_backend_master_packetizer;

architecture arch_tcc_backend_master_packetizer of tcc_backend_master_packetizer is
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
    process (ACLK, i_START_PACKET, i_WRITE_OK_BUFFER, i_VALID, i_LAST)
    begin
        case r_CURRENT_STATE is
            when S_IDLE => if (i_START_PACKET = '1') then
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

            when S_PAYLOAD => if (i_VALID = '1' and i_LAST = '1') then
                                 r_NEXT_STATE <= S_PAYLOAD_WAIT_OK;
                              else
                                 r_NEXT_STATE <= S_PAYLOAD;
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
    o_FLIT <= '1' & "1111111111111111" & "1111111111111111" when (r_CURRENT_STATE = S_HEADER_1_WAIT_OK) else
              '0' & "1100110011001100" & "1100110011001100" when (r_CURRENT_STATE = S_HEADER_2_WAIT_OK) else
              '0' & i_DATA when (r_CURRENT_STATE = S_PAYLOAD_WAIT_OK) else
              '1' & "10101010101010101010101010101010" when (r_CURRENT_STATE = S_TRAILER_WAIT_OK) else
              (data_width_c downto 0 => '0');

              -- @TODO: Mudar código acima.

    o_WRITE_BUFFER <= '1' when (r_CURRENT_STATE = S_HEADER_1) or
                               (r_CURRENT_STATE = S_HEADER_2) or
                               (r_CURRENT_STATE = S_PAYLOAD and i_VALID = '1') or
                               (r_CURRENT_STATE = S_TRAILER) else '0';

    o_READY <= '1' when (r_CURRENT_STATE = S_IDLE or r_CURRENT_STATE = S_PAYLOAD) else '0';

end arch_tcc_backend_master_packetizer;