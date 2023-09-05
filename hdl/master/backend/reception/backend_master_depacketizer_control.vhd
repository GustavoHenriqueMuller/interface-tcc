library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_master_depacketizer_control is
    port(
        -- AMBA AXI 5 signals.
        ACLK   : in std_logic;
        ARESETn: in std_logic;

        -- Backend signals.
        i_READY_RECEIVE_PACKET: in std_logic;
        o_VALID_RECEIVE_PACKET: out std_logic;
        o_LAST_RECEIVE_DATA   : out std_logic;

        i_FLIT          : in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        o_READ_BUFFER   : out std_logic;
        i_READ_OK_BUFFER: in std_logic;

        -- Headers.
        i_HEADER_1: in std_logic(c_FLIT_WIDTH - 1 downto 0);
        i_HEADER_2: in std_logic(c_FLIT_WIDTH - 1 downto 0);

        o_WRITE_HEADER_1_REG: out std_logic;
        o_WRITE_HEADER_2_REG: out std_logic
    );
end backend_master_depacketizer_control;

architecture arch_backend_master_depacketizer_control of backend_master_depacketizer_control is
    type t_STATE is (S_IDLE, S_HEADER_1, S_HEADER_2, S_REST);
    signal r_CURRENT_STATE: t_STATE;
    signal r_NEXT_STATE: t_STATE;

begin
    ---------------------------------------------------------------------------------------------
    -- Update current state on clock rising edge.
    process (ACLK, ARESETn)
    begin
        if (ARESETn = '0') then
            r_CURRENT_STATE <= S_IDLE;
        elsif (rising_edge(ACLK)) then
            r_CURRENT_STATE <= r_NEXT_STATE;
        end if;
    end process;

    ---------------------------------------------------------------------------------------------
    -- State machine.
    process (ACLK)
    begin
        case r_CURRENT_STATE is
            when S_IDLE => if (i_READ_OK_BUFFER = '1') then
                               r_NEXT_STATE <= S_HEADER_1;
                           else
                               r_NEXT_STATE <= S_IDLE;
                           end if;

            when S_HEADER_1 => if (i_READ_OK_BUFFER = '1') then
                                   r_NEXT_STATE <= S_HEADER_2;
                               else
                                   r_NEXT_STATE <= S_HEADER_1;
                               end if;

            when S_HEADER_2 => if (i_READ_OK_BUFFER = '1') then
                                   if (i_HEADER_2(0) = '0') then
                                       -- Packet is write response.
                                       r_NEXT_STATE <= S_WRITE_RESPONSE;
                                   else
                                       -- Packet is read response.
                                       r_NEXT_STATE <= S_REST;
                                   end;
                               else
                                   r_NEXT_STATE <= S_HEADER_2;
                               end if;

            when S_WRITE_RESPONSE => if (i_READY_RECEIVE_PACKET = '1') then
                                         r_NEXT_STATE <= S_IDLE;
                                     else
                                         r_NEXT_STATE <= S_WRITE_RESPONSE;
                                     end;

            -- @TODO: Por enquanto a FSM assume que sempre tem um flit de payload.
            --when S_READ_RESPONSE => if (i_READ_OK_BUFFER = '1') then
            --                   if (i_FLIT(c_FLIT_WIDTH - 1) = '1') then
            --                       -- Flit is trailer.
            --                       r_NEXT_STATE <= S_IDLE;
            --                   else
            --                       -- Flit is payload.
            --                       r_NEXT_STATE <= S_REST;
            --                   end if;
            --               else
            --                   r_NEXT_STATE <= S_REST;
            --               end if;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values.
	o_READ_BUFFER  <= '1' when (r_CURRENT_STATE = S_IDLE)
                               (r_CURRENT_STATE = S_HEADER_1) or
                               (r_CURRENT_STATE = S_HEADER_2) or
                               (r_CURRENT_STATE = S_WRITE_RESPONSE) else '0';

    o_VALID_RECEIVE_PACKET <= '1' when (r_CURRENT_STATE = S_WRITE_RESPONSE) else '0';
    o_LAST_RECEIVE_DATA <= '0'; -- @TODO

    o_WRITE_HEADER_1_REG <= '1' when (r_CURRENT_STATE = S_HEADER_1) else '0';
    o_WRITE_HEADER_2_REG <= '1' when (r_CURRENT_STATE = S_HEADER_2) else '0';

end arch_backend_master_depacketizer_control;