----------------------------------------------------------------------------------
-- Name: Wesley Grignani
-- Module Name: local diff register 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.ccsds123_b2_package.all;

entity local_diff_reg is
  port ( i_clk       : in  std_logic;
         i_en        : in  std_logic;
         i_ldiff     : in  std_logic_vector(DATA_SIZE-1 downto 0);
         o_ldiff_out : out std_logic_vector(DATA_SIZE-1 downto 0));
end local_diff_reg;

architecture Behavioral of local_diff_reg is
signal w_ldiff : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

begin
  process(i_clk, i_en)
  begin
    if(rising_edge(i_clk) and i_en = '1') then
      w_ldiff <= i_ldiff;
    end if;
  end process;
  o_ldiff_out <= w_ldiff;
end Behavioral;
