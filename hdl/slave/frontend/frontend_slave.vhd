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

        o_BURST    : out std_logic_vector(1 downto 0);
        o_LENGTH   : out std_logic_vector(7 downto 0);
        o_DATA_SEND: out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        o_OPC_SEND : out std_logic;
        o_ID       : out std_logic_vector(c_ID_WIDTH - 1 downto 0);

        -- Backend signals (reception).
        i_VALID_RECEIVE_DATA: in std_logic;
        i_LAST_RECEIVE_DATA : in std_logic;

        i_DATA_RECEIVE      : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_HEADER_1_RECEIVE  : in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        i_HEADER_2_RECEIVE  : in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        i_ADDRESS_RECEIVE   : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);

        o_READY_RECEIVE_PACKET: out std_logic;
        o_READY_RECEIVE_DATA  : out std_logic
    );
end frontend_slave;

architecture arch_frontend_slave of frontend_slave is
    -- Injection.
    signal w_OPC_SEND: std_logic;
    signal w_OPC_SEND_OUT: std_logic;

    -- Reception.
    signal w_OPC_RECEIVE: std_logic;
    signal w_STATUS_RECEIVE: std_logic_vector(2 downto 0);

begin
    ---------------------------------------------------------------------------------------------
    -- Injection. @TODO: FAZENDO A RECEPTION PRIMEIRO

    -- Registering.
    w_OPC_SEND <= '0' when (BVALID = '1') else '1' when (RVALID = '1');

    u_OPC_SEND_REG: entity work.reg1b
        port map(
            ACLK     => ACLK,
            ARESETn  => ARESETn,
            i_WRITE  => i_READY_SEND_PACKET,
            i_DATA   => w_OPC_SEND,
            o_DATA   => w_OPC_SEND_OUT
        );

    -- Transaction information.
    --o_BURST     <=
    --o_LENGTH    <=
    --o_DATA_SEND <=
    --o_OPC_SEND  <=
    --o_ID        <=

    -- Control information.
    --o_START_SEND_PACKET <=
    --o_VALID_SEND_DATA   <=
    --o_LAST_SEND_DATA    <=

    -- Ready information to front-end.
    --BREADY <= i_READY_SEND_PACKET;
    --RREADY <= i_READY_SEND_DATA;

    ---------------------------------------------------------------------------------------------
    -- Reception.

    w_OPC_RECEIVE    <= i_HEADER_2_RECEIVE(0);
    w_STATUS_RECEIVE <= i_HEADER_2_RECEIVE(5 downto 3);

    o_READY_RECEIVE_PACKET <= '1' when (AWREADY = '1' and w_OPC_RECEIVE = '0') or
                                       (ARREADY = '1' and w_OPC_RECEIVE = '1') else '0';
    o_READY_RECEIVE_DATA   <= '1' when (WREADY = '1') else '0';

    AWVALID <= '1' when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '0') else '0';
    AW_ID   <= i_HEADER_2_RECEIVE(20 downto 16)         when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '0') else (c_ID_WIDTH - 1 downto 0 => '0');
    AWADDR  <= (31 downto 0 => '0') & i_ADDRESS_RECEIVE when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '0') else (c_ADDR_WIDTH - 1 downto 0 => '0');
    AWLEN   <= i_HEADER_2_RECEIVE(15 downto 8)          when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '0') else (7 downto 0 => '0');
    AWBURST <= i_HEADER_2_RECEIVE(7 downto 6)           when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '0') else (1 downto 0 => '0');

    WVALID <= i_VALID_RECEIVE_DATA;
    WDATA  <= i_DATA_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_DATA_WIDTH - 1 downto 0 => '0');
    WLAST  <= i_LAST_RECEIVE_DATA;

    ARVALID <= '1' when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '1') else '0';
    AR_ID   <= i_HEADER_2_RECEIVE(20 downto 16)         when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '1') else (c_ID_WIDTH - 1 downto 0 => '0');
    ARADDR  <= (31 downto 0 => '0') & i_ADDRESS_RECEIVE when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '1') else (c_ADDR_WIDTH - 1 downto 0 => '0');
    ARLEN   <= i_HEADER_2_RECEIVE(15 downto 8)          when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '1') else (7 downto 0 => '0');
    ARBURST <= i_HEADER_2_RECEIVE(7 downto 6)           when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '1') else (1 downto 0 => '0');

end arch_frontend_slave;