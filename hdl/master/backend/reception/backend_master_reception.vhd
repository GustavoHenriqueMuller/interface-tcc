library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_reception is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_READY_RECEIVE_PACKET: in std_logic;
        o_VALID_RECEIVE_PACKET: out std_logic;
        o_LAST_RECEIVE_DATA   : out std_logic;
        o_DATA_RECEIVE        : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        o_OPC_RECEIVE         : out std_logic;
        o_STATUS_RECEIVE      : out std_logic_vector(c_RESP_WIDTH - 1 downto 0);

        -- XINA signals.
        l_out_data_o: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_out_val_o : in std_logic;
        l_out_ack_i : out std_logic
    );
end backend_master_reception;

architecture arch_backend_master_reception of backend_master_reception is
    signal w_ARESET: std_logic;

    -- Depacketizer.
    signal w_FLIT: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

    -- Registers.
    signal w_WRITE_HEADER_1_REG: std_logic;
    signal w_HEADER_1: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

    signal w_WRITE_HEADER_2_REG: std_logic;
    signal w_HEADER_2: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

    -- FIFO.
    signal w_WRITE_BUFFER   : std_logic;
    signal w_WRITE_OK_BUFFER: std_logic;
    signal w_READ_BUFFER    : std_logic;
    signal w_READ_OK_BUFFER : std_logic;

begin
    -- @TODO: Talvez criar um processo ao invés de fazer registradores separados assim.
    u_HEADER_1_REG: entity work.reg
        generic map(
            p_DATA_WIDTH => c_FLIT_WIDTH
        )
        port map(
            ACLK => ACLK,
            ARESETn => ARESETn,
            i_WRITE => w_WRITE_HEADER_1_REG,
            i_DATA => w_FLIT,
            o_DATA => w_HEADER_1
        );

    u_HEADER_2_REG: entity work.reg
        generic map(
            p_DATA_WIDTH => c_FLIT_WIDTH
        )
        port map(
            ACLK => ACLK,
            ARESETn => ARESETn,
            i_WRITE => w_WRITE_HEADER_2_REG,
            i_DATA => w_FLIT,
            o_DATA => w_HEADER_2
        );

    o_OPC_RECEIVE <= w_HEADER_2(0);
    o_STATUS_RECEIVE <= w_HEADER_2(5 downto 3);

    u_DEPACKETIZER_CONTROL: entity work.backend_master_depacketizer_control
        port map(
            ACLK => ACLK,
            ARESETn => ARESETn,

            i_READY_RECEIVE_PACKET => i_READY_RECEIVE_PACKET,
            o_VALID_RECEIVE_PACKET => o_VALID_RECEIVE_PACKET,
            o_LAST_RECEIVE_DATA    => o_LAST_RECEIVE_DATA,

            i_FLIT => w_FLIT,
            o_READ_BUFFER => w_READ_BUFFER,
            i_READ_OK_BUFFER => w_READ_OK_BUFFER,

            i_HEADER_1 => w_HEADER_1,
            i_HEADER_2 => w_HEADER_2,

            o_WRITE_HEADER_1_REG => w_WRITE_HEADER_1_REG,
            o_WRITE_HEADER_2_REG => w_WRITE_HEADER_2_REG
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
            data_o => w_FLIT,

            wok_o  => w_WRITE_OK_BUFFER,
            wr_i   => w_WRITE_BUFFER,
            data_i => l_out_data_o
        );

    u_RECEIVE_CONTROL: entity work.backend_master_receive_control
        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_WRITE_OK_BUFFER => w_WRITE_OK_BUFFER,
            o_WRITE_BUFFER    => w_WRITE_BUFFER,

            l_out_val_o => l_out_val_o,
            l_out_ack_i => l_out_ack_i
        );

    w_ARESET <= not ARESETn;
end arch_backend_master_reception;