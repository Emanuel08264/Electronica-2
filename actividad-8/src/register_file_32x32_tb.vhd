library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.all;

entity register_file_32x32_tb is
end register_file_32x32_tb;

architecture tb of register_file_32x32_tb is
    signal clk : std_logic;
    signal we      :  std_logic;
    signal addr_w    :  std_logic_vector(4 downto 0);
    signal din     :  std_logic_vector(31 downto 0);
    signal addr_r_a    :  std_logic_vector(4 downto 0);
    signal dout_a    : std_logic_vector(31 downto 0);
    signal addr_r_b    :  std_logic_vector(4 downto 0);
    signal dout_b    : std_logic_vector(31 downto 0);

    constant periodo :time := 10 ns;
begin
    
    dut : entity register_file_32x32 generic map (
       init_file => "../src/register_file_contenido.txt"
    ) port map(
        clk      => clk,
        we      => we,
        addr_w    => addr_w,
        addr_r_a    => addr_r_a,
        addr_r_b    => addr_r_b,
        din     => din,
        dout_a    => dout_a,
        dout_b    => dout_b
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
        we <= '0';
        addr_w <= 5x"0";
        addr_r_a <= 5x"0";
        addr_r_b <= 5x"0";
        din <= x"00000000";
        wait until rising_edge(clk);
        wait for periodo/4;
        addr_r_a <= 5x"1";
        addr_r_b <= 5x"2";
        wait for periodo;
        assert dout_a = x"4D554E44"
            report "Valor inicial a distinto al esperado" severity error;
        assert dout_b = x"4F205648"
            report "Valor inicial b distinto al esperado" severity error;
        we <= '1';
        addr_w <= 5x"3";
        din <= x"ffffffff";
        wait until rising_edge(clk);
        wait for periodo/4;
        addr_r_a <= 5x"3";
        wait for periodo;
        assert dout_a = x"ffffffff"
            report "Valor inicial a distinto al escrito" severity error;
        finish;
    end process;

end tb ; -- tb