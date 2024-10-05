set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports { clk }]
create_clock -add -name sys_clk_pin -period 100.00 -waveform {0 50} [get_ports { clk }]