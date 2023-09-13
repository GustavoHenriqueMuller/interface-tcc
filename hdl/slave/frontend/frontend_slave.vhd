library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;

entity frontend_slave is
    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic;
        ARESETn: in std_logic;

            -- Write request signals.
            AWVALID: out std_logic;
            AWREADY: in std_logic;
            AW_ID  : out std_logic_vector(c_ID_WIDTH - 1 downto 0);
            AWADDR : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
            AWLEN  : out std_logic_vector(7 downto 0);
            AWSIZE : out std_logic_vector(2 downto 0);
            AWBURST: out std_logic_vector(1 downto 0);

            -- Write data signals.
            WVALID : out std_logic;
            WREADY : in std_logic;
            WDATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
            WLAST  : out std_logic;

            -- Write response signals.
            BVALID : in std_logic;
            BREADY : out std_logic;
            BRESP  : in std_logic_vector(c_RESP_WIDTH - 1 downto 0);

            -- Read request signals.
            ARVALID: out std_logic;
            ARREADY: in std_logic;
            AR_ID  : out std_logic_vector(c_ID_WIDTH - 1 downto 0);
            ARADDR : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
            ARLEN  : out std_logic_vector(7 downto 0);
            ARSIZE : out std_logic_vector(2 downto 0);
            ARBURST: out std_logic_vector(1 downto 0);

            -- Read response/data signals.
            RVALID : in std_logic;
            RREADY : out std_logic;
            RDATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
            RLAST  : in std_logic;
            RRESP  : in std_logic_vector(c_RESP_WIDTH - 1 downto 0);

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
        o_OPC_SEND : out std_logic;
        o_ID       : out std_logic_vector(c_ID_WIDTH - 1 downto 0);

        -- Backend signals (reception).
        i_VALID_RECEIVE_DATA: in std_logic;
        i_LAST_RECEIVE_DATA   : in std_logic;
        i_DATA_RECEIVE        : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_OPC_RECEIVE         : in std_logic;
        i_STATUS_RECEIVE      : in std_logic_vector(c_RESP_WIDTH - 1 downto 0);

        o_READY_RECEIVE_PACKET: out std_logic;
        o_READY_RECEIVE_DATA  : out std_logic
    );
end frontend_slave;

architecture arch_frontend_slave of frontend_slave is
    signal w_OPC_SEND: std_logic;
    signal w_OPC_SEND_OUT: std_logic;

    signal w_OPC_RECEIVE: std_logic;
    signal w_OPC_RECEIVE_OUT: std_logic;

begin
    ---------------------------------------------------------------------------------------------
    -- Injection.

    -- Registering.
    w_OPC_SEND <= '0' when (AWVALID = '1') else '1' when (ARVALID = '1');
    u_OPC_SEND_REG: entity work.reg1b
        port map(
            ACLK     => ACLK,
            ARESETn  => ARESETn,
            i_WRITE  => i_READY_SEND_PACKET,
            i_DATA   => w_OPC_SEND,
            o_DATA   => w_OPC_SEND_OUT
        );

    -- Transaction information.
    o_ADDR      <= AWADDR  when (w_OPC_SEND_OUT = '0') else ARADDR  when (w_OPC_SEND_OUT = '1');
    o_BURST     <= AWBURST when (w_OPC_SEND_OUT = '0') else ARBURST when (w_OPC_SEND_OUT = '1');
    o_LENGTH    <= AWLEN   when (w_OPC_SEND_OUT = '0') else ARLEN   when (w_OPC_SEND_OUT = '1');
    o_DATA_SEND <= WDATA   when (w_OPC_SEND_OUT = '0') else (c_DATA_WIDTH - 1 downto 0 => '0');
    o_OPC_SEND  <= w_OPC_SEND_OUT;
    o_ID        <= AW_ID   when (w_OPC_SEND_OUT = '0') else AR_ID when (w_OPC_SEND_OUT = '1');

    -- Control information.
    o_START_SEND_PACKET <= '1' when (AWVALID = '1' or ARVALID = '1') else '0';
    o_VALID_SEND_DATA   <= '1' when (w_OPC_SEND_OUT = '0' and WVALID = '1') or (w_OPC_SEND_OUT = '1') else '0';
    o_LAST_SEND_DATA    <= '1' when (w_OPC_SEND_OUT = '0' and WLAST = '1') or (w_OPC_SEND_OUT = '1') else '0';

    -- Ready information to front-end.
    BREADY <= i_READY_SEND_PACKET;
    RREADY <= i_READY_SEND_DATA;

    ---------------------------------------------------------------------------------------------
    -- Reception.

    o_READY_RECEIVE_PACKET <= '1' when (BREADY = '1' and i_OPC_RECEIVE = '0') or
                                       (RREADY = '1' and i_OPC_RECEIVE = '1') else '0';

    o_READY_RECEIVE_DATA   <= '1' when (RREADY = '1') else '0';

    BVALID <= '1' when (i_VALID_RECEIVE_DATA = '1' and i_OPC_RECEIVE = '0') else '0';
    BRESP  <= i_STATUS_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_RESP_WIDTH - 1 downto 0 => '0');

    RVALID <= '1' when (i_VALID_RECEIVE_DATA = '1' and i_OPC_RECEIVE = '1') else '0';
    RDATA  <= i_DATA_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_DATA_WIDTH - 1 downto 0 => '0');
    RLAST  <= '1' when (i_LAST_RECEIVE_DATA = '1') else '0';
    RRESP  <= i_STATUS_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_RESP_WIDTH - 1 downto 0 => '0');

end arch_frontend_slave;