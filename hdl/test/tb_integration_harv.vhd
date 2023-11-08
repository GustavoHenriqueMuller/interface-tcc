library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tb_integration_harv is
end tb_integration_harv;

architecture rtl of tb_integration_harv is
    -- AMBA-AXI 5 signals.
    signal t_ACLK  : std_logic := '0';
    signal t_RESETn: std_logic := '1';
    signal t_RESET : std_logic := '0';
    signal t2_RESETn: std_logic := '1';

        -- Write request signals.
        signal t_AWVALID: std_logic := '0';
        signal t_AWREADY: std_logic := '0';
        signal t_AWID   : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t_AWADDR : std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0) := (others => '0');
        signal t_AWLEN  : std_logic_vector(7 downto 0) := "00000000";
        signal t_AWSIZE : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_AXI_DATA_WIDTH / 8, 3));
        signal t_AWBURST: std_logic_vector(1 downto 0) := "01";

        -- Write data signals.
        signal t_WVALID : std_logic := '0';
        signal t_WREADY : std_logic := '0';
        signal t_WDATA  : std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0) := (others => '0');
        signal t_WLAST  : std_logic := '0';

        -- Write response signals.
        signal t_BVALID : std_logic := '0';
        signal t_BREADY : std_logic := '0';
        signal t_BID    : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t_BRESP  : std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0) := (others => '0');

        -- Read request signals.
        signal t_ARVALID: std_logic := '0';
        signal t_ARREADY: std_logic := '0';
        signal t_ARID   : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t_ARADDR : std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0) := (others => '0');
        signal t_ARLEN  : std_logic_vector(7 downto 0) := "00000000";
        signal t_ARSIZE : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_AXI_DATA_WIDTH / 8, 3));
        signal t_ARBURST: std_logic_vector(1 downto 0) := "01";

        -- Read response/data signals.
        signal t_RVALID : std_logic := '0';
        signal t_RREADY : std_logic := '0';
        signal t_RDATA  : std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0) := (others => '0');
        signal t_RLAST  : std_logic := '0';
        signal t_RID    : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t_RRESP  : std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0) := (others => '0');

        -- Extra signals.
        signal t_CORRUPT_PACKET: std_logic;

    ------------------------------------------------------------------------------------------------------------------
    -- AMBA-AXI 5 signals.
        -- Write request signals.
        signal t2_AWVALID: std_logic := '0';
        signal t2_AWREADY: std_logic := '0';
        signal t2_AWID   : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t2_AWADDR : std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0) := (others => '0');
        signal t2_AWLEN  : std_logic_vector(7 downto 0) := "00000000";
        signal t2_AWSIZE : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_AXI_DATA_WIDTH / 8, 3));
        signal t2_AWBURST: std_logic_vector(1 downto 0) := "01";

        -- Write data signals.
        signal t2_WVALID : std_logic := '0';
        signal t2_WREADY : std_logic := '0';
        signal t2_WDATA  : std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0) := (others => '0');
        signal t2_WLAST  : std_logic := '0';

        -- Write response signals.
        signal t2_BVALID : std_logic := '0';
        signal t2_BREADY : std_logic := '0';
        signal t2_BID    : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t2_BRESP  : std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0) := (others => '0');

        -- Read request signals.
        signal t2_ARVALID: std_logic := '0';
        signal t2_ARREADY: std_logic := '0';
        signal t2_ARID   : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t2_ARADDR : std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0) := (others => '0');
        signal t2_ARLEN  : std_logic_vector(7 downto 0) := "00000000";
        signal t2_ARSIZE : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_AXI_DATA_WIDTH / 8, 3));
        signal t2_ARBURST: std_logic_vector(1 downto 0) := "01";

        -- Read response/data signals.
        signal t2_RVALID : std_logic := '0';
        signal t2_RREADY : std_logic := '0';
        signal t2_RDATA  : std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0) := (others => '0');
        signal t2_RID    : std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t2_RRESP  : std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0) := (others => '0');

        -- Extra signals.
        signal t2_CORRUPT_PACKET: std_logic;

    ------------------------------------------------------------------------------------------------------------------
    -- Signals of master interface.
    signal t_l_in_data_i : std_logic_vector(data_width_c downto 0);
    signal t_l_in_val_i  : std_logic;
    signal t_l_in_ack_o  : std_logic;
    signal t_l_out_data_o: std_logic_vector(data_width_c downto 0);
    signal t_l_out_val_o : std_logic;
    signal t_l_out_ack_i : std_logic;

    -- Signals of slave interface.
    signal t2_l_in_data_i : std_logic_vector(data_width_c downto 0);
    signal t2_l_in_val_i  : std_logic;
    signal t2_l_in_ack_o  : std_logic;
    signal t2_l_out_data_o: std_logic_vector(data_width_c downto 0);
    signal t2_l_out_val_o : std_logic;
    signal t2_l_out_ack_i : std_logic;

    -- Signals of XINA.
    signal l_in_data_i : data_link_l_t;
    signal l_in_val_i  : ctrl_link_l_t;
    signal l_in_ack_o  : ctrl_link_l_t;
    signal l_out_data_o: data_link_l_t;
    signal l_out_val_o : ctrl_link_l_t;
    signal l_out_ack_i : ctrl_link_l_t;

