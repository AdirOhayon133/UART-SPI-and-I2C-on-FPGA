library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UART_tx is
port(Clk_9600Hz,rst,start_tx : in std_logic;
Data_tx : out std_logic);
end UART_tx;

architecture Behavioral of UART_tx is

type state is (idle, start_bit, st_0, st_1, st_2, st_3, st_4, st_5, st_6, st_7, stop_bit);
signal present_state,next_state: state := idle;
constant A: std_logic_vector(7 downto 0):=x"41";

begin

nxt_state: process(Clk_9600Hz)
begin
if (rising_edge(Clk_9600Hz)) then
if (rst = '1') then
present_state <= idle;
else 
present_state <= next_state;
end if;
end if;
end process;

state_machine: process(present_state, start_tx) 
begin
case present_state is 
when idle =>
Data_tx <= '1';
if(start_tx = '1') then
next_state <= start_bit;
else
next_state <= idle;
end if;
when start_bit=>
Data_tx <= '0';
next_state <= st_0;
when st_0=>
Data_tx <= A(0);
next_state <= st_1;
when st_1=>
Data_tx <= A(1);
next_state <= st_2;
when st_2=>
Data_tx <= A(2);
next_state <= st_3;
when st_3=>
Data_tx <= A(3);
next_state <= st_4;
when st_4=>
Data_tx <= A(4);
next_state <= st_5;
when st_5=>
Data_tx <= A(5);
next_state <= st_6;
when st_6=>
Data_tx <= A(6);
next_state <= st_7;
when st_7=>
Data_tx <= A(7);
next_state <= stop_bit;
when stop_bit=>
Data_tx <= '1';
if (start_tx = '1') then
next_state <= start_bit;
else
next_state <= idle;
end if;
end case;
end process;

end Behavioral;