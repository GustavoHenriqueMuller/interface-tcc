library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_reception is
    generic(
        p_BUFFER_DEPTH: positive;
        p_USE_TMR     : boolean;
        p_USE_HAMMING : boolean
    );

    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_READY_RECEIVE_PACKET: in std_logic;
        i_READY_RECEIVE_DATA  : in std_logic;

        o_VALID_RECEIVE_DATA: out std_logic;
        o_LAST_RECEIVE_DATA : out std_logic;

        o_ID_RECEIVE    : out std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
        o_STATUS_RECEIVE: out std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);
        o_OPC_RECEIVE   : out std_logic;
        o_DATA_RECEIVE  : out std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        o_CORRUPT_RECEIVE: out std_logic;

        -- XINA signals.
        l_out_data_o: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_out_val_o : in std_logic;
        l_out_ack_i : out std_logic
    );
end backend_master_reception;

architecture rtl of backend_master_reception is
    signal w_ARESET: std_logic;

    -- Depacketizer.
    signal w_FLIT: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

    -- Registers.
    signal w_WRITE_H_INTERFACE_REG: std_logic;
    signal w_H_INTERFACE: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

    -- Checksum.
    signal w_ADD: std_logic;
    signal w_COMPARE : std_logic;
    signal w_CHECKSUM: std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
    signal w_INTEGRITY_RESETn: std_logic;

    -- FIFO.
    signal w_WRITE_BUFFER   : std_logic;
    signal w_WRITE_OK_BUFFER: std_logic;
    signal w_READ_BUFFER    : std_logic;
    signal w_READ_OK_BUFFER : std_logic;

begin
    -- Registering headers.
    registering: process(all)
    begin
        if (rising_edge(ACLK) and w_WRITE_H_INTERFACE_REG = '1') then
            w_H_INTERFACE <= w_FLIT;
        end if;
    end process registering;

    o_ID_RECEIVE     <= w_H_INTERFACE(19 downto 15);
    o_STATUS_RECEIVE <= w_H_INTERFACE(4 downto 2);
    o_OPC_RECEIVE    <= w_H_INTERFACE(1);
    o_DATA_RECEIVE   <= w_FLIT(31 downto 0);

    u_DEPACKETIZER_CONTROL:
    if (p_USE_TMR) generate
        u_DEPACKETIZER_CONTROL_TMR: entity work.backend_master_depacketizer_control_tmr
            port map(
                ACLK => ACLK,
                ARESETn => ARESETn,

                i_READY_RECEIVE_PACKET => i_READY_RECEIVE_PACKET,
                i_READY_RECEIVE_DATA   => i_READY_RECEIVE_DATA,
                o_VALID_RECEIVE_DATA   => o_VALID_RECEIVE_DATA,
                o_LAST_RECEIVE_DATA    => o_LAST_RECEIVE_DATA,

                i_FLIT           => w_FLIT,
                i_READ_OK_BUFFER => w_READ_OK_BUFFER,
                o_READ_BUFFER    => w_READ_BUFFER,

                o_WRITE_H_INTERFACE_REG => w_WRITE_H_INTERFACE_REG,

                o_ADD     => w_ADD,
                o_COMPARE => w_COMPARE,
                o_INTEGRITY_RESETn => w_INTEGRITY_RESETn
            );
    else generate
        u_DEPACKETIZER_CONTROL_NORMAL: entity work.backend_master_depacketizer_control
            port map(
                ACLK => ACLK,
                ARESETn => ARESETn,

                i_READY_RECEIVE_PACKET => i_READY_RECEIVE_PACKET,
                i_READY_RECEIVE_DATA   => i_READY_RECEIVE_DATA,
                o_VALID_RECEIVE_DATA   => o_VALID_RECEIVE_DATA,
                o_LAST_RECEIVE_DATA    => o_LAST_RECEIVE_DATA,

                i_FLIT           => w_FLIT,
                i_READ_OK_BUFFER => w_READ_OK_BUFFER,
                o_READ_BUFFER    => w_READ_BUFFER,

                o_WRITE_H_INTERFACE_REG => w_WRITE_H_INTERFACE_REG,

                o_ADD     => w_ADD,
                o_COMPARE => w_COMPARE,
                o_INTEGRITY_RESETn => w_INTEGRITY_RESETn
            );
    end generate;

    u_INTEGRITY_CONTROL_RECEIVE:
    if (p_USE_TMR) generate
        u_INTEGRITY_CONTROL_RECEIVE_TMR: entity work.integrity_control_receive_tmr
            port map(
                ACLK    => ACLK,
                ARESETn => w_INTEGRITY_RESETn,

                i_ADD       => w_ADD,
                i_VALUE_ADD => w_FLIT(c_AXI_DATA_WIDTH - 1 downto 0),
                i_COMPARE   => w_COMPARE,
                i_VALUE_COMPARE => w_FLIT(c_AXI_DATA_WIDTH - 1 downto 0),

                o_CHECKSUM => w_CHECKSUM,
                o_CORRUPT  => o_CORRUPT_RECEIVE
            );
    else generate
        u_INTEGRITY_CONTROL_RECEIVE_NORMAL: entity work.integrity_control_receive
            port map(
                ACLK    => ACLK,
                ARESETn => w_INTEGRITY_RESETn,

                i_ADD       => w_ADD,
                i_VALUE_ADD => w_FLIT(c_AXI_DATA_WIDTH - 1 downto 0),
                i_COMPARE   => w_COMPARE,
                i_VALUE_COMPARE => w_FLIT(c_AXI_DATA_WIDTH - 1 downto 0),

                o_CHECKSUM => w_CHECKSUM,
                o_CORRUPT  => o_CORRUPT_RECEIVE
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
                o_DATA     => w_FLIT,

                o_WRITE_OK => w_WRITE_OK_BUFFER,
                i_WRITE    => w_WRITE_BUFFER,
                i_DATA     => l_out_data_o
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
                o_DATA     => w_FLIT,

                o_WRITE_OK => w_WRITE_OK_BUFFER,
                i_WRITE    => w_WRITE_BUFFER,
                i_DATA     => l_out_data_o
            );
    end generate;

    u_RECEIVE_CONTROL:
    if (p_USE_TMR) generate
        u_RECEIVE_CONTROL_TMR: entity work.receive_control_tmr
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_WRITE_OK_BUFFER => w_WRITE_OK_BUFFER,
                o_WRITE_BUFFER    => w_WRITE_BUFFER,

                l_out_val_o => l_out_val_o,
                l_out_ack_i => l_out_ack_i
            );
    else generate
        u_RECEIVE_CONTROL_NORMAL: entity work.receive_control
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_WRITE_OK_BUFFER => w_WRITE_OK_BUFFER,
                o_WRITE_BUFFER    => w_WRITE_BUFFER,

                l_out_val_o => l_out_val_o,
                l_out_ack_i => l_out_ack_i
            );
    end generate;

    w_ARESET <= not ARESETn;
end rtl;