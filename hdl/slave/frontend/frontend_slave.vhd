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
            AWID   : out std_logic_vector(c_ID_WIDTH - 1 downto 0);
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
            BID    : in std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
            BRESP  : in std_logic_vector(c_RESP_WIDTH - 1 downto 0);

            -- Read request signals.
            ARVALID: out std_logic;
            ARREADY: in std_logic;
            ARID   : out std_logic_vector(c_ID_WIDTH - 1 downto 0);
            ARADDR : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
            ARLEN  : out std_logic_vector(7 downto 0);
            ARSIZE : out std_logic_vector(2 downto 0);
            ARBURST: out std_logic_vector(1 downto 0);

            -- Read response/data signals.
            RVALID : in std_logic;
            RREADY : out std_logic;
            RDATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
            RLAST  : in std_logic;
            RID    : in std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
            RRESP  : in std_logic_vector(c_RESP_WIDTH - 1 downto 0);

        -- Backend signals (injection).
        o_VALID_SEND_DATA  : out std_logic;
        o_LAST_SEND_DATA   : out std_logic;
        i_READY_SEND_DATA  : in std_logic;

        o_DATA_SEND  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        o_STATUS_SEND: out std_logic_vector(c_RESP_WIDTH - 1 downto 0);

        -- Backend signals (reception).
        i_VALID_RECEIVE_PACKET: in std_logic;
        i_VALID_RECEIVE_DATA  : in std_logic;
        i_LAST_RECEIVE_DATA   : in std_logic;

        i_DATA_RECEIVE      : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_H_INTERFACE_RECEIVE: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        i_ADDRESS_RECEIVE   : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);

        o_READY_RECEIVE_PACKET: out std_logic;
        o_READY_RECEIVE_DATA  : out std_logic
    );
end frontend_slave;

architecture rtl of frontend_slave is
    -- Reception.
    signal w_OPC_RECEIVE: std_logic;
    signal w_ID_RECEIVE: std_logic_vector(c_ID_WIDTH - 1 downto 0);
    signal w_LEN_RECEIVE: std_logic_vector(7 downto 0);
    signal w_BURST_RECEIVE: std_logic_vector(1 downto 0);

begin
    ---------------------------------------------------------------------------------------------
    -- Injection.

    -- Control information.
    o_VALID_SEND_DATA   <= '1' when (BVALID = '1' or RVALID = '1') else '0';
    o_LAST_SEND_DATA    <= RLAST;
    o_DATA_SEND         <= RDATA when (RVALID = '1') else (c_DATA_WIDTH - 1 downto 0 => '0');
    o_STATUS_SEND       <= BRESP when (w_OPC_RECEIVE = '0') else
                           RRESP when (w_OPC_RECEIVE = '1') else
                           (c_RESP_WIDTH - 1 downto 0 => '0');

    -- Ready information to IP.
    BREADY <= '1' when (i_READY_SEND_DATA = '1' and w_OPC_RECEIVE = '0') else '0';
    RREADY <= '1' when (i_READY_SEND_DATA = '1' and w_OPC_RECEIVE = '1') else '0';

    ---------------------------------------------------------------------------------------------
    -- Reception.

    w_OPC_RECEIVE   <= i_H_INTERFACE_RECEIVE(1);
    w_ID_RECEIVE    <= i_H_INTERFACE_RECEIVE(19 downto 15);
    w_LEN_RECEIVE   <= i_H_INTERFACE_RECEIVE(14 downto 7);
    w_BURST_RECEIVE <= i_H_INTERFACE_RECEIVE(6 downto 5);

    o_READY_RECEIVE_PACKET <= '1' when (AWREADY = '1' and w_OPC_RECEIVE = '0') or
                                       (ARREADY = '1' and w_OPC_RECEIVE = '1') else '0';
    o_READY_RECEIVE_DATA   <= WREADY;

    AWVALID <= '1' when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '0') else '0';
    AWID    <= w_ID_RECEIVE when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '0') else (c_ID_WIDTH - 1 downto 0 => '0');
    AWADDR  <= i_ADDRESS_RECEIVE & (31 downto 0 => '0') when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '0') else (c_ADDR_WIDTH - 1 downto 0 => '0');
    AWLEN   <= w_LEN_RECEIVE when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '0') else (7 downto 0 => '0');
    AWBURST <= w_BURST_RECEIVE when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '0') else (1 downto 0 => '0');
    AWSIZE  <= "010";

    WVALID <= i_VALID_RECEIVE_DATA;
    WDATA  <= i_DATA_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_DATA_WIDTH - 1 downto 0 => '0');
    WLAST  <= i_LAST_RECEIVE_DATA;

    ARVALID <= '1' when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '1') else '0';
    ARID    <= w_ID_RECEIVE when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '1') else (c_ID_WIDTH - 1 downto 0 => '0');
    ARADDR  <= i_ADDRESS_RECEIVE & (31 downto 0 => '0') when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '1') else (c_ADDR_WIDTH - 1 downto 0 => '0');
    ARLEN   <= w_LEN_RECEIVE when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '1') else (7 downto 0 => '0');
    ARBURST <= w_BURST_RECEIVE when (i_VALID_RECEIVE_PACKET = '1' and w_OPC_RECEIVE = '1') else (1 downto 0 => '0');
    ARSIZE  <= "010";
end rtl;