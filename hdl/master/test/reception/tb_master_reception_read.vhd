library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tb_master_reception_read is
end tb_master_reception_read;

architecture arch_tb_master_reception_read of tb_master_reception_read is
    -- AMBA-AXI 5 signals.
    signal t_ACLK  : std_logic := '0';
    signal t_RESETn: std_logic := '1';
    signal t_RESET : std_logic := '0';

        -- Write request signals.
        signal t_AWVALID: std_logic := '0';
        signal t_AWREADY: std_logic := '0';
        signal t_AW_ID  : std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
        signal t_AWADDR : std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
        signal t_AWLEN  : std_logic_vector(7 downto 0) := "00000000";
        signal t_AWSIZE : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_DATA_WIDTH / 8, 3));
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
        signal t_ARSIZE : std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_DATA_WIDTH / 8, 3));
        signal t_ARBURST: std_logic_vector(1 downto 0) := "01";

        -- Read response/data signals.
        signal t_RVALID : std_logic := '0';
        signal t_RREADY : std_logic := '0';
        signal t_RDATA  : std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
        signal t_RLAST  : std_logic := '0';
        signal t_RRESP  : std_logic_vector(c_RESP_WIDTH - 1 downto 0) := (others => '0');

    -- Signals of router 1.
    signal t_l_in_data_i : std_logic_vector(data_width_c downto 0);
    signal t_l_in_val_i  : std_logic;
    signal t_l_in_ack_o  : std_logic;
    signal t_l_out_data_o: std_logic_vector(data_width_c downto 0);
    signal t_l_out_val_o : std_logic;
    signal t_l_out_ack_i : std_logic;

begin
    u_READ_RESPONSE_INJECTOR: entity work.read_response_injector
        generic map(
            data_width_p => c_DATA_WIDTH
        )
        port map(
            clk_i  => t_ACLK,
            rst_i  => t_RESET,
            data_o => t_l_in_data_i,
            val_o  => t_l_in_val_i,
            ack_i  => t_l_in_ack_o
        );

    u_TOP_MASTER: entity work.tcc_top_master
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

            -- XINA signals.
            l_in_data_i  => t_l_out_data_o,
            l_in_val_i   => t_l_out_val_o,
            l_in_ack_o   => t_l_out_ack_i,

            l_out_data_o => t_l_in_data_i,
            l_out_val_o  => t_l_in_val_i,
            l_out_ack_i  => t_l_in_ack_o
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
        t_RREADY <= '1';
        wait until rising_edge(t_ACLK) and t_RVALID = '1';

                -- Flit 1.
                t_WVALID <= '1';
                t_WDATA <= "bc1qzk3kxhdxnzkpdgdn9ueg34y08smxgfv0hxvcu3";

                wait until rising_edge(t_ACLK) and t_WREADY = '1';

                -- Flit 2.
                t_WVALID <= '1';
                t_WDATA <= "bc1qzk3kxhdxnzkpdgdn9ueg34y08smxgfv0hxvcu3";
                t_WLAST <= '1';

                wait until rising_edge(t_ACLK) and t_WREADY = '1';

                -- Reset.
                t_WDATA <= "00000000000000000000000000000000";
                t_WVALID <= '0';
                t_WLAST <= '0';

        -- @TODO: RECEBER O PAYLOAD.

        t_RREADY <= '0';
        wait for 100 ns;
    end process;

end arch_tb_master_reception_read;