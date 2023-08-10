library IEEE;
use IEEE.std_logic_1164.all;

entity interface_tcc_top is
    generic(
        -- Interface attributes.
        p_TYPE: string  := "MASTER"; -- "MASTER" or "SLAVE"
        
        -- AMBA AXI 5 attributes.
        ID_W_WIDTH: natural := 5;
        ID_R_WIDTH: natural := 5;
        ADDR_WIDTH: natural := 8; -- @TODO: Verificar esse tamanho.
        DATA_WIDTH: natural := 32;
        BRESP_WIDTH: natural := 3;
        RRESP_WIDTH: natural := 3;
    );
  
    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic;
        ARESETn: in std_logic;
        
            -- Write request signals.
            AWVALID: inout std_logic;
            AWREADY: in std_logic;
            AW_ID: inout std_logic_vector(ID_W_WIDTH - 1 downto 0) := (others => '0');
            AWADDR: inout std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
            AWLEN: inout std_logic_vector(7 downto 0) := (others => '0');
            AWSIZE: inout std_logic_vector(2 downto 0) := (others => '0');
            AWBURST: inout std_logic_vector(1 downto 0) := (others => '0');
            
            -- Write data signals.
            WVALID: inout std_logic;
            WREADY: in std_logic;
            WDATA: inout std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
            WLAST: inout std_logic;
            
            -- Write response signals.
            BVALID: inout std_logic;
            BREADY: in std_logic;
            BRESP: inout std_logic_vector(BRESP_WIDTH - 1 downto 0) := (others => '0');
            
            -- Read request signals.
            ARVALID: inout std_logic;
            ARREADY: in std_logic;
            AR_ID: inout std_logic_vector(ID_R_WIDTH - 1 downto 0) := (others => '0');
            ARADDR: inout std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
            ARLEN: inout std_logic_vector(7 downto 0) := (others => '0');
            ARSIZE: inout std_logic_vector(2 downto 0) := (others => '0');
            ARBURST: inout std_logic_vector(1 downto 0) := (others => '0');
            
            -- Read data signals.
            RVALID: inout std_logic;
            RREADY: in std_logic;
            RDATA: inout std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
            RLAST: inout std_logic;
            RRESP: inout std_logic_vector(RRESP_WIDTH - 1 downto 0) := (others => '0');
        
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
begin
    -- Components.
    
end arch_interface_tcc_top; 