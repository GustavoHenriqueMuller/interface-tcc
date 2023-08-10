library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.interface_tcc_package.all;

entity interface_tcc_frontend_master is
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
            AWVALID: in std_logic;
            AWREADY: out std_logic;
            AW_ID  : in std_logic_vector(g_ID_W_WIDTH - 1 downto 0) := (others => '0');
            AWADDR : in std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
            AWLEN  : in std_logic_vector(7 downto 0) := (others => '0');
            AWSIZE : in std_logic_vector(2 downto 0) := (others => '0');
            AWBURST: in std_logic_vector(1 downto 0) := (others => '0');
            
            -- Write data signals.
            WVALID : in std_logic;
            WREADY : out std_logic;
            WDATA  : in std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
            WLAST  : in std_logic;
            
            -- Write response signals.
            BVALID : in std_logic;
            BREADY : out std_logic;
            BRESP  : in std_logic_vector(g_BRESP_WIDTH - 1 downto 0) := (others => '0');
            
            -- Read request signals.
            ARVALID: in std_logic;
            ARREADY: out std_logic;
            AR_ID  : in std_logic_vector(g_ID_R_WIDTH - 1 downto 0) := (others => '0');
            ARADDR : in std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
            ARLEN  : in std_logic_vector(7 downto 0) := (others => '0');
            ARSIZE : in std_logic_vector(2 downto 0) := (others => '0');
            ARBURST: in std_logic_vector(1 downto 0) := (others => '0');
            
            -- Read data signals.
            RVALID : in std_logic;
            RREADY : out std_logic;
            RDATA  : in std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
            RLAST  : in std_logic;
            RRESP  : out std_logic_vector(g_RRESP_WIDTH - 1 downto 0) := (others => '0');
        
        -- Backend signals.
        i_SPC_OPC  : in  std_logic_vector(c_OPC_WIDTH - 1 downto 0);
        i_SPC_DATA : in  std_logic_vector(g_DATA_WIDTH - 1 downto 0);
        i_SPC_WAIT : in  std_logic;
        o_SPC_START: out std_logic;
        o_SPC_OPC  : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
        o_SPC_ADDR : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
        o_SPC_DATA : out std_logic_vector(g_DATA_WIDTH - 1 downto 0)
    );
end interface_tcc_frontend_master;

architecture arch_interface_tcc_frontend_master of interface_tcc_frontend_master is
begin
end arch_interface_tcc_frontend_master;