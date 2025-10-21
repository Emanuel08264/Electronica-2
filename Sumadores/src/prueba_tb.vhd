library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.all;
use ieee.numeric_std.all;


entity prueba_tb is
end prueba_tb;

architecture tb of prueba_tb is
    signal reset: std_logic := '0';
    signal Q, Qsig : std_logic_vector(2 downto 0);
begin
    
    DUT : entity prueba port map (Q => Q, Qsig => Qsig, reset => reset);

     -- Proceso de estimulación
    stim_proc: process
    begin
        -- Primera fase: reset desactivado (contador normal)
        reset <= '0';
        for i in 0 to 7 loop
            Q <= std_logic_vector(to_unsigned(i, 3));
            wait for 20 ns;
        end loop;

        -- Segunda fase: reset activado (todas las salidas deben ir a cero)
        reset <= '1';
        for i in 0 to 7 loop
            Q <= std_logic_vector(to_unsigned(i, 3));
            wait for 20 ns;
        end loop;

        wait;
    end process;
end;
