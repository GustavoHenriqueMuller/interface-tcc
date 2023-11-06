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
            AWID   : out std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            AWADDR : out std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);
            AWLEN  : out std_logic_vector(7 downto 0);
            AWSIZE : out std_logic_vector(2 downto 0);
            AWBURST: out std_logic_vector(1 downto 0);

            -- Write data signals.
            WVALID : out std_logic;
            WREADY : in std_logic;
            WDATA  : out std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
            WLAST  : out std_logic;

            -- Write response signals.
            BVALID : in std_logic;
            BREADY : out std_logic;
            BID    : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            BRESP  : in std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);

            -- Read request signals.
            ARVALID: out std_logic;
            ARREADY: in std_logic;
            ARID   : out std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            ARADDR : out std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);
            ARLEN  : out std_logic_vector(7 downto 0);
            ARSIZE : out std_logic_vector(2 downto 0);
            ARBURST: out std_logic_vector(1 downto 0);

            -- Read response/data signals.
            RVALID : in std_logic;
            RREADY : out std_logic;
            RDATA  : in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
            RLAST  : in std_logic;
            RID    : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            RRESP  : in std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);

            -- Extra signals.
            CORRUPT_PACKET: out std_logic;

        -- Backend signals (injection).
        i_READY_SEND_DATA: in std_logic;
        o_VALID_SEND_DATA: out std_logic;
        o_LAST_SEND_DATA : out std_logic;

        o_DATA_SEND  : out std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
        o_STATUS_SEND: out std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);

        -- Backend signals (reception).
        i_VALID_RECEIVE_PACKET: in std_logic;
        i_VALID_RECEIVE_DATA  : in std_logic;
        i_LAST_RECEIVE_DATA   : in std_logic;

        i_ID_RECEIVE     : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
        i_LEN_RECEIVE    : in std_logic_vector(7 downto 0);
        i_BURST_RECEIVE  : in std_logic_vector(1 downto 0);
        i_OPC_RECEIVE    : in std_logic;
        i_ADDRESS_RECEIVE: in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
        i_DATA_RECEIVE   : in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        i_CORRUPT_RECEIVE: in std_logic;

        o_READY_RECEIVE_PACKET: out std_logic;
        o_READY_RECEIVE_DATA  : out std_logic
    );
end frontend_slave;

architecture rtl of frontend_slave is
    signal w_VALID_SEND_DATA: std_logic;

begin
    ---------------------------------------------------------------------------------------------
    -- Injection.

    -- Registering transaction information.
    registering: process(all)
    begin
        if (rising_edge(ACLK)) then
            if (w_VALID_SEND_DATA = '1') then
                if (BVALID = '1') then
                    -- Registering write signals.
                    o_STATUS_SEND <= BRESP;
                elsif (RVALID = '1') then
                    -- Registering read signals.
                    o_STATUS_SEND <= RRESP;
                end if;
            end if;
        end if;
    end process registering;

    -- Control information.
    w_VALID_SEND_DATA   <= '1' when (BVALID = '1' or RVALID = '1') else '0';
    o_VALID_SEND_DATA   <= w_VALID_SEND_DATA;

    o_LAST_SEND_DATA    <= RLAST;
    o_DATA_SEND         <= RDATA when (RVALID = '1') else (c_AXI_DATA_WIDTH - 1 downto 0 => '0');

    -- Ready information to IP.
    BREADY <= '1' when (i_OPC_RECEIVE = '0' and i_READY_SEND_DATA = '1') else '0';
    RREADY <= '1' when (i_OPC_RECEIVE = '1' and i_READY_SEND_DATA = '1') else '0';

    ---------------------------------------------------------------------------------------------
    -- Reception.
    o_READY_RECEIVE_PACKET <= '1' when (i_OPC_RECEIVE = '0' and AWREADY = '1') or
                                       (i_OPC_RECEIVE = '1' and ARREADY = '1') else '0';
    o_READY_RECEIVE_DATA   <= WREADY;

    AWVALID <= '1' when (i_OPC_RECEIVE = '0' and i_VALID_RECEIVE_PACKET = '1') else '0';
    AWID    <= i_ID_RECEIVE when (i_OPC_RECEIVE = '0' and i_VALID_RECEIVE_PACKET = '1') else (c_AXI_ID_WIDTH - 1 downto 0 => '0');
    AWADDR  <= i_ADDRESS_RECEIVE & (0 to 31 => '0') when (i_OPC_RECEIVE = '0' and i_VALID_RECEIVE_PACKET = '1') else (c_AXI_ADDR_WIDTH - 1 downto 0 => '0');
    AWLEN   <= i_LEN_RECEIVE when (i_OPC_RECEIVE = '0' and i_VALID_RECEIVE_PACKET = '1') else (7 downto 0 => '0');
    AWBURST <= i_BURST_RECEIVE when (i_OPC_RECEIVE = '0' and i_VALID_RECEIVE_PACKET = '1') else (1 downto 0 => '0');
    AWSIZE  <= "010";

    WVALID <= '1' when (i_VALID_RECEIVE_DATA = '1') else '0'; -- @TODO: Mudar aqui
    --WVALID <= '1' when (i_VALID_RECEIVE_DATA = '1' or (i_OPC_RECEIVE = '0' and i_VALID_RECEIVE_PACKET = '1')) else '0'; -- @TODO: Mudar aqui
    WDATA  <= i_DATA_RECEIVE when (i_VALID_RECEIVE_DATA = '1') else (c_AXI_DATA_WIDTH - 1 downto 0 => '0');
    WLAST  <= i_LAST_RECEIVE_DATA;

    ARVALID <= '1' when (i_OPC_RECEIVE = '1' and i_VALID_RECEIVE_PACKET = '1') else '0';
    ARID    <= i_ID_RECEIVE when (i_OPC_RECEIVE = '1' and i_VALID_RECEIVE_PACKET = '1') else (c_AXI_ID_WIDTH - 1 downto 0 => '0');
    ARADDR  <= i_ADDRESS_RECEIVE & (0 to 31 => '0') when (i_OPC_RECEIVE = '1' and i_VALID_RECEIVE_PACKET = '1') else (c_AXI_ADDR_WIDTH - 1 downto 0 => '0');
    ARLEN   <= i_LEN_RECEIVE when (i_OPC_RECEIVE = '1' and i_VALID_RECEIVE_PACKET = '1') else (7 downto 0 => '0');
    ARBURST <= i_BURST_RECEIVE when (i_OPC_RECEIVE = '1' and i_VALID_RECEIVE_PACKET = '1') else (1 downto 0 => '0');
    ARSIZE  <= "010";

    CORRUPT_PACKET <= i_CORRUPT_RECEIVE;
end rtl;
