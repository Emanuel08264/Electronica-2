library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.all;

entity calculadora_tb is
end entity;

architecture tb of calculadora_tb is
    constant periodo : time := 10 ns;
    signal numero: std_logic_vector(3 downto 0);
    signal sel_a: std_logic;
    signal sel_b: std_logic;
    signal cargar_resultado: std_logic;
    signal sel_out: std_logic;
    signal clk: std_logic;
    signal salida_sel : std_logic_vector(3 downto 0);
    signal cero : std_logic; 

begin

    dut: entity calculadora port map (
        numero => numero,
        sel_a => sel_a,
        sel_b => sel_b,
        cargar_resultado => cargar_resultado,
        sel_out => sel_out,
        clk => clk,
        salida_sel => salida_sel,
        cero => cero
    );

    reloj : process
    begin
        clk <= '0';
        wait for periodo/2;
        clk <= '1';
        wait for periodo/2;
    end process;

    estimulo : process
    begin
        numero <= "0000";
        sel_a  <= '0';
        sel_b  <= '0';
        cargar_resultado  <= '0';
        sel_out  <= '0';
        wait for 1.75*periodo;
        sel_a <= '1';
        wait for 3*periodo;
        sel_a <= '0';
        sel_b <= '1';
        wait for 3*periodo;
        sel_b <= '0'; 
        wait for 20.75*periodo;
        finish;
    end process;

end architecture;