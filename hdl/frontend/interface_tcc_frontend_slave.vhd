library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.interface_tcc_package.all;

entity interface_tcc_frontend_slave is
    generic(
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
        
            -- Write request signals.
            AWVALID: out std_logic;
            AWREADY: in std_logic;
            AW_ID  : out std_logic_vector(g_ID_W_WIDTH - 1 downto 0) := (others => '0');
            AWADDR : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
            AWLEN  : out std_logic_vector(7 downto 0) := (others => '0');
            AWSIZE : out std_logic_vector(2 downto 0) := (others => '0');
            AWBURST: out std_logic_vector(1 downto 0) := (others => '0');
            
            -- Write data signals.
            WVALID : out std_logic;
            WREADY : in std_logic;
            WDATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
            WLAST  : out std_logic;
            
            -- Write response signals.
            BVALID : out std_logic;
            BREADY : in std_logic;
            BRESP  : out std_logic_vector(g_BRESP_WIDTH - 1 downto 0) := (others => '0');
            
            -- Read request signals.
            ARVALID: out std_logic;
            ARREADY: in std_logic;
            AR_ID  : out std_logic_vector(g_ID_R_WIDTH - 1 downto 0) := (others => '0');
            ARADDR : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
            ARLEN  : out std_logic_vector(7 downto 0) := (others => '0');
            ARSIZE : out std_logic_vector(2 downto 0) := (others => '0');
            ARBURST: out std_logic_vector(1 downto 0) := (others => '0');
            
            -- Read data signals.
            RVALID : out std_logic;
            RREADY : in std_logic;
            RDATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
            RLAST  : out std_logic;
            RRESP  : in std_logic_vector(g_RRESP_WIDTH - 1 downto 0) := (others => '0');
        
        -- Backend signals.
        i_SPC_READY : in  std_logic;
        i_SPC_OPC   : in  std_logic_vector(c_OPC_WIDTH - 1 downto 0);
        i_SPC_ADDR  : in  std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
        i_SPC_DATA  : in  std_logic_vector(g_DATA_WIDTH - 1 downto 0);
        o_SPC_START : out std_logic;
        o_SPC_OPC   : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
        o_SPC_DATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0)
    );
end interface_tcc_frontend_slave;

architecture arch_interface_tcc_frontend_slave of interface_tcc_frontend_slave is
begin
end arch_interface_tcc_frontend_slave;