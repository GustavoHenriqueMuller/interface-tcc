library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_injection is
    generic(
        SRC_X_p: std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0) := (others => '0');
        SRC_Y_p: std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0) := (others => '0')
    );

    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_START_SEND_PACKET: in std_logic;
        i_VALID_SEND_DATA  : in std_logic;
        i_LAST_SEND_DATA   : in std_logic;

        o_READY_SEND_PACKET: out std_logic;
		o_READY_SEND_DATA  : out std_logic;

		i_ADDR     : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
		i_BURST    : in std_logic_vector(1 downto 0);
        i_LENGTH   : in std_logic_vector(7 downto 0);
        i_DATA_SEND: in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_OPC_SEND : in std_logic;
        i_ID       : in std_logic_vector(c_ID_WIDTH - 1 downto 0);

        -- XINA signals.
        l_in_data_i: out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_in_val_i : out std_logic;
        l_in_ack_o : in std_logic
    );
end backend_master_injection;

architecture rtl of backend_master_injection is
    signal w_ARESET: std_logic;

    -- Routing table.
    signal w_OPC_ADDR: std_logic_vector((c_ADDR_WIDTH / 2) - 1 downto 0);
    signal w_DEST_X  : std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0);
    signal w_DEST_Y  : std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0);

    -- Packetizer.
    signal w_FLIT: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_SELECTOR: std_logic_vector(2 downto 0);

    -- FIFO.
    signal w_WRITE_BUFFER   : std_logic;
    signal w_WRITE_OK_BUFFER: std_logic;
    signal w_READ_BUFFER    : std_logic;
    signal w_READ_OK_BUFFER : std_logic;

begin
    u_ROUTING_TABLE: entity work.backend_master_routing_table
        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_ADDR     => i_ADDR,
            o_OPC_ADDR => w_OPC_ADDR,
            o_DEST_X   => w_DEST_X,
            o_DEST_Y   => w_DEST_Y
        );

    u_PACKETIZER_CONTROL: entity work.backend_master_packetizer_control
        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_OPC_SEND => i_OPC_SEND,
            i_START_SEND_PACKET  => i_START_SEND_PACKET,
            i_VALID_SEND_DATA    => i_VALID_SEND_DATA,
            i_LAST_SEND_DATA     => i_LAST_SEND_DATA,

            o_READY_SEND_PACKET  => o_READY_SEND_PACKET,
            o_READY_SEND_DATA    => o_READY_SEND_DATA,

            i_WRITE_OK_BUFFER => w_WRITE_OK_BUFFER,
            o_FLIT_SELECTOR   => w_FLIT_SELECTOR,
            o_WRITE_BUFFER    => w_WRITE_BUFFER
        );

    u_PACKETIZER_DATAPATH: entity work.backend_master_packetizer_datapath
        generic map(
            SRC_X_p => SRC_X_p,
            SRC_Y_p => SRC_Y_p
        )

        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_OPC_ADDR  => w_OPC_ADDR,
            i_BURST     => i_BURST,
            i_LENGTH    => i_LENGTH,
            i_DATA_SEND => i_DATA_SEND,
            i_OPC_SEND  => i_OPC_SEND,
            i_ID        => i_ID,
            i_DEST_X    => w_DEST_X,
            i_DEST_Y    => w_DEST_Y,
            i_FLIT_SELECTOR => w_FLIT_SELECTOR,

            o_FLIT => w_FLIT
        );

    u_BUFFER_FIFO: entity work.buffering
        generic map(
            data_width_p => c_FLIT_WIDTH,
            buffer_depth_p => 4,
            mode_p => 1
        )
        port map(
            clk_i => ACLK,
            rst_i => w_ARESET,

            rok_o  => w_READ_OK_BUFFER,
            rd_i   => w_READ_BUFFER,
            data_o => l_in_data_i,

            wok_o  => w_WRITE_OK_BUFFER,
            wr_i   => w_WRITE_BUFFER,
            data_i => w_FLIT
        );

    u_SEND_CONTROL: entity work.send_control
        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_READ_OK_BUFFER => w_READ_OK_BUFFER,
            o_READ_BUFFER    => w_READ_BUFFER,

            l_in_val_i  => l_in_val_i,
            l_in_ack_o  => l_in_ack_o
        );

    w_ARESET <= not ARESETn;
end rtl;