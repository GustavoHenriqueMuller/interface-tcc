library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity integrity_control_receive_empty is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Inputs.
        i_ADD      : in std_logic;
        i_VALUE_ADD: in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        i_COMPARE      : in std_logic;
        i_VALUE_COMPARE: in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        -- Outputs.
        o_CORRUPT : out std_logic
    );
end integrity_control_receive_empty;

architecture rtl of integrity_control_receive_empty is
begin
    o_CORRUPT  <= '0';
end rtl;