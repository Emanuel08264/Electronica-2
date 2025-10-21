library ieee;
use ieee.std_logic_1164.all;

entity prueba is
    port(
        reset: in std_logic;
        Q: in std_logic_vector(2 downto 0);
        Qsig: out std_logic_vector(2 downto 0)
    );
end prueba;

architecture arch  of prueba is
begin

Qsig(0) <= not reset and not Q(0);
Qsig(1) <= (not reset and  Q(0) and not Q(1)) or (not reset and not Q(0) and Q(1));
Qsig(2) <= (not reset and  not Q(1) and Q(2)) or (not reset and  Q(0) and Q(1) and not Q(2)) or (not reset and  not Q(0) and Q(1) and Q(2)) ;

end arch;