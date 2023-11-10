----------------------------------------------------------------------------------
-- Name: Wesley Grignani
-- Laboratory of Embedded and Distributed Systems (LEDS) - UNIVALI
----------------------------------------------------------------------------------
-- State machine and control signals for datapath
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.ccsds123_b2_package.all;

entity p_control is
  port ( i_clk              : in  std_logic;
         i_rst              : in  std_logic;
         i_start            : in  std_logic;
         i_z                : in  std_logic_vector(2 downto 0);
         o_enable_first_mem : out std_logic;
         o_enable_init_mem  : out std_logic;
         o_enable_ls        : out std_logic;
         o_enable_ldiff     : out std_logic;
         o_enable_central   : out std_logic;
         o_enable_high      : out std_logic;
         o_enable_double    : out std_logic;
         o_enable_qnt       : out std_logic;
         o_sel_mux_weight   : out std_logic;
         o_rst              : out std_logic;
         o_enable_mapped    : out std_logic;
         o_en_update_weight : out std_logic;
         o_en_ldiff_vec     : out std_logic;
         o_en_weight_vec    : out std_logic);
end p_control;

architecture Behavioral of p_control is

type t_STATE is (s_first_mem, s_first_mem_aux, s_mem_init, s_mem_init_aux, s_init, s_ls, s_first_central, s_ldiff_central, s_central_aux, s_high, s_double, s_qnt, s_mapped, s_update_weights); -- new FSM type
signal r_STATE : t_STATE; -- state register
signal w_NEXT  : t_STATE; -- next state

begin

  -- STATE TRANSITION PROCESS
  p_STATE : process (i_rst, i_clk)
  begin
    if (i_rst = '1') then
      r_STATE <= s_init; -- estado inicial
    elsif (rising_edge(i_clk)) then
      r_STATE <= w_NEXT; -- proximo estado
    end if;
  end process;


  -- NEXT STATE PROCESS
  p_NEXT : process (r_STATE, i_start, i_z)
  variable v_cont_aux : integer := 0;
  begin

    case (r_STATE) is

      when s_first_mem => w_NEXT <= s_first_mem_aux;

      when s_first_mem_aux => w_NEXT <= s_mem_init;

      when s_mem_init => if(v_cont_aux < 2) then
                           w_NEXT <= s_mem_init_aux;
                           v_cont_aux := v_cont_aux + 1;
                         else
                           w_NEXT <= s_init;
                           v_cont_aux := 0;
                         end if;

      when s_mem_init_aux => w_NEXT <= s_mem_init;

      when s_init => if (i_start = '1') then
                       w_NEXT <= s_ls;
                     else
                       w_NEXT <= s_init;
                     end if;

      when s_ls => w_NEXT <= s_first_central;

      when s_first_central => if (i_z = "000") then
                                w_NEXT <= s_high;
                              else
                                w_NEXT <= s_ldiff_central;
                              end if;

      when s_ldiff_central => w_NEXT <= s_high;

      when s_high => w_NEXT <= s_double;

      when s_double => w_NEXT <= s_qnt;

      when s_qnt => w_NEXT <= s_mapped;

      when s_mapped => w_NEXT <= s_update_weights;

      when s_update_weights => w_NEXT <= s_init;

      when others => w_NEXT <= s_init;

    end case;
  end process;


  -- CONTROL SIGNALS

  o_en_ldiff_vec <= '1' when r_STATE = s_mapped else '0';

  o_en_weight_vec <= '1' when r_STATE = s_first_mem_aux or r_STATE = s_mem_init_aux else '0';

  o_enable_first_mem <= '1' when r_STATE = s_first_mem or r_STATE = s_first_mem_aux else '0';

  o_enable_init_mem  <= '1' when r_STATE = s_mem_init or r_STATE = s_first_mem or r_STATE = s_first_mem_aux else '0';

  o_rst              <= '1' when r_STATE = s_init else '0';

  o_enable_ls        <= '1' when r_STATE = s_ls else '0';

  o_enable_ldiff     <= '1' when r_STATE = s_first_central else '0';

  o_enable_central   <= '1' when (r_STATE = s_first_central and i_z /= "000") or r_STATE = s_central_aux else '0';

  o_enable_high      <= '1' when r_STATE = s_high else '0';

  o_enable_double    <= '1' when r_STATE = s_double else '0';

  o_enable_qnt       <= '1' when r_STATE = s_qnt else '0';

  o_enable_mapped    <= '1' when r_STATE = s_mapped else '0';

  o_en_update_weight <= '1' when r_STATE = s_update_weights else '0';

  o_sel_mux_weight   <= '1' when r_STATE = s_mem_init or r_STATE = s_mem_init_aux or r_STATE = s_first_mem or r_STATE = s_first_mem_aux else '0';

end Behavioral;
