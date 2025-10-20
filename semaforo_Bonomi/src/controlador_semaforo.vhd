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
    signal est_act, est_sig : std_logic_vector(2 downto 0);

    constant VERDE_A: std_logic_vector(2 downto 0) := "001"; --Direccion A 0(cod. luces)
    constant AMARILLO_A: std_logic_vector(2 downto 0) := "010";
    constant VERDE_B: std_logic_vector(2 downto 0) := "101"; --Direccion B 1(cod. luces)
    constant AMARILLO_B: std_logic_vector(2 downto 0) := "110";

-- CODIGO DE LUCES
    constant ROJO : std_logic_vector(1 downto 0) := "10";
    constant AMARILLO : std_logic_vector(1 downto 0) := "11";
    constant VERDE : std_logic_vector(1 downto 0) := "01";
    constant NEGRO : std_logic_vector(1 downto 0) := "00";

-- SEÑALES DE COMUNICAICION
    signal hab_1Hz      : std_logic; -- Prescaler
    signal timer_done    : std_logic; -- Salida Z del temporizador
    signal timer_preload : std_logic_vector(N_TIMER-1 downto 0); -- Entrada P del temporizador

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

--MAQUINA DE ESTADO FINITO
-- REGISTRO
    memoria_estado_mef: process(clk)
    begin
        if rising_edge(clk) then
            if not nreset then 
                est_act <= VERDE_A;
            else
                est_act <= est_sig;
            end if;   
        end if;
    end process;

--LOGICA ESTADO SIGUIENTE
    les: process(all)
    begin
        est_sig <= est_act;
        if hab_1Hz then
            case est_act is
                when VERDE_A => 
                    if timer_done then
                        est_sig <= AMARILLO_A;
                    end if;
                when AMARILLO_A => 
                    if timer_done then
                        est_sig <= VERDE_B;
                    end if;
                when VERDE_B => 
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
        confirmacion_peaton_a <= '0';
        confirmacion_peaton_b <= '0';
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
            when VERDE_B => 
                transito_a <=  ROJO;
                transito_b <= VERDE;
                timer_preload <= std_logic_vector(to_unsigned(T_VERDE - 1, N_TIMER));
            when AMARILLO_B => 
                transito_a <=  ROJO;
                transito_b <= AMARILLO;
                timer_preload <= std_logic_vector(to_unsigned(T_AMARILLO - 1, N_TIMER));
            when others => 
                null;            
        end case;    
    end process;
end arch ;