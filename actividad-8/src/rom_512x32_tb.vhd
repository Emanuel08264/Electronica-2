library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.all;

entity rom_512x32_tb is
end rom_512x32_tb;

architecture tb of rom_512x32_tb is
    signal clk     : std_logic;
    signal we      : std_logic;
    signal addr    : std_logic_vector(8 downto 0);
    signal dout    : std_logic_vector(31 downto 0);

    constant periodo :time := 10 ns;
begin
    
    dut : entity rom_512x32 generic map (
       INIT_FILE_B0 => "../src/rom_b0.txt",
       INIT_FILE_B1 => "../src/rom_b1.txt",
       INIT_FILE_B2 => "../src/rom_b2.txt",
       INIT_FILE_B3 => "../src/rom_b3.txt"
    ) port map(
        clk => clk,
        addr => addr,
        dout => dout
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
        addr <= 9x"000";
        wait until rising_edge(clk);
        wait for periodo/4;
        addr <= 9x"008";
        wait for periodo;
        assert dout = x"11223344"
            report "Valor leido distinto al esperado" severity error;
        finish;
    end process;

end tb ; -- tb