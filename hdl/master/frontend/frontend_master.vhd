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
            AWID   : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            AWADDR : in std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);
            AWLEN  : in std_logic_vector(7 downto 0);
            AWSIZE : in std_logic_vector(2 downto 0);
            AWBURST: in std_logic_vector(1 downto 0);

            -- Write data signals.
            WVALID : in std_logic;
            WREADY : out std_logic;
            WDATA  : in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
            WLAST  : in std_logic;

            -- Write response signals.
            BVALID : out std_logic;
            BREADY : in std_logic;
            BID    : out std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            BRESP  : out std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);

            -- Read request signals.
            ARVALID: in std_logic;
            ARREADY: out std_logic;
            ARID   : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            ARADDR : in std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);
            ARLEN  : in std_logic_vector(7 downto 0);
            ARSIZE : in std_logic_vector(2 downto 0);
            ARBURST: in std_logic_vector(1 downto 0);

            -- Read response/data signals.
            RVALID : out std_logic;
            RREADY : in std_logic;
            RDATA  : out std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
            RLAST  : out std_logic;
            RID    : out std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            RRESP  : out std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);

            -- Extra signals.
            CORRUPT_PACKET: out std_logic;

        -- Backend signals (injection).
        i_READY_SEND_DATA  : in std_logic;
        i_READY_SEND_PACKET: in std_logic;

        o_START_SEND_PACKET: out std_logic;
        o_VALID_SEND_DATA  : out std_logic;
        o_LAST_SEND_DATA   : out std_logic;

        o_ADDR     : out std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);
        o_ID       : out std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
        o_LENGTH   : out std_logic_vector(7 downto 0);
        o_BURST    : out std_logic_vector(1 downto 0);
        o_OPC_SEND : out std_logic;
        o_DATA_SEND: out std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        -- Backend signals (reception).
        i_VALID_RECEIVE_DATA: in std_logic;
        i_LAST_RECEIVE_DATA : in std_logic;

        i_ID_RECEIVE    : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
        i_STATUS_RECEIVE: in std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);
        i_OPC_RECEIVE   : in std_logic;
        i_DATA_RECEIVE  : in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        i_CORRUPT_RECEIVE: in std_logic;

        o_READY_RECEIVE_PACKET: out std_logic;
        o_READY_RECEIVE_DATA  : out std_logic
    );
end frontend_master;

architecture rtl of frontend_master is
    -- Injection.
    signal w_OPC_SEND: std_logic;

begin
    ---------------------------------------------------------------------------------------------
    -- Injection.

    -- Registering transaction information.
    registering: process(all)
    begin
        if (rising_edge(ACLK)) then
            if (i_READY_SEND_PACKET) then
                if (AWVALID = '1') then
                    -- Registering write signals.
                    w_OPC_SEND <= '0';

                    o_ADDR      <= AWADDR;
                    o_ID        <= AWID;
                    o_LENGTH    <= AWLEN;
                    o_BURST     <= AWBURST;
                    o_DATA_SEND <= WDATA;
                elsif (ARVALID = '1') then
                    -- Registering read signals.
                    w_OPC_SEND <= '1';

                    o_ADDR      <= ARADDR;
                    o_ID        <= ARID;
                    o_LENGTH    <= ARLEN;
                    o_BURST     <= ARBURST;
                    o_DATA_SEND <= (c_AXI_DATA_WIDTH - 1 downto 0 => '0');
                end if;
            end if;
        end if;
    end process registering;

    o_OPC_SEND <= w_OPC_SEND;

    -- Control information.
    o_START_SEND_PACKET <= '1' when (AWVALID = '1' or ARVALID = '1')    else '0';
    o_VALID_SEND_DATA   <= '1' when (w_OPC_SEND = '0' and WVALID = '1') else '0';
    o_LAST_SEND_DATA    <= '1' when (w_OPC_SEND = '0' and WLAST = '1')  else '0';

    -- Ready information to front-end.
    AWREADY <= i_READY_SEND_PACKET;
    ARREADY <= i_READY_SEND_PACKET;
    WREADY  <= i_READY_SEND_DATA;

    ---------------------------------------------------------------------------------------------
    -- Reception.

    o_READY_RECEIVE_PACKET <= '1' when (i_OPC_RECEIVE = '0' and BREADY = '1') or
                                       (i_OPC_RECEIVE = '1' and RREADY = '1') else '0';

    o_READY_RECEIVE_DATA   <= RREADY;

    -- Write reception.
    BVALID <= '1' when (i_OPC_RECEIVE = '0' and i_VALID_RECEIVE_DATA = '1') else '0';
    BID    <= i_ID_RECEIVE when (i_OPC_RECEIVE = '0' and i_VALID_RECEIVE_DATA = '1') else (c_AXI_ID_WIDTH - 1 downto 0 => '0');
    BRESP  <= i_STATUS_RECEIVE when (i_OPC_RECEIVE = '0' and i_VALID_RECEIVE_DATA = '1') else (c_AXI_RESP_WIDTH - 1 downto 0 => '0');

    -- Read reception.
    RVALID <= '1' when (i_OPC_RECEIVE = '1' and i_VALID_RECEIVE_DATA = '1') else '0';
    RDATA  <= i_DATA_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_AXI_DATA_WIDTH - 1 downto 0 => '0');
    RLAST  <= i_LAST_RECEIVE_DATA;
    RID    <= i_ID_RECEIVE when (i_OPC_RECEIVE = '1' and i_VALID_RECEIVE_DATA = '1') else (c_AXI_ID_WIDTH - 1 downto 0 => '0');
    RRESP  <= i_STATUS_RECEIVE when (i_OPC_RECEIVE = '1' and i_VALID_RECEIVE_DATA = '1') else (c_AXI_RESP_WIDTH - 1 downto 0 => '0');

    CORRUPT_PACKET <= i_CORRUPT_RECEIVE;
end rtl;