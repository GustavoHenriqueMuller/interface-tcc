library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_slave is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Signals (injection).
        i_START_SEND_PACKET: in std_logic;
        i_VALID_SEND_DATA  : in std_logic;
        i_LAST_SEND_DATA   : in std_logic;
        o_READY_SEND_PACKET: out std_logic;
		o_READY_SEND_DATA  : out std_logic;

		i_BURST    : in std_logic_vector(1 downto 0);
        i_LENGTH   : in std_logic_vector(7 downto 0);
        i_DATA_SEND: in std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        i_OPC_SEND : in std_logic;
        i_ID       : in std_logic_vector(c_ID_WIDTH - 1 downto 0);

        -- Signals (reception).
        i_READY_RECEIVE_PACKET: in std_logic;
        i_READY_RECEIVE_DATA  : in std_logic;

        o_VALID_RECEIVE_DATA: out std_logic;
        o_LAST_RECEIVE_DATA : out std_logic;

        o_DATA_RECEIVE      : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        o_HEADER_1_RECEIVE  : out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        o_HEADER_2_RECEIVE  : out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        o_ADDRESS_RECEIVE   : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);

        -- XINA signals.
        l_in_data_i : out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_in_val_i  : out std_logic;
        l_in_ack_o  : in std_logic;
        l_out_data_o: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_out_val_o : in std_logic;
        l_out_ack_i : out std_logic
    );
end backend_slave;

architecture arch_backend_slave of backend_slave is
begin
    u_RECEPTION: entity work.backend_slave_reception
        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_READY_RECEIVE_PACKET => i_READY_RECEIVE_PACKET,
            i_READY_RECEIVE_DATA   => i_READY_RECEIVE_DATA,

            o_VALID_RECEIVE_DATA => o_VALID_RECEIVE_DATA,
            o_LAST_RECEIVE_DATA  => o_LAST_RECEIVE_DATA,
            o_DATA_RECEIVE       => o_DATA_RECEIVE,
            o_HEADER_1_RECEIVE   => o_HEADER_1_RECEIVE,
            o_HEADER_2_RECEIVE   => o_HEADER_2_RECEIVE,
            o_ADDRESS_RECEIVE    => o_ADDRESS_RECEIVE,

            l_out_data_o => l_out_data_o,
            l_out_val_o  => l_out_val_o,
            l_out_ack_i  => l_out_ack_i
        );

end arch_backend_slave;