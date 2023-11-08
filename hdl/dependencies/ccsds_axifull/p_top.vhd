----------------------------------------------------------------------------------
-- Name: Wesley Grignani
-- Laboratory of Embedded and Distributed Systems (LEDS) - UNIVALI
----------------------------------------------------------------------------------
-- Top level of predictor block 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.ccsds123_b2_package.all;

entity p_top is
  port ( i_clk          : in  std_logic; 
         i_rst          : in  std_logic;
         i_start        : in  std_logic;
         i_t            : in  std_logic_vector(7 downto 0);
         i_z            : in  std_logic_vector(2 downto 0);
         i_sample       : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
         i_neighboor    : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
         o_mapped       : out std_logic_vector(SAMPLE_SIZE-1 downto 0));
end p_top;


architecture Behavioral of p_top is
-- control block
component p_control is
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
end component;

-- datapath block
component top_test is
  port (i_clk              : in  std_logic;
        i_enable_ls        : in  std_logic;
        i_rst              : in  std_logic;
        i_sel_weight_mem   : in  std_logic;
        i_enable_ldiff     : in  std_logic;
        i_enable_central   : in  std_logic;
        i_enable_high      : in  std_logic;
        i_enable_double    : in  std_logic;
        i_enable_qnt       : in  std_logic;
        i_enable_mapped    : in  std_logic;
        i_en_update_weight : in  std_logic; 
        i_t                : in  std_logic_vector(7 downto 0);
        i_z                : in  std_logic_vector(2 downto 0);
        i_sample           : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
        i_neighboor        : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
        i_en_ldiff_vec     : in  std_logic; 
        i_en_weight_vec    : in  std_logic;
        i_en_first_mem     : in  std_logic;
        i_en_init_mem      : in  std_logic;
        o_mapped           : out std_logic_vector(SAMPLE_SIZE-1 downto 0));
end component;


signal w_enable_ls, w_enable_ldiff, w_enable_central, w_enable_high, w_enable_double, w_enable_qnt, w_enable_mapped, w_initweights_mem, w_enable_first_mem, w_en_update_weight, w_sel_weight, w_rst, w_en_ldiff_vec, w_en_weight_vec : std_logic := '0';

begin

control_block : p_control 
  port map ( i_clk              => i_clk,
             i_rst              => i_rst,
             i_start            => i_start,
             i_z                => i_z,
             o_enable_first_mem => w_enable_first_mem,
             o_enable_init_mem  => w_initweights_mem,
             o_enable_ls        => w_enable_ls,
             o_enable_ldiff     => w_enable_ldiff,
             o_enable_central   => w_enable_central,
             o_enable_high      => w_enable_high,
             o_enable_double    => w_enable_double,
             o_enable_qnt       => w_enable_qnt,
             o_enable_mapped    => w_enable_mapped,
             o_sel_mux_weight   => w_sel_weight,
             o_rst              => w_rst,
             o_en_update_weight => w_en_update_weight,
             o_en_ldiff_vec     => w_en_ldiff_vec,
             o_en_weight_vec    => w_en_weight_vec);
             
 datapath_block : top_test 
  port map ( i_clk              => i_clk,
             i_enable_ls        => w_enable_ls,
             i_enable_ldiff     => w_enable_ldiff,
             i_enable_central   => w_enable_central,
             i_enable_high      => w_enable_high,
             i_enable_double    => w_enable_double,
             i_enable_qnt       => w_enable_qnt,
             i_enable_mapped    => w_enable_mapped,
             i_t                => i_t,
             i_z                => i_z,
             i_sample           => i_sample,
             i_neighboor        => i_neighboor,
             i_en_update_weight => w_en_update_weight,
             i_sel_weight_mem   => w_sel_weight,
             i_rst              => w_rst,
             i_en_ldiff_vec     => w_en_ldiff_vec,
             i_en_weight_vec    => w_en_weight_vec,
             i_en_first_mem     => w_enable_first_mem,
             i_en_init_mem      => w_initweights_mem,
             o_mapped           => o_mapped);
                
end Behavioral;
