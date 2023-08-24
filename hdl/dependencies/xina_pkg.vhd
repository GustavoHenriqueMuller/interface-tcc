library ieee;
use ieee.std_logic_1164.all;

package xina_pkg is

  constant rows_c             : positive := 2;
  constant cols_c             : positive := 2;
  constant flow_mode_c        : natural  := 0; -- 0 for HS Moore, 1 for HS Mealy
  constant routing_mode_c     : natural  := 0; -- 0 for XY Moore, 1 for XY Mealy
  constant arbitration_mode_c : natural  := 0; -- 0 for RR Moore, 1 for RR Mealy
  constant buffer_mode_c      : natural  := 0; -- 0 for FIFO Ring, 1 for FIFO Shift
  constant buffer_depth_c     : positive := 4;
  constant data_width_c       : positive := 32;

  type data_link_l_t is array (cols_c - 1 downto 0, rows_c - 1 downto 0) of std_logic_vector(data_width_c downto 0);
  type data_link_x_t is array (cols_c downto 0, rows_c - 1 downto 0) of std_logic_vector(data_width_c downto 0);
  type data_link_y_t is array (cols_c - 1 downto 0, rows_c downto 0) of std_logic_vector(data_width_c downto 0);
  type ctrl_link_l_t is array (cols_c - 1 downto 0, rows_c - 1 downto 0) of std_logic;
  type ctrl_link_x_t is array (cols_c downto 0, rows_c - 1 downto 0) of std_logic;
  type ctrl_link_y_t is array (cols_c - 1 downto 0, rows_c downto 0) of std_logic;

end xina_pkg;
