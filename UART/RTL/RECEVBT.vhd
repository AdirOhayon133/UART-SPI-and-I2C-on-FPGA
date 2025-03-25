library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity RECEVBT is
port(Clk_125MHz,rst,Din : in std_logic;
Dout : out std_logic_vector(7 downto 0):="00000000");
end RECEVBT;

architecture Behavioral of RECEVBT is

signal counter : integer range 0 to 13021 := 0;
signal Clk_9600Hz : std_logic := '0';
type state is (start_stop,Datain);
signal present_state,next_state : state;
signal data_index : integer range 0 to 7:=0;
signal num_of_ret : integer range 0 to 8:=0;

begin

clk_div : process(Clk_125MHz)
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

nxt_state: process(Clk_9600Hz)
begin
if (rising_edge(Clk_9600Hz)) then
if (rst = '1') then
present_state <= start_stop;
elsif (data_index = num_of_ret - 1) then
present_state <= next_state;
data_index <= 0;
else
data_index <= data_index + 1;
end if;
end if;
end process;

p2: process(present_state,data_index,Din)
begin
if (present_state=Datain) then
Dout(data_index) <= Din; 
end if;
end process;



state_machine: process(Din,present_state,data_index) 
begin
case present_state is 
when start_stop =>
num_of_ret <= 1;
if(Din = '1') then
next_state <= start_stop;
else
next_state <= Datain;
end if;
when Datain=>
num_of_ret <= 8;
next_state <= start_stop;
end case;
end process;

end Behavioral;

