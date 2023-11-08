library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity buffer_fifo is
    generic (
        p_DATA_WIDTH  : positive := 32;
        p_BUFFER_DEPTH: positive := 4
    );
    port (
        ACLK   : in std_logic;
        ARESET : in std_logic;

        -- Read
        i_READ   : in std_logic;
        o_READ_OK: out std_logic;
        o_DATA   : out std_logic_vector(p_DATA_WIDTH - 1 downto 0);

        -- Write.
        i_WRITE   : in std_logic;
        i_DATA    : in std_logic_vector(p_DATA_WIDTH - 1 downto 0);
        o_WRITE_OK: out std_logic
    );
end buffer_fifo;

architecture rtl of buffer_fifo is

  type FIFO_TYPE is array (p_BUFFER_DEPTH - 1 downto 0) of std_logic_vector(p_DATA_WIDTH - 1 downto 0);
  signal w_FIFO   : FIFO_TYPE;
  signal w_READ_PTR : unsigned(integer(ceil(log2(real(p_BUFFER_DEPTH)))) downto 0) := (others => '0');

begin
    process (all)
        variable var_READ_PTR: unsigned(integer(ceil(log2(real(p_BUFFER_DEPTH)))) downto 0);
    begin
        if (ARESET = '1') then
            w_READ_PTR <= (others => '0');
        elsif (rising_edge(ACLK)) then
            var_READ_PTR := w_READ_PTR;

            if (i_WRITE = '1' and var_READ_PTR /= p_BUFFER_DEPTH) then
                w_FIFO(0) <= i_DATA;

                for i in 1 to p_BUFFER_DEPTH - 1 loop
                    w_FIFO(i) <= w_FIFO(i - 1);
                end loop;

                if not (i_READ = '1' and w_READ_PTR /= 0) then
                    var_READ_PTR := var_READ_PTR + 1;
                end if;
            elsif (i_READ = '1' and w_READ_PTR /= 0) then
                var_READ_PTR := var_READ_PTR - 1;
            end if;

          w_READ_PTR <= var_READ_PTR;
        end if;

        if (var_READ_PTR /= 0) then o_READ_OK <= '1'; else o_READ_OK <= '0'; end if;
        if (var_READ_PTR /= p_BUFFER_DEPTH) then o_WRITE_OK <= '1'; else o_WRITE_OK <= '0'; end if;

        if (to_integer(var_READ_PTR) = 0) then
            o_DATA <= w_FIFO(to_integer(var_READ_PTR));
        else
            o_DATA <= w_FIFO(to_integer(var_READ_PTR - 1));
        end if;
    end process;
end rtl;