library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity top is
    port (
        clk : in std_logic;
        X: in std_logic_vector(7 downto 0);

        display: out std_logic_vector(7 downto 0)
);
end top;

architecture arch of top is
    signal salida_sel: std_logic_vector(3 downto 0); 
begin

    U_CALCULADORA: entity calculadora
    port map (
        clk => clk,
        numero => X(3 downto 0),
        sel_a => X(4),
        sel_b => X(5),
        cargar_resultado => X(6),
        sel_out => X(7),
        salida_sel => salida_sel,
        cero => display(7)
    );

    U_DISPLAY: entity siete_seg
    port map (
        D  => salida_sel,
        Y => display(6 downto 0)
    );

end arch ; -- arch
