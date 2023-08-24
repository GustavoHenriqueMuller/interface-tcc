library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_backend_master_send_control is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_VALID : in std_logic;
    	i_OPC   : in std_logic;
		i_ADDR  : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
		i_BURST : in std_logic_vector(1 downto 0);
		i_LENGTH: in std_logic_vector(7 downto 0);
		i_DATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);

		o_READY : out std_logic;

        -- XINA signals.
        l_out_data_i : in std_logic_vector(data_width_c downto 0);
        l_out_val_i  : in std_logic;
        l_in_ack_i   : in std_logic;
        l_in_data_o  : out std_logic_vector(data_width_c downto 0);
        l_in_val_o   : out std_logic;
        l_out_ack_o  : out std_logic
    );
end tcc_backend_master_send_control;

architecture arch_tcc_backend_master_send_control of tcc_backend_master_send_control is
    type t_STATE is (S_IDLE, S_WAITING_FOR_ACK, S_ACK_BACK);
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
    process (r_CURRENT_STATE, i_VALID, l_in_ack_i)
    begin
        case r_CURRENT_STATE is
            when S_IDLE =>  if (i_VALID = '1') then
                                r_NEXT_STATE <= S_WAITING_FOR_ACK;
                            else
                                r_NEXT_STATE <= S_IDLE;
                            end if;

            when S_WAITING_FOR_ACK => if (l_in_ack_i = '1') then
                                          r_NEXT_STATE <= S_IDLE;
                                      else
                                          r_NEXT_STATE <= S_WAITING_FOR_ACK;
                                      end if;

            when S_ACK_BACK => r_NEXT_STATE <= S_IDLE;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values (front-end).
    o_READY <= '1' when (r_CURRENT_STATE = S_IDLE) else '0';

    ---------------------------------------------------------------------------------------------
    -- Output values (NoC).
    l_in_data_o  <= '1' & i_DATA when (r_CURRENT_STATE = S_WAITING_FOR_ACK) else (data_width_c downto 0 => '0'); -- @TODO: BOP.
    l_in_val_o   <= '1' when (r_CURRENT_STATE = S_WAITING_FOR_ACK) else '0';
    l_out_ack_o  <= '1' when (r_CURRENT_STATE = S_ACK_BACK) else '0';

end arch_tcc_backend_master_send_control;