library ieee;
use ieee.std_logic_1164.all;

entity siete_seg is
    port(
        segundo: in std_logic_vector(3 downto 0);
        display: out std_logic_vector(7 downto 0)
    );
end siete_seg;

architecture arch  of siete_seg is
begin
    with segundo select display <=

    "00111111" when "0000",
    "00000110" when "0001",
    "01011011" when "0010",
    "01001111" when "0011",
    "01101101" when "0100",
    "00000111" when "0101",
    "01100111" when "0110",
    "01111111" when "0111",
    "01111101" when "1000",
    "01100110" when "1001",
    "--------" when others;

end arch;