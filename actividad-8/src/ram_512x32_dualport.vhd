library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity ram_512x32_dualport is
    generic (
        constant INIT_FILE_B0 : string := "ram_b0.txt"; -- Byte 0 (bits 7-0)
        constant INIT_FILE_B1 : string := "ram_b1.txt"; -- Byte 1 (bits 15-8)
        constant INIT_FILE_B2 : string := "ram_b2.txt"; -- Byte 2 (bits 23-16)
        constant INIT_FILE_B3 : string := "ram_b3.txt"  -- Byte 3 (bits 31-24)
    );
    port (
        clk     : in  std_logic;
        we_mask: in  std_logic_vector(3 downto 0);
        din_b0  : in  std_logic_vector(7 downto 0);
        din_b1  : in  std_logic_vector(7 downto 0);
        din_b2  : in  std_logic_vector(7 downto 0);
        din_b3  : in  std_logic_vector(7 downto 0);
        addr_w    : in  std_logic_vector(8 downto 0); 
        addr_r    : in  std_logic_vector(8 downto 0); 
        dout    : out std_logic_vector(31 downto 0) 
    );
end entity ram_512x32_dualport;

architecture arch of ram_512x32_dualport is

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
            addr_w    => addr_W,
            addr_r    => addr_r,
            we      => we_mask(0),         
            din     => din_b0, 
            dout    => dout_b0      
        );

    -- Byte 1 (bits 15-8)
    BRAM_B1 : entity ram_512x8
        generic map (
            init_file => INIT_FILE_B1
        )
        port map (
            clk     => clk,
            addr_w    => addr_W,
            addr_r    => addr_r,
            we      => we_mask(1),
            din     => din_b1,
            dout    => dout_b1
        );

    -- Byte 2 (bits 23-16)
    BRAM_B2 : entity ram_512x8
        generic map (
            init_file => INIT_FILE_B2
        )
        port map (
            clk     => clk,
            addr_w    => addr_W,
            addr_r    => addr_r,
            we      => we_mask(2),
            din     => din_b2,
            dout    => dout_b2
        );

    -- Byte 3 (bits 31-24)
    BRAM_B3 : entity ram_512x8
        generic map (
            init_file => INIT_FILE_B3
        )
        port map (
            clk     => clk,
            addr_w    => addr_W,
            addr_r    => addr_r,
            we      => we_mask(3),
            din     => din_b3,
            dout    => dout_b3
        );

    dout <= dout_b3 & dout_b2 & dout_b1 & dout_b0;

end architecture arch;
