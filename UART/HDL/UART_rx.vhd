library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UART_rx is
port(Clk_9600Hz,rst,Din : in std_logic;
Dout : out std_logic_vector(7 downto 0):="00000000");
end UART_rx;

architecture Behavioral of UART_rx is

type state is (start_stop, st_0, st_1, st_2, st_3, st_4, st_5, st_6, st_7);
signal present_state,next_state : state;

begin

nxt_state: process(Clk_9600Hz)
begin
if (rising_edge(Clk_9600Hz)) then
if (rst = '1') then
present_state <= start_stop;
else 
present_state <= next_state;
end if;
end if;
end process;

state_machine: process(present_state, Din) 
begin
case present_state is 
when start_stop =>
if(Din = '1') then
next_state <= start_stop;
else
next_state <= st_0;
end if;
when st_0=>
Dout(0) <= Din;
next_state <= st_1;
when st_1=>
Dout(1) <= Din;
next_state <= st_2;
when st_2=>
Dout(2) <= Din;
next_state <= st_3;
when st_3=>
Dout(3) <= Din;
next_state <= st_4;
when st_4=>
Dout(4) <= Din;
next_state <= st_5;
when st_5=>
Dout(5) <= Din;
next_state <= st_6;
when st_6=>
Dout(6) <= Din;
next_state <= st_7;
when st_7=>
Dout(7) <= Din;
next_state <= start_stop;
end case;
end process;

end Behavioral;