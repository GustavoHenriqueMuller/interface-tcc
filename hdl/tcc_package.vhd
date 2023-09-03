library IEEE;
library work;

use IEEE.std_logic_1164.all;

package tcc_package is
	-- AMBA AXI attributes.
	constant c_ID_WIDTH   : natural := 5; -- This property corresponds to "c_ID_W_WIDTH" and "c_ID_R_WIDTH".
	constant c_ADDR_WIDTH : natural := 64; -- First half: Operation address. Second half: IP address (XXYY).
	constant c_DATA_WIDTH : natural := 32;
	constant c_FLIT_WIDTH : natural := c_DATA_WIDTH + 1;
	constant c_BRESP_WIDTH: natural := 3;
	constant c_RRESP_WIDTH: natural := 3;

	-- Interface attributes.
	constant c_SRC_X: std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0) := "0000000000000000";
	constant c_SRC_Y: std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0) := "0000000000000000";
end tcc_package;