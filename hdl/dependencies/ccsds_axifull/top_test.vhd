----------------------------------------------------------------------------------
-- Name: Wesley Grignani
-- Laboratory of Embedded and Distributed Systems (LEDS) 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.ccsds123_b2_package.all;


entity top_test is
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
end top_test;

architecture Behavioral of top_test is

-- local sum block
component local_sum is
port ( i_clk       : in  std_logic;
       i_enable    : in  std_logic;
       i_neighboor : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
       o_local_sum : out std_logic_vector(DATA_SIZE-1 downto 0));
end component; 

-- central local difference block
component central_local_diff is
port ( i_clk                : in  std_logic;                      -- clock input
       i_enable             : in  std_logic;                      -- enable input
       i_sample             : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);  -- actual sample
       i_local_sum          : in  std_logic_vector(DATA_SIZE-1 downto 0);  -- output from local_sum
       o_central_local_diff : out std_logic_vector(DATA_SIZE-1 downto 0)); -- output central_local_difference
end component;

-- predicted sample local difference
component predict_central is
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
end component;

component high_resolution is
  port ( i_clk             : in  std_logic;
         i_enable          : in  std_logic;
         i_predict_central : in  std_logic_vector(MAX_SIZE-1 downto 0);
         i_local_sum       : in  std_logic_vector(DATA_SIZE-1 downto 0);
         o_high_res        : out std_logic_vector(MAX_SIZE-1 downto 0));
end component;

component double_res is
  port ( i_clk        : in  std_logic;
         i_enable     : in  std_logic;
         i_t          : in  std_logic_vector(7 downto 0);
         i_sample     : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
         i_neighboor  : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
         i_z          : in  std_logic_vector(2 downto 0);
         i_high_res   : in  std_logic_vector(MAX_SIZE-1 downto 0);
         o_double_res : out std_logic_vector(MAX_SIZE-1 downto 0));
end component;

component quantization is
  port (i_clk             : in  std_logic;
        i_enable          : in  std_logic;
        i_sample          : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
        i_double_res      : in  std_logic_vector(MAX_SIZE-1 downto 0);
        i_t               : in  std_logic_vector(7 downto 0);
        o_quantizer_index : out std_logic_vector(MAX_SIZE-1 downto 0));
end component;

component mapped_residual is
  port (i_clk             : in  std_logic;
        i_enable          : in  std_logic;
        i_double_res      : in  std_logic_vector(MAX_SIZE-1 downto 0);
        i_quantized_index : in  std_logic_vector(MAX_SIZE-1 downto 0);
        o_mapped          : out std_logic_vector(SAMPLE_SIZE-1 downto 0));
end component;

component init_weights is
  port (i_clk              : in  std_logic;
        i_enable           : in  std_logic;
        i_enable_first_mem : in  std_logic; 
        o_weights          : out std_logic_vector(WEIGHT_SIZE-1 downto 0));
end component;

component update_weights is
  port ( i_clk           : in  std_logic;
         i_enable        : in  std_logic;
         i_t             : in  std_logic_vector(7 downto 0);
         i_sample        : in  std_logic_vector(SAMPLE_SIZE-1 downto 0);
         i_double_res    : in  std_logic_vector(MAX_SIZE-1 downto 0);
         i_weight_mem    : in  std_logic_vector(WEIGHT_SIZE-1 downto 0);
         i_localdiff_mem : in  std_logic_vector(DATA_SIZE-1 downto 0);
         o_new_weight    : out std_logic_vector(WEIGHT_SIZE-1 downto 0));
end component;

component mux_weight_mem is
  port (i_weight_from_update : in  std_logic_vector(WEIGHT_SIZE-1 downto 0);
        i_weight_from_init   : in  std_logic_vector(WEIGHT_SIZE-1 downto 0);
        i_sel                : in  std_logic;
        o_weight_out         : out std_logic_vector(WEIGHT_SIZE-1 downto 0));
end component;


-- FF as Memory to store local diff and weights values
component local_diff_reg is
  port ( i_clk       : in  std_logic;
         i_en        : in  std_logic;
         i_ldiff     : in  std_logic_vector(DATA_SIZE-1 downto 0);
         o_ldiff_out : out std_logic_vector(DATA_SIZE-1 downto 0));
end component;

component weights_reg is
  port ( i_clk        : in  std_logic;
         i_en         : in  std_logic;
         i_weight     : in  std_logic_vector(WEIGHT_SIZE-1 downto 0);
         o_weight_out : out std_logic_vector(WEIGHT_SIZE-1 downto 0));
end component;


