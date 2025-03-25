## Clock Signal
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk_125MHz]
create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clk_125MHz]

## Switches
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports rst]
#set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports rd_data]


## Buttons
#set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {btns_4bits_tri_i[0]}]
#set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {btns_4bits_tri_i[1]}]
#set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {btns_4bits_tri_i[2]}]
#set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {btns_4bits_tri_i[3]}]

## LEDs
#set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {led[10]}]
#set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {led[11]}]
#set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports {led[12]}]
#set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {led[13]}]

## RGBLEDs
#set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[0] }];
#set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {led[14]}]
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[2] }];
#set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[3] }];
#set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {led[15]}]
#set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[5] }];

## Pmoda
## RPi GPIO 7-0 are shared with pmoda_rpi_gpio_tri_io[7:0]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {led[8]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {led[7]}]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {led[10]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {led[9]}]
#set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {pmoda_rpi_gpio_tri_io[5]}]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {led[6]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports sda]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports scl]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[2]}]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[3]}]
set_property PULLUP true [get_ports scl]
set_property PULLUP true [get_ports sda]

## Pmodb
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {led[5]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
#set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[7]}]
#set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[6]}]
#set_property PULLUP true [get_ports {pmodb_gpio_tri_io[2]}]
#set_property PULLUP true [get_ports {pmodb_gpio_tri_io[3]}]
#set_property PULLUP true [get_ports {pmodb_gpio_tri_io[6]}]
#set_property PULLUP true [get_ports {pmodb_gpio_tri_io[7]}]


