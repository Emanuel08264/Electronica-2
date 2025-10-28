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
    signal shift_val: integer := to_integer(unsigned(B));
    signal SA: signed(W-1 downto 0) := signed(A);
    signal SB: signed(W-1 downto 0) := signed(B);
    signal UA: unsigned(W-1 downto 0) := unsigned(A);  
    signal UB: unsigned(W-1 downto 0) := unsigned(B);

begin
operaciones: process(all)
    begin 
        case( sel_fn ) is
            --SUMA
            when "0000" =>
                Y <= std_logic_vector(SA+SB);
            --RESTA
            when "0001" =>
                Y <= std_logic_vector(SA-SB);
            --DESPLAZAMIENTO LOGICO IZQ
            when "001-" =>
                Y <=  sll(UA, shift_val);
            --MENOR CON SIGNO 
            when "010-" =>
                Y <= std_logic_vector(to_integer(unsigned(SA<SB)), W);
            --MENOR SIN SIGNO 
            when "011-" =>
                Y <= std_logic_vector(to_integer(unsigned(SA<SB)), W);
            --XOR BIT A BIT
            when "100-" => 
                Y <= A xor B;
            --DESPLAZAMIENTO LOGICO DER
            when "1010" =>
                Y <= shift_right(UA, shift_val);
            --DESPLAZAMIENTO ARITMETICO DER
            when "1011" =>
                Y <= shift_right(SA, shift_val);
            --OR BIT A BIT
            when "110-" =>
                Y <= A or B;
            --AND BIT A BIT
            when "111-" =>
                Y <= A and B;                                      
            when others =>
        
        end case ;
    Z <= Y ?= 0;
end process;
end arch ; -- arch