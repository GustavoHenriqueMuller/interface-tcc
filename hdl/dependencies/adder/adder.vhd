library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
  port
  (
    i_A   : in std_logic_vector(31 downto 0);
    o_ADD : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of adder is

begin

  o_ADD <= std_logic_vector(unsigned(i_A) + 15);

end architecture;