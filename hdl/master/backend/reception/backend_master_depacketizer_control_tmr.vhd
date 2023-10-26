library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_depacketizer_control_tmr is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_READY_RECEIVE_PACKET: in std_logic;
        i_READY_RECEIVE_DATA  : in std_logic;
        o_VALID_RECEIVE_DATA  : out std_logic;
        o_LAST_RECEIVE_DATA   : out std_logic;

        -- Buffer.
        i_FLIT          : in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        o_READ_BUFFER   : out std_logic;
        i_READ_OK_BUFFER: in std_logic;

        -- Headers.
        o_WRITE_H_INTERFACE_REG: out std_logic
    );
end backend_master_depacketizer_control_tmr;

architecture rtl of backend_master_depacketizer_control_tmr is
    type t_BIT_VECTOR is array (2 downto 0) of std_logic;

    signal w_VALID_RECEIVE_DATA: t_BIT_VECTOR;
    signal w_LAST_RECEIVE_DATA: t_BIT_VECTOR;
    signal w_READ_BUFFER: t_BIT_VECTOR;
    signal w_WRITE_H_INTERFACE_REG: t_BIT_VECTOR;

begin
    TMR:
    for i in 2 downto 0 generate
        u_DEPACKETIZER_CONTROL: entity work.backend_master_depacketizer_control
            port map(
                ACLK => ACLK,
                ARESETn => ARESETn,

                i_READY_RECEIVE_PACKET => i_READY_RECEIVE_PACKET,
                i_READY_RECEIVE_DATA   => i_READY_RECEIVE_DATA,
                o_VALID_RECEIVE_DATA   => w_VALID_RECEIVE_DATA(i),
                o_LAST_RECEIVE_DATA    => w_LAST_RECEIVE_DATA(i),

                i_FLIT => i_FLIT,
                o_READ_BUFFER => w_READ_BUFFER(i),
                i_READ_OK_BUFFER => i_READ_OK_BUFFER,

                o_WRITE_H_INTERFACE_REG => w_WRITE_H_INTERFACE_REG(i)
            );
    end generate;

    o_VALID_RECEIVE_DATA <= (w_VALID_RECEIVE_DATA(0) and w_VALID_RECEIVE_DATA(1)) or
                            (w_VALID_RECEIVE_DATA(0) and w_VALID_RECEIVE_DATA(2)) or
                            (w_VALID_RECEIVE_DATA(1) and w_VALID_RECEIVE_DATA(2));

    o_LAST_RECEIVE_DATA <= (w_LAST_RECEIVE_DATA(0) and w_LAST_RECEIVE_DATA(1)) or
                           (w_LAST_RECEIVE_DATA(0) and w_LAST_RECEIVE_DATA(2)) or
                           (w_LAST_RECEIVE_DATA(1) and w_LAST_RECEIVE_DATA(2));

    o_READ_BUFFER <= (w_READ_BUFFER(0) and w_READ_BUFFER(1)) or
                     (w_READ_BUFFER(0) and w_READ_BUFFER(2)) or
                     (w_READ_BUFFER(1) and w_READ_BUFFER(2));

    o_WRITE_H_INTERFACE_REG <= (w_WRITE_H_INTERFACE_REG(0) and w_WRITE_H_INTERFACE_REG(1)) or
                               (w_WRITE_H_INTERFACE_REG(0) and w_WRITE_H_INTERFACE_REG(2)) or
                               (w_WRITE_H_INTERFACE_REG(1) and w_WRITE_H_INTERFACE_REG(2));
end rtl;