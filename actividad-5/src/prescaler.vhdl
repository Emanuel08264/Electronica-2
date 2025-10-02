library ieee;
use ieee.std_logic_1164.all;

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
    signal cuenta: std_logic_vector(7 downto 0);
    signal cuenta_sig: std_logic_vector(7 downto 0);
begin
    registro: process(clk) begin
        if rising_edge(clk) then
            cuenta <= cuenta_sig;
        end if;
    end process registro;

cero <= (cuenta ?= 0);
carga <= (not nreset or cero);

if(carga = '1') then 
cuenta_sig <= (preload - 1) else 
cuenta_sig <= (cuenta - 1)
end if;
        
end arch;

