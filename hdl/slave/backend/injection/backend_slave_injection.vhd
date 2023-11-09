library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_slave_injection is
    generic(
        p_SRC_X: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);
        p_SRC_Y: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);

        p_BUFFER_DEPTH      : positive;
        p_USE_TMR_PACKETIZER: boolean;
        p_USE_TMR_FLOW      : boolean;
        p_USE_TMR_INTEGRITY : boolean;
        p_USE_HAMMING       : boolean;
        p_USE_INTEGRITY     : boolean
    );

    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_VALID_SEND_DATA: in std_logic;
        i_LAST_SEND_DATA : in std_logic;
        o_READY_SEND_DATA: out std_logic;

        i_DATA_SEND  : in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
        i_STATUS_SEND: in std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);

        -- Signals from reception.
        i_H_SRC_RECEIVE        : in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        i_H_INTERFACE_RECEIVE  : in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        i_HAS_REQUEST_PACKET   : in std_logic;
        o_HAS_FINISHED_RESPONSE: out std_logic;

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

    -- Checksum.
    signal w_ADD: std_logic;
    signal w_CHECKSUM: std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal w_INTEGRITY_RESETn: std_logic;

    -- FIFO.
    signal w_WRITE_BUFFER   : std_logic;
    signal w_WRITE_OK_BUFFER: std_logic;
    signal w_READ_BUFFER    : std_logic;
    signal w_READ_OK_BUFFER : std_logic;
begin
    u_PACKETIZER_CONTROL:
    if (p_USE_TMR_PACKETIZER) generate
        u_PACKETIZER_CONTROL_TMR: entity work.backend_slave_packetizer_control_tmr
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_OPC_SEND => i_H_INTERFACE_RECEIVE(1),
                i_VALID_SEND_DATA => i_VALID_SEND_DATA,
                i_LAST_SEND_DATA  => i_LAST_SEND_DATA,
                o_READY_SEND_DATA => o_READY_SEND_DATA,
                o_FLIT_SELECTOR   => w_FLIT_SELECTOR,

                i_HAS_REQUEST_PACKET    => i_HAS_REQUEST_PACKET,
                o_HAS_FINISHED_RESPONSE => o_HAS_FINISHED_RESPONSE,

                i_WRITE_OK_BUFFER => w_WRITE_OK_BUFFER,
                o_WRITE_BUFFER    => w_WRITE_BUFFER,

                o_ADD => w_ADD,
                o_INTEGRITY_RESETn => w_INTEGRITY_RESETn
            );
    else generate
        u_PACKETIZER_CONTROL_NORMAL: entity work.backend_slave_packetizer_control
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_OPC_SEND => i_H_INTERFACE_RECEIVE(1),
                i_VALID_SEND_DATA => i_VALID_SEND_DATA,
                i_LAST_SEND_DATA  => i_LAST_SEND_DATA,
                o_READY_SEND_DATA => o_READY_SEND_DATA,
                o_FLIT_SELECTOR   => w_FLIT_SELECTOR,

                i_HAS_REQUEST_PACKET    => i_HAS_REQUEST_PACKET,
                o_HAS_FINISHED_RESPONSE => o_HAS_FINISHED_RESPONSE,

                i_WRITE_OK_BUFFER => w_WRITE_OK_BUFFER,
                o_WRITE_BUFFER    => w_WRITE_BUFFER,

                o_ADD => w_ADD,
                o_INTEGRITY_RESETn => w_INTEGRITY_RESETn
            );
    end generate;

    u_PACKETIZER_DATAPATH: entity work.backend_slave_packetizer_datapath
        generic map(
            p_SRC_X => p_SRC_X,
            p_SRC_Y => p_SRC_Y
        )

        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_DATA_SEND           => i_DATA_SEND,
            i_STATUS_SEND         => i_STATUS_SEND,
            i_H_SRC_RECEIVE       => i_H_SRC_RECEIVE,
            i_H_INTERFACE_RECEIVE => i_H_INTERFACE_RECEIVE,
            i_FLIT_SELECTOR       => w_FLIT_SELECTOR,
            i_CHECKSUM            => w_CHECKSUM,

            o_FLIT => w_FLIT
        );

    u_INTEGRITY_CONTROL_SEND:
    if (p_USE_INTEGRITY and p_USE_TMR_INTEGRITY) generate
        u_INTEGRITY_CONTROL_SEND_TMR: entity work.integrity_control_send_tmr
            port map(
                ACLK    => ACLK,
                ARESETn => w_INTEGRITY_RESETn,

                i_ADD       => w_ADD,
                i_VALUE_ADD => w_FLIT(c_AXI_DATA_WIDTH - 1 downto 0),

                o_CHECKSUM => w_CHECKSUM
            );
    elsif (p_USE_INTEGRITY) generate
        u_INTEGRITY_CONTROL_SEND_NORMAL: entity work.integrity_control_send
            port map(
                ACLK    => ACLK,
                ARESETn => w_INTEGRITY_RESETn,

                i_ADD       => w_ADD,
                i_VALUE_ADD => w_FLIT(c_AXI_DATA_WIDTH - 1 downto 0),

                o_CHECKSUM => w_CHECKSUM
            );
    end generate;

    u_BUFFER_FIFO:
    if (p_USE_HAMMING) generate
        u_BUFFER_FIFO_HAM: entity work.buffer_fifo_ham
            generic map(
                p_DATA_WIDTH   => c_FLIT_WIDTH,
                p_BUFFER_DEPTH => p_BUFFER_DEPTH
            )
            port map(
                ACLK   => ACLK,
                ARESET => w_ARESET,

                o_READ_OK  => w_READ_OK_BUFFER,
                i_READ     => w_READ_BUFFER,
                o_DATA     => l_in_data_i,

                o_WRITE_OK => w_WRITE_OK_BUFFER,
                i_WRITE    => w_WRITE_BUFFER,
                i_DATA     => w_FLIT
            );
    else generate
        u_BUFFER_FIFO_NORMAL: entity work.buffer_fifo
            generic map(
                p_DATA_WIDTH   => c_FLIT_WIDTH,
                p_BUFFER_DEPTH => p_BUFFER_DEPTH
            )
            port map(
                ACLK   => ACLK,
                ARESET => w_ARESET,

                o_READ_OK  => w_READ_OK_BUFFER,
                i_READ     => w_READ_BUFFER,
                o_DATA     => l_in_data_i,

                o_WRITE_OK => w_WRITE_OK_BUFFER,
                i_WRITE    => w_WRITE_BUFFER,
                i_DATA     => w_FLIT
            );
    end generate;

    u_SEND_CONTROL:
    if (p_USE_TMR_FLOW) generate
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