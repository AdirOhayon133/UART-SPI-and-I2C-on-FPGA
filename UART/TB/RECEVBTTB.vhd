library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity RECEVBTTB is
--  Port ( );
end RECEVBTTB;

architecture Behavioral of RECEVBTTB is

component RECEVBT is
port(Clk_125MHz,rst,Din : in std_logic;
Dout : out std_logic_vector(7 downto 0):="00000000");
end component;

signal Clk_125MHz,rst,Din  : std_logic ;
signal Dout  : std_logic_vector ( 7 downto 0) ;

begin

C1: RECEVBT port map (Clk_125MHz=>Clk_125MHz, rst=>rst, Din=>Din, Dout=>Dout);

rst <='0';

process
begin
Clk_125MHz <= '0' ; wait for 4ns;
Clk_125MHz <= '1' ; wait for 4ns;
end process;

process
begin
Din <= '1' ; wait for 10ms;
Din <= '0' ; wait for 104.17us;
Din <= '0' ; wait for 104.17us;
Din <= '0' ; wait for 104.17us;
Din <= '1' ; wait for 104.17us;
Din <= '1' ; wait for 104.17us;
Din <= '1' ; wait for 104.17us;
Din <= '1' ; wait for 104.17us;
Din <= '0' ; wait for 104.17us;
Din <= '0' ; wait for 104.17us;
Din <= '1' ; wait for 104.17us;
Din <= '1' ; wait for 10ms;
end process;

end Behavioral;
