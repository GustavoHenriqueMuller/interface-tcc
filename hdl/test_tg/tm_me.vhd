library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.all;

entity tm_me is
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
end tm_me;

architecture Behavioral of tm_me is

    -- FSM WIRES
    signal current_state : std_logic;
    signal next_state    : std_logic;
    
    -- ENEABLE WIRES
    signal enb_counter_w : std_logic;
    signal enb_pkg_counter_w : std_logic;
    signal enb_lfsr_w : std_logic;
    signal enb_comp_w : std_logic;
    
    -- COMPARATOR WIRES
    signal header_comp_w : std_logic_vector(data_width_p downto 0);
    signal data_comp_w : std_logic_vector(data_width_p downto 0);
    signal lfsr_pl_w : std_logic_vector(data_width_p-1 downto 0);
    signal error_counter_w : integer range 0 to 255 := 0;
    signal pkg_counter_w : integer range 0 to 255 := 0;
    
    -- FLIT TYPE ID 
    signal id_w : integer range 0 to qnt_flits_p := 0;
    
    constant zero_vector : std_logic_vector((((data_width_p))) downto 0) := (others => '0');
    
begin 

 -- LOAD HEADER VALUE WITH ROUTER POSITION
  header_comp_w <= '1' & std_logic_vector(to_unsigned((x_p), (data_width_p)/2)) & std_logic_vector(to_unsigned((y_p), (data_width_p)/2)); 
 
  lfsr8bits : if data_width_p=8 generate
      process(all)
      begin
        if (rst_i = '1') then
          enb_comp_w <= '0';  
        elsif (rising_edge(clk_i)) then
          -- LOAD SEED WITH THE FIRST PAYLOAD
          if enb_comp_w = '0' and id_w = 1 then
            enb_comp_w <= '1'; 
            lfsr_pl_w <= data_i(data_width_p-1 downto 0);   
          -- LFSR 8 BITS (SEED) 
          elsif enb_comp_w ='1' and enb_lfsr_w ='1' then         
            lfsr_pl_w(0) <= (((lfsr_pl_w(7) XOR lfsr_pl_w(5)) XOR lfsr_pl_w(4)) XOR lfsr_pl_w(3));
            lfsr_pl_w(data_width_p-1 downto 1) <= lfsr_pl_w(data_width_p-2 downto 0);
          end if;
        end if;
      end process;
    end generate;

    lfsr16bits : if data_width_p=16 generate
    process(all)
      begin
        if (rst_i = '1') then
          enb_comp_w <= '0';  
        elsif (rising_edge(clk_i)) then
          -- LOAD SEED WITH THE FIRST PAYLOAD
          if enb_comp_w = '0' and id_w = 1 then
            enb_comp_w <= '1'; 
            lfsr_pl_w <= data_i(data_width_p-1 downto 0);   
          -- LFSR 16 BITS (SEED) 
          elsif enb_comp_w ='1' and enb_lfsr_w ='1' then         
            lfsr_pl_w(0) <= (((lfsr_pl_w(15) XOR lfsr_pl_w(14)) XOR lfsr_pl_w(12)) XOR lfsr_pl_w(3));
            lfsr_pl_w(data_width_p-1 downto 1) <= lfsr_pl_w(data_width_p-2 downto 0);
          end if;
        end if;
      end process;
    end generate;
    
    lfsr32bits : if data_width_p=32 generate
    process(all)
      begin
        if (rst_i = '1') then
          enb_comp_w <= '0';  
        elsif (rising_edge(clk_i)) then
          -- LOAD SEED WITH THE FIRST PAYLOAD
          if enb_comp_w = '0' and id_w = 1 then
            enb_comp_w <= '1'; 
            lfsr_pl_w <= data_i(data_width_p-1 downto 0);   
          -- LFSR 32 BITS (SEED) 
          elsif enb_comp_w ='1' and enb_lfsr_w ='1' then         
            lfsr_pl_w(0) <= (((lfsr_pl_w(31) XOR lfsr_pl_w(21)) XOR lfsr_pl_w(1)) XOR lfsr_pl_w(0));
            lfsr_pl_w(data_width_p-1 downto 1) <= lfsr_pl_w(data_width_p-2 downto 0);
          end if;
        end if;
      end process;
    end generate;
    
    lfsr64bits : if data_width_p=64 generate
      process(all)
      begin
        if (rst_i = '1') then
          enb_comp_w <= '0';  
        elsif (rising_edge(clk_i)) then
          -- LOAD SEED WITH THE FIRST PAYLOAD
          if enb_comp_w = '0' and id_w = 1 then
            enb_comp_w <= '1'; 
            lfsr_pl_w <= data_i(data_width_p-1 downto 0);   
          -- LFSR 64 BITS (SEED) 
          elsif enb_comp_w ='1' and enb_lfsr_w ='1' then         
            lfsr_pl_w(0) <= (((lfsr_pl_w(63) XOR lfsr_pl_w(62)) XOR lfsr_pl_w(60)) XOR lfsr_pl_w(59));
            lfsr_pl_w(data_width_p-1 downto 1) <= lfsr_pl_w(data_width_p-2 downto 0);
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
  
  process (all)
  begin
    -- Carrega o dado esperado no sinal, podendo ser um header, payload e trailer dependendo do id atual
    if enb_comp_w = '1' then  
        if id_w = 0 then
            data_comp_w <= header_comp_w;
        elsif id_w = qnt_flits_p-1 then
            data_comp_w(data_width_p) <= '1';
            data_comp_w(data_width_p-1 downto 0) <= lfsr_pl_w;
        else
            data_comp_w(data_width_p) <= '0';
            data_comp_w(data_width_p-1 downto 0) <= lfsr_pl_w;
        end if;
     else
        data_comp_w <= zero_vector;
     end if;
  end process;
  
  -- Counter para Id, assim sendo possivel saber o tipo do flit esperado, podendo ser um Header, payload ou trailer
  process(all)
    begin
    if(rst_i = '1') then
        id_w <= 0;
    elsif (rising_edge(clk_i) and enb_counter_w = '1') then
        if(id_w >= qnt_flits_p-1) then
            id_w <= 0;
        else
            id_w <= id_w + 1;
        end if;
    end if;
  end process;
  
  -- Compara o dado recebido na porta local com o dado esperado pelo medidor, caso a comparação não seja verdadeira um sinal de erro é levantado
  process (all)
  begin
    if(enb_comp_w = '1' and val_i = '1' and ack_o = '1') then
        if(data_i = data_comp_w) then
            error_o <= '0';
        else
            error_o <= '1';
        end if;
    else 
       error_o <= '0';
    end if;
  end process;
  
