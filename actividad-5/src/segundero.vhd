library ieee;
use ieee.std_logic_1164.all;
use work.all;
use ieee.numeric_std.all;

entity segundero is
    generic(
        constant divisor: integer := 12000000
    );
    port(
        nreset: in std_logic;
        clk: in std_logic;
        display: out std_logic_vector(7 downto 0)
    );
end segundero;

architecture arch  of segundero is
    signal preload: std_logic_vector(23 downto 0);
    signal segundo: unsigned(3 downto 0) := (others => '0');
    signal segundo_sig: unsigned(3 downto 0);
    signal hab, limite, reset_cuenta: std_logic;

    begin
    registro: process(clk) begin
        if rising_edge(clk) then
            segundo <= segundo_sig;
        end if;
    end process registro;

    U1: entity prescaler port map(clk =>clk,nreset =>nreset, preload =>preload, tc =>hab);
   
    preload <= std_logic_vector(to_unsigned(divisor-1,24));

    limite <= segundo ?= 9;

    reset_cuenta <= not nreset or (limite and hab);

    segundo_sig <= "0000" when reset_cuenta else
                    segundo + 1 when hab else
                    segundo;
                    
    U2: entity siete_seg port map(
        D => std_logic_vector(segundo),
        Y => display(6 downto 0));
        display(7) <= limite;
    end arch;
