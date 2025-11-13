library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.all;

entity ram_512x32_dualport_tb is
end ram_512x32_dualport_tb;

architecture tb of ram_512x32_dualport_tb is
    signal clk     : std_logic;
    signal we_b0      : std_logic;
    signal we_b1      : std_logic;
    signal we_b2      : std_logic;
    signal we_b3      : std_logic;
    signal addr_w    : std_logic_vector(8 downto 0);
    signal addr_r    : std_logic_vector(8 downto 0);
    signal din    : std_logic_vector(31 downto 0);
    signal dout    : std_logic_vector(31 downto 0);

    constant periodo :time := 10 ns;
begin
    
    dut : entity ram_512x32_dualport generic map (
       init_file => "../src/ram_512x32_dualport_contenido.txt"
    ) port map(
        clk => clk,
        we_b0 => we_b0,
        we_b1 => we_b1,
        we_b2 => we_b2,
        we_b3 => we_b3,
        addr_w => addr_w,
        addr_r => addr_r,
        din => din,
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
        addr_r <= 9x"0"; 
        addr_w <= 9x"0";
        we_b0 <= '0';
        we_b1 <= '0';
        we_b2 <= '0';
        we_b3 <= '0';
        wait until rising_edge(clk);
        wait for periodo/4;
        addr_r <= 9x"8";
        wait for periodo;
        assert dout = x"11223344"
            report "Valor leido distinto al esperado" severity error;
        we_b1 <= '1';
        din <= x"ffffffff";
        addr_w <= 9x"8";
        wait until rising_edge(clk);
        wait for periodo/4;
        wait for periodo;
        assert dout = x"1122ff44"
            report "Valor leido distinto al escrito" severity error;
        finish;
    end process;

end tb ; -- tb