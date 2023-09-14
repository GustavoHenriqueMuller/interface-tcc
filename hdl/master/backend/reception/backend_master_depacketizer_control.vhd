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
        i_READY_RECEIVE_DATA  : in std_logic;
        o_VALID_RECEIVE_DATA  : out std_logic;
        o_LAST_RECEIVE_DATA   : out std_logic;

        -- Buffer.
        i_FLIT          : in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);
        o_READ_BUFFER   : out std_logic;
        i_READ_OK_BUFFER: in std_logic;

        -- Headers.
        o_WRITE_HEADER_1_REG: out std_logic;
        o_WRITE_HEADER_2_REG: out std_logic
    );
end backend_master_depacketizer_control;

architecture arch_backend_master_depacketizer_control of backend_master_depacketizer_control is
    type t_STATE is (S_HEADER_1, S_HEADER_2,
                     S_WRITE_RESPONSE_TRAILER, S_WRITE_RESPONSE,
                     S_READ_RESPONSE);
    signal r_CURRENT_STATE: t_STATE;
    signal r_NEXT_STATE: t_STATE;

begin
    ---------------------------------------------------------------------------------------------
    -- Update current state on clock rising edge.
    process (all)
    begin
        if (ARESETn = '0') then
            r_CURRENT_STATE <= S_HEADER_1;
        elsif (rising_edge(ACLK)) then
            r_CURRENT_STATE <= r_NEXT_STATE;
        end if;
    end process;

    ---------------------------------------------------------------------------------------------
    -- State machine.
    process (all)
    begin
        case r_CURRENT_STATE is
            when S_HEADER_1 => r_NEXT_STATE <= S_HEADER_2 when (i_READ_OK_BUFFER = '1') else S_HEADER_1;

            when S_HEADER_2 => if (i_READ_OK_BUFFER = '1') then
                                   if (i_FLIT(0) = '0') then
                                       -- Write response. Next flit is trailer.
                                       r_NEXT_STATE <= S_WRITE_RESPONSE_TRAILER;
                                   else
                                       -- Read response.
                                       r_NEXT_STATE <= S_READ_RESPONSE;
                                   end if;
                               else
                                   r_NEXT_STATE <= S_HEADER_2;
                               end if;

            when S_WRITE_RESPONSE_TRAILER => r_NEXT_STATE <= S_WRITE_RESPONSE when (i_READ_OK_BUFFER = '1') else S_WRITE_RESPONSE_TRAILER;

            when S_WRITE_RESPONSE => r_NEXT_STATE <= S_HEADER_1 when (i_READY_RECEIVE_PACKET = '1') else S_WRITE_RESPONSE;

            when S_READ_RESPONSE => if (i_READ_OK_BUFFER = '1' and i_FLIT(c_FLIT_WIDTH - 1) = '1') then
                                        -- Flit is trailer.
                                        r_NEXT_STATE <= S_HEADER_1;
                                    else
                                        r_NEXT_STATE <= S_READ_RESPONSE;
                                    end if;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values.
	o_READ_BUFFER <= '1' when (r_CURRENT_STATE = S_HEADER_1) or
                              (r_CURRENT_STATE = S_HEADER_2) or
                              (r_CURRENT_STATE = S_WRITE_RESPONSE_TRAILER) or
                              (r_CURRENT_STATE = S_READ_RESPONSE and i_READY_RECEIVE_DATA = '1')
                              else '0';

    o_VALID_RECEIVE_DATA <= '1' when (r_CURRENT_STATE = S_WRITE_RESPONSE) or
                                     (r_CURRENT_STATE = S_READ_RESPONSE and i_READ_OK_BUFFER = '1' and i_FLIT(c_FLIT_WIDTH - 1) = '0')
                                     else '0';
    o_LAST_RECEIVE_DATA  <= '0'; -- @TODO.

    o_WRITE_HEADER_1_REG <= '1' when (r_CURRENT_STATE = S_HEADER_1) else '0';
    o_WRITE_HEADER_2_REG <= '1' when (r_CURRENT_STATE = S_HEADER_2) else '0';

end arch_backend_master_depacketizer_control;