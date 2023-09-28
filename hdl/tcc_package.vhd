library IEEE;
library work;

use IEEE.std_logic_1164.all;

package tcc_package is
	-- AMBA AXI attributes.
	constant c_ID_WIDTH   : natural := 5;  -- This constant corresponds to "ID_W_WIDTH" and "ID_R_WIDTH".
	constant c_ADDR_WIDTH : natural := 64; -- First half: Operation address. Second half: IP address (XXYY).
	constant c_DATA_WIDTH : natural := 32;
	constant c_RESP_WIDTH : natural := 3;  -- This constant corresponds to "BRESP_WIDTH" and "RRESP_WIDTH".

	-- Interface attributes.
	constant c_FLIT_WIDTH: natural := c_DATA_WIDTH + 1;
	constant c_SRC_X: std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0) := (others => '0');
	constant c_SRC_Y: std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0) := (others => '0'); -- @TODO: FAZER GENERIC
end package;