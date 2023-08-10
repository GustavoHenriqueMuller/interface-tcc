library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.interface_tcc_package.all;

entity interface_tcc_frontend is
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
        
            -- Write request signals.
            AWVALID: inout std_logic;
            AWREADY: inout std_logic;
            AW_ID  : inout std_logic_vector(g_ID_W_WIDTH - 1 downto 0) := (others => '0');
            AWADDR : inout std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
            AWLEN  : inout std_logic_vector(7 downto 0) := (others => '0');
            AWSIZE : inout std_logic_vector(2 downto 0) := (others => '0');
            AWBURST: inout std_logic_vector(1 downto 0) := (others => '0');
            
            -- Write data signals.
            WVALID : inout std_logic;
            WREADY : inout std_logic;
            WDATA  : inout std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
            WLAST  : inout std_logic;
            
            -- Write response signals.
            BVALID : inout std_logic;
            BREADY : inout std_logic;
            BRESP  : inout std_logic_vector(g_BRESP_WIDTH - 1 downto 0) := (others => '0');
            
            -- Read request signals.
            ARVALID: inout std_logic;
            ARREADY: inout std_logic;
            AR_ID  : inout std_logic_vector(g_ID_R_WIDTH - 1 downto 0) := (others => '0');
            ARADDR : inout std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
            ARLEN  : inout std_logic_vector(7 downto 0) := (others => '0');
            ARSIZE : inout std_logic_vector(2 downto 0) := (others => '0');
            ARBURST: inout std_logic_vector(1 downto 0) := (others => '0');
            
            -- Read data signals.
            RVALID : inout std_logic;
            RREADY : inout std_logic;
            RDATA  : inout std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
            RLAST  : inout std_logic;
            RRESP  : inout std_logic_vector(g_RRESP_WIDTH - 1 downto 0) := (others => '0');
        
        -- Backend signals.
        i_SPC_READY : in std_logic;
        i_SPC_OPC   : in std_logic_vector(c_OPC_WIDTH - 1 downto 0);
        i_SPC_ADDR  : in std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
        i_SPC_DATA  : in std_logic_vector(g_DATA_WIDTH - 1 downto 0);
        i_SPC_WAIT  : in std_logic;
        
        o_SPC_START : out std_logic;
        o_SPC_OPC   : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
        o_SPC_ADDR  : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
        o_SPC_DATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0)
    );
end interface_tcc_frontend;

architecture arch_interface_tcc_frontend of interface_tcc_frontend is
begin
    u_INTERFACE_TCC_MASTER:
        if (g_TYPE = "MASTER") generate
            u_INTERFACE_TCC_FRONTEND_MASTER: interface_tcc_frontend_master
                generic map(
                    g_ID_W_WIDTH => g_ID_W_WIDTH,
                    g_ID_R_WIDTH => g_ID_R_WIDTH,
                    g_ADDR_WIDTH => g_ADDR_WIDTH,
                    g_DATA_WIDTH => g_DATA_WIDTH,
                    g_BRESP_WIDTH => g_BRESP_WIDTH,
                    g_RRESP_WIDTH => g_RRESP_WIDTH
                )
                port map(
                    -- AMBA AXI 5 signals.
                    ACLK => ACLK,
                    ARESETn => ARESETn,
                    
                        -- Write request signals.
                        AWVALID => AWVALID,
                        AWREADY => AWREADY,
                        AW_ID   => AW_ID,
                        AWADDR  => AWADDR,
                        AWLEN   => AWLEN,
                        AWSIZE  => AWSIZE,
                        AWBURST => AWBURST,
                        
                        -- Write data signals.
                        WVALID  => WVALID,
                        WREADY  => WREADY,
                        WDATA   => WDATA,
                        WLAST   => WLAST,
                        
                        -- Write response signals.
                        BVALID  => BVALID,
                        BREADY  => BREADY,
                        BRESP   => BRESP,
                        
                        -- Read request signals.
                        ARVALID => ARVALID,
                        ARREADY => ARREADY,
                        AR_ID   => AR_ID,
                        ARADDR  => ARADDR,
                        ARLEN   => ARLEN,
                        ARSIZE  => ARSIZE,
                        ARBURST => ARBURST,
                        
                        -- Read data signals.
                        RVALID  => RVALID,
                        RREADY  => RREADY,
                        RDATA   => RDATA,
                        RLAST   => RLAST,
                        RRESP   => RRESP,
                    
                    -- Backend signals.
                    i_SPC_OPC   => i_SPC_OPC,
                    i_SPC_DATA  => i_SPC_DATA,
                    i_SPC_WAIT  => i_SPC_WAIT,
                    o_SPC_START => o_SPC_START,
                    o_SPC_OPC   => o_SPC_OPC,
                    o_SPC_ADDR  => o_SPC_ADDR,
                    o_SPC_DATA  => o_SPC_DATA
                );
        end generate;
        
    u_INTERFACE_TCC_SLAVE:
        if (g_TYPE = "SLAVE") generate
            u_INTERFACE_TCC_FRONTEND_SLAVE: interface_tcc_frontend_slave
                generic map(
                    g_ID_W_WIDTH => g_ID_W_WIDTH,
                    g_ID_R_WIDTH => g_ID_R_WIDTH,
                    g_ADDR_WIDTH => g_ADDR_WIDTH,
                    g_DATA_WIDTH => g_DATA_WIDTH,
                    g_BRESP_WIDTH => g_BRESP_WIDTH,
                    g_RRESP_WIDTH => g_RRESP_WIDTH
                )
                port map(
                    -- AMBA AXI 5 signals.
                    ACLK => ACLK,
                    ARESETn => ARESETn,
                    
                        -- Write request signals.
                        AWVALID => AWVALID,
                        AWREADY => AWREADY,
                        AW_ID   => AW_ID,
                        AWADDR  => AWADDR,
                        AWLEN   => AWLEN,
                        AWSIZE  => AWSIZE,
                        AWBURST => AWBURST,
                        
                        -- Write data signals.
                        WVALID  => WVALID,
                        WREADY  => WREADY,
                        WDATA   => WDATA,
                        WLAST   => WLAST,
                        
                        -- Write response signals.
                        BVALID  => BVALID,
                        BREADY  => BREADY,
                        BRESP   => BRESP,
                        
                        -- Read request signals.
                        ARVALID => ARVALID,
                        ARREADY => ARREADY,
                        AR_ID   => AR_ID,
                        ARADDR  => ARADDR,
                        ARLEN   => ARLEN,
                        ARSIZE  => ARSIZE,
                        ARBURST => ARBURST,
                        
                        -- Read data signals.
                        RVALID  => RVALID,
                        RREADY  => RREADY,
                        RDATA   => RDATA,
                        RLAST   => RLAST,
                        RRESP   => RRESP,
                    
                    -- Backend signals.
                    i_SPC_READY => i_SPC_READY,
                    i_SPC_OPC   => i_SPC_OPC,
                    i_SPC_ADDR  => i_SPC_ADDR,
                    i_SPC_DATA  => i_SPC_DATA,
                    o_SPC_START => o_SPC_START,
                    o_SPC_OPC   => o_SPC_OPC,
                    o_SPC_DATA  => o_SPC_DATA
                );
        end generate;
end arch_interface_tcc_frontend;