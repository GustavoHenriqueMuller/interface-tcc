library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_top_master is
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
            AWVALID: in std_logic;
            AWREADY: out std_logic;
            AWID   : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            AWADDR : in std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);
            AWLEN  : in std_logic_vector(7 downto 0) := (others => '0');
            AWBURST: in std_logic_vector(1 downto 0) := "01";

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
            ARID   : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
            ARADDR : in std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0) := (others => '0');
            ARLEN  : in std_logic_vector(7 downto 0) := (others => '0');
            ARBURST: in std_logic_vector(1 downto 0) := "01";

            -- Read response/data signals.
            RVALID : out std_logic;
            RREADY : in std_logic;
            RDATA  : out std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
            RLAST  : out std_logic;
            RID    : out std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
            RRESP  : out std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);

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
end tcc_top_master;

architecture rtl of tcc_top_master is
    -- Injection.
    signal w_START_SEND_PACKET: std_logic;
    signal w_VALID_SEND_DATA  : std_logic;
    signal w_LAST_SEND_DATA   : std_logic;

    signal w_READY_SEND_PACKET: std_logic;
    signal w_READY_SEND_DATA  : std_logic;

    signal w_ADDR     : std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);
    signal w_BURST    : std_logic_vector(1 downto 0);
    signal w_LENGTH   : std_logic_vector(7 downto 0);
    signal w_DATA_SEND: std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
    signal w_OPC_SEND : std_logic;
    signal w_ID       : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);

    -- Reception.
    signal w_READY_RECEIVE_PACKET: std_logic;
    signal w_READY_RECEIVE_DATA  : std_logic;

    signal w_VALID_RECEIVE_DATA: std_logic;
    signal w_LAST_RECEIVE_DATA : std_logic;

    signal w_ID_RECEIVE    : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
    signal w_STATUS_RECEIVE: std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);
    signal w_OPC_RECEIVE   : std_logic;
    signal w_DATA_RECEIVE  : std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

    signal w_CORRUPT_RECEIVE: std_logic;

begin
    u_FRONTEND: entity work.frontend_master
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

            -- Backend signals.
            i_READY_SEND_PACKET => w_READY_SEND_PACKET,
            i_READY_SEND_DATA   => w_READY_SEND_DATA,

            o_START_SEND_PACKET => w_START_SEND_PACKET,
            o_VALID_SEND_DATA   => w_VALID_SEND_DATA,
            o_LAST_SEND_DATA    => w_LAST_SEND_DATA,

            o_ADDR      => w_ADDR,
            o_BURST     => w_BURST,
            o_LENGTH    => w_LENGTH,
            o_DATA_SEND => w_DATA_SEND,
            o_OPC_SEND  => w_OPC_SEND,
            o_ID        => w_ID,

            -- Backend signals (reception).
            i_VALID_RECEIVE_DATA => w_VALID_RECEIVE_DATA,
            i_LAST_RECEIVE_DATA  => w_LAST_RECEIVE_DATA,

            i_ID_RECEIVE     => w_ID_RECEIVE,
            i_STATUS_RECEIVE => w_STATUS_RECEIVE,
            i_OPC_RECEIVE    => w_OPC_RECEIVE,
            i_DATA_RECEIVE   => w_DATA_RECEIVE,

            i_CORRUPT_RECEIVE      => w_CORRUPT_RECEIVE,

            o_READY_RECEIVE_PACKET => w_READY_RECEIVE_PACKET,
            o_READY_RECEIVE_DATA   => w_READY_RECEIVE_DATA
        );

    u_BACKEND: entity work.backend_master
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

            -- Backend signals.
            i_START_SEND_PACKET => w_START_SEND_PACKET,
            i_VALID_SEND_DATA   => w_VALID_SEND_DATA,
            i_LAST_SEND_DATA    => w_LAST_SEND_DATA,
            o_READY_SEND_DATA   => w_READY_SEND_DATA,
            o_READY_SEND_PACKET => w_READY_SEND_PACKET,

            i_ADDR      => w_ADDR,
            i_BURST     => w_BURST,
            i_LENGTH    => w_LENGTH,
            i_DATA_SEND => w_DATA_SEND,
            i_OPC_SEND  => w_OPC_SEND,
            i_ID        => w_ID,

            -- Backend signals (reception).
            i_READY_RECEIVE_PACKET => w_READY_RECEIVE_PACKET,
            i_READY_RECEIVE_DATA   => w_READY_RECEIVE_DATA,

            o_VALID_RECEIVE_DATA   => w_VALID_RECEIVE_DATA,
            o_LAST_RECEIVE_DATA    => w_LAST_RECEIVE_DATA,

            o_ID_RECEIVE     => w_ID_RECEIVE,
            o_STATUS_RECEIVE => w_STATUS_RECEIVE,
            o_OPC_RECEIVE    => w_OPC_RECEIVE,
            o_DATA_RECEIVE   => w_DATA_RECEIVE,

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