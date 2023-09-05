library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.all;

entity response_injector is
    generic(
        data_width_p: positive;
        qnt_flits_p : positive
    );
    port(
        clk_i : in std_logic;
        rst_i : in std_logic;
        data_o: out std_logic_vector(data_width_p downto 0);
        val_o : out std_logic;
        ack_i : in  std_logic
    );
end response_injector;

architecture arch_response_injector of response_injector is

    signal current_state : std_logic := '0';
    signal next_state    : std_logic;

    signal x: std_logic_vector(1 downto 0) := "01";
    signal y: std_logic_vector(1 downto 0) := "00";

    signal enb_counter_w: std_logic;
    signal id_w: integer range 0 to qnt_flits_p := 0;
    signal header_w: std_logic_vector(data_width_p downto 0)  := "1" & "0000000000000001" & "0000000000000000";
    signal payload_w: std_logic_vector(data_width_p downto 0) := "0" & "0000000000000000" & "0000000000000000";
    signal trailer_w: std_logic_vector(data_width_p downto 0) := "1" & "0000000000000000" & "0000000000000000";
    signal data_out_w: std_logic_vector(data_width_p downto 0);

begin
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
        elsif id_w < qnt_flits_p - 1 then
            data_out_w <= payload_w;
        else
            data_out_w <= trailer_w;
        end if;
  end process;

  process(all)
    begin
    if(rst_i = '1') then
        id_w <= 0;
    elsif (rising_edge(clk_i)) then
        if(enb_counter_w = '1') then
            if(id_w >= qnt_flits_p - 1) then
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
  data_o <= data_out_w;

end arch_response_injector;