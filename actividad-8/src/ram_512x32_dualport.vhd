library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity ram_512x32_dualport is
    generic (
        constant init_file : string := ""
    );
    port (
        clk     : in  std_logic;
        we_b0      : in  std_logic;
        we_b1      : in  std_logic;
        we_b2      : in  std_logic;
        we_b3      : in  std_logic;
        addr_w    : in  std_logic_vector(8 downto 0);
        addr_r    : in  std_logic_vector(8 downto 0);
        din : in std_logic_vector(31 downto 0);
        dout    : out std_logic_vector(31 downto 0)
    );
end entity ram_512x32_dualport;

architecture behavioral of ram_512x32_dualport is
    type ram_type is array (511 downto 0) of std_logic_vector(31 downto 0);

    impure function init_ram return ram_type is 
        file ram_file : text;
        variable ram_data : ram_type := (others => (others => '0'));
        variable line_content : line;
        variable addr_index : integer := 0;
        variable valid : boolean;
        variable status : file_open_status;
    begin
        file_open(status, ram_file, init_file, read_mode);
        if status = open_ok then
            while not endfile(ram_file) loop
                readline(ram_file, line_content);
                hread(line_content, ram_data(addr_index), valid);               
                if valid then
                    addr_index := addr_index + 1;
                end if;
            end loop;
        end if;
        return ram_data;
    end function init_ram;

    signal ram : ram_type := init_ram; 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we_b0 = '1' then
                ram(to_integer(unsigned(addr_w)))(7 downto 0) <= din(7 downto 0);
            end if;
            if we_b1 = '1' then
                ram(to_integer(unsigned(addr_w)))(15 downto 8) <= din(15 downto 8);
            end if;
            if we_b2 = '1' then
                ram(to_integer(unsigned(addr_w)))(23 downto 16) <= din(23 downto 16);
            end if;
            if we_b3 = '1' then
                ram(to_integer(unsigned(addr_w)))(31 downto 24) <= din(31 downto 24);
            end if;
            dout <= ram(to_integer(unsigned(addr_r)));
        end if;
    end process;
end architecture behavioral;