begin
    -- XINA signals.
    l_in_data_i(0, 0) <= t_l_in_data_i;
    l_in_data_i(1, 0) <= t2_l_in_data_i;

    l_in_val_i(0, 0) <= t_l_in_val_i;
    l_in_val_i(1, 0) <= t2_l_in_val_i;

    t_l_in_ack_o <= l_in_ack_o(0, 0);
    t2_l_in_ack_o <= l_in_ack_o(1, 0);

    t_l_out_data_o <= l_out_data_o(0, 0);
    t2_l_out_data_o <= l_out_data_o(1, 0);

    t_l_out_val_o <= l_out_val_o(0, 0);
    t2_l_out_val_o <= l_out_val_o(1, 0);

    l_out_ack_i(0, 0) <= t_l_out_ack_i;
    l_out_ack_i(1, 0) <= t2_l_out_ack_i;

    -- Instances.
    u_TOP_MASTER: entity work.tcc_top_master
        port map(
            -- AMBA AXI 5 signals.
            ACLK    => t_ACLK,
            ARESETn => t_RESETn,

                -- Write request signals.
                AWVALID => t_AWVALID,
                AWREADY => t_AWREADY,
                AWID    => t_AWID,
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
                BID     => t_BID,
                BRESP   => t_BRESP,

                -- Read request signals.
                ARVALID => t_ARVALID,
                ARREADY => t_ARREADY,
                ARID    => t_ARID,
                ARADDR  => t_ARADDR,
                ARLEN   => t_ARLEN,
                ARSIZE  => t_ARSIZE,
                ARBURST => t_ARBURST,

                -- Read response/data signals.
                RVALID  => t_RVALID,
                RREADY  => t_RREADY,
                RDATA   => t_RDATA,
                RLAST   => t_RLAST,
                RID     => t_RID,
                RRESP   => t_RRESP,

                CORRUPT_PACKET => t_CORRUPT_PACKET,

            -- XINA signals.
            l_in_data_i  => t_l_in_data_i,
            l_in_val_i   => t_l_in_val_i,
            l_in_ack_o   => t_l_in_ack_o,
            l_out_data_o => t_l_out_data_o,
            l_out_val_o  => t_l_out_val_o,
            l_out_ack_i  => t_l_out_ack_i
        );

    u_HARV_PROCESSOR: entity work.adder_full_v1_0

    u_TOP_SLAVE: entity work.tcc_top_slave
        generic map(
            p_SRC_X => "0000000000000001",
            p_SRC_Y => "0000000000000000"
        )

        port map(
            -- AMBA AXI 5 signals.
            ACLK    => t_ACLK,
            ARESETn => t_RESETn,

                -- Write request signals.
                AWVALID => t2_AWVALID,
                AWREADY => t2_AWREADY,
                AWID    => t2_AWID,
                AWADDR  => t2_AWADDR,
                AWLEN   => t2_AWLEN,
                AWSIZE  => t2_AWSIZE,
                AWBURST => t2_AWBURST,

                -- Write data signals.
                WVALID  => t2_WVALID,
                WREADY  => t2_WREADY,
                WDATA   => t2_WDATA,
                WLAST   => t2_WLAST,

                -- Write response signals.
                BVALID  => t2_BVALID,
                BREADY  => t2_BREADY,
                BRESP   => t2_BRESP,

                -- Read request signals.
                ARVALID => t2_ARVALID,
                ARREADY => t2_ARREADY,
                ARID    => t2_ARID,
                ARADDR  => t2_ARADDR,
                ARLEN   => t2_ARLEN,
                ARSIZE  => t2_ARSIZE,
                ARBURST => t2_ARBURST,

                -- Read response/data signals.
                RVALID  => t2_RVALID,
                RREADY  => t2_RREADY,
                RDATA   => t2_RDATA,
                RLAST   => '1',
                RRESP   => t2_RRESP,

                -- Extra signals.
                CORRUPT_PACKET => t2_CORRUPT_PACKET,

            -- XINA signals.
            l_in_data_i  => t2_l_in_data_i,
            l_in_val_i   => t2_l_in_val_i,
            l_in_ack_o   => t2_l_in_ack_o,

            l_out_data_o => t2_l_out_data_o,
            l_out_val_o  => t2_l_out_val_o,
            l_out_ack_i  => t2_l_out_ack_i
        );

    u_XINA_NETWORK: entity work.xina
        generic map(
            rows_p => 1,
            cols_p => 2
        )

        port map(
            clk_i => t_ACLK,
            rst_i => t_RESET,

            l_in_data_i  => l_in_data_i,
            l_in_val_i   => l_in_val_i,
            l_in_ack_o   => l_in_ack_o,
            l_out_data_o => l_out_data_o,
            l_out_val_o  => l_out_val_o,
            l_out_ack_i  => l_out_ack_i
        );

    ---------------------------------------------------------------------------------------------
    -- Clock.
    process
    begin
        wait for 50 ns;
        t_ACLK <= not t_ACLK;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Reset.
    process(t_RESETn)
    begin
        t_RESET <= not t_RESETn;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Tests.
    process
    begin
        -- Reset slave.
        t2_RESETn <= '0';
        wait for 100 ns;
        t2_RESETn <= '1';

        ---------------------------------------------------------------------------------------------
        -- First transaction.
        t_AWVALID <= '1';
        t_AWADDR <= "0000000000000000" & "0000000000000000" & "0000000000000001" & "0000000000000000";
        t_AWID <= "00001";
        t_AWLEN <= "00000000";

        wait until rising_edge(t_ACLK) and t_AWREADY = '1';
        t_AWVALID <= '0';

        t_AWADDR <= (others => '0');
        t_AWID <= (others => '0');
        t_AWLEN <= (others => '0');

        -- Flit.
        t_WVALID <= '1';
        t_WDATA <= "00001000010100110000000000000000";
        t_WLAST <= '1';

        wait until rising_edge(t_ACLK) and t_WREADY = '1';

        -- Reset.
        t_WDATA <= (others => '0');
        t_WVALID <= '0';
        t_WLAST <= '0';

        ---------------------------------------------------------------------------------------------
        -- Second transaction.
        t_ARVALID <= '1';
        t_ARADDR <= "0000000000000000" & "0000000000000000" & "0000000000000001" & "0000000000000000";
        t_ARID <= "00001";
        t_ARLEN <= "00000000";

        wait until rising_edge(t_ACLK) and t_ARREADY = '1';
        t_ARVALID <= '0';

        -- RESULT: 00001000010100110000000000001010 / 0853000A

        ---------------------------------------------------------------------------------------------
        -- Receive first transaction response.
        t_BREADY <= '1';

        wait until rising_edge(t_ACLK) and t_BVALID = '1';
        t_BREADY <= '0';

        ---------------------------------------------------------------------------------------------
        -- Receive second transaction response.
        t_RREADY <= '1';

        wait until rising_edge(t_ACLK) and t_RVALID = '1' and t_RLAST = '1';
        t_RREADY <= '0';

        wait;
    end process;
end rtl;
