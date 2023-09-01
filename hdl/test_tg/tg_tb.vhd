library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;
use work.tg_tm_pkg.all;

entity tg_tb is
end tg_tb;

architecture rtl of tg_tb is
    signal t_ACLK  : std_logic := '0';
    signal t_RESET : std_logic := '0';

    signal t_DATA_o: std_logic_vector(c_DATA_WIDTH downto 0);
    signal t_VAL_o : std_logic;
    signal t_ACK_i : std_logic;

        -- Signals between backend and XINA router.
        signal t_l_out_data_o: std_logic_vector(c_DATA_WIDTH downto 0);
        signal t_l_out_val_o : std_logic;
        signal t_l_out_ack_i : std_logic;

        signal t_n_in_data_i : std_logic_vector(c_DATA_WIDTH downto 0);
        signal t_n_in_val_i  : std_logic;
        signal t_n_in_ack_o  : std_logic;
        signal t_n_out_data_o: std_logic_vector(c_DATA_WIDTH downto 0);
        signal t_n_out_val_o : std_logic;
        signal t_n_out_ack_i : std_logic;

        signal t_e_in_data_i : std_logic_vector(c_DATA_WIDTH downto 0);
        signal t_e_in_val_i  : std_logic;
        signal t_e_in_ack_o  : std_logic;
        signal t_e_out_data_o: std_logic_vector(c_DATA_WIDTH downto 0);
        signal t_e_out_val_o : std_logic;
        signal t_e_out_ack_i : std_logic;

        signal t_s_in_data_i : std_logic_vector(c_DATA_WIDTH downto 0);
        signal t_s_in_val_i  : std_logic;
        signal t_s_in_ack_o  : std_logic;
        signal t_s_out_data_o: std_logic_vector(c_DATA_WIDTH downto 0);
        signal t_s_out_val_o : std_logic;
        signal t_s_out_ack_i : std_logic;

        signal t_w_in_data_i : std_logic_vector(c_DATA_WIDTH downto 0);
        signal t_w_in_val_i  : std_logic;
        signal t_w_in_ack_o  : std_logic;
        signal t_w_out_data_o: std_logic_vector(c_DATA_WIDTH downto 0);
        signal t_w_out_val_o : std_logic;
        signal t_w_out_ack_i : std_logic;

begin
    u_TG_MO: entity work.tg_mo
        generic map(
            rows_p => 1,
            cols_p => 1,
            data_width_p => c_DATA_WIDTH,
            qnt_flits_p => 3,
            traffic_mode_p => 0,
            x_p => 3,
            y_p => 3
        )
        port map(
            clk_i => t_ACLK,
            rst_i => t_RESET,
            ack_i => t_ACK_i,
            val_o => t_VAL_o,
            data_o => t_DATA_o
        );

    u_XINA_ROUTER: entity work.router
        port map(
            clk_i => t_ACLK,
            rst_i => t_RESET,

            -- local channel interface
            l_in_data_i  => t_DATA_o,
            l_in_val_i   => t_VAL_o,
            l_in_ack_o   => t_ACK_i,
            l_out_data_o => t_l_out_data_o,
            l_out_val_o  => t_l_out_val_o,
            l_out_ack_i  => t_l_out_ack_i,
            -- north channel interface
            n_in_data_i  => t_n_in_data_i,
            n_in_val_i   => t_n_in_val_i,
            n_in_ack_o   => t_n_in_ack_o,
            n_out_data_o => t_n_out_data_o,
            n_out_val_o  => t_n_out_val_o,
            n_out_ack_i  => t_n_out_ack_i,
            -- east channel interface
            e_in_data_i  => t_e_in_data_i,
            e_in_val_i   => t_e_in_val_i,
            e_in_ack_o   => t_e_in_ack_o,
            e_out_data_o => t_e_out_data_o,
            e_out_val_o  => t_e_out_val_o,
            e_out_ack_i  => t_e_out_ack_i,
            -- south channel interface
            s_in_data_i  => t_s_in_data_i,
            s_in_val_i   => t_s_in_val_i,
            s_in_ack_o   => t_s_in_ack_o,
            s_out_data_o => t_s_out_data_o,
            s_out_val_o  => t_s_out_val_o,
            s_out_ack_i  => t_s_out_ack_i,
            -- west port interface
            w_in_data_i  => t_w_in_data_i,
            w_in_val_i   => t_w_in_val_i,
            w_in_ack_o   => t_w_in_ack_o,
            w_out_data_o => t_w_out_data_o,
            w_out_val_o  => t_w_out_val_o,
            w_out_ack_i  => t_w_out_ack_i
        );

    ---------------------------------------------------------------------------------------------
    -- Clock.
    process
    begin
        wait for 50 ns;
        t_ACLK <= not t_ACLK;
    end process;

    process
    begin
        t_RESET <= '1';
        wait for 50 ns;
        t_RESET <= '0';
        wait;
    end process;
end rtl;