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

        i_VALID             : in std_logic;
        i_LAST              : in std_logic;
        i_READY_SEND_CONTROL: in std_logic;

		o_FLIT : out std_logic_vector(data_width_c downto 0);
        o_VALID: out std_logic;
        o_READY: out std_logic
    );
end tcc_backend_master_packetizer;

architecture arch_tcc_backend_master_packetizer of tcc_backend_master_packetizer is
    type t_STATE is (S_IDLE, S_HEADER, S_PAYLOAD, S_TRAILER);
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
            when S_IDLE => if (i_VALID = '1') then
                               r_NEXT_STATE <= S_HEADER;
                           else
                               r_NEXT_STATE <= S_IDLE;
                           end if;

            when S_HEADER => r_NEXT_STATE <= S_PAYLOAD;

            when S_PAYLOAD => if (i_LAST = '1') then
                                 r_NEXT_STATE <= S_TRAILER;
                              else
                                 r_NEXT_STATE <= S_PAYLOAD;
                              end if;

            when S_TRAILER => r_NEXT_STATE <= S_IDLE;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values.
    o_FLIT <= '1' & "1111111111111111" & "1111111111111111" when (r_CURRENT_STATE = S_HEADER) else
              '0' & i_DATA when (r_CURRENT_STATE = S_PAYLOAD) else
              '1' & "10101010101010101010101010101010" when (r_CURRENT_STATE = S_TRAILER) else
              (data_width_c downto 0 => '0');

    o_VALID <= '1' when (r_CURRENT_STATE = S_HEADER) or
                        (r_CURRENT_STATE = S_PAYLOAD and i_VALID = '1') or
                        (r_CURRENT_STATE = S_TRAILER) else '0';

    o_READY <= '1' when (r_CURRENT_STATE = S_IDLE and i_READY_SEND_CONTROL = '1') else '0';

end arch_tcc_backend_master_packetizer;