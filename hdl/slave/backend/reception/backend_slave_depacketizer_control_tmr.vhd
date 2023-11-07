library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_slave_depacketizer_control_tmr is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_READY_RECEIVE_PACKET: in std_logic;
        i_READY_RECEIVE_DATA  : in std_logic;
        o_VALID_RECEIVE_PACKET: out std_logic;
        o_VALID_RECEIVE_DATA  : out std_logic;
        o_LAST_RECEIVE_DATA   : out std_logic;

        -- Signals from injection.
        i_HAS_FINISHED_RESPONSE: in std_logic;
        o_HAS_REQUEST_PACKET   : out std_logic;

        -- Buffer.
        i_FLIT          : in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        o_READ_BUFFER   : out std_logic;
        i_READ_OK_BUFFER: in std_logic;

        -- Headers.
        i_H_INTERFACE: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

        o_WRITE_H_SRC_REG: out std_logic;
        o_WRITE_H_INTERFACE_REG: out std_logic;
        o_WRITE_H_ADDRESS_REG  : out std_logic;

        -- Integrity control.
        o_ADD    : out std_logic;
        o_COMPARE: out std_logic;
        o_INTEGRITY_RESETn: out std_logic
    );
end backend_slave_depacketizer_control_tmr;

architecture rtl of backend_slave_depacketizer_control_tmr is
    type t_BIT_VECTOR is array (2 downto 0) of std_logic;

    signal w_VALID_RECEIVE_PACKET: t_BIT_VECTOR;
    signal w_VALID_RECEIVE_DATA: t_BIT_VECTOR;
    signal w_LAST_RECEIVE_DATA: t_BIT_VECTOR;
    signal w_HAS_REQUEST_PACKET: t_BIT_VECTOR;
    signal w_READ_BUFFER: t_BIT_VECTOR;
    signal w_WRITE_H_SRC_REG: t_BIT_VECTOR;
    signal w_WRITE_H_INTERFACE_REG: t_BIT_VECTOR;
    signal w_WRITE_H_ADDRESS_REG: t_BIT_VECTOR;

    signal w_ADD: t_BIT_VECTOR;
    signal w_COMPARE: t_BIT_VECTOR;
    signal w_INTEGRITY_RESETn: t_BIT_VECTOR;

begin
    TMR:
    for i in 2 downto 0 generate
        u_DEPACKETIZER_CONTROL: entity work.backend_slave_depacketizer_control
            port map(
                ACLK => ACLK,
                ARESETn => ARESETn,

                i_READY_RECEIVE_PACKET => i_READY_RECEIVE_PACKET,
                i_READY_RECEIVE_DATA   => i_READY_RECEIVE_DATA,
                o_VALID_RECEIVE_PACKET => w_VALID_RECEIVE_PACKET(i),
                o_VALID_RECEIVE_DATA   => w_VALID_RECEIVE_DATA(i),
                o_LAST_RECEIVE_DATA    => w_LAST_RECEIVE_DATA(i),

                i_HAS_FINISHED_RESPONSE => i_HAS_FINISHED_RESPONSE,
                o_HAS_REQUEST_PACKET    => w_HAS_REQUEST_PACKET(i),

                i_FLIT => i_FLIT,
                o_READ_BUFFER => w_READ_BUFFER(i),
                i_READ_OK_BUFFER => i_READ_OK_BUFFER,

                i_H_INTERFACE => i_H_INTERFACE,

                o_WRITE_H_SRC_REG => w_WRITE_H_SRC_REG(i),
                o_WRITE_H_INTERFACE_REG => w_WRITE_H_INTERFACE_REG(i),
                o_WRITE_H_ADDRESS_REG   => w_WRITE_H_ADDRESS_REG(i)
            );
    end generate;

    o_VALID_RECEIVE_PACKET <= (w_VALID_RECEIVE_PACKET(0) and w_VALID_RECEIVE_PACKET(1)) or
                              (w_VALID_RECEIVE_PACKET(0) and w_VALID_RECEIVE_PACKET(2)) or
                              (w_VALID_RECEIVE_PACKET(1) and w_VALID_RECEIVE_PACKET(2));

    o_VALID_RECEIVE_DATA <= (w_VALID_RECEIVE_DATA(0) and w_VALID_RECEIVE_DATA(1)) or
                            (w_VALID_RECEIVE_DATA(0) and w_VALID_RECEIVE_DATA(2)) or
                            (w_VALID_RECEIVE_DATA(1) and w_VALID_RECEIVE_DATA(2));

    o_LAST_RECEIVE_DATA <= (w_LAST_RECEIVE_DATA(0) and w_LAST_RECEIVE_DATA(1)) or
                           (w_LAST_RECEIVE_DATA(0) and w_LAST_RECEIVE_DATA(2)) or
                           (w_LAST_RECEIVE_DATA(1) and w_LAST_RECEIVE_DATA(2));

    o_HAS_REQUEST_PACKET <= (w_HAS_REQUEST_PACKET(0) and w_HAS_REQUEST_PACKET(1)) or
                            (w_HAS_REQUEST_PACKET(0) and w_HAS_REQUEST_PACKET(2)) or
                            (w_HAS_REQUEST_PACKET(1) and w_HAS_REQUEST_PACKET(2));

    o_READ_BUFFER <= (w_READ_BUFFER(0) and w_READ_BUFFER(1)) or
                     (w_READ_BUFFER(0) and w_READ_BUFFER(2)) or
                     (w_READ_BUFFER(1) and w_READ_BUFFER(2));

    o_WRITE_H_SRC_REG <= (w_WRITE_H_SRC_REG(0) and w_WRITE_H_SRC_REG(1)) or
                         (w_WRITE_H_SRC_REG(0) and w_WRITE_H_SRC_REG(2)) or
                         (w_WRITE_H_SRC_REG(1) and w_WRITE_H_SRC_REG(2));

    o_WRITE_H_INTERFACE_REG <= (w_WRITE_H_INTERFACE_REG(0) and w_WRITE_H_INTERFACE_REG(1)) or
                               (w_WRITE_H_INTERFACE_REG(0) and w_WRITE_H_INTERFACE_REG(2)) or
                               (w_WRITE_H_INTERFACE_REG(1) and w_WRITE_H_INTERFACE_REG(2));

    o_WRITE_H_ADDRESS_REG <= (w_WRITE_H_ADDRESS_REG(0) and w_WRITE_H_ADDRESS_REG(1)) or
                             (w_WRITE_H_ADDRESS_REG(0) and w_WRITE_H_ADDRESS_REG(2)) or
                             (w_WRITE_H_ADDRESS_REG(1) and w_WRITE_H_ADDRESS_REG(2));

    o_ADD              <= (w_ADD(0) and w_ADD(1)) or
                          (w_ADD(0) and w_ADD(2)) or
                          (w_ADD(1) and w_ADD(2));

    o_COMPARE          <= (w_COMPARE(0) and w_COMPARE(1)) or
                          (w_COMPARE(0) and w_COMPARE(2)) or
                          (w_COMPARE(1) and w_COMPARE(2));

    o_INTEGRITY_RESETn <= (w_INTEGRITY_RESETn(0) and w_INTEGRITY_RESETn(1)) or
                          (w_INTEGRITY_RESETn(0) and w_INTEGRITY_RESETn(2)) or
                          (w_INTEGRITY_RESETn(1) and w_INTEGRITY_RESETn(2));
end rtl;