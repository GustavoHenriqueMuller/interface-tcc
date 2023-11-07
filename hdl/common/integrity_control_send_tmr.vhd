library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity integrity_control_send_tmr is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Inputs.
        i_ADD      : in std_logic;
        i_VALUE_ADD: in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        -- Outputs.
        o_CHECKSUM: out std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0)
    );
end integrity_control_send_tmr;

architecture rtl of integrity_control_send_tmr is
    type t_BIT_VECTOR_CHECKSUM is array (2 downto 0) of std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
    signal w_CHECKSUM: t_BIT_VECTOR_CHECKSUM;

begin
    TMR:
    for i in 2 downto 0 generate
        u_INTEGRITY_CONTROL_SEND: entity work.integrity_control_send
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_ADD       => i_ADD,
                i_VALUE_ADD => i_VALUE_ADD,

                o_CHECKSUM => w_CHECKSUM(i)
            );
    end generate;

    TMR_CHECKSUM:
    for i in c_AXI_DATA_WIDTH - 1 downto 0 generate
        o_CHECKSUM(i) <= (w_CHECKSUM(0)(i) and w_CHECKSUM(1)(i)) or
                         (w_CHECKSUM(0)(i) and w_CHECKSUM(2)(i)) or
                         (w_CHECKSUM(1)(i) and w_CHECKSUM(2)(i));
    end generate;
end rtl;