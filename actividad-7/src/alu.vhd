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

end arch ; -- arch