library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master is
    generic(
        p_SRC_X: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);
        p_SRC_Y: std_logic_vector((c_AXI_ADDR_WIDTH / 4) - 1 downto 0);

        p_BUFFER_DEPTH      : positive;
        p_USE_TMR_PACKETIZER: boolean;
        p_USE_TMR_FLOW      : boolean;
        p_USE_TMR_INTEGRITY : boolean;
        p_USE_HAMMING       : boolean;
        p_USE_INTEGRITY     : boolean
    );

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

        i_ADDR     : in std_logic_vector(c_AXI_ADDR_WIDTH - 1 downto 0);
        i_ID       : in std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
        i_LENGTH   : in std_logic_vector(7 downto 0);
        i_BURST    : in std_logic_vector(1 downto 0);
        i_OPC_SEND : in std_logic;
        i_DATA_SEND: in std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        -- Signals (reception).
        i_READY_RECEIVE_PACKET: in std_logic;
        i_READY_RECEIVE_DATA  : in std_logic;

        o_VALID_RECEIVE_DATA: out std_logic;
        o_LAST_RECEIVE_DATA : out std_logic;

        o_ID_RECEIVE    : out std_logic_vector(c_AXI_ID_WIDTH - 1 downto 0);
        o_STATUS_RECEIVE: out std_logic_vector(c_AXI_RESP_WIDTH - 1 downto 0);
        o_OPC_RECEIVE   : out std_logic;
        o_DATA_RECEIVE  : out std_logic_vector(c_AXI_DATA_WIDTH - 1 downto 0);

        o_CORRUPT_RECEIVE: out std_logic;

        -- XINA signals.
        l_in_data_i : out std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_in_val_i  : out std_logic;
        l_in_ack_o  : in std_logic;
        l_out_data_o: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        l_out_val_o : in std_logic;
        l_out_ack_i : out std_logic
    );
end backend_master;

architecture rtl of backend_master is
begin
    u_INJECTION: entity work.backend_master_injection
        generic map(
            p_SRC_X => p_SRC_X,
            p_SRC_Y => p_SRC_Y,

            p_BUFFER_DEPTH       => p_BUFFER_DEPTH,
            p_USE_TMR_PACKETIZER => p_USE_TMR_PACKETIZER,
            p_USE_TMR_FLOW       => p_USE_TMR_FLOW,
            p_USE_TMR_INTEGRITY  => p_USE_TMR_INTEGRITY,
            p_USE_HAMMING        => p_USE_HAMMING,
            p_USE_INTEGRITY      => p_USE_INTEGRITY
        )

        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_START_SEND_PACKET => i_START_SEND_PACKET,
            i_VALID_SEND_DATA   => i_VALID_SEND_DATA,
            i_LAST_SEND_DATA    => i_LAST_SEND_DATA,
            o_READY_SEND_PACKET => o_READY_SEND_PACKET,
            o_READY_SEND_DATA   => o_READY_SEND_DATA,

            i_ADDR      => i_ADDR,
            i_ID        => i_ID,
            i_LENGTH    => i_LENGTH,
            i_BURST     => i_BURST,
            i_OPC_SEND  => i_OPC_SEND,
            i_DATA_SEND => i_DATA_SEND,

            l_in_data_i => l_in_data_i,
            l_in_val_i  => l_in_val_i,
            l_in_ack_o  => l_in_ack_o
        );

    u_RECEPTION: entity work.backend_master_reception
        generic map(
            p_BUFFER_DEPTH       => p_BUFFER_DEPTH,
            p_USE_TMR_PACKETIZER => p_USE_TMR_PACKETIZER,
            p_USE_TMR_FLOW       => p_USE_TMR_FLOW,
            p_USE_TMR_INTEGRITY  => p_USE_TMR_INTEGRITY,
            p_USE_HAMMING        => p_USE_HAMMING,
            p_USE_INTEGRITY      => p_USE_INTEGRITY
        )

        port map(
            ACLK    => ACLK,
            ARESETn => ARESETn,

            i_READY_RECEIVE_PACKET => i_READY_RECEIVE_PACKET,
            i_READY_RECEIVE_DATA   => i_READY_RECEIVE_DATA,

            o_VALID_RECEIVE_DATA  => o_VALID_RECEIVE_DATA,
            o_LAST_RECEIVE_DATA   => o_LAST_RECEIVE_DATA,

            o_ID_RECEIVE     => o_ID_RECEIVE,
            o_STATUS_RECEIVE => o_STATUS_RECEIVE,
            o_OPC_RECEIVE    => o_OPC_RECEIVE,
            o_DATA_RECEIVE   => o_DATA_RECEIVE,

            o_CORRUPT_RECEIVE => o_CORRUPT_RECEIVE,

            l_out_data_o => l_out_data_o,
            l_out_val_o  => l_out_val_o,
            l_out_ack_i  => l_out_ack_i
        );
end rtl;