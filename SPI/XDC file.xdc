## Clock Signal
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk_125MHz]
create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clk_125MHz]

## Switches
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports rst]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports tx_enable]

## Pmoda
## RPi GPIO 7-0 are shared with pmoda_rpi_gpio_tri_io[7:0]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports mosi]
#set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {pmoda_rpi_gpio_tri_io[0]}]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports cs]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports sclk]
#set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {pmoda_rpi_gpio_tri_io[5]}]
#set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {pmoda_rpi_gpio_tri_io[4]}]
#set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {pmoda_rpi_gpio_tri_io[7]}]
#set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {pmoda_rpi_gpio_tri_io[6]}]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[2]}]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[3]}]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[6]}]
#set_property PULLUP true [get_ports {pmoda_rpi_gpio_tri_io[7]}]

## Pmodb
#set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[1]}]
#set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {pmodb_gpio_tri_io[0]}]
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



