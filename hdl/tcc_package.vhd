library IEEE;
library work;

use IEEE.std_logic_1164.all;

package tcc_package is
	constant c_ID_WIDTH   : natural := 5; -- This property corresponds to "c_ID_W_WIDTH" and "c_ID_R_WIDTH".
	constant c_ADDR_WIDTH : natural := 8;
	constant c_DATA_WIDTH : natural := 32;
	constant c_FLIT_WIDTH : natural := c_DATA_WIDTH + 1;
	constant c_BRESP_WIDTH: natural := 3;
	constant c_RRESP_WIDTH: natural := 3;
end tcc_package;