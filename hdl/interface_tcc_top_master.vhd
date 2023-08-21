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
        l_out_data_i : in data_link_l_t;
        l_out_val_i  : in ctrl_link_l_t;
        l_in_ack_i   : in ctrl_link_l_t;
        l_in_data_o  : out data_link_l_t;
        l_in_val_o   : out ctrl_link_l_t;
        l_out_ack_o  : out ctrl_link_l_t
    );
end interface_tcc_top_master;

architecture arch_interface_tcc_top_master of interface_tcc_top_master is
    -- Signals between front-end and back-end.
    signal w_BACKEND_VALID_IN  : std_logic;
    signal w_BACKEND_OPC_IN    : std_logic;
    signal w_BACKEND_ADDR_IN   : std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
    signal w_BACKEND_BURST_IN  : std_logic_vector(1 downto 0);
    signal w_BACKEND_LENGTH_IN : std_logic_vector(7 downto 0);
    signal w_BACKEND_DATA_IN   : std_logic_vector(c_DATA_WIDTH - 1 downto 0);
    signal w_BACKEND_ID_IN     : std_logic_vector(c_ID_W_WIDTH - 1 downto 0);

    signal w_BACKEND_READY_OUT : std_logic;

    -- Signals between backend and XINA router.
    signal w_l_in_data_o  : data_link_l_t;
    signal w_l_in_val_o   : ctrl_link_l_t;
    signal w_l_in_ack_i   : ctrl_link_l_t;
    signal w_l_out_data_i : data_link_l_t;
    signal w_l_out_val_i  : ctrl_link_l_t;
    signal w_l_out_ack_o  : ctrl_link_l_t;

begin
    u_INTERFACE_TCC_FRONTEND_MASTER: entity work.interface_tcc_frontend_master
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
            i_BACKEND_READY => w_BACKEND_READY_OUT,

            o_BACKEND_OPC => w_BACKEND_OPC_IN,
            o_BACKEND_ADDR => w_BACKEND_ADDR_IN,
            o_BACKEND_BURST => w_BACKEND_BURST_IN,
            o_BACKEND_LENGTH => w_BACKEND_LENGTH_IN,
            o_BACKEND_VALID => w_BACKEND_VALID_IN,
            o_BACKEND_DATA => w_BACKEND_DATA_IN,
            o_BACKEND_ID => w_BACKEND_ID_IN
        );

    u_INTERFACE_TCC_BACKEND_MASTER: entity work.interface_tcc_backend_master
        port map(
            -- AMBA AXI 5 signals.
            ACLK => ACLK,
            ARESETn => ARESETn,

            -- Backend signals.
            i_VALID  => w_BACKEND_VALID_IN,
			i_OPC    => w_BACKEND_OPC_IN,
			i_ADDR   => w_BACKEND_ADDR_IN,
			i_BURST  => w_BACKEND_BURST_IN,
			i_LENGTH => w_BACKEND_LENGTH_IN,
			i_DATA   => w_BACKEND_DATA_IN,

			o_READY  => w_BACKEND_READY_OUT,

            -- XINA signals.
            l_out_data_i => w_l_out_data_i,
            l_out_val_i  => w_l_out_val_i,
            l_in_ack_i   => w_l_in_ack_i,
            l_in_data_o  => w_l_in_data_o,
            l_in_val_o   => w_l_in_val_o,
            l_out_ack_o  => w_l_out_ack_o
        );

end arch_interface_tcc_top_master;