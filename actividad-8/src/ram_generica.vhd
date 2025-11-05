library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ram is
    generic (
        addr_width : natural := 9;--512x8
        data_width : natural := 8);
    port (
        addr : in std_logic_vector (addr_width - 1 downto 0);
        write_en : in std_logic;
        clk : in std_logic;
        din : in std_logic_vector (data_width - 1 downto 0);
        dout : out std_logic_vector (data_width - 1 downto 0)
        );
end ram;

architecture rtl of ram is
    type mem_type is array ((2** addr_width) - 1 downto 0) of
    std_logic_vector(data_width - 1 downto 0);
    signal ram : ram_type;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if (write_en = '1') then
                ram(to_integer(unsigned(addr))) <= din;
        -- Using write address bus.
            end if;
            dout <= ram(to_integer(unsigned(addr)));
        end if;
    -- Output register controlled by clock.
    end process;
end rtl;