library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;  

entity top is
    port (
        clk     : in  std_logic;
        we   : in  std_logic;
        addr_sel: in  std_logic;
        addr_out: in std_logic;
        numero : in  std_logic_vector(3 downto 0);

        display: out std_logic_vector(7 downto 0)
    );
end entity top;

architecture rtl of top is

    signal ram_addr : std_logic_vector(3 downto 0) := (others => '0');
    signal ram_dout : std_logic_vector(3 downto 0);
    signal rise_we, rise_addr_sel : std_logic := '0';
    signal display_code: std_logic_vector(3 downto 0);


begin
--Rise detect

    U_RISE_WE: entity rise_detect
        port map (
            clk => clk,
            sel => we,
            rise_sel => rise_we
        );
    U_RISE_ADDR_SEL: entity rise_detect
        port map (
            clk => clk,
            sel => addr_sel,
            rise_sel => rise_addr_sel
        );

--Registro direcciones

U_ADD: process(clk)
begin
    if rising_edge(clk) then
        if rise_addr_sel = '1' then
            ram_addr <= numero;
        end if;
    end if;
end process;

-- Memoria RAM 16x4
    U_RAM: entity ram_16x4
        generic map (
            init_file => "../src/ram_16x4_contenido.txt"
        )
        port map (
            clk   => clk,
            we    => rise_we,
            addr  => ram_addr,
            din   => numero,
            dout  => ram_dout
        );

-- Asignacion de salida
process(all)
begin
    if addr_out = '1' then
        display_code <= ram_addr;
    else
        display_code <= ram_dout;
    end if;
end process;

-- Display 7 segmentos
U_DISPLAY: entity siete_seg
    port map (
        D => display_code,
        Y    => display(6 downto 0)
    );
display(7) <= addr_out; 

end architecture rtl;