library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.all;

entity rise_detect_tb is
end entity;

architecture tb of rise_detect_tb is
    constant periodo : time := 10 ns;
    signal clk: std_logic;
    signal sel: std_logic;
    signal rise_sel: std_logic;
begin

    dut: entity rise_detect port map (
        clk => clk,
        sel => sel,
        rise_sel => rise_sel
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
        sel <= '0';
        wait for 10.75*periodo;
        sel <= '1';
        wait for 10*periodo;
        sel <= '0';
        wait for periodo;
        finish;
    end process;

end architecture;