library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity send_control_tmr is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Buffer signals.
        i_READ_OK_BUFFER: in std_logic;
        o_READ_BUFFER   : out std_logic;

        -- XINA signals.
        l_in_val_i: out std_logic;
        l_in_ack_o: in std_logic
    );
end send_control_tmr;

architecture rtl of send_control_tmr is
    type t_BIT_VECTOR is array (2 downto 0) of std_logic;

    signal w_READ_BUFFER: t_BIT_VECTOR;
    signal w_l_in_val_i : t_BIT_VECTOR;

begin
    TMR:
    for i in 2 downto 0 generate
        u_SEND_CONTROL: entity work.send_control
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_READ_OK_BUFFER => i_READ_OK_BUFFER,
                o_READ_BUFFER    => w_READ_BUFFER(i),

                l_in_val_i  => w_l_in_val_i(i),
                l_in_ack_o  => l_in_ack_o
            );
    end generate;

    o_READ_BUFFER <= (w_READ_BUFFER(0) and w_READ_BUFFER(1)) or
                     (w_READ_BUFFER(0) and w_READ_BUFFER(2)) or
                     (w_READ_BUFFER(1) and w_READ_BUFFER(2));

    l_in_val_i    <= (w_l_in_val_i(0) and w_l_in_val_i(1)) or
                     (w_l_in_val_i(0) and w_l_in_val_i(2)) or
                     (w_l_in_val_i(1) and w_l_in_val_i(2));
end rtl;