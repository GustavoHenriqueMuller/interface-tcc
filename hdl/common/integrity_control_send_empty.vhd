library IEEE;
library work;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity integrity_control_send_empty is
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
end integrity_control_send_empty;

architecture rtl of integrity_control_send_empty is
begin
    o_CHECKSUM <= (others => '0');
end rtl;