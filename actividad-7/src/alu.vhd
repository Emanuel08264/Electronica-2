library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    generic (
        constant W : positive
    );
    port (
        A : in std_logic_vector (W-1 downto 0);
        B : in std_logic_vector (W-1 downto 0);
        sel_fn : in std_logic_vector (3 downto 0);
        Y : out std_logic_vector (W-1 downto 0);
        Z : out std_logic
    );
end alu;

architecture arch of alu is
begin
    process(all)
    begin
        case sel_fn => 
            --SUMA
            when "0000" then 
                Y => std_logic_vector(signed(A)+signed(B));
            --RESTA
            when "0001" then
                Y => std_logic_vector(signed(A)-signed(B));
            --DESPLAZAMIENTO LOGICO A LA IZQUIERDA
            when "001x" then
                Y => 
            --MENOR CON SIGNO 
            when "010x" then 
                Y => std_logic_vector(signed(A) < signed(B));
            --MENOR SIN SIGNO
            when "011x" then
                Y => std_logic_vector(unsigned(A) < unsigned(B));
            --OR EXCLUSIVO BIT A BIT
            when "100x" then
                Y => A xor B;
            --DESPLAZAMIENTO LOGICO A LA DERECHA
            when "1010" then
                Y =>
            --DESPLAZAMIENTO ARITMETICO A LA DERECHA
            when "1011" then
                Y =>
            --OR BIT A BIT
            when "110x" then
                Y => A or B;
            --AND BIT A BIT
            when "111x" then
                Y => A and B;
        end case;
    end process;

    Z <= Y ?= 0;

end arch ; -- arch