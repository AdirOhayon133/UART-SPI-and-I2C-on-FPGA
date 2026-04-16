library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Clk_div is
port(Clk_125MHz, rst: in std_logic;
Clk_9600Hz: out std_logic);
end Clk_div;

architecture Behavioral of Clk_div is

signal counter : integer range 0 to 13020 := 0;

begin

Diveder : process(Clk_125MHz)
begin
if (rising_edge(Clk_125MHz)) then
if (counter <= 6510) then
Clk_9600Hz <= '0';
counter <= counter +1;
elsif (counter > 6510 and counter < 13020) then 
Clk_9600Hz <= '1';
counter <= counter +1;
elsif (counter = 13020) then 
counter <= 0;
end if;
end if;
end process;

end Behavioral;