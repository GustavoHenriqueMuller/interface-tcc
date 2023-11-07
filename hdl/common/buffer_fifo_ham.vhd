library ieee;
use ieee.std_logic_1164.all;

use work.hamming_pkg.all;

entity buffer_fifo_ham is
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
end buffer_fifo_ham;

architecture rtl of buffer_fifo_ham is
    constant c_PARITY_WIDTH: integer := par_width_f(p_DATA_WIDTH);
    signal w_DATA_ENCODE   : std_logic_vector(p_DATA_WIDTH + c_PARITY_WIDTH - 1 downto 0);
    signal w_DATA_DECODE   : std_logic_vector(p_DATA_WIDTH + c_PARITY_WIDTH - 1 downto 0);

begin
    buffer_fifo : entity work.buffer_fifo
        generic map(
            p_DATA_WIDTH   => p_DATA_WIDTH + c_PARITY_WIDTH,
            p_BUFFER_DEPTH => p_BUFFER_DEPTH
        )
        port map(
            ACLK       => ACLK,
            ARESET     => ARESET,
            o_READ_OK  => o_READ_OK,
            i_READ     => i_READ,
            o_DATA     => w_DATA_DECODE,
            o_WRITE_OK => o_WRITE_OK,
            i_WRITE    => i_WRITE,
            i_DATA     => w_DATA_ENCODE
        );

    hamming_enc : entity work.hamming_enc
        generic map(
            width_p => p_DATA_WIDTH
        )
        port map(
            data_i => i_DATA,
            data_o => w_DATA_ENCODE
        );

    hamming_dec : entity work.hamming_dec
        generic map(
            width_p => p_DATA_WIDTH
        )
        port map(
            data_i => w_DATA_DECODE,
            data_o => o_DATA
        );
end rtl;