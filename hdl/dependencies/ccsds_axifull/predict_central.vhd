-----------------------------------------------------------------------------------------------------
-- Name: Wesley Grignani
-- Laboratory of Embedded and Distributed Systems (LEDS) - UNIVALI
-----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.ccsds123_b2_package.all;

entity predict_central is
  port (i_clk            : in  std_logic;
        i_enable         : in  std_logic;
        i_rst            : in  std_logic;
        i_z              : in  std_logic_vector(2 downto 0);
        local_diff_mem0  : in  std_logic_vector(DATA_SIZE-1 downto 0);
        local_diff_mem1  : in  std_logic_vector(DATA_SIZE-1 downto 0);
        local_diff_mem2  : in  std_logic_vector(DATA_SIZE-1 downto 0);
        weights_mem0     : in  std_logic_vector(WEIGHT_SIZE-1 downto 0);
        weights_mem1     : in  std_logic_vector(WEIGHT_SIZE-1 downto 0);
        weights_mem2     : in  std_logic_vector(WEIGHT_SIZE-1 downto 0);
        predict_central  : out std_logic_vector(MAX_SIZE-1 downto 0));
end predict_central;

architecture Behavioral of predict_central is

signal w_sum, w_sum3, w_sum2, w_sum1, w_weights_aux0, w_weights_aux1, w_weights_aux2, w_localdiff_aux0, w_localdiff_aux1, w_localdiff_aux2 : integer := 0;   

begin

w_weights_aux0 <= to_integer(signed (weights_mem0));
w_weights_aux1 <= to_integer(signed (weights_mem1));
w_weights_aux2 <= to_integer(signed (weights_mem2));

w_localdiff_aux0 <= to_integer(signed (local_diff_mem0));
w_localdiff_aux1 <= to_integer(signed (local_diff_mem1));
w_localdiff_aux2 <= to_integer(signed (local_diff_mem2));

w_sum3 <= (w_weights_aux2 * w_localdiff_aux0) + (w_weights_aux1 * w_localdiff_aux1) + (w_weights_aux0 * w_localdiff_aux2);
w_sum2 <= (w_weights_aux2 * w_localdiff_aux0) + (w_weights_aux1 * w_localdiff_aux1);
w_sum1 <= (w_weights_aux2 * w_localdiff_aux0);

process(i_clk, i_enable, i_z, i_rst)
begin
  if(i_rst = '1') then
    w_sum <= 0;
  elsif(rising_edge(i_clk) and i_enable = '1') then
    if(i_z > "010") then 
      w_sum <= w_sum3;
    elsif(i_z = "010") then
      w_sum <= w_sum2;
    else
      w_sum <= w_sum1;
    end if;
  end if;
end process;

predict_central <= std_logic_vector(to_signed (w_sum, MAX_SIZE));

end Behavioral;
