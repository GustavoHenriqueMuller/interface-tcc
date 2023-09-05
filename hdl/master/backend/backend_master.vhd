library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_START_PACKET: in std_logic;
        i_VALID : in std_logic;
        i_LAST  : in std_logic;
		i_ADDR  : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
		i_BURST : in std_logic_vector(1 downto 0);
        i_LENGTH: in std_logic_vector(7 downto 0);
        i_DATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_OPC   : in std_logic;
        i_ID    : in std_logic_vector(c_ID_WIDTH - 1 downto 0);

        o_READY_START_PACKET: out std_logic;
		o_READY : out std_logic;

        -- XINA signals.
        l_in_data_i : out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_in_val_i  : out std_logic;
        l_in_ack_o  : in std_logic;
        l_out_data_o: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_out_val_o : in std_logic;
        l_out_ack_i : out std_logic
    );
end backend_master;

architecture arch_backend_master of backend_master is
begin
    u_BACKEND_MASTER_INJECTION: entity work.backend_master_injection
        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_START_PACKET => i_START_PACKET,
            i_VALID  => i_VALID,
            i_LAST   => i_LAST,
            i_ADDR   => i_ADDR,
            i_BURST  => i_BURST,
            i_LENGTH => i_LENGTH,
            i_DATA   => i_DATA,
            i_OPC    => i_OPC,
            i_ID     => i_ID,

            o_READY_START_PACKET => o_READY_START_PACKET,
            o_READY => o_READY,

            l_in_data_i => l_in_data_i,
            l_in_val_i  => l_in_val_i,
            l_in_ack_o  => l_in_ack_o
        );
end arch_backend_master;