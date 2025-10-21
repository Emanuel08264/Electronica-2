library ieee;
use ieee.std_logic_1164.all;

entity emergencia_fsm is 

    port(
        clk               : in  std_logic;
        nreset            : in  std_logic;
        solicitud_emergencia  : in  std_logic; 
        clear_emergencia      : in  std_logic; 

        pedido_emergencia       : out std_logic;
        confirmacion_emergencia : out std_logic 
    );
end entity emergencia_fsm; 

architecture arch of emergencia_fsm is 

    --ESTADOS EMERGENCIA 
    type t_estado_emergencia is (EM_IDLE, EM_REQUESTED); 
    signal est_actual, est_siguiente : t_estado_emergencia; 

begin 

    --MEMORIA EMERGENCIA 
    memoria_emergencia: process(clk) 
    begin
        if rising_edge(clk) then
            est_actual <= est_siguiente; 
        end if;
    end process;

    --LOGICA EMERGENCIA 
    logica_emergencia: process(est_actual, solicitud_emergencia, clear_emergencia, nreset)
    begin
        if not nreset then
            est_siguiente       <= EM_IDLE; 
            confirmacion_emergencia <= '0';
            pedido_emergencia       <= '0';
        else
            est_siguiente       <= est_actual;
            confirmacion_emergencia <= '0';
            pedido_emergencia       <= '0';

            case est_actual is 
                when EM_IDLE =>
                    pedido_emergencia       <= '0';
                    confirmacion_emergencia <= '0';
                    if solicitud_emergencia then 
                        est_siguiente <= EM_REQUESTED;
                    end if;

                when EM_REQUESTED =>
                    pedido_emergencia       <= '1';
                    confirmacion_emergencia <= '1';
                    if clear_emergencia and not solicitud_emergencia then 
                        est_siguiente <= EM_IDLE;
                    end if;

                when others =>
                    est_siguiente <= EM_IDLE; 
            end case;

        end if;
    end process;

end architecture arch; 