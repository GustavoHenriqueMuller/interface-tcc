library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_slave_injection is
    generic(
        SRC_X_p: std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0);
        SRC_Y_p: std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0)
    );

    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_VALID_SEND_DATA: in std_logic;
        i_LAST_SEND_DATA : in std_logic;
        o_READY_SEND_DATA: out std_logic;

        i_DATA_SEND  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_STATUS_SEND: in std_logic_vector(c_RESP_WIDTH - 1 downto 0);

        -- Signals from reception.
        i_H_SRC_RECEIVE: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        i_H_INTERFACE_RECEIVE: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

        -- XINA signals.
        l_in_data_i: out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_in_val_i : out std_logic;
        l_in_ack_o : in std_logic
    );
end backend_slave_injection;

architecture rtl of backend_slave_injection is
    signal w_ARESET: std_logic;

    -- Packetizer.
    signal w_FLIT: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_SELECTOR: std_logic_vector(2 downto 0);

    -- FIFO.
    signal w_WRITE_BUFFER   : std_logic;
    signal w_WRITE_OK_BUFFER: std_logic;
    signal w_READ_BUFFER    : std_logic;
    signal w_READ_OK_BUFFER : std_logic;
begin
    u_PACKETIZER_CONTROL: entity work.backend_slave_packetizer_control
        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_OPC_SEND => i_H_INTERFACE_RECEIVE(1),
            i_VALID_SEND_DATA => i_VALID_SEND_DATA,
            i_LAST_SEND_DATA  => i_LAST_SEND_DATA,
            o_READY_SEND_DATA => o_READY_SEND_DATA,

            i_WRITE_OK_BUFFER => w_WRITE_OK_BUFFER,
            o_FLIT_SELECTOR   => w_FLIT_SELECTOR,
            o_WRITE_BUFFER    => w_WRITE_BUFFER
        );

    u_PACKETIZER_DATAPATH: entity work.backend_slave_packetizer_datapath
        generic map(
            SRC_X_p => SRC_X_p,
            SRC_Y_p => SRC_Y_p
        )

        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_DATA_SEND => i_DATA_SEND,
            i_STATUS_SEND => i_STATUS_SEND,
            i_H_SRC_RECEIVE => i_H_SRC_RECEIVE,
            i_H_INTERFACE_RECEIVE => i_H_INTERFACE_RECEIVE,
            i_FLIT_SELECTOR => w_FLIT_SELECTOR,

            o_FLIT => w_FLIT
        );

    u_BUFFER_FIFO: entity work.buffering
        generic map(
            data_width_p => c_FLIT_WIDTH,
            buffer_depth_p => c_BUFFER_DEPTH,
            mode_p => c_BUFFER_MODE
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

    u_SEND_CONTROL: entity work.send_control_tmr
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