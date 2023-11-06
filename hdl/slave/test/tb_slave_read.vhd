library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tb_slave_read is
end tb_slave_read;

architecture rtl of tb_slave_read is
    -- AMBA-AXI 5 signals.
    signal t_ACLK  : std_logic := '0';
    signal t_RESETn: std_logic := '1';
    signal t_RESET : std_logic := '0';

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

    -- Signals of slave interface.
    signal t_l_in_data_i : std_logic_vector(data_width_c downto 0);
    signal t_l_in_val_i  : std_logic;
    signal t_l_in_ack_o  : std_logic;
    signal t_l_out_data_o: std_logic_vector(data_width_c downto 0);
    signal t_l_out_val_o : std_logic;
    signal t_l_out_ack_i : std_logic;

    -- Signals of response injector.
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
    u_READ_REQUEST_INJECTOR: entity work.read_request_injector
        generic map(
            data_width_p => c_AXI_DATA_WIDTH
        )
        port map(
            clk_i  => t_ACLK,
            rst_i  => t_RESET,
            data_o => t2_l_in_data_i,
            val_o  => t2_l_in_val_i,
            ack_i  => t2_l_in_ack_o
        );

    u_TOP_SLAVE: entity work.tcc_top_slave
        generic map(
            p_SRC_X => (others => '0'),
            p_SRC_Y => (others => '0')
        )

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

                -- Extra signals.
                CORRUPT_PACKET => t_CORRUPT_PACKET,

            -- XINA signals.
            l_in_data_i  => t_l_in_data_i,
            l_in_val_i   => t_l_in_val_i,
            l_in_ack_o   => t_l_in_ack_o,

            l_out_data_o => t_l_out_data_o,
            l_out_val_o  => t_l_out_val_o,
            l_out_ack_i  => t_l_out_ack_i
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
    t_RESET <= not t_RESETn;

    ---------------------------------------------------------------------------------------------
    -- Tests.
    process
    begin
        -- Receiving read transaction.
        t_ARREADY <= '1';
        wait until rising_edge(t_ACLK) and t_ARVALID = '1';

        t_ARREADY <= '0';

        -- Sending read data (2 flits).
        t_RVALID <= '1';
        t_RDATA  <= "10101010101010101010101010101010"; -- AAA
        t_RRESP  <= "101";
        t_RLAST  <= '0';

        wait until rising_edge(t_ACLK) and t_RREADY = '1';

        t_RVALID <= '1';
        t_RDATA  <= "11011101110111011101110111011101"; -- DDD
        t_RRESP  <= "101";
        t_RLAST  <= '1';

        -- Ending transaction.
        wait until rising_edge(t_ACLK) and t_RREADY = '1';

        t_RVALID <= '0';
        t_RLAST  <= '0';
        t_RRESP  <= "000";
        wait;
    end process;
end rtl;