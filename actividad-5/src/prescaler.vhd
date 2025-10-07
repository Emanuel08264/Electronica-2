library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prescaler is
    port(
        nreset: in std_logic;
        clk: in std_logic;
        preload: in std_logic_vector(23 downto 0);
        tc: out std_logic
    );
end prescaler;

architecture arch  of prescaler is
    signal carga: std_logic;
    signal cero: std_logic;
    signal cuenta: unsigned(23 downto 0);
    signal cuenta_sig: unsigned(23 downto 0);
begin
    registro: process(clk) 
    begin
        if rising_edge(clk) then
            cuenta <= cuenta_sig;
        end if;
    end process registro;

cero <= cuenta ?= 0;
carga <= not nreset or cero;
 
cuenta_sig <= (unsigned(preload)) when carga 
else cuenta - 1;

tc <= cero;
        
end arch;