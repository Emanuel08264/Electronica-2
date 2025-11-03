library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity calculadora is
    port (
        numero: in std_logic_vector(3 downto 0);
        sel_a, sel_b, cargar_resultado, sel_out, clk: in std_logic;

        salida_sel : out std_logic_vector(3 downto 0);
        cero : out std_logic 
    );
end calculadora;

architecture arch of calculadora is
    signal a_act, a_sig, b_act, b_sig, resultado: std_logic_vector(3 downto 0);
    signal rise_sel_a, rise_sel_b, rise_cargar_resultado: std_logic;
begin

    --REGISTROS A Y B

    REGISTRO_A: process (clk)
    begin
        if rising_edge(clk) then
            a_act <= a_sig;
        end if;
    end process;
    REGISTRO_B: process (clk)
    begin
        if rising_edge(clk) then
            b_act <= b_sig;
        end if;
    end process;

    --DETECTO FLANCO
    U_RISE_DETECT_A: entity rise_detect
        port map (
            clk => clk,
            sel => sel_a,
            rise_sel => rise_sel_a
        );
    U_RISE_DETECT_B: entity rise_detect
        port map (
            clk => clk,
            sel => sel_b,
            rise_sel => rise_sel_b
        );
    U_RISE_DETECT_RESULTADO: entity rise_detect
        port map (
            clk => clk,
            sel => cargar_resultado,
            rise_sel => rise_cargar_resultado
        );
    LES: process(all)
    begin
    --LOGICA ESTADO SIGUIENTE A
        a_sig <= a_act;
        if rise_cargar_resultado or rise_sel_a then
            if rise_cargar_resultado then
                a_sig <= resultado;
            else
                a_sig <= numero;
            end if;
        end if;
    --LOGICA ESTADO SIGUIENTE B
        b_sig <=  b_act;
        if rise_sel_b then
            b_sig <= numero; 
            else
            b_sig <= b_act;
        end if;
    end process;
    --RESULTADO
    RESULTADO_LOGIC: entity alu
        generic map (
            W => 4
        )
        port map (
            A => a_act,
            B => b_act,
            sel_fn => numero,
            Y => resultado,
            Z => cero
        );

    --LOGICA DE SALIDA
    LS: process(all)
    begin
        if sel_out then
            salida_sel <=  b_act;
        else
            salida_sel <=  a_act;
        end if;
    end process;
end arch ; -- arch