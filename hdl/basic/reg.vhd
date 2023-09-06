library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity reg is
    generic (
        p_DATA_WIDTH   : natural := 32;
        p_DEFAULT_VALUE: natural := 0
    );
    port (
        ACLK   : in std_logic;
        ARESETn: in std_logic;
        i_WRITE: in std_logic;
        i_DATA : in std_logic_vector(p_DATA_WIDTH - 1 downto 0);
        o_DATA : out std_logic_vector(p_DATA_WIDTH - 1 downto 0)
    );
end reg;

architecture arch_reg of reg is
    signal r_DATA: std_logic_vector(p_DATA_WIDTH - 1 downto 0) := conv_std_logic_vector(p_DEFAULT_VALUE, p_DATA_WIDTH);

begin
    process (ACLK, ARESETn)
    begin
        if (ARESETn = '0') then
            r_DATA <= conv_std_logic_vector(p_DEFAULT_VALUE, p_DATA_WIDTH);
        elsif (rising_edge(ACLK)) then
            if (i_WRITE = '1') then
                r_DATA <= i_DATA;
            end if;
        end if;
    end process;

  o_DATA <= r_DATA;
end arch_reg;