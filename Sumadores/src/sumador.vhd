library ieee;
use ieee.std_logic_1164.all;

entity sumador is
    port(
        A: in std_logic_vector(3 downto 0);
        B: in std_logic_vector(3 downto 0);
        Cin: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Cout: out std_logic 
    );
end sumador;

architecture arch of sumador is
 signal carry : std_logic_vector(4 downto 0);
begin
    carry(0) <= Cin;

    gen_sum: for i in 0 to 3 generate
        begin
            S(i)    <= A(i) xor B(i) xor carry(i);
            carry(i+1) <= (A(i) and B(i)) or (carry(i) and (A(i) xor B(i)));
    end generate;

    Cout <= carry(4);
end;
