library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity receive_control is
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
end receive_control;

architecture rtl of receive_control is
    type t_STATE is (S_IDLE, S_WRITE_BUFFER, S_WAIT_VAL_ZERO);
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
            when S_IDLE => if (l_out_val_o = '1' and i_WRITE_OK_BUFFER = '1') then r_NEXT_STATE <= S_WRITE_BUFFER; else r_NEXT_STATE <= S_IDLE; end if;

            when S_WRITE_BUFFER => r_NEXT_STATE <= S_WAIT_VAL_ZERO;

            when S_WAIT_VAL_ZERO => if (l_out_val_o = '0') then r_NEXT_STATE <= S_IDLE; else r_NEXT_STATE <= S_WAIT_VAL_ZERO; end if;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values (buffer).
    o_WRITE_BUFFER <= '1' when (r_STATE = S_WRITE_BUFFER) else '0';

    ---------------------------------------------------------------------------------------------
    -- Output values (NoC).
    l_out_ack_i <= '1' when (r_STATE = S_WAIT_VAL_ZERO) else '0';

end rtl;