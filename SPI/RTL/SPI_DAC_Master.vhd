library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SPI_DAC_Master is
port ( clk_125MHz, rst, tx_enable: in std_logic;
mosi, cs, sclk: out std_logic );
end SPI_DAC_Master;

architecture Behavioral of SPI_DAC_Master is

type state is (st_idle, st0_txmt, st1_txmt);
signal present_state, next_state: state;
constant control: std_logic_vector(3 downto 0):="0011";
constant data: std_logic_vector(11 downto 0):="010000000000";
constant max_length: natural:=12;
signal timer: natural range 0 to max_length;
signal data_index: natural range 0 to max_length;
signal spi_sclk: std_logic:='0';
signal count: integer range 0 to 63 :=0;

begin

sclk <= spi_sclk;


p_cdiv: process(clk_125MHz)
begin
if(rising_edge(clk_125MHz)) then
count<=count + 1;
if(count=62) then
spi_sclk<=not spi_sclk;
count<=0;
end if;
end if;
end process;

p1: process(spi_sclk, rst)
begin
if(rst='1') then
present_state<=st_idle;
data_index<=0;
elsif(rising_edge(spi_sclk)) then
if(data_index=timer-1) then
present_state<=next_state;
data_index<=0;
else
data_index<=data_index +1;
end if; 
end if;
end process;

p2: process(present_state, tx_enable, data_index) 
begin
case present_state is
when st_idle =>
cs<='1';
mosi<='0';
timer<=1;
if(tx_enable ='1') then
next_state<=st0_txmt;
else
next_state<=st_idle;
end if; 
when st0_txmt =>
cs<='0';
timer<=4;
mosi<=control(3-data_index);
next_state<=st1_txmt; 
when st1_txmt =>
cs<='0';
timer<=12;
mosi<=data(11-data_index);
next_state<=st_idle;
end case;
end process;


end Behavioral;
