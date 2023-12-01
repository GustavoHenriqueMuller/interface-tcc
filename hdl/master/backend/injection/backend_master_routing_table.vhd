library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_routing_table is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_ADDR : in std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);

        o_OPC_ADDR: out std_logic_vector((c_AXI_ADDR_WIDTH / 2) - 1 downto 0);
        o_DEST_X  : out std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);
        o_DEST_Y  : out std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0)
    );
end backend_master_routing_table;

architecture rtl of backend_master_routing_table is
begin
    o_OPC_ADDR <= i_ADDR((c_AXI_ADDR_WIDTH - 1) downto c_AXI_ADDR_WIDTH / 2);
    o_DEST_X   <= i_ADDR((c_AXI_ADDR_WIDTH / 2) - 1 downto c_AXI_ADDR_WIDTH / 4);
    o_DEST_Y   <= i_ADDR((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);
end rtl;