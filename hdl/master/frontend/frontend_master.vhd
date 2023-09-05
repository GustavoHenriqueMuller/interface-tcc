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

            -- Read response/data signals.
            RVALID : out std_logic;
            RREADY : in std_logic;
            RDATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
            RLAST  : out std_logic;
            RRESP  : out std_logic_vector(c_RRESP_WIDTH - 1 downto 0);

        -- Backend signals (injection).
        o_START_SEND_PACKET: out std_logic;
        o_VALID_SEND_DATA  : out std_logic;
        o_LAST_SEND_DATA   : out std_logic;

        i_READY_SEND_DATA  : in std_logic;
        i_READY_SEND_PACKET: in std_logic;

        o_ADDR     : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        o_BURST    : out std_logic_vector(1 downto 0);
        o_LENGTH   : out std_logic_vector(7 downto 0);
        o_DATA_SEND: out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        o_OPC      : out std_logic;
        o_ID       : out std_logic_vector(c_ID_WIDTH - 1 downto 0);

        -- Backend signals (reception).
        o_READY_RECEIVE_PACKET: out std_logic;
        i_VALID_RECEIVE_PACKET: in std_logic;
        i_LAST_RECEIVE_DATA   : in std_logic;
        i_DATA_RECEIVE        : in std_logic_vector(c_DATA_WIDTH - 1 downto 0)
    );
end frontend_master;

architecture arch_frontend_master of frontend_master is
    signal w_OPC: std_logic;
    signal w_OPC_OUT: std_logic;

begin
    ---------------------------------------------------------------------------------------------
    -- Injection.

    -- @TODO: Registrar outros sinais que vem do IP (AWADDR, AW_ID, etc...).
    -- Transaction information registering.
    w_OPC <= '0' when (AWVALID = '1') else '1' when (ARVALID = '1');
    u_OPC_REG: entity work.reg1b
        port map(
            ACLK     => ACLK,
            ARESETn  => ARESETn,
            i_WRITE  => i_READY_SEND_PACKET,
            i_DATA   => w_OPC,
            o_DATA   => w_OPC_OUT
        );

    -- Transaction information.
    o_ADDR      <= AWADDR  when (w_OPC_OUT = '0') else ARADDR when (w_OPC_OUT = '1');
    o_BURST     <= AWBURST when (w_OPC_OUT = '0') else ARBURST when (w_OPC_OUT = '1');
    o_LENGTH    <= AWLEN   when (w_OPC_OUT = '0') else ARLEN when (w_OPC_OUT = '1');
    o_DATA_SEND <= WDATA   when (w_OPC_OUT = '0') else (c_DATA_WIDTH - 1 downto 0 => '0');
    o_OPC       <= w_OPC_OUT;
    o_ID        <= AW_ID   when (w_OPC_OUT = '0') else AR_ID when (w_OPC_OUT = '1');

    -- Control information.
    o_START_SEND_PACKET <= '1' when (AWVALID = '1' or ARVALID = '1') else '0';
    o_VALID_SEND_DATA   <= '1' when (w_OPC_OUT = '0' and WVALID = '1') or (w_OPC_OUT = '1') else '0';
    o_LAST_SEND_DATA    <= '1' when (w_OPC_OUT = '0' and WLAST = '1') or (w_OPC_OUT = '1') else '0';

    -- Ready information to front-end.
    AWREADY <= i_READY_SEND_PACKET;
    WREADY  <= i_READY_SEND_DATA;
    ARREADY <= i_READY_SEND_PACKET;

    ---------------------------------------------------------------------------------------------
    -- Reception.
    -- @TODO

    -- BVALID  <=

end arch_frontend_master;