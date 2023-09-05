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

    -- FIFO.
    signal w_WRITE_BUFFER   : std_logic;
    signal w_WRITE_OK_BUFFER: std_logic;
    signal w_READ_BUFFER    : std_logic := '0';
    signal w_READ_OK_BUFFER : std_logic;

begin
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

    u_BACKEND_MASTER_RECEIVE_CONTROL: entity work.backend_master_receive_control
        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_WRITE_OK_BUFFER  => w_WRITE_OK_BUFFER,
            o_WRITE_BUFFER  => w_WRITE_BUFFER,

            l_out_val_o => l_out_val_o,
            l_out_ack_i => l_out_ack_i
        );

    w_ARESET <= not ARESETn;
end arch_backend_master_reception;