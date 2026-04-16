library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Main_UART is
Port (Clk_125MHz, rst, start_tx_pb, rx : in std_logic;
tx : out std_logic;
rx_result_led : out std_logic_vector( 7 downto 0)); 

end Main_UART;

architecture Behavioral of Main_UART is

component Clk_div is 
port(Clk_125MHz, rst: in std_logic;
Clk_9600Hz: out std_logic);
end component;

component UART_rx is 
port(Clk_9600Hz,rst,Din : in std_logic;
Dout : out std_logic_vector(7 downto 0):="00000000");
end component;

component UART_tx is 
port(Clk_9600Hz,rst,start_tx : in std_logic;
Data_tx : out std_logic);
end component;

component Edge_detection is 
port(Clk_9600Hz, D : in std_logic;
Q : out std_logic);
end component;

signal start_tx, Clk_9600Hz : std_logic;

begin

subs1_clk_div: Clk_div port map(Clk_125MHz => Clk_125MHz, rst => rst, Clk_9600Hz => Clk_9600Hz);
subs2_UART_rx: UART_rx port map(Clk_9600Hz => Clk_9600Hz, rst => rst, Din => rx, Dout => rx_result_led);
subs3_UART_tx: UART_tx port map(Clk_9600Hz => Clk_9600Hz, rst => rst, start_tx => start_tx, Data_tx => tx);
subs4_start_tx_pb: Edge_detection port map(Clk_9600Hz => Clk_9600Hz, D => start_tx_pb, Q => start_tx);

end Behavioral;
