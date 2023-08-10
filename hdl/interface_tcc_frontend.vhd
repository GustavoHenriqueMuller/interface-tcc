library IEEE;
use IEEE.std_logic_1164.all;

entity interface_tcc_frontend is
    generic (
        -- Interface attributes.
        p_TYPE: string  := "MASTER"; -- "MASTER" or "SLAVE"
        
        -- AMBA AXI 5 attributes.
        ID_W_WIDTH: natural := 5;
        ID_R_WIDTH: natural := 5;
        ADDR_WIDTH: natural := 8; -- @TODO: Verificar esse tamanho.
        DATA_WIDTH: natural := 32;
        BRESP_WIDTH: natural := 3;
        RRESP_WIDTH: natural := 3;
    );
    
    port(
        -- AMBA AXI 5 signals.
        ACLK: in std_logic;
        ARESETn: in std_logic;
        
        AWVALID: inout std_logic;
        AWREADY: inout std_logic;
        AWADDR: inout std_logic;
        
        -- Signals with back-end.
        l_in_data_o  : out data_link_l_t;
        l_in_val_o   : out ctrl_link_l_t;
        l_in_ack_i   : in ctrl_link_l_t;
        l_out_data_i : in data_link_l_t;
        l_out_val_i  : in ctrl_link_l_t;
        l_out_ack_o  : out ctrl_link_l_t
    );
end interface_tcc_frontend;

architecture arch_interface_tcc_frontend is
end arch_interface_tcc_frontend;