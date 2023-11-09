library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_top_slave is
    generic(
        p_SRC_X: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0) := (others => '0');
        p_SRC_Y: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0) := (others => '0');

        p_BUFFER_DEPTH      : positive := c_BUFFER_DEPTH;
        p_USE_TMR_PACKETIZER: boolean  := c_USE_TMR_PACKETIZER;
        p_USE_TMR_FLOW      : boolean  := c_USE_TMR_FLOW;
        p_USE_TMR_INTEGRITY : boolean  := c_USE_TMR_INTEGRITY;
        p_USE_HAMMING       : boolean  := c_USE_HAMMING;
        p_USE_INTEGRITY     : boolean  := c_USE_INTEGRITY
    );

    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic;
        ARESETn: in std_logic := '1';

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
            BID    : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
            BRESP  : in std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0) := (others => '0');

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
            RID    : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
            RRESP  : in std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0) := (others => '0');

            -- Extra signals.
            CORRUPT_PACKET: out std_logic;

        -- XINA signals.
        l_in_data_i : out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_in_val_i  : out std_logic;
        l_in_ack_o  : in std_logic;
        l_out_data_o: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_out_val_o : in std_logic;
        l_out_ack_i : out std_logic
    );
end tcc_top_slave;

architecture rtl of tcc_top_slave is
    -- Injection.
    signal w_VALID_SEND_DATA  : std_logic;
    signal w_LAST_SEND_DATA   : std_logic;
    signal w_READY_SEND_DATA  : std_logic;

    signal w_DATA_SEND  : std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
    signal w_STATUS_SEND: std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);

    -- Reception.
    signal w_READY_RECEIVE_PACKET: std_logic;
    signal w_READY_RECEIVE_DATA  : std_logic;

    signal w_VALID_RECEIVE_PACKET: std_logic;
    signal w_VALID_RECEIVE_DATA  : std_logic;
    signal w_LAST_RECEIVE_DATA   : std_logic;

    signal w_ID_RECEIVE     : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
    signal w_LEN_RECEIVE    : std_logic_vector(7 downto 0);
    signal w_BURST_RECEIVE  : std_logic_vector(1 downto 0);
    signal w_OPC_RECEIVE    : std_logic;
    signal w_ADDRESS_RECEIVE: std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
    signal w_DATA_RECEIVE   : std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

    signal w_CORRUPT_RECEIVE: std_logic;

begin
    u_FRONTEND: entity work.frontend_slave
        port map(
            -- AMBA AXI 5 signals.
            ACLK => ACLK,
            ARESETn => ARESETn,

                -- Write request signals.
                AWVALID => AWVALID,
                AWREADY => AWREADY,
                AWID    => AWID,
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
                BID     => BID,
                BRESP   => BRESP,

                -- Read request signals.
                ARVALID => ARVALID,
                ARREADY => ARREADY,
                ARID    => ARID,
                ARADDR  => ARADDR,
                ARLEN   => ARLEN,
                ARSIZE  => ARSIZE,
                ARBURST => ARBURST,

                -- Read response/data signals.
                RVALID  => RVALID,
                RREADY  => RREADY,
                RDATA   => RDATA,
                RLAST   => RLAST,
                RID     => RID,
                RRESP   => RRESP,

                -- Extra signals.
                CORRUPT_PACKET => CORRUPT_PACKET,

            -- Backend signals (injection).
            o_VALID_SEND_DATA   => w_VALID_SEND_DATA,
            o_LAST_SEND_DATA    => w_LAST_SEND_DATA,
            i_READY_SEND_DATA   => w_READY_SEND_DATA,

            o_DATA_SEND   => w_DATA_SEND,
            o_STATUS_SEND => w_STATUS_SEND,

            -- Backend signals (reception).
            o_READY_RECEIVE_PACKET => w_READY_RECEIVE_PACKET,
            o_READY_RECEIVE_DATA   => w_READY_RECEIVE_DATA,

            i_VALID_RECEIVE_PACKET => w_VALID_RECEIVE_PACKET,
            i_VALID_RECEIVE_DATA   => w_VALID_RECEIVE_DATA,
            i_LAST_RECEIVE_DATA    => w_LAST_RECEIVE_DATA,

            i_ID_RECEIVE      => w_ID_RECEIVE,
            i_LEN_RECEIVE     => w_LEN_RECEIVE,
            i_BURST_RECEIVE   => w_BURST_RECEIVE,
            i_OPC_RECEIVE     => w_OPC_RECEIVE,
            i_ADDRESS_RECEIVE => w_ADDRESS_RECEIVE,
            i_DATA_RECEIVE    => w_DATA_RECEIVE,

            i_CORRUPT_RECEIVE => w_CORRUPT_RECEIVE
        );

    u_BACKEND: entity work.backend_slave
        generic map(
            p_SRC_X => p_SRC_X,
            p_SRC_Y => p_SRC_Y,

            p_BUFFER_DEPTH       => p_BUFFER_DEPTH,
            p_USE_TMR_PACKETIZER => p_USE_TMR_PACKETIZER,
            p_USE_TMR_FLOW       => p_USE_TMR_FLOW,
            p_USE_TMR_INTEGRITY  => p_USE_TMR_INTEGRITY,
            p_USE_HAMMING        => p_USE_HAMMING,
            p_USE_INTEGRITY      => p_USE_INTEGRITY
        )

        port map(
            -- AMBA AXI 5 signals.
            ACLK => ACLK,
            ARESETn => ARESETn,

            -- Backend signals (injection).
            i_VALID_SEND_DATA   => w_VALID_SEND_DATA,
            i_LAST_SEND_DATA    => w_LAST_SEND_DATA,
            o_READY_SEND_DATA   => w_READY_SEND_DATA,

            i_DATA_SEND   => w_DATA_SEND,
            i_STATUS_SEND => w_STATUS_SEND,

            -- Backend signals (reception).
            i_READY_RECEIVE_PACKET => w_READY_RECEIVE_PACKET,
            i_READY_RECEIVE_DATA   => w_READY_RECEIVE_DATA,

            o_VALID_RECEIVE_PACKET => w_VALID_RECEIVE_PACKET,
            o_VALID_RECEIVE_DATA   => w_VALID_RECEIVE_DATA,
            o_LAST_RECEIVE_DATA    => w_LAST_RECEIVE_DATA,

            o_ID_RECEIVE      => w_ID_RECEIVE,
            o_LEN_RECEIVE     => w_LEN_RECEIVE,
            o_BURST_RECEIVE   => w_BURST_RECEIVE,
            o_OPC_RECEIVE     => w_OPC_RECEIVE,
            o_ADDRESS_RECEIVE => w_ADDRESS_RECEIVE,
            o_DATA_RECEIVE    => w_DATA_RECEIVE,

            o_CORRUPT_RECEIVE => w_CORRUPT_RECEIVE,

            -- XINA signals.
            l_in_data_i  => l_in_data_i,
            l_in_val_i   => l_in_val_i,
            l_in_ack_o   => l_in_ack_o,
            l_out_data_o => l_out_data_o,
            l_out_val_o  => l_out_val_o,
            l_out_ack_i  => l_out_ack_i
        );
end rtl;