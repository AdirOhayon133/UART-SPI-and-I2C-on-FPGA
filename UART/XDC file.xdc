## Clock Signal
set_property -dict { PACKAGE_PIN H16    IOSTANDARD LVCMOS33 } [get_ports { Clk_125MHz }]; #IO_L13P_T2_MRCC_35 Sch=SYSCLK
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { Clk_125MHz }];#set

## Switches
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {rst}]
#set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {sws_2bits_tri_i[1]}]

## LEDs
#set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {leds_4bits_tri_o[0]}]
#set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {leds_4bits_tri_o[1]}]
#set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports {leds_4bits_tri_o[2]}]
#set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {leds_4bits_tri_o[3]}]

## RGBLEDs
#set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[0] }]; 
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[1] }]; 
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[2] }]; 
#set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[3] }];
#set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[4] }]; 
#set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { rgbleds_6bits_tri_o[5] }]; 

## Pmoda
## RPi GPIO 7-0 are shared with pmoda_rpi_gpio_tri_io[7:0]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {Dout[6]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {Dout[5]}]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {Din}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {Dout[7]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {Dout[3]}]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {Dout[4]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {Dout[1]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {Dout[2]}]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[2]}]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[3]}]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[6]}]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[7]}]

## Pmodb
#set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[1]}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {Dout[0]}]
#set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[3]}]
#set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[2]}]
#set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[5]}]
#set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[4]}]
#set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[7]}]
#set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[6]}]
#set_property PULLUP true [get_ports {pmodb_gpio_tri_io[2]}]
#set_property PULLUP true [get_ports {pmodb_gpio_tri_io[3]}]
#set_property PULLUP true [get_ports {pmodb_gpio_tri_io[6]}]
#set_property PULLUP true [get_ports {pmodb_gpio_tri_io[7]}]