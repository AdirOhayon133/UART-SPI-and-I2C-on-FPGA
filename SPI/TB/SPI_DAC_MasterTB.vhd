library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SPI_DAC_MasterTB is
--  Port ( );
end SPI_DAC_MasterTB;

architecture Behavioral of SPI_DAC_MasterTB is

component SPI_DAC_Master is
port ( clk_125MHz, rst, tx_enable: in std_logic;
mosi, cs, sclk: out std_logic );
end component;

signal clk_125MHz, rst, tx_enable, mosi, cs, sclk : std_logic;

begin

CH1: SPI_DAC_Master port map(clk_125MHz=>clk_125MHz,rst=>rst,tx_enable=>tx_enable,mosi=>mosi,
cs=>cs,sclk=>sclk);

rst <= '0';

process
begin
clk_125MHz <='0'; wait for 4ns;
clk_125MHz <='1'; wait for 4ns;
end process;

process
begin
tx_enable <='0'; wait for 10ms;
tx_enable <='1'; wait for 3ms;
tx_enable <='0'; wait for 20ms;
end process;


end Behavioral;
