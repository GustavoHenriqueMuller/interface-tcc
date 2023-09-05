library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_receive_control is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Buffer signals.
        i_WRITE_OK_BUFFER: in std_logic;
		o_WRITE_BUFFER   : out std_logic;

        -- XINA signals.
        l_out_val_o: in std_logic;
        l_out_ack_i: out std_logic
    );
end backend_master_receive_control;

architecture arch_backend_master_receive_control of backend_master_receive_control is
    type t_STATE is (S_IDLE, S_WRITING_TO_BUFFER, S_FINISH_WRITING);
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
    process (ACLK, i_WRITE_OK_BUFFER, l_out_val_o)
    begin
        case r_CURRENT_STATE is
            when S_IDLE => if (l_out_val_o = '1') then
                               r_NEXT_STATE <= S_WRITING_TO_BUFFER;
                           else
                               r_NEXT_STATE <= S_IDLE;
                           end if;

            when S_WRITING_TO_BUFFER => if (i_WRITE_OK_BUFFER = '1') then
                                            r_NEXT_STATE <= S_FINISH_WRITING;
                                        else
                                            r_NEXT_STATE <= S_WRITING_TO_BUFFER;
                                        end if;

            when S_FINISH_WRITING => r_NEXT_STATE <= S_IDLE;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values (buffer).
    o_WRITE_BUFFER <= '1' when (r_CURRENT_STATE = S_WRITING_TO_BUFFER) else '0';

    ---------------------------------------------------------------------------------------------
    -- Output values (NoC).
    l_out_ack_i <= '1' when (r_CURRENT_STATE /= S_IDLE) else '0';

end arch_backend_master_receive_control;