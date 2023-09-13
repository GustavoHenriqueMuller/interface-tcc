library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_packetizer_datapath is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
		i_OPC_ADDR : in std_logic_vector((c_ADDR_WIDTH / 2) - 1 downto 0);
        i_BURST    : in std_logic_vector(1 downto 0);
		i_LENGTH   : in std_logic_vector(7 downto 0);
        i_DATA_SEND: in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_OPC_SEND : in std_logic;
        i_ID       : in std_logic_vector(c_ID_WIDTH - 1 downto 0);
        i_DEST_X   : in std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0);
        i_DEST_Y   : in std_logic_vector((c_ADDR_WIDTH / 4) - 1 downto 0);
        i_FLIT_SELECTOR: in std_logic_vector(2 downto 0);

		o_FLIT: out std_logic_vector(c_FLIT_WIDTH - 1 downto 0)
    );
end backend_master_packetizer_datapath;

architecture arch_backend_master_packetizer_datapath of backend_master_packetizer_datapath is
    signal w_FLIT_HEADER_1: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_HEADER_2: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_ADDRESS : std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_PAYLOAD : std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_TRAILER : std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

begin
    u_MUX5: entity work.mux5
        generic map(
            p_DATA_WIDTH => data_width_c + 1
        )
        port map(
            i_SELECTOR => i_FLIT_SELECTOR,
            i_DATA_A   => w_FLIT_HEADER_1,
            i_DATA_B   => w_FLIT_HEADER_2,
            i_DATA_C   => w_FLIT_ADDRESS,
            i_DATA_D   => w_FLIT_PAYLOAD,
            i_DATA_E   => w_FLIT_TRAILER,
            o_DATA     => o_FLIT
        );

    w_FLIT_HEADER_1 <= '1' & "1111111111111111" & "1111111111111111";
    w_FLIT_HEADER_2 <= '0' & "00000000000" & i_ID & i_LENGTH & i_BURST & "000" & "1" & "0" & i_OPC_SEND;
    w_FLIT_ADDRESS  <= '0' & i_OPC_ADDR;
    w_FLIT_PAYLOAD  <= '0' & i_DATA_SEND;
    w_FLIT_TRAILER  <= '1' & "1010101010101010" & "1010101010101010";

end arch_backend_master_packetizer_datapath;