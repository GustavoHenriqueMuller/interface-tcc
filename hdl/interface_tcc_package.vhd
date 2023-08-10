library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.xina_package.all;

package interface_tcc_package is
  	constant c_OPC_WIDTH: natural := 3;
	
	-- Components.
	component interface_tcc_frontend is
		generic(
			-- Interface attributes.
			g_TYPE: string  := "MASTER"; -- "MASTER" or "SLAVE"
				
			-- AMBA AXI 5 attributes.
			g_ID_W_WIDTH : natural := 5;
			g_ID_R_WIDTH : natural := 5;
			g_ADDR_WIDTH : natural := 8;
			g_DATA_WIDTH : natural := 32;
			g_BRESP_WIDTH: natural := 3;
			g_RRESP_WIDTH: natural := 3
		);
		  
		port(
			-- AMBA AXI 5 signals.
			ACLK: in std_logic;
			ARESETn: in std_logic;
				
				-- Write request signals.
				AWVALID: inout std_logic;
				AWREADY: inout std_logic;
				AW_ID  : inout std_logic_vector(g_ID_W_WIDTH - 1 downto 0) := (others => '0');
				AWADDR : inout std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
				AWLEN  : inout std_logic_vector(7 downto 0) := (others => '0');
				AWSIZE : inout std_logic_vector(2 downto 0) := (others => '0');
				AWBURST: inout std_logic_vector(1 downto 0) := (others => '0');
				
				-- Write data signals.
				WVALID : inout std_logic;
				WREADY : inout std_logic;
				WDATA  : inout std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
				WLAST  : inout std_logic;
				
				-- Write response signals.
				BVALID : inout std_logic;
				BREADY : inout std_logic;
				BRESP  : inout std_logic_vector(g_BRESP_WIDTH - 1 downto 0) := (others => '0');
					
				-- Read request signals.
				ARVALID: inout std_logic;
				ARREADY: inout std_logic;
				AR_ID  : inout std_logic_vector(g_ID_R_WIDTH - 1 downto 0) := (others => '0');
				ARADDR : inout std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
				ARLEN  : inout std_logic_vector(7 downto 0) := (others => '0');
				ARSIZE : inout std_logic_vector(2 downto 0) := (others => '0');
				ARBURST: inout std_logic_vector(1 downto 0) := (others => '0');
					
				-- Read data signals.
				RVALID : inout std_logic;
				RREADY : inout std_logic;
				RDATA  : inout std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
				RLAST  : inout std_logic;
				RRESP  : inout std_logic_vector(g_RRESP_WIDTH - 1 downto 0) := (others => '0');
			
			-- Backend signals.
			i_SPC_READY : in  std_logic;
			i_SPC_OPC   : in  std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			i_SPC_ADDR  : in  std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
			i_SPC_DATA  : in  std_logic_vector(g_DATA_WIDTH - 1 downto 0);
			i_SPC_WAIT  : in  std_logic;
			
			o_SPC_START : out std_logic;
			o_SPC_OPC   : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			o_SPC_ADDR  : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
			o_SPC_DATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0)
		);
	end component;
	
	-- Master frontend.
	component interface_tcc_frontend_master is
		generic(
			-- AMBA AXI 5 attributes.
			g_ID_W_WIDTH : natural := 5;
			g_ID_R_WIDTH : natural := 5;
			g_ADDR_WIDTH : natural := 8;
			g_DATA_WIDTH : natural := 32;
			g_BRESP_WIDTH: natural := 3;
			g_RRESP_WIDTH: natural := 3
		);
	
		port(
			-- AMBA AXI 5 signals.
			ACLK: in std_logic;
			ARESETn: in std_logic;
			
				-- Write request signals.
				AWVALID: in std_logic;
				AWREADY: out std_logic;
				AW_ID  : in std_logic_vector(g_ID_W_WIDTH - 1 downto 0) := (others => '0');
				AWADDR : in std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
				AWLEN  : in std_logic_vector(7 downto 0) := (others => '0');
				AWSIZE : in std_logic_vector(2 downto 0) := (others => '0');
				AWBURST: in std_logic_vector(1 downto 0) := (others => '0');
				
				-- Write data signals.
				WVALID : in std_logic;
				WREADY : out std_logic;
				WDATA  : in std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
				WLAST  : in std_logic;
				
				-- Write response signals.
				BVALID : in std_logic;
				BREADY : out std_logic;
				BRESP  : in std_logic_vector(g_BRESP_WIDTH - 1 downto 0) := (others => '0');
				
				-- Read request signals.
				ARVALID: in std_logic;
				ARREADY: out std_logic;
				AR_ID  : in std_logic_vector(g_ID_R_WIDTH - 1 downto 0) := (others => '0');
				ARADDR : in std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
				ARLEN  : in std_logic_vector(7 downto 0) := (others => '0');
				ARSIZE : in std_logic_vector(2 downto 0) := (others => '0');
				ARBURST: in std_logic_vector(1 downto 0) := (others => '0');
				
				-- Read data signals.
				RVALID : in std_logic;
				RREADY : out std_logic;
				RDATA  : in std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
				RLAST  : in std_logic;
				RRESP  : out std_logic_vector(g_RRESP_WIDTH - 1 downto 0) := (others => '0');
			
			-- Backend signals.
			i_SPC_OPC  : in  std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			i_SPC_DATA : in  std_logic_vector(g_DATA_WIDTH - 1 downto 0);
			i_SPC_WAIT : in  std_logic;
			o_SPC_START: out std_logic;
			o_SPC_OPC  : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			o_SPC_ADDR : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
			o_SPC_DATA : out std_logic_vector(g_DATA_WIDTH - 1 downto 0)
		);
	end component;
  
  	-- Slave frontend.
  	component interface_tcc_frontend_slave is
		generic(
			-- AMBA AXI 5 attributes.
			g_ID_W_WIDTH : natural := 5;
			g_ID_R_WIDTH : natural := 5;
			g_ADDR_WIDTH : natural := 8;
			g_DATA_WIDTH : natural := 32;
			g_BRESP_WIDTH: natural := 3;
			g_RRESP_WIDTH: natural := 3
		);
	
		port(
			-- AMBA AXI 5 signals.
			ACLK: in std_logic;
			ARESETn: in std_logic;
			
				-- Write request signals.
				AWVALID: out std_logic;
				AWREADY: in std_logic;
				AW_ID  : out std_logic_vector(g_ID_W_WIDTH - 1 downto 0) := (others => '0');
				AWADDR : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
				AWLEN  : out std_logic_vector(7 downto 0) := (others => '0');
				AWSIZE : out std_logic_vector(2 downto 0) := (others => '0');
				AWBURST: out std_logic_vector(1 downto 0) := (others => '0');
				
				-- Write data signals.
				WVALID : out std_logic;
				WREADY : in std_logic;
				WDATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
				WLAST  : out std_logic;
				
				-- Write response signals.
				BVALID : out std_logic;
				BREADY : in std_logic;
				BRESP  : out std_logic_vector(g_BRESP_WIDTH - 1 downto 0) := (others => '0');
				
				-- Read request signals.
				ARVALID: out std_logic;
				ARREADY: in std_logic;
				AR_ID  : out std_logic_vector(g_ID_R_WIDTH - 1 downto 0) := (others => '0');
				ARADDR : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
				ARLEN  : out std_logic_vector(7 downto 0) := (others => '0');
				ARSIZE : out std_logic_vector(2 downto 0) := (others => '0');
				ARBURST: out std_logic_vector(1 downto 0) := (others => '0');
				
				-- Read data signals.
				RVALID : out std_logic;
				RREADY : in std_logic;
				RDATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
				RLAST  : out std_logic;
				RRESP  : in std_logic_vector(g_RRESP_WIDTH - 1 downto 0) := (others => '0');
			
			-- Backend signals.
			i_SPC_READY : in  std_logic;
			i_SPC_OPC   : in  std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			i_SPC_ADDR  : in  std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
			i_SPC_DATA  : in  std_logic_vector(g_DATA_WIDTH - 1 downto 0);
			o_SPC_START : out std_logic;
			o_SPC_OPC   : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			o_SPC_DATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0)
		);
  	end component;
	
	-- Backend.
	component interface_tcc_backend is
		generic(
			-- Interface attributes.
			g_TYPE: string  := "MASTER"; -- "MASTER" or "SLAVE"
			
			-- AMBA AXI 5 attributes.
			g_ID_W_WIDTH : natural := 5;
			g_ID_R_WIDTH : natural := 5;
			g_ADDR_WIDTH : natural := 8;
			g_DATA_WIDTH : natural := 32;
			g_BRESP_WIDTH: natural := 3;
			g_RRESP_WIDTH: natural := 3
		);
		
		port(
			-- AMBA AXI 5 signals.
			ACLK: in std_logic;
			ARESETn: in std_logic;
			
			-- Backend signals.
			i_SPC_START : in std_logic;
			i_SPC_OPC   : in std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			i_SPC_ADDR  : in std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
			i_SPC_DATA  : in std_logic_vector(g_DATA_WIDTH - 1 downto 0);
			
			o_SPC_READY : out std_logic;
			o_SPC_OPC   : out std_logic_vector(c_OPC_WIDTH - 1 downto 0);
			o_SPC_ADDR  : out std_logic_vector(g_ADDR_WIDTH - 1 downto 0);
			o_SPC_DATA  : out std_logic_vector(g_DATA_WIDTH - 1 downto 0);
			o_SPC_WAIT  : out std_logic;
			
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