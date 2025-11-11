library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rise_detect is
    port (
        clk: in std_logic;
        sel : in std_logic;
        rise_sel: out std_logic
    );
end rise_detect;

architecture arch of rise_detect is
    signal sel_act_1, sel_act_2: std_logic := '0';
begin
--REGISTRO 1
    REGISTRO_1: process (clk)
        begin
            if rising_edge(clk) then
                sel_act_1 <= sel;
            end if;
        end process;
--REGISTRO 2
    REGISTRO_2: process (clk)
        begin
            if rising_edge(clk) then
                sel_act_2 <= sel_act_1;
            end if;
        end process;
--LOGICA SALIDA
    rise_sel <= (sel_act_1 and not sel_act_2);
end arch;