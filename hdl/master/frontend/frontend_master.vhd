library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;

entity frontend_master is
    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic;
        ARESETn: in std_logic;

            -- Write request signals.
            AWVALID: in std_logic;
            AWREADY: out std_logic;
            AW_ID  : in std_logic_vector(c_ID_WIDTH - 1 downto 0);
            AWADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
            AWLEN  : in std_logic_vector(7 downto 0);
            AWSIZE : in std_logic_vector(2 downto 0);
            AWBURST: in std_logic_vector(1 downto 0);

            -- Write data signals.
            WVALID : in std_logic;
            WREADY : out std_logic;
            WDATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
            WLAST  : in std_logic;

            -- Write response signals.
            BVALID : out std_logic;
            BREADY : in std_logic;
            BRESP  : out std_logic_vector(c_BRESP_WIDTH - 1 downto 0);

            -- Read request signals.
            ARVALID: in std_logic;
            ARREADY: out std_logic;
            AR_ID  : in std_logic_vector(c_ID_WIDTH - 1 downto 0);
            ARADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
            ARLEN  : in std_logic_vector(7 downto 0);
            ARSIZE : in std_logic_vector(2 downto 0);
            ARBURST: in std_logic_vector(1 downto 0);

            -- Read data signals.
            RVALID : out std_logic;
            RREADY : in std_logic;
            RDATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
            RLAST  : out std_logic;
            RRESP  : out std_logic_vector(c_RRESP_WIDTH - 1 downto 0);

        -- Backend signals.
        i_BACKEND_READY : in std_logic;

        o_BACKEND_VALID : out std_logic;
        o_BACKEND_LAST  : out std_logic;
        o_BACKEND_ADDR  : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        o_BACKEND_BURST : out std_logic_vector(1 downto 0);
        o_BACKEND_LENGTH: out std_logic_vector(7 downto 0);
        o_BACKEND_DATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        o_BACKEND_OPC   : out std_logic;
        o_BACKEND_ID    : out std_logic_vector(c_ID_WIDTH - 1 downto 0)
    );
end frontend_master;

architecture arch_frontend_master of frontend_master is
    signal w_OPC: std_logic;

begin
    u_FRONTEND_MASTER_SEND_CONTROL: entity work.frontend_master_send_control
        port map (
            ACLK => ACLK,
            ARESETn => ARESETn,

            -- Signals from front-end.
            AWVALID => AWVALID,
            WLAST   => WLAST,
            WVALID  => WVALID,
            ARVALID => ARVALID,

            -- Signals to front-end.
            AWREADY => AWREADY,
            WREADY  => WREADY,
            ARREADY => ARREADY,

            -- Signals from back-end.
            i_BACKEND_READY => i_BACKEND_READY,

            -- Signals to back-end.
            o_BACKEND_VALID  => o_BACKEND_VALID,
            o_BACKEND_LAST   => o_BACKEND_LAST,
            o_OPC            => w_OPC
        );

    u_FRONTEND_MASTER_DATA_MULTIPLEXER: entity work.frontend_master_data_multiplexer
        port map(
            ACLK => ACLK,
            ARESETn => ARESETn,

            -- Signals from front-end.
            AW_ID   => AW_ID,
            AWADDR  => AWADDR,
            AWLEN   => AWLEN,
            AWBURST => AWBURST,
            WDATA   => WDATA,

            AR_ID   => AR_ID,
            ARADDR  => ARADDR,
            ARLEN   => ARLEN,
            ARBURST => ARBURST,

            i_OPC => w_OPC,

            -- Signals to back-end.
            o_BACKEND_OPC    => o_BACKEND_OPC,
            o_BACKEND_ADDR   => o_BACKEND_ADDR,
            o_BACKEND_BURST  => o_BACKEND_BURST,
            o_BACKEND_LENGTH => o_BACKEND_LENGTH,
            o_BACKEND_DATA   => o_BACKEND_DATA,
            o_BACKEND_ID     => o_BACKEND_ID
        );

    -- @TODO: Os sinais abaixo vão sair de um controlador de receber pacotes do backend.
    -- BVALID : out std_logic;
    -- BRESP  : out std_logic_vector(c_BRESP_WIDTH - 1 downto 0);
    -- RVALID : out std_logic;
    -- RDATA  : out std_logic_vector(data_width_c - 1 downto 0);
    -- RLAST  : out std_logic;
    -- RRESP  : out std_logic_vector(c_RRESP_WIDTH - 1 downto 0);
end arch_frontend_master;