library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;

entity tb_master_frontend is
end tb_master_frontend;

architecture arch_tb_master_frontend of tb_master_frontend is
    -- AMBA-AXI 5 signals.
    signal t_ACLK: std_logic := '0';
    signal t_RESETn: std_logic := '1';

        -- Write request signals.
        signal t_AWVALID: std_logic := '0';
        signal t_AWREADY: std_logic := '0';
        signal t_AW_ID  : std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t_AWADDR : std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
        signal t_AWLEN  : std_logic_vector(7 downto 0) := "00000000";
        signal t_AWSIZE : std_logic_vector(2 downto 0) := "101";
        signal t_AWBURST: std_logic_vector(1 downto 0) := "01";

        -- Write data signals.
        signal t_WVALID : std_logic := '0';
        signal t_WREADY : std_logic := '0';
        signal t_WDATA  : std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
        signal t_WLAST  : std_logic := '0';

        -- Write response signals.
        signal t_BVALID : std_logic := '0';
        signal t_BREADY : std_logic := '0';
        signal t_BRESP  : std_logic_vector(c_RESP_WIDTH - 1 downto 0) := (others => '0');

        -- Read request signals.
        signal t_ARVALID: std_logic := '0';
        signal t_ARREADY: std_logic := '0';
        signal t_AR_ID  : std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t_ARADDR : std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
        signal t_ARLEN  : std_logic_vector(7 downto 0) := "00000000";
        signal t_ARSIZE : std_logic_vector(2 downto 0) := "101";
        signal t_ARBURST: std_logic_vector(1 downto 0) := "01";

        -- Read response/data signals.
        signal t_RVALID : std_logic := '0';
        signal t_RREADY : std_logic := '0';
        signal t_RDATA  : std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
        signal t_RLAST  : std_logic := '0';
        signal t_RRESP  : std_logic_vector(c_RESP_WIDTH - 1 downto 0) := (others => '0');

    -- Signals between front-end and back-end.
    signal t_START_SEND_PACKET: std_logic;
    signal t_VALID_SEND_DATA  : std_logic;
    signal t_LAST_SEND_DATA   : std_logic;

    signal t_READY_SEND_PACKET: std_logic := '1';
    signal t_READY_SEND_DATA  : std_logic := '1';

    signal t_ADDR     : std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
    signal t_BURST    : std_logic_vector(1 downto 0);
    signal t_LENGTH   : std_logic_vector(7 downto 0);
    signal t_DATA_SEND: std_logic_vector(c_DATA_WIDTH - 1 downto 0);
    signal t_OPC_SEND : std_logic;
    signal t_ID       : std_logic_vector(c_ID_WIDTH - 1 downto 0);

    signal t_READY_RECEIVE_PACKET: std_logic;
    signal t_READY_RECEIVE_DATA: std_logic;

    signal t_VALID_RECEIVE_PACKET: std_logic;
    signal t_LAST_RECEIVE_DATA   : std_logic;
    signal t_DATA_RECEIVE  : std_logic_vector(c_DATA_WIDTH - 1 downto 0);
    signal t_OPC_RECEIVE   : std_logic;
    signal t_STATUS_RECEIVE: std_logic_vector(c_RESP_WIDTH - 1 downto 0);

begin
    u_FRONTEND_MASTER: entity work.frontend_master
        port map(
            -- AMBA AXI 5 signals.
            ACLK    => t_ACLK,
            ARESETn => t_RESETn,

                -- Write request signals.
                AWVALID => t_AWVALID,
                AWREADY => t_AWREADY,
                AW_ID   => t_AW_ID,
                AWADDR  => t_AWADDR,
                AWLEN   => t_AWLEN,
                AWSIZE  => t_AWSIZE,
                AWBURST => t_AWBURST,

                -- Write data signals.
                WVALID  => t_WVALID,
                WREADY  => t_WREADY,
                WDATA   => t_WDATA,
                WLAST   => t_WLAST,

                -- Write response signals.
                BVALID  => t_BVALID,
                BREADY  => t_BREADY,
                BRESP   => t_BRESP,

                -- Read request signals.
                ARVALID => t_ARVALID,
                ARREADY => t_ARREADY,
                AR_ID   => t_AR_ID,
                ARADDR  => t_ARADDR,
                ARLEN   => t_ARLEN,
                ARSIZE  => t_ARSIZE,
                ARBURST => t_ARBURST,

                -- Read response/data signals.
                RVALID  => t_RVALID,
                RREADY  => t_RREADY,
                RDATA   => t_RDATA,
                RLAST   => t_RLAST,
                RRESP   => t_RRESP,

            -- Backend signals.
            o_START_SEND_PACKET => t_START_SEND_PACKET,
            o_VALID_SEND_DATA   => t_VALID_SEND_DATA,
            i_READY_SEND_DATA   => t_READY_SEND_DATA,
            i_READY_SEND_PACKET => t_READY_SEND_PACKET,

            o_LAST_SEND_DATA => t_LAST_SEND_DATA,
            o_ADDR      => t_ADDR,
            o_BURST     => t_BURST,
            o_LENGTH    => t_LENGTH,
            o_DATA_SEND => t_DATA_SEND,
            o_OPC_SEND  => t_OPC_SEND,
            o_ID        => t_ID,

            -- Backend signals (reception).
            o_READY_RECEIVE_PACKET => t_READY_RECEIVE_PACKET,
            o_READY_RECEIVE_DATA => t_READY_RECEIVE_DATA,

            i_VALID_RECEIVE_PACKET => t_VALID_RECEIVE_PACKET,
            i_LAST_RECEIVE_DATA    => t_LAST_RECEIVE_DATA,
            i_DATA_RECEIVE         => t_DATA_RECEIVE,
            i_OPC_RECEIVE          => t_OPC_RECEIVE,
            i_STATUS_RECEIVE       => t_STATUS_RECEIVE
        );

    ---------------------------------------------------------------------------------------------
    -- Clock.
    process
    begin
        wait for 50 ns;
        t_ACLK <= not t_ACLK;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Tests.
    process
    begin
        -- Simple write transaction.
        t_AWVALID <= '1';
        t_AWADDR <= "10101010101010101010101010101010" & "10101010101010101010101010101010";
        t_AW_ID <= "00001";
        t_AWLEN <= "00000001";

        wait until rising_edge(t_ACLK) and t_AWREADY = '1';

        t_AWVALID <= '0';
        t_WVALID <= '1';
        t_WDATA <= "10101010101010101010101010101010";
        t_WLAST <= '1';

        wait until rising_edge(t_ACLK) and t_WREADY = '1';
        t_WDATA <= "00000000000000000000000000000000";
        t_WVALID <= '0';
    end process;

end arch_tb_master_frontend;