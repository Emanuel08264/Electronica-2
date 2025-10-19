library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    --generic (TWIDTH: integer := 6);
    port(
        clk, nreset, hab: in std_logic;
        reload: in std_logic_vector(5 downto 0);
        done: out std_logic
    );
end timer;

architecture arch of timer is
    signal est_act, est_sig: unsigned(5 downto 0);

begin

    registro: process(clk)
    begin
        if rising_edge(clk) then
            est_act <= est_sig;
        end if;    
    end process;

    -- Datapath

    done <= '1' when est_act = else
            '0';

    est_sig <=  est_act whan not hab else
                (others => '0') when not nreset else
                unsigned(reload) when est_act = 0 else
                est_act - 1;
end arch;