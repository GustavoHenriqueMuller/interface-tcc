library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_tb is
end tcc_tb;

architecture arch_tcc_tb of tcc_tb is
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
        signal t_BRESP  : std_logic_vector(c_BRESP_WIDTH - 1 downto 0) := (others => '0');

        -- Read request signals.
        signal t_ARVALID: std_logic := '0';
        signal t_ARREADY: std_logic := '0';
        signal t_AR_ID  : std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t_ARADDR : std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
        signal t_ARLEN  : std_logic_vector(7 downto 0) := "00000000";
        signal t_ARSIZE : std_logic_vector(2 downto 0) := "101";
        signal t_ARBURST: std_logic_vector(1 downto 0) := "01";

        -- Read data signals.
        signal t_RVALID : std_logic := '0';
        signal t_RREADY : std_logic := '0';
        signal t_RDATA  : std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
        signal t_RLAST  : std_logic := '0';
        signal t_RRESP  : std_logic_vector(c_RRESP_WIDTH - 1 downto 0) := (others => '0');

    -- Signals between backend and XINA router.
    signal t_l_out_data_i : std_logic_vector(data_width_c downto 0);
    signal t_l_out_val_i  : std_logic;
    signal t_l_in_ack_i   : std_logic;
    signal t_l_in_data_o  : std_logic_vector(data_width_c downto 0);
    signal t_l_in_val_o   : std_logic;
    signal t_l_out_ack_o  : std_logic;

    signal t_n_out_data_i : std_logic_vector(data_width_c downto 0);
    signal t_n_out_val_i  : std_logic;
    signal t_n_in_ack_i   : std_logic;
    signal t_n_in_data_o  : std_logic_vector(data_width_c downto 0);
    signal t_n_in_val_o   : std_logic;
    signal t_n_out_ack_o  : std_logic;

    signal t_e_out_data_i : std_logic_vector(data_width_c downto 0);
    signal t_e_out_val_i  : std_logic;
    signal t_e_in_ack_i   : std_logic;
    signal t_e_in_data_o  : std_logic_vector(data_width_c downto 0);
    signal t_e_in_val_o   : std_logic;
    signal t_e_out_ack_o  : std_logic;

    signal t_s_out_data_i : std_logic_vector(data_width_c downto 0);
    signal t_s_out_val_i  : std_logic;
    signal t_s_in_ack_i   : std_logic;
    signal t_s_in_data_o  : std_logic_vector(data_width_c downto 0);
    signal t_s_in_val_o   : std_logic;
    signal t_s_out_ack_o  : std_logic;

    signal t_w_out_data_i : std_logic_vector(data_width_c downto 0);
    signal t_w_out_val_i  : std_logic;
    signal t_w_in_ack_i   : std_logic;
    signal t_w_in_data_o  : std_logic_vector(data_width_c downto 0);
    signal t_w_in_val_o   : std_logic;
    signal t_w_out_ack_o  : std_logic;

begin
    u_TCC_TOP_MASTER: entity work.tcc_top_master
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

                -- Read data signals.
                RVALID  => t_RVALID,
                RREADY  => t_RREADY,
                RDATA   => t_RDATA,
                RLAST   => t_RLAST,
                RRESP   => t_RRESP,

            -- XINA signals.
            l_out_data_i => t_l_out_data_i,
            l_out_val_i  => t_l_out_val_i,
            l_in_ack_i   => t_l_in_ack_i,
            l_in_data_o  => t_l_in_data_o,
            l_in_val_o   => t_l_in_val_o,
            l_out_ack_o  => t_l_out_ack_o
        );

    u_XINA_ROUTER: entity work.router
        port map(
            clk_i => t_ACLK,
            rst_i => not t_RESETn,

            -- local channel interface
            l_in_data_i  => t_l_in_data_o,
            l_in_val_i   => t_l_in_val_o,
            l_in_ack_o   => t_l_in_ack_i,
            l_out_data_o => t_l_out_data_i,
            l_out_val_o  => t_l_out_val_i,
            l_out_ack_i  => t_l_out_ack_o,
            -- north channel interface
            n_in_data_i  => t_l_in_data_o,
            n_in_val_i   => t_l_in_val_o,
            n_in_ack_o   => t_l_in_ack_i,
            n_out_data_o => t_l_out_data_i,
            n_out_val_o  => t_l_out_val_i,
            n_out_ack_i  => t_l_out_ack_o,
            -- east channel interface
            e_in_data_i  => t_l_in_data_o,
            e_in_val_i   => t_l_in_val_o,
            e_in_ack_o   => t_l_in_ack_i,
            e_out_data_o => t_l_out_data_i,
            e_out_val_o  => t_l_out_val_i,
            e_out_ack_i  => t_l_out_ack_o,
            -- south channel interface
            s_in_data_i  => t_l_in_data_o,
            s_in_val_i   => t_l_in_val_o,
            s_in_ack_o   => t_l_in_ack_i,
            s_out_data_o => t_l_out_data_i,
            s_out_val_o  => t_l_out_val_i,
            s_out_ack_i  => t_l_out_ack_o,
            -- west port interface
            w_in_data_i  => t_l_in_data_o,
            w_in_val_i   => t_l_in_val_o,
            w_in_ack_o   => t_l_in_ack_i,
            w_out_data_o => t_l_out_data_i,
            w_out_val_o  => t_l_out_val_i,
            w_out_ack_i  => t_l_out_ack_o
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
        wait for 100 ns;

        -- Simple write transaction.
        t_AWVALID <= '1';
        t_AWADDR <= "10101010";
        t_AW_ID <= "00001";
        t_AWLEN <= "00000001";
        wait for 50 ns;

        t_AWVALID <= '0';
        t_WVALID <= '1';
        t_WDATA <= "10101010101010101010101010101010";
        t_WLAST <= '1';
        wait for 50 ns;
    end process;
end arch_tcc_tb;