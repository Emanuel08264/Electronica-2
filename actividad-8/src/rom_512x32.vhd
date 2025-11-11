library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity rom_512x32 is
    generic (
        constant INIT_FILE_B0 : string := ""; -- Byte 0 (bits 7-0)
        constant INIT_FILE_B1 : string := ""; -- Byte 1 (bits 15-8)
        constant INIT_FILE_B2 : string := ""; -- Byte 2 (bits 23-16)
        constant INIT_FILE_B3 : string := ""  -- Byte 3 (bits 31-24)
    );
    port (
        clk     : in  std_logic;
        addr    : in  std_logic_vector(8 downto 0); 
        dout    : out std_logic_vector(31 downto 0) 
    );
end entity rom_512x32;

architecture arch of rom_512x32 is

    signal dout_b0 : std_logic_vector(7 downto 0);
    signal dout_b1 : std_logic_vector(7 downto 0);
    signal dout_b2 : std_logic_vector(7 downto 0);
    signal dout_b3 : std_logic_vector(7 downto 0);

begin

    -- Byte 0 (bits 7-0)
    BRAM_B0 : entity ram_512x8
        generic map (
            init_file => INIT_FILE_B0 
        )
        port map (
            clk     => clk,
            addr    => addr,
            we      => '0',         
            din     => (others => '0'), 
            dout    => dout_b0      
        );

    -- Byte 1 (bits 15-8)
    BRAM_B1 : entity ram_512x8
        generic map (
            init_file => INIT_FILE_B1
        )
        port map (
            clk     => clk,
            addr    => addr,
            we      => '0',
            din     => (others => '0'),
            dout    => dout_b1
        );

    -- Byte 2 (bits 23-16)
    BRAM_B2 : entity ram_512x8
        generic map (
            init_file => INIT_FILE_B2
        )
        port map (
            clk     => clk,
            addr    => addr,
            we      => '0',
            din     => (others => '0'),
            dout    => dout_b2
        );

    -- Byte 3 (bits 31-24)
    BRAM_B3 : entity ram_512x8
        generic map (
            init_file => INIT_FILE_B3
        )
        port map (
            clk     => clk,
            addr    => addr,
            we      => '0',
            din     => (others => '0'),
            dout    => dout_b3
        );

    dout <= dout_b3 & dout_b2 & dout_b1 & dout_b0;

end architecture arch;
