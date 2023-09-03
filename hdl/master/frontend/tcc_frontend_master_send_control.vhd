library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;

entity tcc_frontend_master_send_control is
    port (
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Signals from front-end.
        AWVALID: in std_logic;
        WLAST  : in std_logic;
        WVALID : in std_logic;
        ARVALID: in std_logic;

        -- Signals to front-end.
        AWREADY: out std_logic;
        WREADY : out std_logic;
        ARREADY: out std_logic;

        -- Signals from backend.
        i_BACKEND_READY: in std_logic;

        -- Signals to back-end.
        o_BACKEND_VALID: out std_logic;
        o_BACKEND_LAST : out std_logic;
        o_OPERATION    : out std_logic
    );
end tcc_frontend_master_send_control;

architecture arch_tcc_frontend_master_send_control of tcc_frontend_master_send_control is
    type t_STATE is (S_IDLE, S_WAIT_HEADERS_WRITE, S_WAIT_HEADERS_READ,
                             S_WRITE_TRANSFER, S_READ_TRANSFER);
    signal r_CURRENT_STATE: t_STATE;
    signal r_NEXT_STATE   : t_STATE;

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
    process (ACLK, AWVALID, ARVALID, i_BACKEND_READY, WLAST)
    begin
        case r_CURRENT_STATE is
            when S_IDLE =>  if (AWVALID = '1' and i_BACKEND_READY = '1') then
                                r_NEXT_STATE <= S_WAIT_HEADERS_WRITE;
                            elsif (ARVALID = '1' and i_BACKEND_READY = '1') then
                                r_NEXT_STATE <= S_WAIT_HEADERS_READ;
                            else
                                r_NEXT_STATE <= S_IDLE;
                            end if;

            when S_WAIT_HEADERS_WRITE => if (i_BACKEND_READY = '1') then
                                             r_NEXT_STATE <= S_WRITE_TRANSFER;
                                         else
                                             r_NEXT_STATE <= S_WAIT_HEADERS_WRITE;
                                         end if;

            when S_WAIT_HEADERS_READ => if (i_BACKEND_READY = '1') then
                                            r_NEXT_STATE <= S_READ_TRANSFER;
                                        else
                                            r_NEXT_STATE <= S_WAIT_HEADERS_READ;
                                        end if;

            when S_WRITE_TRANSFER => if (WLAST = '1' and i_BACKEND_READY = '1') then
                                         r_NEXT_STATE <= S_IDLE;
                                     else
                                         r_NEXT_STATE <= S_WRITE_TRANSFER;
                                     end if;

            when S_READ_TRANSFER => if (i_BACKEND_READY = '1') then
                                        r_NEXT_STATE <= S_IDLE;
                                    else
                                        r_NEXT_STATE <= S_READ_TRANSFER;
                                    end if;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values (front-end).
    AWREADY <= '1' when (r_CURRENT_STATE = S_IDLE and i_BACKEND_READY = '1') else '0';
    WREADY  <= '1' when (r_CURRENT_STATE = S_WRITE_TRANSFER and i_BACKEND_READY = '1') else '0';
    ARREADY <= '1' when (r_CURRENT_STATE = S_IDLE and i_BACKEND_READY = '1') else '0';

    ---------------------------------------------------------------------------------------------
    -- Output values (back-end).
    o_BACKEND_VALID <= '1' when ((r_CURRENT_STATE = S_IDLE and r_NEXT_STATE = S_WAIT_HEADERS_WRITE) or
                                 (r_CURRENT_STATE = S_IDLE and r_NEXT_STATE = S_WAIT_HEADERS_READ) or
                                 (r_CURRENT_STATE = S_WRITE_TRANSFER and WVALID = '1') or
                                 r_CURRENT_STATE = S_READ_TRANSFER)
                                else '0';

    o_BACKEND_LAST  <= '1' when ((r_CURRENT_STATE = S_WRITE_TRANSFER and WLAST = '1')
                               or r_CURRENT_STATE = S_READ_TRANSFER)
                               else '0';

    o_OPERATION     <= '0' when (r_CURRENT_STATE = S_WAIT_HEADERS_WRITE or r_CURRENT_STATE = S_WRITE_TRANSFER) else '1';

end arch_tcc_frontend_master_send_control;