library ieee;
use ieee.std_logic_1164.all;

entity peaton_fsm is 

    port(
        clk               : in  std_logic;
        nreset            : in  std_logic;
        solicitud_peaton  : in  std_logic; 
        clear_peaton      : in  std_logic; 

        pedido_peaton       : out std_logic;
        confirmacion_peaton : out std_logic 
    );
end entity peaton_fsm; 

architecture arch of peaton_fsm is 

    --ESTADOS PEATON 
    type t_estado_peaton is (PEA_IDLE, PEA_REQUESTED); 
    signal est_actual, est_siguiente : t_estado_peaton; 

begin 

    --MEMORIA PEATON 
    memoria_peaton: process(clk) 
    begin
        if rising_edge(clk) then
            est_actual <= est_siguiente; 
        end if;
    end process;

    --LOGICA PEATON 
    logica_peaton: process(est_actual, solicitud_peaton, clear_peaton, nreset)
    begin
        if not nreset then
            est_siguiente       <= PEA_IDLE; 
            confirmacion_peaton <= '0';
            pedido_peaton       <= '0';
        else
            est_siguiente       <= est_actual;
            confirmacion_peaton <= '0';
            pedido_peaton       <= '0';

            case est_actual is 
                when PEA_IDLE =>
                    pedido_peaton       <= '0';
                    confirmacion_peaton <= '0';
                    if solicitud_peaton then 
                        est_siguiente <= PEA_REQUESTED;
                    end if;

                when PEA_REQUESTED =>
                    pedido_peaton       <= '1';
                    confirmacion_peaton <= '1';
                    if clear_peaton then 
                        est_siguiente <= PEA_IDLE;
                    end if;

                when others =>
                    est_siguiente <= PEA_IDLE; 
            end case;

        end if;
    end process;

end architecture arch; 