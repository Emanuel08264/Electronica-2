library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.all;
use ieee.numeric_std.all;

entity uno_de_n_tb is
end uno_de_n_tb;

architecture tb of uno_de_n_tb is
    signal A : std_logic_vector(2 downto 0);
    signal Y: std_logic_vector(7 downto 0);
begin
    
    DUT : entity uno_de_n port map (A => A, Y => Y);
    stim : process is
    begin
        for i in 0 to 7 loop
            A <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
        end loop;
    
    finish;   
    end process;
end tb;
