library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity I2C_LM75_TB is
--  Port ( );
end I2C_LM75_TB;

architecture Behavioral of I2C_LM75_TB is

component I2C_LM75 is
port(clk_125MHz, rst : in std_logic;
scl: out std_logic;
sda: inout std_logic;
led: out std_logic_vector(10 downto 0) );
end component;

signal clk_125MHz, rst, scl, sda : std_logic;
signal led : std_logic_vector(10 downto 0);


begin

CH1: I2C_LM75 port map(clk_125MHz => clk_125MHz, rst => rst, scl=> scl,
sda => sda, led=> led);   

rst <='0';

process
begin
clk_125MHz <='0'; wait for 4ns;
clk_125MHz <='1'; wait for 4ns;
end process;



end Behavioral;
