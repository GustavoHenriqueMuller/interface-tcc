----------------------------------------------------------------------------------
-- Name: Wesley Grignani
-- Module Name: weights register 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.ccsds123_b2_package.all;

entity weights_reg is
  port ( i_clk        : in  std_logic;
         i_en         : in  std_logic;
         i_weight     : in  std_logic_vector(WEIGHT_SIZE-1 downto 0);
         o_weight_out : out std_logic_vector(WEIGHT_SIZE-1 downto 0));
end weights_reg;

architecture Behavioral of weights_reg is
signal w_weights : std_logic_vector(WEIGHT_SIZE-1 downto 0) := (others => '0');

begin
  process(i_clk, i_en)
  begin
    if(rising_edge(i_clk) and i_en = '1') then
      w_weights <= i_weight;
    end if;
  end process;
  o_weight_out <= w_weights;
end Behavioral;
