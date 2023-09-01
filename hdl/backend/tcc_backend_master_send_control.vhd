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
        i_VALID: in std_logic;
        i_FLIT : in std_logic_vector(data_width_c downto 0);
		o_READY: out std_logic;

        -- XINA signals.
        l_in_data_i: out std_logic_vector(data_width_c downto 0);
        l_in_val_i : out std_logic;
        l_in_ack_o : in std_logic
    );
end tcc_backend_master_send_control;

architecture arch_tcc_backend_master_send_control of tcc_backend_master_send_control is
    type t_STATE is (S_IDLE, S_WAITING_FOR_ACK_TO_ONE, S_WAITING_FOR_ACK_TO_ZERO);
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
                               r_NEXT_STATE <= S_WAITING_FOR_ACK_TO_ONE;
                           else
                               r_NEXT_STATE <= S_IDLE;
                           end if;

            when S_WAITING_FOR_ACK_TO_ONE => if (l_in_ack_o = '1') then
                                                r_NEXT_STATE <= S_WAITING_FOR_ACK_TO_ZERO;
                                             else
                                                r_NEXT_STATE <= S_WAITING_FOR_ACK_TO_ONE;
                                             end if;

            when S_WAITING_FOR_ACK_TO_ZERO => if (l_in_ack_o = '0') then
                                                 r_NEXT_STATE <= S_IDLE;
                                              else
                                                 r_NEXT_STATE <= S_WAITING_FOR_ACK_TO_ZERO;
                                              end if;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values (front-end).
    o_READY <= '1' when (r_CURRENT_STATE = S_IDLE) else '0';

    ---------------------------------------------------------------------------------------------
    -- Output values (NoC).
    l_in_data_i <= i_FLIT;
    l_in_val_i  <= '1' when (r_CURRENT_STATE = S_WAITING_FOR_ACK_TO_ONE) else '0';

end arch_tcc_backend_master_send_control;