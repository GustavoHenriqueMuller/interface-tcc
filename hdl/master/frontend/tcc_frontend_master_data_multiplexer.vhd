library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;

entity tcc_frontend_master_data_multiplexer is
    port (
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Signals from front-end.
        AW_ID  : in std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
        AWADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        AWLEN  : in std_logic_vector(7 downto 0);
        AWBURST: in std_logic_vector(1 downto 0);
        WDATA  : in std_logic_vector(c_DATA_WIDTH - 1 downto 0) := (others => '0');

        AR_ID  : in std_logic_vector(c_ID_WIDTH - 1 downto 0) := (others => '0');
        ARADDR : in std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        ARLEN  : in std_logic_vector(7 downto 0);
        ARBURST: in std_logic_vector(1 downto 0);

        -- Signals from control.
        i_OPC  : in std_logic;

        -- Signals to back-end.
        o_BACKEND_OPC   : out std_logic;
        o_BACKEND_ADDR  : out std_logic_vector(c_ADDR_WIDTH - 1 downto 0);
        o_BACKEND_BURST : out std_logic_vector(1 downto 0);
        o_BACKEND_LENGTH: out std_logic_vector(7 downto 0);
        o_BACKEND_DATA  : out std_logic_vector(c_DATA_WIDTH - 1 downto 0);
        o_BACKEND_ID    : out std_logic_vector(c_ID_WIDTH - 1 downto 0)
    );
end tcc_frontend_master_data_multiplexer;

architecture arch_tcc_frontend_master_data_multiplexer of tcc_frontend_master_data_multiplexer is
begin
    o_BACKEND_OPC    <= i_OPC;

    o_BACKEND_ADDR   <= AWADDR  when (i_OPC = '0') else ARADDR when (i_OPC = '1');

    o_BACKEND_BURST  <= AWBURST when (i_OPC = '0') else ARBURST when (i_OPC = '1');

    o_BACKEND_LENGTH <= AWLEN   when (i_OPC = '0') else ARLEN when (i_OPC = '1');

    o_BACKEND_DATA   <= WDATA   when (i_OPC = '0') else (c_DATA_WIDTH - 1 downto 0 => '0');
    -- @TODO: else (c_DATA_WIDTH - 1 downto c_ADDR_WIDTH => '0') & ARADDR when ((i_OPC = '1'));

    o_BACKEND_ID     <= AW_ID   when (i_OPC = '0') else AR_ID when (i_OPC = '1');

end arch_tcc_frontend_master_data_multiplexer;