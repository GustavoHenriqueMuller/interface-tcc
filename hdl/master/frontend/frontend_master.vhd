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
        i_BACKEND_READY_START_PACKET: in std_logic;

        o_BACKEND_START_PACKET: out std_logic;
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
    signal w_OPC_OUT: std_logic;

begin
    -- @TODO: Registrar outros sinais que vem do IP (AWADDR, AW_ID, etc...).
    -- Transaction information registering.
    w_OPC <= '0' when (AWVALID = '1') else '1' when (ARVALID = '1');
    u_OPC_REG: entity work.reg1b
        port map(
            i_CLK    => ACLK,
            i_RESETn => ARESETn,
            i_WRITE  => i_BACKEND_READY_START_PACKET,
            i_DATA   => w_OPC,
            o_DATA   => w_OPC_OUT
        );

    -- Transaction information.
    o_BACKEND_ADDR   <= AWADDR  when (w_OPC_OUT = '0') else ARADDR when (w_OPC_OUT = '1');
    o_BACKEND_BURST  <= AWBURST when (w_OPC_OUT = '0') else ARBURST when (w_OPC_OUT = '1');
    o_BACKEND_LENGTH <= AWLEN   when (w_OPC_OUT = '0') else ARLEN when (w_OPC_OUT = '1');
    o_BACKEND_DATA   <= WDATA   when (w_OPC_OUT = '0') else (c_DATA_WIDTH - 1 downto 0 => '0');
    o_BACKEND_OPC    <= w_OPC_OUT;
    o_BACKEND_ID     <= AW_ID   when (w_OPC_OUT = '0') else AR_ID when (w_OPC_OUT = '1');

    -- Control information.
    o_BACKEND_START_PACKET <= '1' when (AWVALID = '1' or ARVALID = '1') else '0';
    o_BACKEND_VALID  <= '1' when (w_OPC_OUT = '0' and WVALID = '1') or (w_OPC_OUT = '1') else '0';
    o_BACKEND_LAST   <= '1' when (w_OPC_OUT = '0' and WLAST = '1') or (w_OPC_OUT = '1') else '0';

    -- Ready information to front-end.
    AWREADY <= i_BACKEND_READY_START_PACKET;
    WREADY  <= i_BACKEND_READY;
    ARREADY <= i_BACKEND_READY_START_PACKET;

end arch_frontend_master;