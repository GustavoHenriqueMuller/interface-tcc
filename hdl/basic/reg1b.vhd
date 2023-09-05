library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity reg1b is
    generic (
        p_DEFAULT_VALUE : natural := 0
    );
    port (
        i_CLK   : in  std_logic;
        i_RESETn: in  std_logic;
        i_WRITE : in  std_logic;
        i_DATA  : in  std_logic;
        o_DATA  : out std_logic
    );
end reg1b;

architecture arch_reg1b of reg1b is
    signal r_DATA: std_logic;

begin
    process (i_CLK, i_RESETn)
    begin
        if (i_RESETn = '0') then
            r_DATA <= i_DATA;
        elsif (rising_edge(i_CLK)) then
            if (i_WRITE = '1') then
                r_DATA <= i_DATA;
            end if;
        end if;
    end process;

    o_DATA <= r_DATA;
end arch_reg1b;