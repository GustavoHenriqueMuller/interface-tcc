library IEEE;
library work;

use IEEE.std_logic_1164.all;

package tcc_package is
	-- AMBA AXI attributes.
	constant c_AXI_ID_WIDTH  : natural := 5;  -- This constant corresponds to "ID_W_WIDTH" and "ID_R_WIDTH".
	constant c_AXI_ADDR_WIDTH: natural := 64; -- First half: Operation address. Second half: IP address (XXYY).
	constant c_AXI_DATA_WIDTH: natural := 32;
	constant c_AXI_RESP_WIDTH: natural := 3;  -- This constant corresponds to "BRESP_WIDTH" and "RRESP_WIDTH".

	-- Interface attributes.
	constant c_FLIT_WIDTH        : natural  := c_AXI_DATA_WIDTH + 1;
	constant c_BUFFER_DEPTH      : positive := 10;
	constant c_USE_TMR_PACKETIZER: boolean  := false;
	constant c_USE_TMR_FLOW      : boolean  := true;
	constant c_USE_TMR_INTEGRITY : boolean  := false;
	constant c_USE_HAMMING       : boolean  := false;
	constant c_USE_INTEGRITY     : boolean  := false;
end package;