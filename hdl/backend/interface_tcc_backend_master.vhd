library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.interface_tcc_package.all;
use work.xina_package.all;

entity interface_tcc_backend_master is
    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_VALID : out std_logic;
    	i_OPC   : out std_logic;
		i_ADDR  : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
		i_BURST : out std_logic_vector(1 downto 0);
		i_LENGTH: out std_logic_vector(7 downto 0);
		i_DATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);

		o_READY: out std_logic;

        -- XINA signals.
        l_out_data_i : in data_link_l_t;
        l_out_val_i  : in ctrl_link_l_t;
        l_in_ack_i   : in ctrl_link_l_t;
        l_in_data_o  : out data_link_l_t;
        l_in_val_o   : out ctrl_link_l_t;
        l_out_ack_o  : out ctrl_link_l_t
    );
end interface_tcc_backend_master;

architecture arch_interface_tcc_backend_master of interface_tcc_backend_master is
begin
    o_READY <= '1';
end arch_interface_tcc_backend_master;