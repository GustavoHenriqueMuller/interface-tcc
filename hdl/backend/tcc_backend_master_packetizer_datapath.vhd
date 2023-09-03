library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity tcc_backend_master_packetizer_datapath is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
    	i_OPC   : in std_logic;
		i_BURST : in std_logic_vector(1 downto 0);
		i_LENGTH: in std_logic_vector(7 downto 0);
        i_ID    : in std_logic_vector(c_ID_WIDTH - 1 downto 0);
		i_DATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_OPERATION_ADDR: in std_logic_vector((c_ADDR_WIDTH / 2) - 1 downto 0);
        i_DEST_X: in std_logic_vector(c_ADDR_WIDTH / 2);
        i_DEST_Y: in std_logic_vector(c_ADDR_WIDTH / 2);

        i_FLIT_SELECTOR: in std_logic_vector(1 downto 0);
		o_FLIT         : out std_logic_vector(c_FLIT_WIDTH - 1 downto 0)
    );
end tcc_backend_master_packetizer_datapath;

architecture arch_tcc_backend_master_packetizer_datapath of tcc_backend_master_packetizer_datapath is
    signal w_FLIT_HEADER_1: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_HEADER_2: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_PAYLOAD : std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_TRAILER : std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

begin
    u_MUX4: entity work.mux4
        generic map(
            data_width_p => data_width_c + 1
        )
        port map(
            i_SELECTOR => i_FLIT_SELECTOR,
            i_DATA_A   => w_FLIT_HEADER_1,
            i_DATA_B   => w_FLIT_HEADER_2,
            i_DATA_C   => w_FLIT_PAYLOAD,
            i_DATA_D   => w_FLIT_TRAILER,
            o_DATA     => o_FLIT
        );

    -- @TODO: Ver a questão do ADDR que não está sendo colocado no payload (ignorado por enquanto).
    -- @TODO: Também ver a questão de modificar os roteadores da xina para eles considerarem a metade direita
    -- do primeiro flit como o endereço de destino, e não o flit inteiro.
    -- w_FLIT_HEADER_1 <= '1' & c_SRC_X & c_SRC_Y & i_DEST_X & i_DEST_Y;
    w_FLIT_HEADER_1 <= '1' & "1111111111111111" & "1111111111111111";
    w_FLIT_HEADER_2 <= '0' & "00000000000" & i_ID & i_LENGTH & i_BURST & "000" & "1" & "0" & i_OPC;
    w_FLIT_PAYLOAD  <= '0' & i_DATA;
    w_FLIT_TRAILER  <= '1' & "1010101010101010" & "1010101010101010";

end arch_tcc_backend_master_packetizer_datapath;