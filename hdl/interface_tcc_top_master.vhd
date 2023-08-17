library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.interface_tcc_package.all;
use work.xina_package.all;

entity interface_tcc_top_master is
    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic;
        ARESETn: in std_logic;
        
            -- Write request signals.
            AWVALID: in std_logic;
            AWREADY: out std_logic;
            AW_ID  : in std_logic_vector(c_ID_W_WIDTH - 1 downto 0) := (others => '0');
            AWADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
            AWLEN  : in std_logic_vector(7 downto 0) := (others => '0');
            AWSIZE : in std_logic_vector(2 downto 0) := (others => '0');
            AWBURST: in std_logic_vector(1 downto 0) := (others => '0');
            
            -- Write data signals.
            WVALID : in std_logic;
            WREADY : out std_logic;
            WDATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
            WLAST  : in std_logic;
            
            -- Write response signals.
            BVALID : out std_logic;
            BREADY : in std_logic;
            BRESP  : out std_logic_vector(c_BRESP_WIDTH - 1 downto 0) := (others => '0');
            
            -- Read request signals.
            ARVALID: in std_logic;
            ARREADY: out std_logic;
            AR_ID  : in std_logic_vector(c_ID_R_WIDTH - 1 downto 0) := (others => '0');
            ARADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
            ARLEN  : in std_logic_vector(7 downto 0) := (others => '0');
            ARSIZE : in std_logic_vector(2 downto 0) := (others => '0');
            ARBURST: in std_logic_vector(1 downto 0) := (others => '0');
            
            -- Read data signals.
            RVALID : out std_logic;
            RREADY : in std_logic;
            RDATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
            RLAST  : out std_logic;
            RRESP  : out std_logic_vector(c_RRESP_WIDTH - 1 downto 0) := (others => '0');
        
        -- XINA signals.
        l_in_data_o  : out data_link_l_t;
        l_in_val_o   : out ctrl_link_l_t;
        l_in_ack_i   : in ctrl_link_l_t;
        l_out_data_i : in data_link_l_t;
        l_out_val_i  : in ctrl_link_l_t;
        l_out_ack_o  : out ctrl_link_l_t
    );
end interface_tcc_top_master;

architecture arch_interface_tcc_top_master of interface_tcc_top_master is
    -- Signals between frontend and backend.
    signal w_BACKEND_READY    : std_logic := '0';
    signal w_BACKEND_OPC_IN   : std_logic_vector(c_OPC_WIDTH - 1 downto 0) := (others => '0');
    signal w_BACKEND_ADDR_IN  : std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal w_BACKEND_DATA_IN  : std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal w_BACKEND_START    : std_logic := '0';
    signal w_BACKEND_WAIT     : std_logic := '0';
    signal w_BACKEND_OPC_OUT  : std_logic_vector(c_OPC_WIDTH - 1 downto 0) := (others => '0');
    signal w_BACKEND_ADDR_OUT : std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal w_BACKEND_DATA_OUT : std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    -- Signals between backend and XINA router.
    signal w_l_in_data_o  : data_link_l_t;
    signal w_l_in_val_o   : ctrl_link_l_t;
    signal w_l_in_ack_i   : ctrl_link_l_t;
    signal w_l_out_data_i : data_link_l_t;
    signal w_l_out_val_i  : ctrl_link_l_t;
    signal w_l_out_ack_o  : ctrl_link_l_t;
    
begin
    u_INTERFACE_TCC_FRONTEND_MASTER: interface_tcc_frontend_master
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
            i_BACKEND_READY => w_BACKEND_READY,
            i_BACKEND_OPC   => w_BACKEND_OPC_IN,
            i_BACKEND_ADDR  => w_BACKEND_ADDR_IN,
            i_BACKEND_DATA  => w_BACKEND_DATA_IN,
            i_BACKEND_WAIT  => w_BACKEND_WAIT,
            
            o_BACKEND_START => w_BACKEND_START,
            o_BACKEND_OPC   => w_BACKEND_OPC_OUT,
            o_BACKEND_ADDR  => w_BACKEND_ADDR_OUT,
            o_BACKEND_DATA  => w_BACKEND_DATA_OUT
        );
        
    u_INTERFACE_TCC_BACKEND_MASTER: interface_tcc_backend_master
        port map(
            -- AMBA AXI 5 signals.
            ACLK => ACLK,
            ARESETn => ARESETn,
                       
            -- Backend signals.
            i_BACKEND_START => w_BACKEND_START,
            i_BACKEND_OPC   => w_BACKEND_OPC_OUT,
            i_BACKEND_ADDR  => w_BACKEND_ADDR_OUT,
            i_BACKEND_DATA  => w_BACKEND_DATA_OUT,
            
            o_BACKEND_READY => w_BACKEND_READY,
            o_BACKEND_OPC   => w_BACKEND_OPC_IN,
            o_BACKEND_ADDR  => w_BACKEND_ADDR_IN,
            o_BACKEND_DATA  => w_BACKEND_DATA_IN,
            o_BACKEND_WAIT  => w_BACKEND_WAIT,
            
            -- XINA signals.
            l_in_data_o  => w_l_in_data_o,
            l_in_val_o => w_l_in_val_o,
            l_in_ack_i => w_l_in_ack_i,
            l_out_data_i => w_l_out_data_i,
            l_out_val_i => w_l_out_val_i,
            l_out_ack_o => w_l_out_ack_o
        );
end arch_interface_tcc_top_master;