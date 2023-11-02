library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_injection is
    generic(
        p_SRC_X: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);
        p_SRC_Y: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);

        p_BUFFER_DEPTH: positive;
        p_BUFFER_MODE : natural;
        p_USE_TMR     : boolean;
        p_USE_HAMMING : boolean
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

		i_ADDR     : in std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);
		i_ID       : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
        i_LENGTH   : in std_logic_vector(7 downto 0);
        i_BURST    : in std_logic_vector(1 downto 0);
        i_OPC_SEND : in std_logic;
        i_DATA_SEND: in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        -- XINA signals.
        l_in_data_i: out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_in_val_i : out std_logic;
        l_in_ack_o : in std_logic
    );
end backend_master_injection;

architecture rtl of backend_master_injection is
    signal w_ARESET: std_logic;

    -- Routing table.
    signal w_OPC_ADDR: std_logic_vector((c_AXI_ADDR_WIDTH / 2) - 1 downto 0);
    signal w_DEST_X  : std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);
    signal w_DEST_Y  : std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);

    -- Packetizer.
    signal w_FLIT: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_SELECTOR: std_logic_vector(2 downto 0);

    -- Checksum.
    signal w_ADD: std_logic;
    signal w_CHECKSUM: std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
    signal w_INTEGRITY_RESETn: std_logic;

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

    u_PACKETIZER_CONTROL:
    if (p_USE_TMR) generate
        u_PACKETIZER_CONTROL_TMR: entity work.backend_master_packetizer_control_tmr
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_OPC_SEND => i_OPC_SEND,
                i_START_SEND_PACKET  => i_START_SEND_PACKET,
                i_VALID_SEND_DATA    => i_VALID_SEND_DATA,
                i_LAST_SEND_DATA     => i_LAST_SEND_DATA,

                o_READY_SEND_PACKET  => o_READY_SEND_PACKET,
                o_READY_SEND_DATA    => o_READY_SEND_DATA,
                o_FLIT_SELECTOR      => w_FLIT_SELECTOR,

                i_WRITE_OK_BUFFER => w_WRITE_OK_BUFFER,
                o_WRITE_BUFFER    => w_WRITE_BUFFER,

                o_ADD => w_ADD,
                o_INTEGRITY_RESETn => w_INTEGRITY_RESETn
            );
    else generate
        u_PACKETIZER_CONTROL_NORMAL: entity work.backend_master_packetizer_control
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_OPC_SEND => i_OPC_SEND,
                i_START_SEND_PACKET  => i_START_SEND_PACKET,
                i_VALID_SEND_DATA    => i_VALID_SEND_DATA,
                i_LAST_SEND_DATA     => i_LAST_SEND_DATA,

                o_READY_SEND_PACKET  => o_READY_SEND_PACKET,
                o_READY_SEND_DATA    => o_READY_SEND_DATA,
                o_FLIT_SELECTOR      => w_FLIT_SELECTOR,

                i_WRITE_OK_BUFFER => w_WRITE_OK_BUFFER,
                o_WRITE_BUFFER    => w_WRITE_BUFFER,

                o_ADD => w_ADD,
                o_INTEGRITY_RESETn => w_INTEGRITY_RESETn
            );
    end generate;

    u_PACKETIZER_DATAPATH: entity work.backend_master_packetizer_datapath
        generic map(
            p_SRC_X => p_SRC_X,
            p_SRC_Y => p_SRC_Y
        )

        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_OPC_ADDR  => w_OPC_ADDR,
            i_ID        => i_ID,
            i_LENGTH    => i_LENGTH,
            i_BURST     => i_BURST,
            i_OPC_SEND  => i_OPC_SEND,
            i_DATA_SEND => i_DATA_SEND,

            i_DEST_X    => w_DEST_X,
            i_DEST_Y    => w_DEST_Y,
            i_FLIT_SELECTOR => w_FLIT_SELECTOR,
            i_CHECKSUM  => w_CHECKSUM,

            o_FLIT => w_FLIT
        );

    u_INTEGRITY_CONTROL_SEND: entity work.integrity_control_send
        port map(
            ACLK    => ACLK,
            ARESETn => w_INTEGRITY_RESETn,

            i_ADD   => w_ADD,
            i_VALUE_ADD => w_FLIT(c_AXI_DATA_WIDTH - 1 downto 0),

            o_CHECKSUM => w_CHECKSUM
        );

    u_BUFFER_FIFO:
    if (p_USE_HAMMING) generate
        u_BUFFER_FIFO_HAM: entity work.buffering_ham
            generic map(
                data_width_p => c_FLIT_WIDTH,
                buffer_depth_p => p_BUFFER_DEPTH,
                mode_p => p_BUFFER_MODE
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
    else generate
        u_BUFFER_FIFO_NORMAL: entity work.buffering
            generic map(
                data_width_p => c_FLIT_WIDTH,
                buffer_depth_p => p_BUFFER_DEPTH,
                mode_p => p_BUFFER_MODE
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
    end generate;

    u_SEND_CONTROL:
    if (p_USE_TMR) generate
        u_SEND_CONTROL_TMR: entity work.send_control_tmr
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_READ_OK_BUFFER => w_READ_OK_BUFFER,
                o_READ_BUFFER    => w_READ_BUFFER,

                l_in_val_i  => l_in_val_i,
                l_in_ack_o  => l_in_ack_o
            );
    else generate
        u_SEND_CONTROL_NORMAL: entity work.send_control
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_READ_OK_BUFFER => w_READ_OK_BUFFER,
                o_READ_BUFFER    => w_READ_BUFFER,

                l_in_val_i  => l_in_val_i,
                l_in_ack_o  => l_in_ack_o
            );
    end generate;

    w_ARESET <= not ARESETn;
end rtl;