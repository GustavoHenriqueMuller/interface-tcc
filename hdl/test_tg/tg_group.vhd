----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2022 03:39:03 PM
-- Design Name: 
-- Module Name: tg_group - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use work.xina_pkg.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.xina_pkg.all;
use work.tg_tm_pkg.all;

entity tg_group is
generic(
     -- # of routers in x and y
     rows_p : positive := rows_c;
     cols_p : positive := cols_c;
     -- input and output flow regulation mode
     flow_mode_p : natural := flow_mode_c; -- 0 for HS Moore, 1 for HS Mealy
     -- network data width
     data_width_p : positive := data_width_c;
     -- tg & tm
     traffic_mode_p     : natural := traffic_mode_c;  -- 0 Perfect Shuffle, 1 Bit-reversal, 2 Butterfly, 3 Matrix Transpose, 4 Complementar
     qnt_flits_p        : positive := qnt_flits_c -- Header + N payload + trailer
   );
   port(
     --inputs
     clk_i : in std_logic;
     rst_i : in std_logic;
     l_in_ack_i : in ctrl_link_l_t;
     l_in_val_o : out ctrl_link_l_t;
     l_data_temp_o : out data_link_l_t
     );
end tg_group;

architecture Behavioral of tg_group is

component tg_mo
 generic(
   rows_p  : positive;
   cols_p  : positive;
   data_width_p : positive;
   qnt_flits_p : positive;
   traffic_mode_p : natural;
   x_p : integer;
   y_p : integer
  );
  port(
    clk_i : in std_logic;
    rst_i : in std_logic;
    data_o : out std_logic_vector(data_width_p downto 0);
    val_o  : out std_logic;
    ack_i  : in  std_logic
  );
end component tg_mo;

component tg_me
   generic(
     rows_p  : positive;
     cols_p  : positive;
     data_width_p : positive;
     qnt_flits_p : positive;
     traffic_mode_p : natural;
     x_p : integer;
     y_p : integer
    );
    port(
      clk_i : in std_logic;
      rst_i : in std_logic;
      data_o : out std_logic_vector(data_width_p downto 0);
      val_o  : out std_logic;
      ack_i  : in  std_logic
    );
end component tg_me;

begin
-- Geração dos blocos geradores e medidores de tráfego
  col_tg_tm :
  for i in 0 to cols_p-1 generate
    row_tg_tm :
    for j in 0 to rows_p-1 generate
        
        -- Caso a Noc seja no formato Moore
        moore : if flow_mode_p = 0 generate
            tg_mo_u : tg_mo
                generic map(
                    rows_p => rows_p,
                    cols_p => cols_p,
                    data_width_p => data_width_p,
                    qnt_flits_p => qnt_flits_p,
                    traffic_mode_p => traffic_mode_p,
                    x_p => i,
                    y_p => j
                )
                port map(
                    clk_i => clk_i,
                    rst_i => rst_i,
                    ack_i => l_in_ack_i(i, j),
                    data_o => l_data_temp_o(i, j),
                    val_o => l_in_val_o(i, j)
                );
             end generate; 
        -- Caso a NoC for no formato Mealy
        mealy : if flow_mode_p = 1 generate 
            tg_me_u : tg_me
                generic map(
                    rows_p => rows_p,
                    cols_p => cols_p,
                    data_width_p => data_width_p,
                    qnt_flits_p => qnt_flits_p,
                    traffic_mode_p => traffic_mode_p,
                    x_p => i,
                    y_p => j
                )
                port map(
                    clk_i => clk_i,
                    rst_i => rst_i,
                    ack_i => l_in_ack_i(i, j),
                    data_o => l_data_temp_o(i, j),
                    val_o => l_in_val_o(i, j)
                );
            
        end generate;
    end generate;
  end generate;

end Behavioral;
