library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Main_UART_TB is
--  Port ( );
end Main_UART_TB;

architecture Behavioral of Main_UART_TB is

component Main_UART is
Port (Clk_125MHz, rst, start_tx_pb, rx : in std_logic;
tx : out std_logic;
rx_result_led : out std_logic_vector( 7 downto 0)); 
end component;

signal Clk_125MHz, rst, start_tx_pb, rx, tx : std_logic;
signal rx_result_led : std_logic_vector( 7 downto 0);

begin

CH1: Main_UART port map(Clk_125MHz => Clk_125MHz, rst => rst, start_tx_pb => start_tx_pb, rx => rx, tx => tx, rx_result_led => rx_result_led);

rst <= '0';

process
begin
Clk_125MHz <= '0' ; wait for 4ns;
Clk_125MHz <= '1' ; wait for 4ns;
end process;

process
begin
rx <= '1' ; wait for 10ms;
rx <= '0' ; wait for 104.17us;
rx <= '1' ; wait for 104.17us;
rx <= '0' ; wait for 104.17us;
rx <= '0' ; wait for 104.17us;
rx <= '0' ; wait for 104.17us;
rx <= '0' ; wait for 104.17us;
rx <= '0' ; wait for 104.17us;
rx <= '1' ; wait for 104.17us;
rx <= '0' ; wait for 104.17us;
rx <= '1' ; wait for 104.17us;
rx <= '1' ; wait for 10ms;
end process;

process
begin
start_tx_pb <= '0' ; wait for 10ms;
start_tx_pb <= '1' ; wait for 200us;
end process;

end Behavioral;
