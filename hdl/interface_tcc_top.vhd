library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.interface_tcc_package.all;
use work.xina_package.all;

entity interface_tcc_top is
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
        
        -- XINA signals.
        l_in_data_o  : out data_link_l_t;
        l_in_val_o   : out ctrl_link_l_t;
        l_in_ack_i   : in ctrl_link_l_t;
        l_out_data_i : in data_link_l_t;
        l_out_val_i  : in ctrl_link_l_t;
        l_out_ack_o  : out ctrl_link_l_t
    );
end interface_tcc_top;

architecture arch_interface_tcc_top of interface_tcc_top is
    -- Signals between frontend and backend.
    signal w_SPC_READY    : std_logic := '0';
    signal w_SPC_OPC_IN   : std_logic_vector(c_OPC_WIDTH - 1 downto 0) := (others => '0');
    signal w_SPC_ADDR_IN  : std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal w_SPC_DATA_IN  : std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal w_SPC_START    : std_logic := '0';
    signal w_SPC_WAIT     : std_logic := '0';
    signal w_SPC_OPC_OUT  : std_logic_vector(c_OPC_WIDTH - 1 downto 0) := (others => '0');
    signal w_SPC_ADDR_OUT : std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal w_SPC_DATA_OUT : std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    -- Signals between backend and XINA router.
    signal w_l_in_data_o  : data_link_l_t;
    signal w_l_in_val_o   : ctrl_link_l_t;
    signal w_l_in_ack_i   : ctrl_link_l_t;
    signal w_l_out_data_i : data_link_l_t;
    signal w_l_out_val_i  : ctrl_link_l_t;
    signal w_l_out_ack_o  : ctrl_link_l_t;
    
begin
    u_INTERFACE_TCC_FRONTEND: interface_tcc_frontend
        generic map(
            g_TYPE => g_TYPE,
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
            i_SPC_READY => w_SPC_READY,
            i_SPC_OPC   => w_SPC_OPC_IN,
            i_SPC_ADDR  => w_SPC_ADDR_IN,
            i_SPC_DATA  => w_SPC_DATA_IN,
            i_SPC_WAIT  => w_SPC_WAIT,
            
            o_SPC_START => w_SPC_START,
            o_SPC_OPC   => w_SPC_OPC_OUT,
            o_SPC_ADDR  => w_SPC_ADDR_OUT,
            o_SPC_DATA  => w_SPC_DATA_OUT
        );
        
    u_INTERFACE_TCC_BACKEND: interface_tcc_backend
        generic map(
            g_TYPE => g_TYPE,
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
                       
            -- Backend signals.
            i_SPC_START => w_SPC_START,
            i_SPC_OPC   => w_SPC_OPC_OUT,
            i_SPC_ADDR  => w_SPC_ADDR_OUT,
            i_SPC_DATA  => w_SPC_DATA_OUT,
            
            o_SPC_READY => w_SPC_READY,
            o_SPC_OPC   => w_SPC_OPC_IN,
            o_SPC_ADDR  => w_SPC_ADDR_IN,
            o_SPC_DATA  => w_SPC_DATA_IN,
            o_SPC_WAIT  => w_SPC_WAIT,
            
            -- XINA signals.
            l_in_data_o  => w_l_in_data_o,
            l_in_val_o => w_l_in_val_o,
            l_in_ack_i => w_l_in_ack_i,
            l_out_data_i => w_l_out_data_i,
            l_out_val_i => w_l_out_val_i,
            l_out_ack_o => w_l_out_ack_o
        );
end arch_interface_tcc_top; 