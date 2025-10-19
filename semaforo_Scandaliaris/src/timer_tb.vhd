library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.all;

entity timer_tb is
end timer_tb;

architecture tb of timer_tb is
    constant period: time := 10 ns;
    signal clk, nreset, done: std_logic;
    signal reload: std_logic_vector(5 downto 0);
begin

    dut: entity timer
        port map (
            reload => reload, -- variable archivo externo => archivo local
            clk => clk,
            nreset => nreset, 
            done => done
        );

    clk_gen: process
    begin
        clk <= '1';
        wait for period/2; 
        clk <= '0';
        wait for period/2;
    end process;         

    --estimulo: process
    --begin
    --    nreset <= '0';
    --    wait until rising_edge(clk);
    --    wait for periodo/4;
    --    nreset <= '1';
    --    wait;
    --end process; 

    evaluacion: process
    begin
        wait until rising_edge(clk);
        wait for period/4;
        nreset <= '0';
        reload <= "001010";
        wait for 3*period;
        nreset <= '0';
        wait for 15*period;
        finish;
    end process;
end tb;