library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_slave_packetizer_control_tmr is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_OPC_SEND       : in std_logic;
        i_VALID_SEND_DATA: in std_logic;
        i_LAST_SEND_DATA : in std_logic;
        o_READY_SEND_DATA: out std_logic;
        o_FLIT_SELECTOR  : out std_logic_vector(2 downto 0);

        -- Signals from reception.
        i_HAS_REQUEST_PACKET   : in std_logic;
        o_HAS_FINISHED_RESPONSE: out std_logic;

        -- Buffer.
        i_WRITE_OK_BUFFER: in std_logic;
        o_WRITE_BUFFER   : out std_logic;

        -- Integrity control.
        o_ADD: out std_logic;
        o_INTEGRITY_RESETn: out std_logic
    );
end backend_slave_packetizer_control_tmr;

architecture rtl of backend_slave_packetizer_control_tmr is
    type t_BIT_VECTOR is array (2 downto 0) of std_logic;
    type t_BIT_VECTOR_FLIT_SELECTOR is array (2 downto 0) of std_logic_vector(2 downto 0);

    signal w_READY_SEND_DATA: t_BIT_VECTOR;
    signal w_WRITE_BUFFER: t_BIT_VECTOR;
    signal w_FLIT_SELECTOR: t_BIT_VECTOR_FLIT_SELECTOR;
    signal w_HAS_FINISHED_RESPONSE: t_BIT_VECTOR;

    signal w_ADD: t_BIT_VECTOR;
    signal w_INTEGRITY_RESETn: t_BIT_VECTOR;

begin
    TMR:
    for i in 2 downto 0 generate
        u_PACKETIZER_CONTROL: entity work.backend_slave_packetizer_control
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_OPC_SEND => i_OPC_SEND,
                i_VALID_SEND_DATA => i_VALID_SEND_DATA,
                i_LAST_SEND_DATA  => i_LAST_SEND_DATA,
                o_READY_SEND_DATA => w_READY_SEND_DATA(i),
                o_FLIT_SELECTOR   => w_FLIT_SELECTOR(i),

                i_HAS_REQUEST_PACKET    => i_HAS_REQUEST_PACKET,
                o_HAS_FINISHED_RESPONSE => w_HAS_FINISHED_RESPONSE(i),

                i_WRITE_OK_BUFFER => i_WRITE_OK_BUFFER,
                o_WRITE_BUFFER    => w_WRITE_BUFFER(i)
            );
    end generate;

    o_READY_SEND_DATA <= (w_READY_SEND_DATA(0) and w_READY_SEND_DATA(1)) or
                         (w_READY_SEND_DATA(0) and w_READY_SEND_DATA(2)) or
                         (w_READY_SEND_DATA(1) and w_READY_SEND_DATA(2));

    o_WRITE_BUFFER <= (w_WRITE_BUFFER(0) and w_WRITE_BUFFER(1)) or
                      (w_WRITE_BUFFER(0) and w_WRITE_BUFFER(2)) or
                      (w_WRITE_BUFFER(1) and w_WRITE_BUFFER(2));

    o_ADD <= (w_ADD(0) and w_ADD(1)) or
             (w_ADD(0) and w_ADD(2)) or
             (w_ADD(1) and w_ADD(2));

    o_INTEGRITY_RESETn <= (w_INTEGRITY_RESETn(0) and w_INTEGRITY_RESETn(1)) or
                          (w_INTEGRITY_RESETn(0) and w_INTEGRITY_RESETn(2)) or
                          (w_INTEGRITY_RESETn(1) and w_INTEGRITY_RESETn(2));

    TMR_FLIT_SELECTOR:
    for i in 2 downto 0 generate
        o_FLIT_SELECTOR(i) <= (w_FLIT_SELECTOR(0)(i) and w_FLIT_SELECTOR(1)(i)) or
                              (w_FLIT_SELECTOR(0)(i) and w_FLIT_SELECTOR(2)(i)) or
                              (w_FLIT_SELECTOR(1)(i) and w_FLIT_SELECTOR(2)(i));
    end generate;

    o_HAS_FINISHED_RESPONSE <= (w_HAS_FINISHED_RESPONSE(0) and w_HAS_FINISHED_RESPONSE(1)) or
                               (w_HAS_FINISHED_RESPONSE(0) and w_HAS_FINISHED_RESPONSE(2)) or
                               (w_HAS_FINISHED_RESPONSE(1) and w_HAS_FINISHED_RESPONSE(2));
end rtl;