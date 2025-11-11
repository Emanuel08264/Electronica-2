library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity register_file is
    generic (
        constant init_file : string := ""
    );
    port (
        clk     : in  std_logic;

        we      : in  std_logic;
        addr_w    : in  std_logic_vector(4 downto 0);
        din     : in  std_logic_vector(31 downto 0);

        addr_r_a    : in  std_logic_vector(4 downto 0);
        dout_a    : out std_logic_vector(31 downto 0);

        addr_r_b    : in  std_logic_vector(4 downto 0);
        dout_b    : out std_logic_vector(31 downto 0)
    );
end entity register_file;

architecture behavioral of register_file is
    type register_type is array (31 downto 0) of std_logic_vector(31 downto 0);

    impure function init_register return register_type is 
        file register_file : text;
        variable register_data : register_type := (others => (others => '0'));
        variable line_content : line;
        variable addr_index : integer := 0;
        variable valid : boolean;
        variable status : file_open_status;
    begin
        file_open(status, register_file, init_file, read_mode);
        if status = open_ok then
            while not endfile(register_file) loop
                readline(register_file, line_content);
                hread(line_content, register_data(addr_index), valid);               
                if valid then
                    addr_index := addr_index + 1;
                end if;
            end loop;
        end if;
        return register_data;
    end function init_register;

    signal register_f : register_type := init_register; 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                register_f(to_integer(unsigned(addr_w))) <= din;
            end if;
            dout_a <= register_f(to_integer(unsigned(addr_r_a)));
            dout_b <= register_f(to_integer(unsigned(addr_r_b)));
        end if;
    end process;
end architecture behavioral;