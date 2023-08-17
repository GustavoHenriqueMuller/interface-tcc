library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.xina_package.all;

package interface_tcc_package is
  	constant c_OPC_WIDTH: natural := 1; -- '0' = WRITE, '1' = READ.
	constant c_ID_W_WIDTH : natural := 5;
	constant c_ID_R_WIDTH : natural := 5;
	constant c_ADDR_WIDTH : natural := 8;
	constant c_DATA_WIDTH : natural := 32;
	constant c_BRESP_WIDTH: natural := 3;
	constant c_RRESP_WIDTH: natural := 3
	
	-- Components.
	component interface_tcc_frontend_master is
		port(
			-- AMBA AXI 5 signals.
			ACLK: in std_logic;
			ARESETn: in std_logic;
			
				-- Write request signals.
				AWVALID: in std_logic;
				AWREADY: out std_logic;
				AW_ID  : in std_logic_vector(c_ID_W_WIDTH - 1 downto 0) := (others => '0');
				AWADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
				AWLEN  : in std_logic_vector(7 downto 0) := (others => '0');
				AWSIZE : in std_logic_vector(2 downto 0) := (others => '0');
				AWBURST: in std_logic_vector(1 downto 0) := (others => '0');
				
				-- Write data signals.
				WVALID : in std_logic;
				WREADY : out std_logic;
				WDATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
				WLAST  : in std_logic;
				
				-- Write response signals.
				BVALID : out std_logic;
				BREADY : in std_logic;
				BRESP  : out std_logic_vector(c_BRESP_WIDTH - 1 downto 0) := (others => '0');
				
				-- Read request signals.
				ARVALID: in std_logic;
				ARREADY: out std_logic;
				AR_ID  : in std_logic_vector(c_ID_R_WIDTH - 1 downto 0) := (others => '0');
				ARADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0) := (others => '0');
				ARLEN  : in std_logic_vector(7 downto 0) := (others => '0');
				ARSIZE : in std_logic_vector(2 downto 0) := (others => '0');
				ARBURST: in std_logic_vector(1 downto 0) := (others => '0');
				
				-- Read data signals.
				RVALID : out std_logic;
				RREADY : in std_logic;
				RDATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');
				RLAST  : out std_logic;
				RRESP  : out std_logic_vector(c_RRESP_WIDTH - 1 downto 0) := (others => '0');
			
			-- Backend signals.
			i_BACKEND_READY: in std_logic;
			i_BACKEND_OPC  : in std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			i_BACKEND_ADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
			i_BACKEND_DATA : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
			i_BACKEND_WAIT : in std_logic;
			
			o_BACKEND_START: out std_logic;
			o_BACKEND_OPC  : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			o_BACKEND_ADDR : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
			o_BACKEND_DATA : out std_logic_vector(c_DATA_WIDTH - 1 downto 0)
		);
	end component;
	
	-- Frontend master send control.
	component interface_tcc_frontend_master_send_control is
		port (
			ACLK: in std_logic;
			ARESETn: in std_logic;
			
			-- Signals from front-end.
			AWVALID: in std_logic;
			AWADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
			AWLEN  : in std_logic_vector(7 downto 0);
			AWBURST: in std_logic_vector(1 downto 0);
			WLAST  : in std_logic;
			
			ARVALID: in std_logic;
			ARADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
			ARLEN  : in std_logic_vector(7 downto 0);
			ARBURST: in std_logic_vector(1 downto 0);
			RLAST  : in std_logic;
			
			-- Signals to back-end.
			o_BACKEND_OPC   : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			o_BACKEND_ADDR  : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
			o_BACKEND_BURST : out std_logic_vector(1 downto 0);
			o_BACKEND_TYPE  : out std_logic;
			o_BACKEND_LENGTH: out std_logic_vector(7 downto 0);
			o_BACKEND_START : out std_logic;
		);
	end component;
		
	-- Backend.
	component interface_tcc_backend_master is
		port(
			-- AMBA AXI 5 signals.
			ACLK: in std_logic;
			ARESETn: in std_logic;
			
			-- Backend signals.
			i_BACKEND_START: in std_logic;
			i_BACKEND_OPC  : in std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			i_BACKEND_ADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
			i_BACKEND_DATA : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
			
			o_BACKEND_READY: out std_logic;
			o_BACKEND_OPC  : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			o_BACKEND_ADDR : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
			o_BACKEND_DATA : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
			o_BACKEND_WAIT : out std_logic;
			
			-- XINA signals.
			l_in_data_o  : out data_link_l_t;
			l_in_val_o   : out ctrl_link_l_t;
			l_in_ack_i   : in ctrl_link_l_t;
			l_out_data_i : in data_link_l_t;
			l_out_val_i  : in ctrl_link_l_t;
			l_out_ack_o  : out ctrl_link_l_t
		);
	end component;
end interface_tcc_package;