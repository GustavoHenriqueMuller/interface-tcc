library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity receive_control_tmr is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Buffer signals.
        i_WRITE_OK_BUFFER: in std_logic;
        o_WRITE_BUFFER   : out std_logic;

        -- XINA signals.
        l_out_val_o: in std_logic;
        l_out_ack_i: out std_logic
    );
end receive_control_tmr;

architecture rtl of receive_control_tmr is
    type t_BIT_VECTOR is array (2 downto 0) of std_logic;

    signal w_WRITE_BUFFER: t_BIT_VECTOR;
    signal w_l_out_ack_i : t_BIT_VECTOR;

begin
    TMR:
    for i in 2 downto 0 generate
        u_RECEIVE_CONTROL: entity work.receive_control
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_WRITE_OK_BUFFER => i_WRITE_OK_BUFFER,
                o_WRITE_BUFFER    => w_WRITE_BUFFER(i),

                l_out_val_o => l_out_val_o,
                l_out_ack_i => w_l_out_ack_i(i)
            );
    end generate;

    o_WRITE_BUFFER <= (w_WRITE_BUFFER(0) and w_WRITE_BUFFER(1)) or
                      (w_WRITE_BUFFER(0) and w_WRITE_BUFFER(2)) or
                      (w_WRITE_BUFFER(1) and w_WRITE_BUFFER(2));

    l_out_ack_i    <= (w_l_out_ack_i(0) and w_l_out_ack_i(1)) or
                      (w_l_out_ack_i(0) and w_l_out_ack_i(2)) or
                      (w_l_out_ack_i(1) and w_l_out_ack_i(2));
end rtl;