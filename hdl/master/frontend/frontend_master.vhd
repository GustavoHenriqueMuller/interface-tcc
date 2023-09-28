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
            AWID   : in std_logic_vector(c_ID_WIDTH - 1 downto 0);
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
            BID    : out std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
            BRESP  : out std_logic_vector(c_RESP_WIDTH - 1 downto 0);

            -- Read request signals.
            ARVALID: in std_logic;
            ARREADY: out std_logic;
            ARID   : in std_logic_vector(c_ID_WIDTH - 1 downto 0);
            ARADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
            ARLEN  : in std_logic_vector(7 downto 0);
            ARSIZE : in std_logic_vector(2 downto 0);
            ARBURST: in std_logic_vector(1 downto 0);

            -- Read response/data signals.
            RVALID : out std_logic;
            RREADY : in std_logic;
            RDATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
            RLAST  : out std_logic;
            RID    : out std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
            RRESP  : out std_logic_vector(c_RESP_WIDTH - 1 downto 0);

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
        i_LAST_RECEIVE_DATA : in std_logic;

        i_DATA_RECEIVE: in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_HEADER_INTERFACE_RECEIVE: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

        o_READY_RECEIVE_PACKET: out std_logic;
        o_READY_RECEIVE_DATA  : out std_logic
    );
end frontend_master;

architecture arch_frontend_master of frontend_master is
    -- Injection.
    signal w_OPC_SEND: std_logic;
    signal w_OPC_SEND_OUT: std_logic;

    -- Reception.
    signal w_OPC_RECEIVE: std_logic;
    signal w_STATUS_RECEIVE: std_logic_vector(2 downto 0);
    signal w_ID_RECEIVE: std_logic_vector(c_ID_WIDTH - 1 downto 0);

begin
    ---------------------------------------------------------------------------------------------
    -- Injection.

    -- Registering.
    w_OPC_SEND <= '0' when (AWVALID = '1') else '1' when (ARVALID = '1');

    registering: process(all)
    begin
        if (rising_edge(ACLK)) then
            if (i_READY_SEND_PACKET) then w_OPC_SEND_OUT <= w_OPC_SEND; end if;
        end if;
    end process registering;

    -- Transaction information.
    o_ADDR      <= AWADDR  when (w_OPC_SEND_OUT = '0') else ARADDR  when (w_OPC_SEND_OUT = '1');
    o_BURST     <= AWBURST when (w_OPC_SEND_OUT = '0') else ARBURST when (w_OPC_SEND_OUT = '1');
    o_LENGTH    <= AWLEN   when (w_OPC_SEND_OUT = '0') else ARLEN   when (w_OPC_SEND_OUT = '1');
    o_DATA_SEND <= WDATA   when (w_OPC_SEND_OUT = '0') else (c_DATA_WIDTH - 1 downto 0 => '0');
    o_OPC_SEND  <= w_OPC_SEND_OUT;
    o_ID        <= AWID   when (w_OPC_SEND_OUT = '0') else ARID when (w_OPC_SEND_OUT = '1');

    -- Control information.
    o_START_SEND_PACKET <= '1' when (AWVALID = '1' or ARVALID = '1') else '0';
    o_VALID_SEND_DATA   <= '1' when (w_OPC_SEND_OUT = '0' and WVALID = '1') or (w_OPC_SEND_OUT = '1') else '0';
    o_LAST_SEND_DATA    <= '1' when (w_OPC_SEND_OUT = '0' and WLAST = '1') or (w_OPC_SEND_OUT = '1') else '0';

    -- Ready information to front-end.
    AWREADY <= i_READY_SEND_PACKET;
    ARREADY <= i_READY_SEND_PACKET;
    WREADY  <= i_READY_SEND_DATA;

    ---------------------------------------------------------------------------------------------
    -- Reception.

    w_OPC_RECEIVE    <= i_HEADER_INTERFACE_RECEIVE(0);
    w_STATUS_RECEIVE <= i_HEADER_INTERFACE_RECEIVE(5 downto 3);
    w_ID_RECEIVE     <= i_HEADER_INTERFACE_RECEIVE(20 downto 16);

    o_READY_RECEIVE_PACKET <= '1' when (BREADY = '1' and w_OPC_RECEIVE = '0') or
                                       (RREADY = '1' and w_OPC_RECEIVE = '1') else '0';

    o_READY_RECEIVE_DATA   <= RREADY;

    BVALID <= '1' when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '0') else '0';
    BID    <= w_ID_RECEIVE when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '0') else (c_ID_WIDTH - 1 downto 0 => '0');
    BRESP  <= w_STATUS_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_RESP_WIDTH - 1 downto 0 => '0');

    RVALID <= '1' when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '1') else '0';
    RDATA  <= i_DATA_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_DATA_WIDTH - 1 downto 0 => '0');
    RLAST  <= i_LAST_RECEIVE_DATA;
    RID    <= w_ID_RECEIVE when (i_VALID_RECEIVE_DATA = '1' and w_OPC_RECEIVE = '1') else (c_ID_WIDTH - 1 downto 0 => '0');
    RRESP  <= w_STATUS_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_RESP_WIDTH - 1 downto 0 => '0');

end arch_frontend_master;