-- ERROR COUNTER
process (all)
begin
  if(rst_i = '1') then
      error_counter_w <= 0;
  elsif (rising_edge(clk_i) and error_o = '1') then
      if(error_counter_w >= 255) then
          error_counter_w <= 0;
      else
          error_counter_w <= error_counter_w + 1;
      end if;
  end if; 
end process;

-- PKG COUNTER
process (all)
begin
  if(rst_i = '1') then
      pkg_counter_w <= 0;
  elsif (rising_edge(clk_i) and enb_pkg_counter_w = '1') then
      if(pkg_counter_w >= 255) then
          pkg_counter_w <= 0;
      else
          pkg_counter_w <= pkg_counter_w + 1;
      end if;
  end if; 
end process;
  
  -- Máquina de estados Mealy
  process (all)
  begin
    case current_state is
      when '0' =>
        if (val_i = '1') then
            ack_o <= '0';
            next_state <= '1';
            rdy_o <= '0';
            enb_counter_w <= '0';
            enb_lfsr_w <= '0';
        else
            ack_o <= '0';
            next_state <= '0';
            rdy_o <= '0';
            enb_counter_w <= '0';
            enb_lfsr_w <= '0';
        end if;
        
      when '1' =>
        if (val_i = '0') then
            ack_o <= '1';
            next_state <= '0';
            rdy_o <= '0';
            enb_counter_w <= '1';
            if id_w > 0 then
                enb_lfsr_w <= '1';
            else 
                enb_lfsr_w <= '0';
            end if;
            
            if id_w = 0 then
                enb_pkg_counter_w <= '1';
            else 
                enb_pkg_counter_w <= '0';
            end if;
            
        else
            ack_o <= '1';
            next_state <= '1';
            rdy_o <= '1';
            enb_counter_w <= '0';
            enb_lfsr_w <= '0';

        end if;
      when others =>
        ack_o  <= '0';
        next_state <= '0';
    end case;
  end process;

    error_counter_o <= std_logic_vector(to_unsigned(error_counter_w, 8));
    pkg_counter_o <= std_logic_vector(to_unsigned(pkg_counter_w, 8));
    
end Behavioral;