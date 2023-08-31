library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_backend_master is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_VALID : in std_logic;
    	i_OPC   : in std_logic;
		i_ADDR  : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
		i_BURST : in std_logic_vector(1 downto 0);
		i_LENGTH: in std_logic_vector(7 downto 0);
		i_DATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);

		o_READY : out std_logic;

        -- XINA signals.
        l_in_data_i  : out std_logic_vector(data_width_c downto 0);
        l_in_val_i   : out std_logic;
        l_in_ack_o   : in std_logic;
        l_out_data_o : in std_logic_vector(data_width_c downto 0);
        l_out_val_o  : in std_logic;
        l_out_ack_i  : out std_logic
    );
end tcc_backend_master;

architecture arch_tcc_backend_master of tcc_backend_master is
begin
    u_TCC_BACKEND_MASTER_SEND_CONTROL: entity work.tcc_backend_master_send_control
        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_VALID  => i_VALID,
            i_OPC    => i_OPC,
            i_ADDR   => i_ADDR,
            i_BURST  => i_BURST,
            i_LENGTH => i_LENGTH,
            i_DATA   => i_DATA,
            o_READY  => o_READY,

            l_in_data_i => l_in_data_i,
            l_in_val_i  => l_in_val_i,
            l_in_ack_o  => l_in_ack_o
        );
end arch_tcc_backend_master;