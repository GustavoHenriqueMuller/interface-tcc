library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_slave_packetizer_datapath is
    generic(
        p_SRC_X: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);
        p_SRC_Y: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0)
    );

    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_DATA_SEND    : in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);
        i_STATUS_SEND  : in std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);
        i_H_SRC_RECEIVE: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        i_H_INTERFACE_RECEIVE: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        i_FLIT_SELECTOR: in std_logic_vector(2 downto 0);
        i_CHECKSUM     : in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        o_FLIT: out std_logic_vector(c_FLIT_WIDTH - 1 downto 0)
    );
end backend_slave_packetizer_datapath;

architecture rtl of backend_slave_packetizer_datapath is
    signal w_FLIT_H_DEST: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_H_SRC : std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_H_INTERFACE: std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_PAYLOAD : std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
    signal w_FLIT_TRAILER : std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

    signal w_ID: std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
    signal w_LENGTH: std_logic_vector(7 downto 0);
    signal w_BURST : std_logic_vector(1 downto 0);
    signal w_OPC   : std_logic;

begin
    u_MUX5: entity work.mux5
        generic map(
            p_DATA_WIDTH => c_FLIT_WIDTH
        )
        port map(
            i_SELECTOR => i_FLIT_SELECTOR,
            i_DATA_A   => w_FLIT_H_DEST,
            i_DATA_B   => w_FLIT_H_SRC,
            i_DATA_C   => w_FLIT_H_INTERFACE,
            i_DATA_D   => w_FLIT_PAYLOAD,
            i_DATA_E   => w_FLIT_TRAILER,
            o_DATA     => o_FLIT
        );

    w_ID     <= i_H_INTERFACE_RECEIVE(19 downto 15);
    w_LENGTH <= i_H_INTERFACE_RECEIVE(14 downto 7);
    w_BURST  <= i_H_INTERFACE_RECEIVE(6 downto 5);
    w_OPC    <= i_H_INTERFACE_RECEIVE(1);

    w_FLIT_H_DEST <= '1' & i_H_SRC_RECEIVE(31 downto 0);
    w_FLIT_H_SRC  <= '0' & p_SRC_X & p_SRC_Y;
    w_FLIT_H_INTERFACE <= '0' & "000000000000" & w_ID & w_LENGTH & w_BURST & i_STATUS_SEND & w_OPC & "1";
    w_FLIT_PAYLOAD  <= '0' & i_DATA_SEND;
    w_FLIT_TRAILER  <= '1' & i_CHECKSUM;
end rtl;