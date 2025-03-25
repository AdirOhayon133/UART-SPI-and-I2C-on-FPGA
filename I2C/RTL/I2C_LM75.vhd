library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity I2C_LM75 is
port(clk_125MHz, rst : in std_logic;
scl: out std_logic;
sda: inout std_logic;
led: out std_logic_vector(10 downto 0) );
end I2C_LM75;

architecture Behavioral of I2C_LM75 is

type state is (st_idle, st0_start, st1_Address_w, st2_ack1, st3_pointer,
st4_ack2, st5_delay, st6_restart, st7_Address_r, st8_ack3,
st9_read_msb, st10_ack4_Master, st11_read_lsb, st12_nack_Master, st13_stop);
signal present_state, next_state: state;
signal Data_MSB: std_logic_vector(7 downto 0);
signal Data_LSB: std_logic_vector(7 downto 0);
constant Address_write: std_logic_vector(7 downto 0):=x"92";
constant Address_read: std_logic_vector(7 downto 0):=x"93";
constant Pointer: std_logic_vector(7 downto 0):=x"00";
signal scl_buss, dcl_buss: std_logic:='0';
constant max_length: integer:=8;
signal data_index: integer range 0 to 7;
signal timer: integer range 0 to max_length;
signal count: integer range 0 to 156:=0;
signal clk_400KHz: std_logic:='0';
signal sda_signal, scl_signal : std_logic;
signal rd_data : std_logic;
signal counter_data: integer range 0 to 125000000:=0;

begin

scl <= scl_signal;
sda <= sda_signal;
led(10 downto 3) <= Data_MSB;
led(2 downto 0) <= Data_LSB(7 downto 5);

read_data : process(clk_125MHz)
begin
if (rising_edge(clk_125MHz)) then
if (counter_data < 624999 ) then
rd_data <= '0';
counter_data <= counter_data +1;
elsif (counter_data >= 624999 and counter_data < 631249) then 
rd_data <= '1';
counter_data <= counter_data +1;
elsif (counter_data >= 631249 and counter_data < 124999999) then 
rd_data <= '0';
counter_data <= counter_data +1;
elsif (counter_data = 124999999) then
counter_data <= 0;
end if;
end if;
end process;

clk400KHz: process(clk_125MHz)
begin
if(rst='1') then
clk_400KHz <='0';
count<=0;
elsif(rising_edge(clk_125MHz)) then
if(count=155) then
clk_400KHz<=not clk_400KHz;
count<=0;
else
count<=count + 1;
end if;
end if;
end process;

clk_100KHz: process (clk_400KHz)
variable count_1: integer range 0 to 3:=0;
begin
if(rst='1') then
scl_buss<='1';
dcl_buss<='1';
count_1:=0;
elsif(rising_edge(clk_400KHz)) then
if(count_1=0) then
scl_buss<='0';
elsif(count_1=1) then
dcl_buss<='1';
elsif(count_1=2) then
scl_buss<='1';
else
dcl_buss<='0';
end if;
if(count_1=3) then
count_1:=0;
else
count_1:=count_1 + 1;
end if;
end if;
end process;

Present_state_and_next_state: process(dcl_buss, rst)
begin
if(rst ='1') then
present_state<=st_idle;
data_index<=0;
elsif (dcl_buss 'event and dcl_buss ='1') then
if(data_index=timer-1) then
present_state<=next_state;
data_index<=0;
else
data_index<=data_index +1;
end if; 
end if;
end process;

Registers_in: process(dcl_buss)
begin
if(dcl_buss'event and dcl_buss='0') then 
if (present_state=st9_read_msb) then
Data_MSB(7-data_index) <= sda; 
elsif (present_state=st11_read_lsb) then
Data_LSB(7-data_index) <= sda; 
end if;
end if;
end process;

p3: process(present_state, scl_buss, dcl_buss, rd_data)
begin
case present_state is
when st_idle =>
scl_signal<='1';
sda_signal<='1';
timer<=1;
if (rd_data='1') then
next_state<=st0_start;
else
next_state<=st_idle;
end if;
when st0_start =>
sda_signal<=dcl_buss;
scl_signal<='1'; 
timer<=1;
next_state<=st1_Address_w;
when st1_Address_w =>
sda_signal<=Address_write(7-data_index);
timer<=8;
scl_signal<=scl_buss;
next_state<=st2_ack1;
when st2_ack1 =>
sda_signal<='Z';
scl_signal<=scl_buss;
timer<=1;
next_state<=st3_pointer;
when st3_pointer =>
sda_signal<=pointer(7-data_index);
timer<=8;
scl_signal<=scl_buss;
next_state<=st4_ack2;
when st4_ack2 =>
sda_signal<='Z';
scl_signal<=scl_buss;
timer<=1;
next_state<=st5_delay;
when st5_delay =>
sda_signal<='1';
scl_signal<=scl_buss;
timer<=1;
next_state<=st6_restart;
when st6_restart =>
sda_signal<=dcl_buss; 
scl_signal<='1';
timer<=1;
next_state<=st7_Address_r;
when st7_Address_r =>
sda_signal<=Address_read(7-data_index);
timer<=8;
scl_signal<=scl_buss;
next_state<=st8_ack3;
when st8_ack3 =>
sda_signal<='Z';
scl_signal<=scl_buss;
timer<=1;
next_state<=st9_read_msb;
when st9_read_msb =>
sda_signal<='Z';
scl_signal<=scl_buss;
timer<=8;
next_state<=st10_ack4_Master;
when st10_ack4_Master=>
sda_signal<='0';
scl_signal<=scl_buss;
timer<=1;
next_state<=st11_read_lsb;
when st11_read_lsb=>
sda_signal<='Z';
scl_signal<=scl_buss;
timer<=8;
next_state<=st12_nack_Master;
when st12_nack_Master=>
sda_signal<='1';
scl_signal<=scl_buss;
timer<=1;
next_state<=st13_stop;
when st13_stop=>
sda_signal<=not dcl_buss;
scl_signal<='1';
timer<=1;
next_state<=st_idle;
end case;
end process;

end Behavioral;
