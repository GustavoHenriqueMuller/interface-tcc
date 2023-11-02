library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity integrity_control_receive_tmr is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Inputs.
        i_ADD: in std_logic;
        i_VALUE_ADD: in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        i_COMPARE: in std_logic;
        i_VALUE_COMPARE: in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        -- Outputs.
        o_CHECKSUM: out std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
        o_CORRUPT: out std_logic
    );
end integrity_control_receive_tmr;

architecture rtl of integrity_control_receive_tmr is
    type t_BIT_VECTOR is array (2 downto 0) of std_logic;
    type t_BIT_VECTOR_CHECKSUM is array (2 downto 0) of std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

    signal w_CHECKSUM: t_BIT_VECTOR_CHECKSUM;
    signal w_CORRUPT: t_BIT_VECTOR;

begin
    TMR:
    for i in 2 downto 0 generate
        u_INTEGRITY_CONTROL_RECEIVE: entity work.integrity_control_receive
            port map(
                ACLK    => ACLK,
                ARESETn => ARESETn,

                i_ADD       => i_ADD,
                i_VALUE_ADD => i_VALUE_ADD,
                i_COMPARE   => i_COMPARE,
                i_VALUE_COMPARE => i_VALUE_COMPARE,

                o_CHECKSUM => w_CHECKSUM(i),
                o_CORRUPT  => w_CORRUPT(i)
            );
    end generate;

    TMR_CHECKSUM:
    for i in c_AXI_DATA_WIDTH - 1 downto 0 generate
        o_CHECKSUM(i) <= (w_CHECKSUM(0)(i) and w_CHECKSUM(1)(i)) or
                         (w_CHECKSUM(0)(i) and w_CHECKSUM(2)(i)) or
                         (w_CHECKSUM(1)(i) and w_CHECKSUM(2)(i));
    end generate;

    o_CORRUPT <= (w_CORRUPT(0) and w_CORRUPT(1)) or
                 (w_CORRUPT(0) and w_CORRUPT(2)) or
                 (w_CORRUPT(1) and w_CORRUPT(2));
end rtl;