signal w_local_sum, w_central_diff, w_localdiff_out, w_ldiff_reg0, w_ldiff_reg1, w_ldiff_reg2 : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
signal w_predict_central, w_high_res, w_double_res, w_quantized_index : std_logic_vector(MAX_SIZE-1 downto 0) := (others => '0');
signal w_initweights, w_new_weight, w_weight_mux, w_weights, w_weight_reg0, w_weight_reg1, w_weight_reg2 : std_logic_vector(WEIGHT_SIZE-1 downto 0) := (others => '0');
signal w_control_counter : std_logic_vector(P-1 downto 0) := (others => '0');

begin

  local_sum_block : local_sum
    port map (i_clk       => i_clk,
              i_enable    => i_enable_ls,
              i_neighboor => i_neighboor,
              o_local_sum => w_local_sum);
              
  local_diff_block : central_local_diff
    port map (i_clk                => i_clk,
              i_enable             => i_enable_ldiff,
              i_sample             => i_sample,
              i_local_sum          => w_local_sum,
              o_central_local_diff => w_central_diff);
              
   predict_central_block: predict_central
     port map (i_clk            => i_clk,
               i_enable         => i_enable_central,
               i_rst            => i_rst,
               i_z              => i_z,
               local_diff_mem0  => w_ldiff_reg0,
               local_diff_mem1  => w_ldiff_reg1,
               local_diff_mem2  => w_ldiff_reg2,
               weights_mem0     => w_weight_reg0,
               weights_mem1     => w_weight_reg1,
               weights_mem2     => w_weight_reg2,
               predict_central  => w_predict_central);
               
   high_res_block : high_resolution 
     port map ( i_clk             => i_clk, 
                i_enable          => i_enable_high,
                i_predict_central => w_predict_central,
                i_local_sum       => w_local_sum,
                o_high_res        => w_high_res);
              
   double_res_block : double_res
     port map ( i_clk        => i_clk,   
                i_enable     => i_enable_double,   
                i_t          => i_t,   
                i_sample     => i_sample,
                i_neighboor  => i_neighboor,   
                i_z          => i_z,   
                i_high_res   => w_high_res,
                o_double_res => w_double_res);
                
   quantization_block : quantization 
     port map (i_clk             => i_clk,
               i_enable          => i_enable_qnt,
               i_sample          => i_sample,
               i_double_res      => w_double_res,
               i_t               => i_t,
               o_quantizer_index => w_quantized_index);
               
   u_mapped_res : mapped_residual 
     port map (i_clk             => i_clk,
               i_enable          => i_enable_mapped,
               i_double_res      => w_double_res,
               i_quantized_index => w_quantized_index,
               o_mapped          => o_mapped);
               
               
   u_init_weights : init_weights 
     port map ( i_clk              => i_clk,
                i_enable           => i_en_init_mem,
                i_enable_first_mem => i_en_first_mem,
                o_weights          => w_initweights);          
             
   update_weights_block : update_weights 
     port map ( i_clk           => i_clk,
                i_enable        => i_en_update_weight,
                i_t             => i_t,
                i_sample        => i_sample,
                i_double_res    => w_double_res,
                i_weight_mem    => w_weight_reg0,
                i_localdiff_mem => w_localdiff_out,
                o_new_weight    => w_new_weight);
                
    mux_weight : mux_weight_mem 
      port map (i_weight_from_update => w_new_weight,
                i_weight_from_init   => w_initweights,
                i_sel                => i_sel_weight_mem,
                o_weight_out         => w_weight_mux);
                
    
    -- local difference register for P = 3
    ldiff_reg_0 : local_diff_reg
      port map (i_clk       => i_clk,
                i_en        => i_en_ldiff_vec,
                i_ldiff     => w_central_diff,
                o_ldiff_out => w_ldiff_reg0);
             
    ldiff_reg_1 : local_diff_reg
      port map (i_clk       => i_clk,
                i_en        => i_en_ldiff_vec,
                i_ldiff     => w_ldiff_reg0,
                o_ldiff_out => w_ldiff_reg1);
 
    ldiff_reg_2 : local_diff_reg
      port map (i_clk       => i_clk,
                i_en        => i_en_ldiff_vec,
                i_ldiff     => w_ldiff_reg1,
                o_ldiff_out => w_ldiff_reg2);
                
    weight_reg0 : weights_reg
      port map(i_clk        => i_clk,
               i_en         => i_en_weight_vec,
               i_weight     => w_weight_mux,
               o_weight_out => w_weight_reg0);            

    weight_reg1 : weights_reg
      port map(i_clk        => i_clk,
               i_en         => i_en_weight_vec,
               i_weight     => w_weight_reg0,
               o_weight_out => w_weight_reg1);    
    
    weight_reg2 : weights_reg
      port map(i_clk        => i_clk,
               i_en         => i_en_weight_vec,
               i_weight     => w_weight_reg1,
               o_weight_out => w_weight_reg2);
               
end Behavioral;
