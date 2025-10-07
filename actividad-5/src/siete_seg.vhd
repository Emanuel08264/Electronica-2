library ieee;
use ieee.std_logic_1164.all;

entity siete_seg is
    port(
        segundo: in std_logic_vector(3 downto 0);
        display: out std_logic_vector(6 downto 0)
    );
end siete_seg;

architecture arch  of siete_seg is
begin
    with segundo select display <=

    "0111111" when "0000",
    "0000110" when "0001",
    "1011011" when "0010",
    "1001111" when "0011",
    "1101101" when "0100",
    "0000111" when "0101",
    "1100111" when "0110",
    "1111111" when "0111",
    "1111101" when "1000",
    "1100110" when "1001",
    "-------" when others;

end arch;