library ieee;
use ieee.std_logic_1164.all;
use work.xina_pkg.all;

package tg_tm_pkg is
  constant traffic_mode_c : natural := 4;  -- 0 Perfect Shuffle, 1 Bit-reversal, 2 Butterfly, 3 Matrix Transpose, 4 Complementar
  constant qnt_flits_c    : positive := 4; -- Header + N payload + trailer
  type error_counter_type is array (cols_c - 1 downto 0, rows_c - 1 downto 0) of std_logic_vector(7 downto 0);
end tg_tm_pkg;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.xina_pkg.all;
use work.tg_tm_pkg.all;

entity xina_tg_tm is
   generic(
     -- # of routers in x and y
     rows_p : positive := rows_c;
     cols_p : positive := cols_c;
     -- input and output flow regulation mode
     flow_mode_p : natural := flow_mode_c; -- 0 for HS Moore, 1 for HS Mealy
     -- routing mode
     routing_mode_p : natural := routing_mode_c; -- 0 for XY Moore, 1 for XY Mealy
     -- arbitration mode
     arbitration_mode_p : natural := arbitration_mode_c; -- 0 for RR Moore, 1 for RR Mealy
     -- input buffer mode and depth
     buffer_mode_p  : natural  := buffer_mode_c; -- 0 for FIFO Ring, 1 for FIFO Shift
     buffer_depth_p : positive := buffer_depth_c;
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
     
     l_in_error_button_i : in std_logic; --insert error
     l_in_enable_button_i : in std_logic; --enable output register
     
     error_pos_i : in std_logic_vector(3 downto 0); -- insert error in the XY rounter
     mux_select_i : in std_logic_vector(3 downto 0); --select the XY router counter

     error_counter_o : out std_logic_vector(7 downto 0);--error counter output
     pkg_counter_o : out std_logic_vector(7 downto 0) -- package counter output
     );
end xina_tg_tm;

architecture Behavioral of xina_tg_tm is

component tg_group is
  generic(
    rows_p : positive := rows_c;
    cols_p : positive := cols_c;
    flow_mode_p : natural := flow_mode_c;
    data_width_p : positive := data_width_c;
    traffic_mode_p : natural := traffic_mode_c;  
    qnt_flits_p    : positive := qnt_flits_c 
   );
   port(
    clk_i : in std_logic;
    rst_i : in std_logic;
    l_in_ack_i : in ctrl_link_l_t;
    l_in_val_o : out ctrl_link_l_t;
    l_data_temp_o : out data_link_l_t
   );
end component tg_group;

