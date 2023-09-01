library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.xina_pkg.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.xina_pkg.all;
use work.tg_tm_pkg.all;

entity tm_group is
   generic(
     rows_p : positive := rows_c;
     cols_p : positive := cols_c;
     flow_mode_p : natural := flow_mode_c; -- 0 for HS Moore, 1 for HS Mealy
     data_width_p : positive := data_width_c;
     qnt_flits_p        : positive := qnt_flits_c -- Header + N payload + trailer
   );
    port(
        clk_i : in std_logic;
        rst_i : in std_logic;
        l_out_data_i : in  data_link_l_t;
        l_out_val_i  : in  ctrl_link_l_t;
        l_out_ack_o  : out ctrl_link_l_t;
        rdy_o        : out ctrl_link_l_t;
        error_o      : out ctrl_link_l_t;
        error_counter_o : out error_counter_type;
        pkg_counter_o : out error_counter_type
    );
end tm_group;

architecture Behavioral of tm_group is
component tm_mo
    generic(
        rows_p  : positive;
        cols_p  : positive;
        data_width_p : positive;
        qnt_flits_p : positive;
        x_p : integer; 
        y_p : integer
    );
    port(
        clk_i   : in std_logic;
        rst_i   : in std_logic;
        val_i   : in std_logic;
        data_i  : in std_logic_vector(data_width_p downto 0);
        ack_o   : out  std_logic;
        rdy_o   : out std_logic;
        error_o : out std_logic;
        error_counter_o : out std_logic_vector(7 downto 0);
        pkg_counter_o : out std_logic_vector(7 downto 0)
    );
end component tm_mo;

component tm_me
    generic(
        rows_p  : positive;
        cols_p  : positive;
        data_width_p : positive;
        qnt_flits_p : positive;
        x_p : integer; 
        y_p : integer
    );
    port(
        clk_i   : in std_logic;
        rst_i   : in std_logic;
        val_i   : in std_logic;
        data_i  : in std_logic_vector(data_width_p downto 0);
        ack_o   : out  std_logic;
        rdy_o   : out std_logic;
        error_o : out std_logic;
        error_counter_o : out std_logic_vector(7 downto 0);
        pkg_counter_o : out std_logic_vector(7 downto 0)
    );
end component tm_me;

begin
  -- TM generator (Mealy or Moore)
  col_tg_tm :
  for i in 0 to cols_p-1 generate
    row_tg_tm :
    for j in 0 to rows_p-1 generate
        moore : if flow_mode_p = 0 generate          
              tm_mo_u : tm_mo
                generic map(
                    rows_p => rows_p,
                    cols_p => cols_p,
                    data_width_p => data_width_p,
                    qnt_flits_p => qnt_flits_p,
                    x_p => i,
                    y_p => j    
                )
                port map(
                    clk_i => clk_i,
                    rst_i => rst_i,
                    val_i => l_out_val_i(i, j),
                    data_i => l_out_data_i(i, j),
                    ack_o => l_out_ack_o(i, j),
                    rdy_o => rdy_o(i, j),
                    error_o => error_o(i, j),
                    error_counter_o => error_counter_o(i,j),
                    pkg_counter_o => pkg_counter_o(i,j)
                );
                
        end generate;
        mealy : if flow_mode_p = 1 generate 
            tm_me_u : tm_me
                generic map(
                    rows_p => rows_p,
                    cols_p => cols_p,
                    data_width_p => data_width_p,
                    qnt_flits_p => qnt_flits_p,
                    x_p => i,
                    y_p => j    
                )
                port map(
                    clk_i => clk_i,
                    rst_i => rst_i,
                    val_i => l_out_val_i(i, j),
                    data_i => l_out_data_i(i, j),
                    ack_o => l_out_ack_o(i, j),
                    rdy_o => rdy_o(i, j),
                    error_o => error_o(i, j),
                    error_counter_o => error_counter_o(i,j),
                    pkg_counter_o => pkg_counter_o(i,j)
                );
        end generate;
    end generate;
  end generate;
  
end Behavioral;