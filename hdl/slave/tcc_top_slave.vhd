library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_top_slave is
    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic    := '0';
        ARESETn: in std_logic := '1';

            -- Write request signals.
            AWVALID: out std_logic := '0';
            AWREADY: in std_logic  := '1';
            AW_ID  : out std_logic_vector(c_ID_WIDTH - 1 downto 0)   := (others => '0');
            AWADDR : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
            AWLEN  : out std_logic_vector(7 downto 0) := "00000000";
            AWSIZE : out std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_DATA_WIDTH / 8, 3));
            AWBURST: out std_logic_vector(1 downto 0) := "01";

            -- Write data signals.
            WVALID : out std_logic := '0';
            WREADY : in std_logic  := '0';
            WDATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
            WLAST  : out std_logic := '0';

            -- Write response signals.
            BVALID : in std_logic  := '0';
            BREADY : out std_logic := '0';
            BRESP  : in std_logic_vector(c_RESP_WIDTH - 1 downto 0) := (others => '0');

            -- Read request signals.
            ARVALID: out std_logic := '0';
            ARREADY: in std_logic  := '1';
            AR_ID  : out std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
            ARADDR : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
            ARLEN  : out std_logic_vector(7 downto 0) := "00000000";
            ARSIZE : out std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_DATA_WIDTH / 8, 3));
            ARBURST: out std_logic_vector(1 downto 0) := "01";

            -- Read response/data signals.
            RVALID : in std_logic  := '0';
            RREADY : out std_logic := '1';
            RDATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
            RLAST  : in std_logic  := '0';
            RRESP  : in std_logic_vector(c_RESP_WIDTH - 1 downto 0) := (others => '0');

        -- XINA signals.
        l_in_data_i : out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_in_val_i  : out std_logic;
        l_in_ack_o  : in std_logic;
        l_out_data_o: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_out_val_o : in std_logic;
        l_out_ack_i : out std_logic
    );
end tcc_top_slave;

architecture arch_tcc_top_slave of tcc_top_slave is
    -- Signals between front-end and back-end.
    -- Injection.
    signal w_START_SEND_PACKET: std_logic;
    signal w_VALID_SEND_DATA  : std_logic;
    signal w_LAST_SEND_DATA   : std_logic;

    signal w_READY_SEND_PACKET : std_logic;
    signal w_READY_SEND_DATA   : std_logic;

    signal w_ADDR     : std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
    signal w_BURST    : std_logic_vector(1 downto 0);
    signal w_LENGTH   : std_logic_vector(7 downto 0);
    signal w_DATA_SEND: std_logic_vector(c_DATA_WIDTH - 1 downto 0);
    signal w_OPC_SEND : std_logic;
    signal w_ID       : std_logic_vector(c_ID_WIDTH - 1 downto 0);

    -- Reception.
    signal w_READY_RECEIVE_PACKET: std_logic;
    signal w_READY_RECEIVE_DATA  : std_logic;

    signal w_VALID_RECEIVE_DATA: std_logic;
    signal w_LAST_RECEIVE_DATA   : std_logic;
    signal w_DATA_RECEIVE  : std_logic_vector(c_DATA_WIDTH - 1 downto 0);
    signal w_OPC_RECEIVE   : std_logic;
    signal w_STATUS_RECEIVE: std_logic_vector(c_RESP_WIDTH - 1 downto 0);

begin
    u_FRONTEND: entity work.frontend_slave
        port map(
            -- AMBA AXI 5 signals.
            ACLK => ACLK,
            ARESETn => ARESETn,

                -- Write request signals.
                AWVALID => AWVALID,
                AWREADY => AWREADY,
                AW_ID   => AW_ID,
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
                BRESP   => BRESP,

                -- Read request signals.
                ARVALID => ARVALID,
                ARREADY => ARREADY,
                AR_ID   => AR_ID,
                ARADDR  => ARADDR,
                ARLEN   => ARLEN,
                ARSIZE  => ARSIZE,
                ARBURST => ARBURST,

                -- Read response/data signals.
                RVALID  => RVALID,
                RREADY  => RREADY,
                RDATA   => RDATA,
                RLAST   => RLAST,
                RRESP   => RRESP,

            -- Backend signals.
            o_START_SEND_PACKET => w_START_SEND_PACKET,
            o_VALID_SEND_DATA   => w_VALID_SEND_DATA,
            o_LAST_SEND_DATA    => w_LAST_SEND_DATA,

            i_READY_SEND_DATA   => w_READY_SEND_DATA,
            i_READY_SEND_PACKET => w_READY_SEND_PACKET,

            o_ADDR      => w_ADDR,
            o_BURST     => w_BURST,
            o_LENGTH    => w_LENGTH,
            o_DATA_SEND => w_DATA_SEND,
            o_OPC_SEND  => w_OPC_SEND,
            o_ID        => w_ID,

            -- Backend signals (reception).
            o_READY_RECEIVE_PACKET => w_READY_RECEIVE_PACKET,
            o_READY_RECEIVE_DATA   => w_READY_RECEIVE_DATA,

            i_VALID_RECEIVE_DATA => w_VALID_RECEIVE_DATA,
            i_LAST_RECEIVE_DATA    => w_LAST_RECEIVE_DATA,
            i_DATA_RECEIVE         => w_DATA_RECEIVE,
            i_OPC_RECEIVE          => w_OPC_RECEIVE,
            i_STATUS_RECEIVE       => w_STATUS_RECEIVE
        );

    u_BACKEND: entity work.backend_slave
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

            o_VALID_RECEIVE_DATA => w_VALID_RECEIVE_DATA,
            o_LAST_RECEIVE_DATA    => w_LAST_RECEIVE_DATA,
            o_DATA_RECEIVE         => w_DATA_RECEIVE,
            o_OPC_RECEIVE          => w_OPC_RECEIVE,
            o_STATUS_RECEIVE       => w_STATUS_RECEIVE,

            -- XINA signals.
            l_in_data_i  => l_in_data_i,
            l_in_val_i   => l_in_val_i,
            l_in_ack_o   => l_in_ack_o,
            l_out_data_o => l_out_data_o,
            l_out_val_o  => l_out_val_o,
            l_out_ack_i  => l_out_ack_i
        );

end arch_tcc_top_slave;