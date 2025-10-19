library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.all;
use ieee.numeric_std.all;

entity siete_segmentos_tb is
end siete_segmentos_tb;

architecture tb of siete_segmentos_tb is
    signal D: std_logic_vector(3 downto 0);
    signal Y: std_logic_vector(6 downto 0);
begin

    DUT : entity siete_segmentos port map (D => D, Y => Y);
    stim : process is
    begin
        for i in 0 to 15 loop
            D <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
        end loop;
    
    finish;   
    end process;
end tb;
