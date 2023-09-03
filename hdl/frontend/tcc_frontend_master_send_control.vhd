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
        AW_ID  : in std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
        AWADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        AWLEN  : in std_logic_vector(7 downto 0);
        AWBURST: in std_logic_vector(1 downto 0);
        WDATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        WLAST  : in std_logic;
        WVALID : in std_logic;

        ARVALID: in std_logic;
        AR_ID  : in std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
        ARADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        ARLEN  : in std_logic_vector(7 downto 0);
        ARBURST: in std_logic_vector(1 downto 0);

        -- Signals to front-end.
        AWREADY: out std_logic;
        WREADY : out std_logic;
        ARREADY: out std_logic;

        -- Signals from backend.
        i_BACKEND_READY : in std_logic;

        -- Signals to back-end.
        o_BACKEND_START_PACKET: out std_logic;
        o_BACKEND_VALID : out std_logic;
        o_BACKEND_LAST  : out std_logic;
        o_BACKEND_OPC   : out std_logic;
        o_BACKEND_ADDR  : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        o_BACKEND_BURST : out std_logic_vector(1 downto 0);
        o_BACKEND_LENGTH: out std_logic_vector(7 downto 0);
        o_BACKEND_DATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        o_BACKEND_ID    : out std_logic_vector(c_ID_WIDTH - 1 downto 0)
    );
end tcc_frontend_master_send_control;

architecture arch_tcc_frontend_master_send_control of tcc_frontend_master_send_control is
    type t_STATE is (S_IDLE, S_WAIT_PACKET_HEADERS_WRITE, S_WAIT_PACKET_HEADERS_READ, S_WRITE_TRANSACTION, S_READ_TRANSACTION);
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
                                r_NEXT_STATE <= S_WAIT_PACKET_HEADERS_WRITE;
                            elsif (ARVALID = '1' and i_BACKEND_READY = '1') then
                                r_NEXT_STATE <= S_WAIT_PACKET_HEADERS_READ;
                            else
                                r_NEXT_STATE <= S_IDLE;
                            end if;

            when S_WAIT_PACKET_HEADERS_WRITE => if (i_BACKEND_READY = '1') then
                                                    r_NEXT_STATE <= S_WRITE_TRANSACTION;
                                                end if;

            when S_WAIT_PACKET_HEADERS_READ => if (i_BACKEND_READY = '1') then
                                                   r_NEXT_STATE <= S_READ_TRANSACTION;
                                               end if;

            when S_WRITE_TRANSACTION => if (WLAST = '1' and i_BACKEND_READY = '1') then
                                            r_NEXT_STATE <= S_IDLE;
                                        else
                                            r_NEXT_STATE <= S_WRITE_TRANSACTION;
                                        end if;

            when S_READ_TRANSACTION =>  r_NEXT_STATE <= S_IDLE;

            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values (front-end).
    AWREADY <= '1' when (r_CURRENT_STATE = S_IDLE and i_BACKEND_READY = '1') else '0';
    WREADY <= '1' when (r_CURRENT_STATE = S_WRITE_TRANSACTION and i_BACKEND_READY = '1') else '0';
    ARREADY <= '1' when (r_NEXT_STATE = S_READ_TRANSACTION) else '0';

    ---------------------------------------------------------------------------------------------
    -- Output values (back-end).
    o_BACKEND_START_PACKET <= '1' when (r_NEXT_STATE = S_WRITE_TRANSACTION) or (r_NEXT_STATE = S_READ_TRANSACTION)
                              else '0';

    o_BACKEND_VALID <= '1' when ((r_CURRENT_STATE = S_WRITE_TRANSACTION and WVALID = '1')
                           or r_CURRENT_STATE = S_READ_TRANSACTION)
                           else '0';

    o_BACKEND_LAST <= '1' when ((r_CURRENT_STATE = S_WRITE_TRANSACTION and WLAST = '1')
                           or r_CURRENT_STATE = S_READ_TRANSACTION)
                           else '0';

    o_BACKEND_OPC <= '0' when (r_CURRENT_STATE = S_IDLE or r_CURRENT_STATE = S_WAIT_PACKET_HEADERS_WRITE) else '1';

    o_BACKEND_ADDR <= AWADDR when (r_CURRENT_STATE = S_WAIT_PACKET_HEADERS_WRITE)
                      else ARADDR when (r_CURRENT_STATE = S_WAIT_PACKET_HEADERS_READ)
                      else (c_ADDR_WIDTH - 1 downto 0 => '0');

    o_BACKEND_BURST <= AWBURST when (r_CURRENT_STATE = S_WAIT_PACKET_HEADERS_WRITE)
                       else ARBURST when (r_CURRENT_STATE = S_WAIT_PACKET_HEADERS_READ)
                       else (1 downto 0 => '0');

    o_BACKEND_LENGTH <= AWLEN when (r_CURRENT_STATE = S_WAIT_PACKET_HEADERS_WRITE)
                        else ARLEN when (r_CURRENT_STATE = S_WAIT_PACKET_HEADERS_READ)
                        else (7 downto 0 => '0');

    -- Read packages only have the read address as the payload.
    o_BACKEND_DATA <= WDATA when (r_CURRENT_STATE = S_WRITE_TRANSACTION)
					  else (c_DATA_WIDTH - 1 downto c_ADDR_WIDTH => '0') & ARADDR when (r_CURRENT_STATE = S_READ_TRANSACTION)
                      else (c_DATA_WIDTH - 1 downto 0 => '0');

    o_BACKEND_ID <= AW_ID when (r_CURRENT_STATE = S_WAIT_PACKET_HEADERS_WRITE)
                    else AR_ID when (r_CURRENT_STATE = S_WAIT_PACKET_HEADERS_READ)
                    else (c_ID_WIDTH - 1 downto 0 => '0');

end arch_tcc_frontend_master_send_control;