library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;

entity tcc_frontend_master_tb is
end tcc_frontend_master_tb;

architecture arch_tcc_frontend_master_tb of tcc_frontend_master_tb is
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

    -- Signals between front-end and back-end.
    signal t_BACKEND_VALID_IN  : std_logic := '0';
    signal t_BACKEND_OPC_IN    : std_logic := '0';
    signal t_BACKEND_ADDR_IN   : std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
    signal t_BACKEND_BURST_IN  : std_logic_vector(1 downto 0);
    signal t_BACKEND_LENGTH_IN : std_logic_vector(7 downto 0);
    signal t_BACKEND_DATA_IN   : std_logic_vector(c_DATA_WIDTH - 1 downto 0);
    signal t_BACKEND_ID_IN     : std_logic_vector(c_ID_WIDTH - 1 downto 0);

    signal t_BACKEND_READY_OUT : std_logic := '1';

begin
    u_TCC_FRONTEND_MASTER: entity work.tcc_frontend_master
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

            -- Backend signals.
            i_BACKEND_READY  => t_BACKEND_READY_OUT,

            o_BACKEND_OPC    => t_BACKEND_OPC_IN,
            o_BACKEND_ADDR   => t_BACKEND_ADDR_IN,
            o_BACKEND_BURST  => t_BACKEND_BURST_IN,
            o_BACKEND_LENGTH => t_BACKEND_LENGTH_IN,
            o_BACKEND_VALID  => t_BACKEND_VALID_IN,
            o_BACKEND_DATA   => t_BACKEND_DATA_IN,
            o_BACKEND_ID     => t_BACKEND_ID_IN
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

end arch_tcc_frontend_master_tb;