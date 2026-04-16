library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Edge_detection is
port(Clk_9600Hz, D : in std_logic;
Q : out std_logic);
end Edge_detection;

architecture Behavioral of Edge_detection is

signal R0, R1 : std_logic := '0';

begin

Edge_detection_2_DFF: process(Clk_9600Hz) 
begin
if(rising_edge(Clk_9600Hz)) then
R0 <= D;
R1 <= R0;
end if;
end process;

Q <= ((not R1) and (R0));

end Behavioral;
