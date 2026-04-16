library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DFF_debouncer is
port(Clk_9600Hz, D : in std_logic;
Q : out std_logic);
end DFF_debouncer;

architecture Behavioral of DFF_debouncer is

signal R0, R1 : std_logic := '0';

begin

DFF_and_Edge_detection: process(Clk_9600Hz) 
begin
if(rising_edge(Clk_9600Hz)) then
R0 <= D;
R1 <= R0;
end if;
end process;

Q <= ((not R1) and (R0));

end Behavioral;