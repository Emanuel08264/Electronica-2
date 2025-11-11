library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.all;

entity top_tb is
end top_tb;

architecture tb of top_tb is
    signal clk     : std_logic;
    signal we      : std_logic;
    signal addr_sel : std_logic;
    signal addr_out : std_logic;
    signal numero    : std_logic_vector(3 downto 0) := (others => '0');
    signal display    : std_logic_vector(7 downto 0);

    constant periodo :time := 10 ns;

begin
    
    U_TOP: entity top
        port map (
            clk     => clk,
            we      => we,
            addr_sel => addr_sel,
            addr_out => addr_out,
            numero    => numero,
            display => display
        );

    reloj : process
    begin
        clk <= '0';
        wait for periodo/2;
        clk <= '1';
        wait for periodo/2;
    end process;

    estimulo_y_evaluacion : process
    begin
        -- Condiciones iniciales
        addr_sel <= '0'; 
        we <= '0';
        addr_out <= '0'; 
        numero <= (others => '0');


        wait until rising_edge(clk); 
        wait for periodo/4; 
        -- Selecciono direccion 1
        numero   <= x"1";   
        addr_sel <= '1';   
        -- Espero un ciclo de reloj para que el rise detect capture el flanco
        wait until rising_edge(clk);        
        wait for periodo/4; 
        addr_sel <= '0'; 
        -- Espero otro ciclo de reloj para que el registro de direcciones capture el valor
        wait until rising_edge(clk);
        -- Espero otro ciclo de reloj para que el valor este disponible en la salida de la RAM       
        wait until rising_edge(clk);
        -- Espero un cuarto de periodo para evaluar la salida
        wait for periodo/4; 
        -- Evaluo que el valor leido sea el esperado (5 en la direccion 1)
        assert display = "01101101"
            report "Valor leido distinto al esperado" severity error;


        -- Escribo un nuevo valor (F) en la direccion 1
        numero <= x"F";
        we <= '1'; 
        -- Espero un ciclo de reloj para que el rise detect capture el flanco
        wait until rising_edge(clk);         
        we <= '0'; 
        -- Espero otro ciclo de reloj para que el valor sea escrito en la RAM
        wait until rising_edge(clk); 
        -- Espero otro ciclo de reloj para que la RAM tenga el valor disponible en la salida
        wait until rising_edge(clk); 
        -- Espero un cuarto de periodo para evaluar la salida
        wait for periodo/4; 
        -- Evaluo que el valor escrito sea el esperado
        assert display = "01110001"
            report "Valor escrito (F) no se pudo leer" severity error;

        -- Ahora pruebo el MAR
        addr_out <= '1';
        -- Espero un ciclo de reloj para que el cambio en addr_out se propague
        wait for periodo; 
        wait for periodo/4;
        -- Evaluo que el valor del MAR sea el esperado (1)
        assert display = "10000110"
            report "Falla al visualizar el MAR" severity error;
        finish;
    end process;

end tb ; -- tb