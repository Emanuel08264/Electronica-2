library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity controlador_semaforo is
    generic (
        constant N_PRE      : integer;
        constant C_PRE      : unsigned(N_PRE-1 downto 0);
        constant N_TIMER    : integer;
        constant T_VERDE    : integer;
        constant T_AMARILLO : integer;
        constant T_PEATON   : integer);
    port (
        clk : in std_logic;
        nreset : in std_logic;
        
        solicitud_peaton_a : in std_logic;
        solicitud_peaton_b : in std_logic;
        solicitud_emergencia_a : in std_logic;
        solicitud_emergencia_b : in std_logic;
        confirmacion_peaton_a : out std_logic;
        confirmacion_peaton_b : out std_logic;
        confirmacion_emergencia_a : out std_logic;
        confirmacion_emergencia_b : out std_logic;

        transito_a : out std_logic_vector (1 downto 0);
        peaton_a : out std_logic;
        transito_b : out std_logic_vector (1 downto 0);
        peaton_b : out std_logic);
end controlador_semaforo;

architecture arch of controlador_semaforo is
--ESTADOS

    type t_estado_transito is(
        VERDE_A,
        AMARILLO_A,
        VERDE_B,
        AMARILLO_B,
        E_PEATON_A,
        E_PEATON_B
    );
    signal est_act, est_sig : t_estado_transito;

-- CODIGO DE LUCES
    constant ROJO : std_logic_vector(1 downto 0) := "10";
    constant AMARILLO : std_logic_vector(1 downto 0) := "11";
    constant VERDE : std_logic_vector(1 downto 0) := "01";
    constant NEGRO : std_logic_vector(1 downto 0) := "00";

-- SEÑALES DE COMUNICAICION
    signal hab_1Hz      : std_logic; -- Prescaler

    signal timer_done    : std_logic; -- Salida Z del temporizador
    signal timer_preload : std_logic_vector(N_TIMER-1 downto 0); -- Entrada P del temporizador

    signal pedido_peaton_a : std_logic;
    signal clear_peaton_a  : std_logic;
    signal pedido_peaton_b : std_logic; 
    signal clear_peaton_b  : std_logic;

begin

--CONEXION MODULOS DE TIEMPO
    U_PRESCALER: entity work.prescaler
    generic map(N => N_PRE) 
    port map(
        clk => clk,
        nreset => nreset,
        preload => std_logic_vector(C_PRE),
        tc => hab_1Hz
    );

    U_TEMPORIZADOR: entity work.temporizador
    generic map(N => N_TIMER)
    port map(
        clk => clk,
        hab => hab_1Hz,
        reset => not nreset,
        P => timer_preload,
        T => timer_done,
        Z => open
    );

-- CONEXION MAQUINA PEATON
    U_PEATON_A: entity work.peaton_fsm
    port map(
            clk          => clk,
            nreset       => nreset,
            solicitud_peaton    => solicitud_peaton_a,  
            clear_peaton        => clear_peaton_a,      
            confirmacion_peaton => confirmacion_peaton_a, 
            pedido_peaton       => pedido_peaton_a
    );
    U_Peaton_B : entity work.peaton_fsm
        port map (
            clk          => clk,
            nreset       => nreset,
            solicitud_peaton    => solicitud_peaton_b,  
            clear_peaton        => clear_peaton_b,      
            confirmacion_peaton => confirmacion_peaton_b, 
            pedido_peaton       => pedido_peaton_b       
        );


--MAQUINA CONTROL SEMAFORO
-- REGISTRO
    memoria_estado_mef: process(clk)
    begin
        if rising_edge(clk) then          
                est_act <= est_sig;
            end if;   
    end process;

--LOGICA ESTADO SIGUIENTE
    les: process(all)
    begin
        if not nreset then
            est_sig <= VERDE_A;
        else
            est_sig <= est_act;
            if hab_1Hz then
                case est_act is
                    when VERDE_A =>
                        if timer_done and pedido_peaton_a then
                            est_sig <= E_PEATON_A;
                        elsif timer_done and not pedido_peaton_a then 
                            est_sig <= AMARILLO_A;
                        end if;

                    when E_PEATON_A =>
                         if timer_done then
                             est_sig <= AMARILLO_A;
                         end if;

                    when AMARILLO_A =>
                        if timer_done then
                            est_sig <= VERDE_B;
                        end if;

                    when VERDE_B =>
                        if timer_done and pedido_peaton_b then
                            est_sig <= E_PEATON_B;
                        elsif timer_done and not pedido_peaton_b then 
                            est_sig <= AMARILLO_B;
                        end if;

                    when E_PEATON_B => 
                         if timer_done then
                            est_sig <= AMARILLO_B;
                         end if;

                    when AMARILLO_B =>
                        if timer_done then
                            est_sig <= VERDE_A;
                        end if;
                    when others =>
                        est_sig <= VERDE_A;
                end case;
            end if; 
        end if; 
    end process;

--LOGICA SALIDA

    ls: process(all)
    begin
    --VALORES POR DEFECTO
        transito_a <= ROJO;
        transito_b <= ROJO;
        timer_preload <= (others => '0'); -- Valor por defecto
        peaton_a   <= '0';
        peaton_b   <= '0';
        clear_peaton_a <= '0';
        clear_peaton_b <= '0';
        confirmacion_emergencia_a <= '0';
        confirmacion_emergencia_b <= '0';
    --CASE
        case est_act is
            when VERDE_A =>
                transito_a <=  VERDE;
                transito_b <= ROJO;
                timer_preload <= std_logic_vector(to_unsigned(T_VERDE - 1, N_TIMER));
            when AMARILLO_A => 
                transito_a <=  AMARILLO;
                transito_b <= ROJO;
                timer_preload <= std_logic_vector(to_unsigned(T_AMARILLO - 1, N_TIMER));
            when E_PEATON_A => 
                transito_a <=  VERDE;
                transito_b <= ROJO;
                timer_preload <= std_logic_vector(to_unsigned(T_PEATON - 1, N_TIMER));
                peaton_a <= '1';
                clear_peaton_a <= '1';         
            when VERDE_B => 
                transito_a <=  ROJO;
                transito_b <= VERDE;
                timer_preload <= std_logic_vector(to_unsigned(T_VERDE - 1, N_TIMER));
            when AMARILLO_B => 
                transito_a <=  ROJO;
                transito_b <= AMARILLO;
                timer_preload <= std_logic_vector(to_unsigned(T_AMARILLO - 1, N_TIMER));
            when E_PEATON_B => 
                transito_a <=  ROJO;
                transito_b <= VERDE;
                timer_preload <= std_logic_vector(to_unsigned(T_PEATON - 1, N_TIMER));
                peaton_b <= '1';
                clear_peaton_b <= '1';
            when others => 
                null;            
        end case;    
    end process;
end arch ;