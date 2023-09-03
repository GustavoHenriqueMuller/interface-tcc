library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.all;

entity tg_mo is 
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
end tg_mo;

architecture Behavioral of tg_mo is 
      
    signal enb_counter_w : std_logic;
    signal enb_lfsr_w : std_logic := '0';
    signal current_state : std_logic;
    signal next_state    : std_logic;
    signal id_w : integer range 0 to qnt_flits_p := 0;
    signal header_w : std_logic_vector(data_width_p downto 0);
    signal data_out_w : std_logic_vector(data_width_p downto 0);
    signal seed_pl_w : std_logic_vector(data_width_p-1 downto 0);
    signal lfsr_pl_w : std_logic_vector(data_width_p-1 downto 0);
    signal hd_x_w : std_logic_vector(1 downto 0);
    signal hd_y_w : std_logic_vector(1 downto 0);
    
    constant zero_vector : std_logic_vector((((data_width_p-4)/2)-1) downto 0) := (others => '0');
    
begin       
    hd_x_w <= std_logic_vector(to_unsigned((x_p), 2));
    hd_y_w <= std_logic_vector(to_unsigned((y_p), 2));
    seed_pl_w <= std_logic_vector(to_unsigned((rows_p*((x_p*rows_p)+y_p))+(2**(x_p+data_width_p/4)),data_width_p/2)) & std_logic_vector(to_unsigned((rows_p*((y_p*rows_p)+x_p))+(2**(y_p+data_width_p/4)),data_width_p/2));    
    
    perfectShuffle : if traffic_mode_p=0 generate
      begin
        header_w <=  "1" & zero_vector & hd_x_w(0) & hd_y_w(1) & zero_vector & hd_y_w(0) & hd_x_w(1);
    end generate;
    bitReversal : if traffic_mode_p=1 generate
      begin
        header_w <=  "1" & zero_vector & hd_y_w(0) & hd_y_w(1) & zero_vector & hd_x_w(0) & hd_x_w(1);
    end generate;
    butterfly : if traffic_mode_p=2 generate
      begin
        header_w <=  "1" & zero_vector & hd_y_w(0) & hd_x_w(0) & zero_vector & hd_y_w(1) & hd_x_w(1);
    end generate;
    matrixTranspose : if traffic_mode_p=3 generate
      begin
        header_w <=  "1" & zero_vector & hd_y_w(1) & hd_y_w(0) & zero_vector & hd_x_w(1) & hd_x_w(0);
    end generate;
    complementar : if traffic_mode_p=4 generate
      begin
        header_w <=  "1" & zero_vector & not(hd_x_w(1)) & not(hd_x_w(0)) & zero_vector & not(hd_y_w(1)) & not(hd_y_w(0));
    end generate;
    
    lfsr8bits : if data_width_p=8 generate
      process(all)
      begin
        if (rst_i = '1') then
          lfsr_pl_w(data_width_p-1 downto 0) <= seed_pl_w;   
        elsif (rising_edge(clk_i)) then
          if enb_lfsr_w = '1' then
            lfsr_pl_w(0) <= (((lfsr_pl_w(7) XOR lfsr_pl_w(5)) XOR lfsr_pl_w(4)) XOR lfsr_pl_w(3));
            lfsr_pl_w(data_width_p-1 downto 1) <= lfsr_pl_w(data_width_p-2 downto 0);
          else
            lfsr_pl_w <= lfsr_pl_w;
          end if;
        end if;
      end process;
    end generate;
    
    lfsr16bits : if data_width_p=16 generate
    process(all)
      begin
        if (rst_i = '1') then
          lfsr_pl_w(data_width_p-1 downto 0) <= seed_pl_w;   
        elsif (rising_edge(clk_i)) then
          if enb_lfsr_w = '1' then
            lfsr_pl_w(0) <= (((lfsr_pl_w(15) XOR lfsr_pl_w(14)) XOR lfsr_pl_w(12)) XOR lfsr_pl_w(3));
            lfsr_pl_w(data_width_p-1 downto 1) <= lfsr_pl_w(data_width_p-2 downto 0);
          else
            lfsr_pl_w <= lfsr_pl_w;
          end if;
        end if;
      end process;
    end generate;
      
    lfsr32bits : if data_width_p=32 generate
    process(all)
      begin
        if (rst_i = '1') then
          lfsr_pl_w(data_width_p-1 downto 0) <= seed_pl_w;   
        elsif (rising_edge(clk_i)) then
          if enb_lfsr_w = '1' then
            lfsr_pl_w(0) <= (((lfsr_pl_w(31) XOR lfsr_pl_w(21)) XOR lfsr_pl_w(1)) XOR lfsr_pl_w(0));
            lfsr_pl_w(data_width_p-1 downto 1) <= lfsr_pl_w(data_width_p-2 downto 0);
          else
            lfsr_pl_w <= lfsr_pl_w;
          end if;
        end if;
      end process;
    end generate;
      
    lfsr64bits : if data_width_p=64 generate
      process(all)
      begin
        if (rst_i = '1') then
          lfsr_pl_w(data_width_p-1 downto 0) <= seed_pl_w;   
        elsif (rising_edge(clk_i)) then
          if enb_lfsr_w = '1' then
            lfsr_pl_w(0) <= (((lfsr_pl_w(63) XOR lfsr_pl_w(62)) XOR lfsr_pl_w(60)) XOR lfsr_pl_w(59));
            lfsr_pl_w(data_width_p-1 downto 1) <= lfsr_pl_w(data_width_p-2 downto 0);
          else
            lfsr_pl_w <= lfsr_pl_w;
          end if;
        end if;
      end process;
    end generate;
  
  --FSM  
  process (all)
  begin
    if (rst_i = '1') then
        current_state <= '0';
    elsif (rising_edge(clk_i)) then
        current_state <= next_state;
    end if;
  end process;
  
  process(all)
    begin
        if id_w = 0 then
            data_out_w <= header_w;
        elsif id_w = qnt_flits_p-1 then
            data_out_w(data_width_p) <= '1';
            data_out_w(data_width_p-1 downto 0) <= lfsr_pl_w;
        else
            data_out_w(data_width_p) <= '0';
            data_out_w(data_width_p-1 downto 0) <= lfsr_pl_w;
        end if;
  end process;
  
  process(all)
    begin
    if(rst_i = '1') then
        id_w <= 0;
    elsif (rising_edge(clk_i)) then
        if(enb_counter_w = '1') then
            if(id_w >= qnt_flits_p-1) then
                id_w <= 0;
            else
                id_w <= id_w + 1;
            end if;
        end if;
    end if;
  end process;
  
  process (all)
  begin
    case current_state is
      when '0' =>
        if (ack_i = '1') then
          next_state <= '1';
        else
          next_state <= '0';
        end if;
      when '1' =>
        if (ack_i = '0') then
          next_state <= '0';
        else
          next_state <= '1';
        end if;
     when others => next_state <= '0';
    end case;
  end process;

  val_o  <= '1' when (current_state = '0') else '0';
  enb_counter_w <= '1' when (current_state = '1' and ack_i = '1') else '0';
  enb_lfsr_w <= '1' when (current_state = '1' and ack_i = '1' and id_w > 0) else '0';
  data_o <= data_out_w;
  
end Behavioral;