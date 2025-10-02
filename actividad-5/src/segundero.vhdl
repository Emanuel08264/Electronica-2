library ieee;
use ieee.std_logic_1164.all;

entity segundero is
    port(
        nreset: in std_logic;
        hab: in std_logic;
        clk: in std_logic;
        display: out std_logic_vector(7 downto 0)
    );
end segundero;

architecture arch  of segundero is
    signal limite: std_logic;
    signal segundo: std_logic_vector(7 downto 0);
    signal segundo_sig: std_logic_vector(7 downto 0);
begin
    registro: process(clk) begin
        if rising_edge(clk) then
            segundo <= segundo_sig;
        end if;
    end process registro;

        
end arch;