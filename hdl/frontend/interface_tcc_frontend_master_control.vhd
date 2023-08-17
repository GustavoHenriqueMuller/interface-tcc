library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.interface_tcc_package.all;

entity interface_tcc_frontend_master_send_control is
    port (
        ACLK: in std_logic;
        ARESETn: in std_logic;
        
        -- Signals from front-end.
        AWVALID: in std_logic;
        AWADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        AWLEN  : in std_logic_vector(7 downto 0);
        AWBURST: in std_logic_vector(1 downto 0);
        WLAST  : in std_logic;
        
        ARVALID: in std_logic;
        ARADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        ARLEN  : in std_logic_vector(7 downto 0);
        ARBURST: in std_logic_vector(1 downto 0);
        RLAST  : in std_logic;
        
        -- Signals to back-end.
        o_BACKEND_OPC   : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
        o_BACKEND_ADDR  : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        o_BACKEND_BURST : out std_logic_vector(1 downto 0);
        o_BACKEND_TYPE  : out std_logic;
        o_BACKEND_LENGTH: out std_logic_vector(7 downto 0);
        o_BACKEND_START : out std_logic;
        -- @TODO: o_BACKEND_ID, o_BACKEND_DATA
    );
end interface_tcc_frontend_master_send_control;

architecture arch_interface_tcc_frontend_master_send_control of interface_tcc_frontend_master_send_control is
    type t_STATE is (S_IDLE, S_START_WRITE_TRANSACTION, S_WRITE_TRANSACTION, S_START_READ_TRANSACTION, S_READ_TRANSACTION);
    signal r_CURRENT_STATE: t_STATE;
    signal r_NEXT_STATE   : t_STATE;
    
    ---------------------------------------------------------------------------------------------
    -- Update current state on clock rising edge.
    process (ACLK, ARESETn)
    begin
        if (ARESETn = '0') then
            r_CURRENT_STATE <= S_IDLE;
        elsif (rising_edge(i_CLK)) then
            r_CURRENT_STATE <= r_NEXT_STATE;
        end if;
    end process;
    
    ---------------------------------------------------------------------------------------------
    -- State machine.
    process (r_CURRENT_STATE, AWVALID, WLAST, ARVALID, RLAST)
    begin
        case r_CURRENT_STATE is
            when S_IDLE =>  if (AWVALID = '1') then
                                r_NEXT_STATE <= S_START_WRITE_TRANSACTION;    
                            elsif (ARVALID = '1') then
                                r_NEXT_STATE <= S_START_READ_TRANSACTION;
                            else
                                r_NEXT_STATE <= S_IDLE;
                            end if;
                            
            when S_START_WRITE_TRANSACTION => r_NEXT_STATE <= S_WRITE_TRANSACTION;
                            
            when S_WRITE_TRANSACTION => if (WLAST = '1') then
                                            r_NEXT_STATE <= S_IDLE;
                                        else
                                            r_NEXT_STATE <= S_WRITE_TRANSACTION;
                                        end if;
                                        
            when S_START_READ_TRANSACTION => r_NEXT_STATE <= S_READ_TRANSACTION;
                                        
            when S_READ_TRANSACTION => if (RLAST = '1') then
                                            r_NEXT_STATE <= S_IDLE;
                                        else
                                            r_NEXT_STATE <= S_READ_TRANSACTION;
                                        end if;
                            
            when others => r_NEXT_STATE <= S_IDLE;
        end case;
    end process;
    
    ---------------------------------------------------------------------------------------------
    -- Output values.
    o_BACKEND_OPC   <= '0' when (r_CURRENT_STATE = S_IDLE or r_CURRENT_STATE = S_WRITE_TRANSACTION) else '1';
    
    o_BACKEND_ADDR  <= AWADDR when (r_CURRENT_STATE = S_WRITE_TRANSACTION)
                       else ARADDR when (r_CURRENT_STATE = S_READ_TRANSACTION)
                       else (c_ADDR_WIDTH - 1 downto 0 => '0');
                      -- @TODO: Código acima é ideal?
                      
    o_BACKEND_BURST <= AWBURST when (r_CURRENT_STATE = S_WRITE_TRANSACTION)
                       else ARBURST when (r_CURRENT_STATE = S_READ_TRANSACTION)
                       else (1 downto 0 => '0');
                       
    o_BACKEND_TYPE <= '0'; -- '0' = Request. -- @TODO: Isso não deveria ser uma constante?
    
    o_BACKEND_LENGTH <= AWLEN when (r_CURRENT_STATE = S_WRITE_TRANSACTION)
                        else ARLEN when (r_CURRENT_STATE = S_READ_TRANSACTION)
                        else (7 downto 0 => '0');
                        
    o_BACKEND_START <= '1' when (r_CURRENT_STATE = S_START_WRITE_TRANSACTION or r_CURRENT_STATE = S_START_READ_TRANSACTION)
                        else '0';
                        
end arch_interface_tcc_frontend_master_send_control;