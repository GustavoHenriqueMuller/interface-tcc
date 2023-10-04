library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity send_control is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Buffer signals.
        i_READ_OK_BUFFER: in std_logic;
		o_READ_BUFFER   : out std_logic;

        -- XINA signals.
        l_in_val_i: out std_logic;
        l_in_ack_o: in std_logic
    );
end send_control;

architecture rtl of send_control is
    type t_STATE is (S_IDLE, S_WAITING_ACK_ONE, S_WAITING_ACK_ZERO, S_READ_BUFFER);
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
            when S_IDLE => r_NEXT_STATE <= S_WAITING_ACK_ONE when (i_READ_OK_BUFFER = '1') else S_IDLE;

            when S_WAITING_ACK_ONE => r_NEXT_STATE <= S_WAITING_ACK_ZERO when (l_in_ack_o = '1') else S_WAITING_ACK_ONE;

            when S_WAITING_ACK_ZERO => r_NEXT_STATE <= S_READ_BUFFER when (l_in_ack_o = '0') else S_WAITING_ACK_ZERO;

            when S_READ_BUFFER => r_NEXT_STATE <= S_WAITING_ACK_ONE when (i_READ_OK_BUFFER = '1') else S_IDLE;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values (buffer).
    o_READ_BUFFER <= '1' when (r_STATE = S_READ_BUFFER) else '0';

    ---------------------------------------------------------------------------------------------
    -- Output values (NoC).
    l_in_val_i <= '1' when (r_STATE = S_IDLE and i_READ_OK_BUFFER = '1') or
                           (r_STATE = S_WAITING_ACK_ONE) else '0';

end rtl;