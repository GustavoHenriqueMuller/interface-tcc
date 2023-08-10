library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.interface_tcc_package.all;
use work.xina_package.all;

entity interface_tcc_backend is
    generic(
        -- Interface attributes.
        g_TYPE: string  := "MASTER"; -- "MASTER" or "SLAVE"
        
        -- AMBA AXI 5 attributes.
        g_ID_W_WIDTH : natural := 5;
        g_ID_R_WIDTH : natural := 5;
        g_ADDR_WIDTH : natural := 8;
        g_DATA_WIDTH : natural := 32;
        g_BRESP_WIDTH: natural := 3;
        g_RRESP_WIDTH: natural := 3
    );
    
    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic;
        ARESETn: in std_logic;
        
        -- Backend signals.
        i_SPC_START : in std_logic;
        i_SPC_OPC   : in std_logic_vector(c_OPC_WIDTH - 1 downto 0);
        i_SPC_ADDR  : in std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
        i_SPC_DATA  : in std_logic_vector(g_DATA_WIDTH - 1 downto 0);
        
        o_SPC_READY : out std_logic;
        o_SPC_OPC   : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
        o_SPC_ADDR  : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
        o_SPC_DATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0);
        o_SPC_WAIT  : out std_logic;
        
        -- XINA signals.
        l_in_data_o  : out data_link_l_t;
        l_in_val_o   : out ctrl_link_l_t;
        l_in_ack_i   : in ctrl_link_l_t;
        l_out_data_i : in data_link_l_t;
        l_out_val_i  : in ctrl_link_l_t;
        l_out_ack_o  : out ctrl_link_l_t
    );
end interface_tcc_backend;

architecture arch_interface_tcc_backend of interface_tcc_backend is
begin
    
end arch_interface_tcc_backend;