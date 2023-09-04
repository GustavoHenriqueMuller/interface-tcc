library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_top_master is
    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic    := '0';
        ARESETn: in std_logic := '1';

            -- Write request signals.
            AWVALID: in std_logic  := '0';
            AWREADY: out std_logic := '1';
            AW_ID  : in std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
            AWADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
            AWLEN  : in std_logic_vector(7 downto 0) := "00000000";
            AWSIZE : in std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_DATA_WIDTH / 8, 3));
            AWBURST: in std_logic_vector(1 downto 0) := "01";

            -- Write data signals.
            WVALID : in std_logic  := '0';
            WREADY : out std_logic := '0';
            WDATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
            WLAST  : in std_logic  := '0';

            -- Write response signals.
            BVALID : out std_logic := '0';
            BREADY : in std_logic  := '0';
            BRESP  : out std_logic_vector(c_BRESP_WIDTH - 1 downto 0) := (others => '0');

            -- Read request signals.
            ARVALID: in std_logic  := '0';
            ARREADY: out std_logic := '1';
            AR_ID  : in std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
            ARADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
            ARLEN  : in std_logic_vector(7 downto 0) := "00000000";
            ARSIZE : in std_logic_vector(2 downto 0) := std_logic_vector(to_unsigned(c_DATA_WIDTH / 8, 3));
            ARBURST: in std_logic_vector(1 downto 0) := "01";

            -- Read data signals.
            RVALID : out std_logic := '0';
            RREADY : in std_logic  := '1';
            RDATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
            RLAST  : out std_logic := '0';
            RRESP  : out std_logic_vector(c_RRESP_WIDTH - 1 downto 0) := (others => '0');

        -- XINA signals.
        l_in_data_i : out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_in_val_i  : out std_logic;
        l_in_ack_o  : in std_logic;
        l_out_data_o: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_out_val_o : in std_logic;
        l_out_ack_i : out std_logic
    );
end tcc_top_master;

architecture arch_tcc_top_master of tcc_top_master is
    -- Signals between front-end and back-end.
    signal w_BACKEND_VALID_IN : std_logic;
    signal w_BACKEND_LAST_IN  : std_logic;
    signal w_BACKEND_ADDR_IN  : std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
    signal w_BACKEND_BURST_IN : std_logic_vector(1 downto 0);
    signal w_BACKEND_LENGTH_IN: std_logic_vector(7 downto 0);
    signal w_BACKEND_DATA_IN  : std_logic_vector(c_DATA_WIDTH - 1 downto 0);
    signal w_BACKEND_OPC_IN   : std_logic;
    signal w_BACKEND_ID_IN    : std_logic_vector(c_ID_WIDTH - 1 downto 0);

    signal w_BACKEND_READY_OUT: std_logic;

begin
    u_FRONTEND_MASTER: entity work.frontend_master
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

                -- Read data signals.
                RVALID  => RVALID,
                RREADY  => RREADY,
                RDATA   => RDATA,
                RLAST   => RLAST,
                RRESP   => RRESP,

            -- Backend signals.
            i_BACKEND_READY => w_BACKEND_READY_OUT,

            o_BACKEND_VALID  => w_BACKEND_VALID_IN,
            o_BACKEND_LAST   => w_BACKEND_LAST_IN,
            o_BACKEND_ADDR   => w_BACKEND_ADDR_IN,
            o_BACKEND_BURST  => w_BACKEND_BURST_IN,
            o_BACKEND_LENGTH => w_BACKEND_LENGTH_IN,
            o_BACKEND_DATA   => w_BACKEND_DATA_IN,
            o_BACKEND_OPC    => w_BACKEND_OPC_IN,
            o_BACKEND_ID     => w_BACKEND_ID_IN
        );

    u_BACKEND_MASTER: entity work.backend_master
        port map(
            -- AMBA AXI 5 signals.
            ACLK => ACLK,
            ARESETn => ARESETn,

            -- Backend signals.
            i_VALID  => w_BACKEND_VALID_IN,
            i_LAST   => w_BACKEND_LAST_IN,
			i_ADDR   => w_BACKEND_ADDR_IN,
			i_BURST  => w_BACKEND_BURST_IN,
			i_LENGTH => w_BACKEND_LENGTH_IN,
            i_DATA   => w_BACKEND_DATA_IN,
            i_OPC    => w_BACKEND_OPC_IN,
            i_ID     => w_BACKEND_ID_IN,

			o_READY  => w_BACKEND_READY_OUT,

            -- XINA signals.
            l_in_data_i  => l_in_data_i,
            l_in_val_i   => l_in_val_i,
            l_in_ack_o   => l_in_ack_o,
            l_out_data_o => l_out_data_o,
            l_out_val_o  => l_out_val_o,
            l_out_ack_i  => l_out_ack_i
        );

end arch_tcc_top_master;