library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.xina_package.all;

package interface_tcc_package is
	constant c_ID_W_WIDTH : natural := 5; -- @NOTE: Por enquanto, "c_ID_W_WIDTH" e "c_ID_R_WIDTH" devem sempre ser iguais.
	constant c_ID_R_WIDTH : natural := 5;

	constant c_ADDR_WIDTH : natural := 8;
	constant c_DATA_WIDTH : natural := 32;
	constant c_BRESP_WIDTH: natural := 3;
	constant c_RRESP_WIDTH: natural := 3;
end interface_tcc_package;