component tm_group is
  generic(
    rows_p : positive := rows_c;
    cols_p : positive := cols_c;
    flow_mode_p  : natural := flow_mode_c;
    data_width_p : positive := data_width_c;
    qnt_flits_p  : positive := qnt_flits_c
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
end component tm_group;

component error_generator is
  generic(
    rows_p : positive := rows_c;
    cols_p : positive := cols_c;
    data_width_p : positive := data_width_c
  );
  port(
    clk_i : std_logic;
    x_i : integer;
    y_i : integer; 
    l_data_i : data_link_l_t;
    button_pressed_i : std_logic;
    l_in_ack : ctrl_link_l_t;
    l_data_o : out data_link_l_t;
    flip_signal : out ctrl_link_l_t
  );
end component;
 
component button_error_debounce is
  port(
    clk_i : in std_logic;
    rst_i : in std_logic;
    l_in_error_button_i : in std_logic;
    flip_signal_i : in ctrl_link_l_t;
    x_i : integer;
    y_i : integer;
    button_pressed_o : out std_logic
  );
end component button_error_debounce;

component button_enable_debounce is
port(
  clk_i : in std_logic;
  rst_i : in std_logic;
  l_in_enable_button_i : in std_logic;
  enable_signal_i : in std_logic;
  
  x_i : integer;
  y_i : integer;
  
  button_pressed_o : out std_logic
  
);
end component;
  
  --INTEGER ROUTER POSITION
  signal x: integer;
  signal y : integer;
  
  --XINA WIRES
  signal l_in_val_w   :  ctrl_link_l_t;
  signal l_in_ack_w   :  ctrl_link_l_t;
  signal l_out_data_w :  data_link_l_t;
  signal l_out_val_w  :  ctrl_link_l_t;
  signal l_out_ack_w  :  ctrl_link_l_t;
  
  --TM WIRES
  signal rdy_w        : ctrl_link_l_t; --not connected
  signal error_w      : ctrl_link_l_t; --not connected
  
  --ERROR GENERATOR WIRES
  signal l_data_temp_i_w : data_link_l_t; 
  signal l_data_temp_o_w : data_link_l_t; 
  
  --ERROR BUTTON WIRES
  signal error_button_pressed_w : std_logic;
  signal flip_signal_w : ctrl_link_l_t :=("0000","0000","0000","0000");
  
  --ENABLE BUTTON WIRES
  signal enable_signal_w : std_logic;
  signal enable_button_w : std_logic;
  
  --ERROR COUNTER WIRES
  signal pkg_counter_w : error_counter_type;
  
  --MUX WIRES
  signal error_counter_w : error_counter_type;
  signal mux_select_w : std_logic_vector(3 downto 0);
  signal mux_out_w : std_logic_vector(7 downto 0);
  signal pkg_mux_out_w : std_logic_vector(7 downto 0);
  
  --OUTPUT REGISTER WIRES
  signal error_counter_reg_w : std_logic_vector(7 downto 0);
  
begin
  xina : entity work.xina
    generic map(
      rows_p             => rows_p,
      cols_p             => cols_p,
      flow_mode_p        => flow_mode_p,
      routing_mode_p     => routing_mode_p,
      arbitration_mode_p => arbitration_mode_p,
      buffer_mode_p      => buffer_mode_p,
      buffer_depth_p     => buffer_depth_p,
      data_width_p       => data_width_p
    )
    port map(
      clk_i        => clk_i,
      rst_i        => rst_i,
      l_in_data_i  => l_data_temp_i_w,
      l_in_val_i   => l_in_val_w,
      l_in_ack_o   => l_in_ack_w,
      l_out_data_o => l_out_data_w,
      l_out_val_o  => l_out_val_w,
      l_out_ack_i  => l_out_ack_w
    );
  
  tg_group_u : tg_group 
  generic map(
     rows_p => rows_p,
     cols_p => cols_p,
     flow_mode_p => flow_mode_p,
     data_width_p => data_width_p,
     traffic_mode_p => traffic_mode_p,
     qnt_flits_p => qnt_flits_p 
   )
   port map(
     clk_i => clk_i,
     rst_i => rst_i,
     l_in_ack_i => l_in_ack_w,
     l_in_val_o => l_in_val_w,
     l_data_temp_o => l_data_temp_o_w
     );
  
   tm_group_u : tm_group 
   generic map(
     rows_p => rows_c,
     cols_p => cols_c,
     flow_mode_p => flow_mode_c,
     data_width_p => data_width_c,
     qnt_flits_p => qnt_flits_c
   )
   port map(
      clk_i => clk_i,
      rst_i => rst_i,
      l_out_data_i => l_out_data_w,
      l_out_val_i  => l_out_val_w,
      l_out_ack_o  => l_out_ack_w,
      rdy_o        => rdy_w,
      error_o      => error_w,
      error_counter_o =>error_counter_w,
      pkg_counter_o => pkg_counter_w
   );
   
   error_generator_u : error_generator 
   generic map(
     rows_p => rows_p,
     cols_p => cols_p
   )
   port map(
     clk_i => clk_i,
     x_i => x,
     y_i => y,
     l_data_i => l_data_temp_o_w,
     button_pressed_i => error_button_pressed_w,
     l_in_ack => l_in_ack_w,
     l_data_o => l_data_temp_i_w,
     flip_signal => flip_signal_w
   );
   
  button_error_debounce_u : button_error_debounce 
  port map(
    clk_i => clk_i,
    rst_i => rst_i,
    l_in_error_button_i => l_in_error_button_i,
    flip_signal_i => flip_signal_w,
    x_i => x,
    y_i => y,
    button_pressed_o => error_button_pressed_w
  );
  
  button_enable_debounce_u : button_enable_debounce 
  port map(
    clk_i => clk_i,
    rst_i => rst_i,
    l_in_enable_button_i => l_in_enable_button_i,
    enable_signal_i => enable_signal_w,
    x_i => x,
    y_i => y,
    button_pressed_o => enable_button_w
  );

--Gets converts router position to integer
process(all)
  begin
    x <= to_integer(unsigned(error_pos_i(3 downto 2)));
    y <= to_integer(unsigned(error_pos_i(1 downto 0)));
 end process;

--Mux input to Mux wire
process(all)
begin
  mux_select_w(3 downto 0)<=mux_select_i(3 downto 0);
end process;

-- MUX error counter
process(all)
begin
  case mux_select_w is
    when "0000" => mux_out_w <= error_counter_w(0,0);
    when "0001" => mux_out_w <= error_counter_w(0,1);
    when "0010" => mux_out_w <= error_counter_w(0,2);
    when "0011" => mux_out_w <= error_counter_w(0,3);
    when "0100" => mux_out_w <= error_counter_w(1,0);
    when "0101" => mux_out_w <= error_counter_w(1,1);
    when "0110" => mux_out_w <= error_counter_w(1,2);
    when "0111" => mux_out_w <= error_counter_w(1,3);
    when "1000" => mux_out_w <= error_counter_w(2,0);
    when "1001" => mux_out_w <= error_counter_w(2,1);
    when "1010" => mux_out_w <= error_counter_w(2,2);
    when "1011" => mux_out_w <= error_counter_w(2,3);
    when "1100" => mux_out_w <= error_counter_w(3,0);
    when "1101" => mux_out_w <= error_counter_w(3,1);
    when "1110" => mux_out_w <= error_counter_w(3,2);
    when "1111" => mux_out_w <= error_counter_w(3,3);
    when others => mux_out_w <= "00000000";
  end case;
end process;

-- MUX pkg counter
process(all)
begin
  case mux_select_w is
    when "0000" => pkg_mux_out_w <= pkg_counter_w(0,0);
    when "0001" => pkg_mux_out_w <= pkg_counter_w(0,1);
    when "0010" => pkg_mux_out_w <= pkg_counter_w(0,2);
    when "0011" => pkg_mux_out_w <= pkg_counter_w(0,3);
    when "0100" => pkg_mux_out_w <= pkg_counter_w(1,0);
    when "0101" => pkg_mux_out_w <= pkg_counter_w(1,1);
    when "0110" => pkg_mux_out_w <= pkg_counter_w(1,2);
    when "0111" => pkg_mux_out_w <= pkg_counter_w(1,3);
    when "1000" => pkg_mux_out_w <= pkg_counter_w(2,0);
    when "1001" => pkg_mux_out_w <= pkg_counter_w(2,1);
    when "1010" => pkg_mux_out_w <= pkg_counter_w(2,2);
    when "1011" => pkg_mux_out_w <= pkg_counter_w(2,3);
    when "1100" => pkg_mux_out_w <= pkg_counter_w(3,0);
    when "1101" => pkg_mux_out_w <= pkg_counter_w(3,1);
    when "1110" => pkg_mux_out_w <= pkg_counter_w(3,2);
    when "1111" => pkg_mux_out_w <= pkg_counter_w(3,3);
    when others => pkg_mux_out_w <= "00000000";
  end case;
end process;


--OUTPUT REGISTER
process (all)                     
  begin
    if(rst_i ='1') then
      error_counter_reg_w <= "00000000";
    elsif rising_edge(clk_i) then
      if (enable_button_w = '1') then
        error_counter_reg_w <= mux_out_w;
        enable_signal_w<='1';
      else
        error_counter_reg_w <= error_counter_reg_w;
        enable_signal_w<='0';
      end if;
    end if;
end process;

process(all)
begin 
  error_counter_o <= error_counter_reg_w;
  pkg_counter_o <= pkg_mux_out_w;
end process;

end Behavioral;