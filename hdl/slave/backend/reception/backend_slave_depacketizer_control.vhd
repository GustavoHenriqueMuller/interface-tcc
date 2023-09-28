library IEEE;
library work;

use IEEE.std_logic_1164.all;
use work.tcc_package.all;
use work.xina_pkg.all;

entity backend_slave_depacketizer_control is
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
        i_HEADER_INTERFACE: in std_logic_vector(c_FLIT_WIDTH - 1 downto 0);

        o_WRITE_HEADER_SRC_REG: out std_logic;
        o_WRITE_HEADER_INTERFACE_REG: out std_logic;
        o_WRITE_HEADER_ADDRESS_REG  : out std_logic
    );
end backend_slave_depacketizer_control;

architecture arch_backend_slave_depacketizer_control of backend_slave_depacketizer_control is
    type t_STATE is (S_HEADER_DEST, S_HEADER_SRC, S_HEADER_INTERFACE, S_HEADER_ADDRESS,
                     S_WRITE_REQUEST, S_READ_REQUEST_TRAILER, S_READ_REQUEST,
                     S_WAIT_FOR_READY);
    signal r_CURRENT_STATE: t_STATE;
    signal r_NEXT_STATE: t_STATE;

begin
    ---------------------------------------------------------------------------------------------
    -- Update current state on clock rising edge.
    process (all)
    begin
        if (ARESETn = '0') then
            r_CURRENT_STATE <= S_HEADER_DEST;
        elsif (rising_edge(ACLK)) then
            r_CURRENT_STATE <= r_NEXT_STATE;
        end if;
    end process;

    ---------------------------------------------------------------------------------------------
    -- State machine.
    process (all)
    begin
        case r_CURRENT_STATE is
            when S_HEADER_DEST => r_NEXT_STATE <= S_HEADER_SRC when (i_READ_OK_BUFFER = '1') else S_HEADER_DEST;

            when S_HEADER_SRC  => r_NEXT_STATE <= S_HEADER_INTERFACE when (i_READ_OK_BUFFER = '1') else S_HEADER_SRC;

            when S_HEADER_INTERFACE => r_NEXT_STATE <= S_HEADER_ADDRESS when (i_READ_OK_BUFFER = '1') else S_HEADER_INTERFACE;

            when S_HEADER_ADDRESS => if (i_READ_OK_BUFFER = '1') then
                                         if (i_HEADER_INTERFACE(0) = '0') then
                                             -- Write request.
                                             r_NEXT_STATE <= S_WRITE_REQUEST;
                                         else
                                             -- Read request. Next flit is trailer.
                                             r_NEXT_STATE <= S_READ_REQUEST_TRAILER;
                                         end if;
                                     else
                                         r_NEXT_STATE <= S_HEADER_ADDRESS;
                                     end if;

            when S_WRITE_REQUEST => if (i_READY_RECEIVE_PACKET = '1' and i_FLIT(c_FLIT_WIDTH - 1) = '1') then
                                        -- Flit is trailer.
                                        r_NEXT_STATE <= S_HEADER_DEST;
                                    else
                                        r_NEXT_STATE <= S_WRITE_REQUEST;
                                    end if;

            when S_READ_REQUEST_TRAILER => if (i_READ_OK_BUFFER = '1') then
                                               r_NEXT_STATE <= S_READ_REQUEST;
                                           else
                                               r_NEXT_STATE <= S_READ_REQUEST_TRAILER;
                                           end if;

            when S_READ_REQUEST => r_NEXT_STATE   <= S_WAIT_FOR_READY when (i_READY_RECEIVE_PACKET = '1') else S_READ_REQUEST;
            when S_WAIT_FOR_READY => r_NEXT_STATE <= S_HEADER_DEST    when (i_READY_RECEIVE_PACKET = '1') else S_WAIT_FOR_READY;
        end case;
    end process;

    ---------------------------------------------------------------------------------------------
    -- Output values.
	o_READ_BUFFER <= '1' when (r_CURRENT_STATE = S_HEADER_DEST) or
                              (r_CURRENT_STATE = S_HEADER_SRC) or
                              (r_CURRENT_STATE = S_HEADER_INTERFACE) or
                              (r_CURRENT_STATE = S_HEADER_ADDRESS) or
                              (r_CURRENT_STATE = S_READ_REQUEST_TRAILER) or
                              (r_CURRENT_STATE = S_WRITE_REQUEST and i_READY_RECEIVE_DATA = '1')
                              else '0';

    o_VALID_RECEIVE_DATA <= '1' when (r_CURRENT_STATE = S_READ_REQUEST) or
                                     (r_CURRENT_STATE = S_WRITE_REQUEST and i_READ_OK_BUFFER = '1' and i_FLIT(c_FLIT_WIDTH - 1) = '0')
                                     else '0';
    o_LAST_RECEIVE_DATA  <= '0';

    o_WRITE_HEADER_SRC_REG       <= '1' when (r_CURRENT_STATE = S_HEADER_SRC) else '0';
    o_WRITE_HEADER_INTERFACE_REG <= '1' when (r_CURRENT_STATE = S_HEADER_INTERFACE) else '0';
    o_WRITE_HEADER_ADDRESS_REG   <= '1' when (r_CURRENT_STATE = S_HEADER_ADDRESS)  else '0';

end arch_backend_slave_depacketizer_control;