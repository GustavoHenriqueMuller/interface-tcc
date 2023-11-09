library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.all;

entity write_response_injector is
    generic(
        data_width_p   : positive
    );
    port(
        clk_i : in std_logic;
        rst_i : in std_logic;
        data_o: out std_logic_vector(data_width_p downto 0);
        val_o : out std_logic;
        ack_i : in  std_logic
    );
end write_response_injector;

architecture arch_write_response_injector of write_response_injector is

    signal current_state : std_logic := '0';
    signal next_state    : std_logic;

    constant id_w: std_logic_vector(4 downto 0) := "00001";
    constant len_w: std_logic_vector(7 downto 0) := "00000000";
    constant burst_w: std_logic_vector(1 downto 0) := "01";
    constant status_w: std_logic_vector(2 downto 0) := "010";
    constant opc_w: std_logic := '0';
    constant type_w: std_logic := '1';

    signal enb_counter_w: std_logic;
    signal state_w: integer range 0 to 3 := 0;
    signal header_dest_w : std_logic_vector(data_width_p downto 0) := "1" & "0000000000000000" & "0000000000000000";
    signal header_src_w : std_logic_vector(data_width_p downto 0)  := "0" & "0000000000000001" & "0000000000000000";
    signal header_interface_w : std_logic_vector(data_width_p downto 0) := "0" & "000000000000" & id_w & len_w & burst_w & status_w & opc_w & type_w;
    signal trailer_w : std_logic_vector(data_width_p downto 0) := "1" & "0000000000000001" & "1000000000101001";
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
        if state_w = 0 then
            data_out_w <= header_dest_w;
        elsif state_w = 1 then
            data_out_w <= header_src_w;
        elsif state_w = 2 then
            data_out_w <= header_interface_w;
        elsif state_w = 3 then
            data_out_w <= trailer_w;
        end if;
  end process;

  process(all)
    begin
    if (rst_i = '1') then
        state_w <= 0;
    elsif (rising_edge(clk_i)) then
        if (enb_counter_w = '1') then
            if (state_w >= 3) then
                state_w <= 0;
            else
                state_w <= state_w + 1;
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

end arch_write_response_injector;