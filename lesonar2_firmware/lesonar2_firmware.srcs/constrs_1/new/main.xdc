## FPGA Configuration I/O Options
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# I/O Pins
set_property -dict {PACKAGE_PIN T14  IOSTANDARD LVCMOS33} [get_ports {mic_clk}];

set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS33} [get_ports {ft_rxf_n}];
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {ft_txe_n}];
set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports {ft_oe_n}];
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS33} [get_ports {ft_rd_n}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {ft_wr_n}];

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {ft_be[0]}];
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports {ft_be[1]}];
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {ft_be[2]}];
set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports {ft_be[3]}];


set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports {emitter_p}];
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports {emitter_n}];

set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN AB1  IOSTANDARD LVCMOS33} [get_ports {ft_data[0]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN AB2  IOSTANDARD LVCMOS33} [get_ports {ft_data[1]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN AA1  IOSTANDARD LVCMOS33} [get_ports {ft_data[2]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN Y1  IOSTANDARD LVCMOS33} [get_ports {ft_data[3]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN Y2  IOSTANDARD LVCMOS33} [get_ports {ft_data[4]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN W1  IOSTANDARD LVCMOS33} [get_ports {ft_data[5]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN W2  IOSTANDARD LVCMOS33} [get_ports {ft_data[6]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN V2  IOSTANDARD LVCMOS33} [get_ports {ft_data[7]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN U1  IOSTANDARD LVCMOS33} [get_ports {ft_data[8]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN U2  IOSTANDARD LVCMOS33} [get_ports {ft_data[9]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN T1  IOSTANDARD LVCMOS33} [get_ports {ft_data[10]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN R1  IOSTANDARD LVCMOS33} [get_ports {ft_data[11]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN R2  IOSTANDARD LVCMOS33} [get_ports {ft_data[12]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN P1  IOSTANDARD LVCMOS33} [get_ports {ft_data[13]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN P2  IOSTANDARD LVCMOS33} [get_ports {ft_data[14]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN N2  IOSTANDARD LVCMOS33} [get_ports {ft_data[15]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN K1  IOSTANDARD LVCMOS33} [get_ports {ft_data[16]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN K2  IOSTANDARD LVCMOS33} [get_ports {ft_data[17]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN J1  IOSTANDARD LVCMOS33} [get_ports {ft_data[18]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN J2  IOSTANDARD LVCMOS33} [get_ports {ft_data[19]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN H2  IOSTANDARD LVCMOS33} [get_ports {ft_data[20]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN G1  IOSTANDARD LVCMOS33} [get_ports {ft_data[21]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN G2  IOSTANDARD LVCMOS33} [get_ports {ft_data[22]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN F1  IOSTANDARD LVCMOS33} [get_ports {ft_data[23]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN E1  IOSTANDARD LVCMOS33} [get_ports {ft_data[24]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN E2  IOSTANDARD LVCMOS33} [get_ports {ft_data[25]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN D1  IOSTANDARD LVCMOS33} [get_ports {ft_data[26]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN D2  IOSTANDARD LVCMOS33} [get_ports {ft_data[27]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN C2  IOSTANDARD LVCMOS33} [get_ports {ft_data[28]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN B1  IOSTANDARD LVCMOS33} [get_ports {ft_data[29]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN B2  IOSTANDARD LVCMOS33} [get_ports {ft_data[30]}];
set_property -dict {SLEW FAST DRIVE 4 PACKAGE_PIN A1  IOSTANDARD LVCMOS33} [get_ports {ft_data[31]}];



set_property -dict {PACKAGE_PIN AA3 IOSTANDARD LVCMOS33} [get_ports {mic_wire[0]}];
set_property -dict {PACKAGE_PIN AB3 IOSTANDARD LVCMOS33} [get_ports {mic_wire[1]}];
set_property -dict {PACKAGE_PIN AA4 IOSTANDARD LVCMOS33} [get_ports {mic_wire[2]}];
set_property -dict {PACKAGE_PIN AA5 IOSTANDARD LVCMOS33} [get_ports {mic_wire[3]}];
set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS33} [get_ports {mic_wire[4]}];
set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS33} [get_ports {mic_wire[5]}];
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS33} [get_ports {mic_wire[6]}];
set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS33} [get_ports {mic_wire[7]}];
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS33} [get_ports {mic_wire[8]}];
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS33} [get_ports {mic_wire[9]}];
set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports {mic_wire[10]}];
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports {mic_wire[11]}];
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports {mic_wire[12]}];
set_property -dict {PACKAGE_PIN Y3 IOSTANDARD LVCMOS33} [get_ports {mic_wire[13]}];
set_property -dict {PACKAGE_PIN Y4 IOSTANDARD LVCMOS33} [get_ports {mic_wire[14]}];
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports {mic_wire[15]}];
set_property -dict {PACKAGE_PIN W9 IOSTANDARD LVCMOS33} [get_ports {mic_wire[16]}];
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS33} [get_ports {mic_wire[17]}];
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports {mic_wire[18]}];
set_property -dict {PACKAGE_PIN Y7 IOSTANDARD LVCMOS33} [get_ports {mic_wire[19]}];
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {mic_wire[20]}];
set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports {mic_wire[21]}];
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {mic_wire[22]}];
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports {mic_wire[23]}];

# FIXME: Les deux micros sont sur le +1V ....
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {mic_wire[24]}];

set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[25]}];
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[26]}];
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[27]}];
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[28]}];
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[29]}];
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[30]}];
set_property -dict {PACKAGE_PIN J6 IOSTANDARD LVCMOS33} [get_ports {mic_wire[31]}];
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {mic_wire[32]}];
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {mic_wire[33]}];
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports {mic_wire[34]}];
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[35]}];
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[36]}];
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[37]}];
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[38]}];
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[39]}];
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[40]}];
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[41]}];
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[42]}];

# FIXME: A corriger!!!!
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[43]}];

set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[44]}];
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[45]}];
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[46]}];
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[47]}];
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[48]}];
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[49]}];
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports {mic_wire[50]}];
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[51]}];
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[52]}];
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[53]}];
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[54]}];
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[55]}];
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[56]}];
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[57]}];
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[58]}];
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {mic_wire[59]}];
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[60]}];
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[61]}];
set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[62]}];
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[63]}];
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[64]}];
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[65]}];
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[66]}];
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[67]}];
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[68]}];
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[69]}];

# FIXME: A corriger dans le routage!!!
# set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS33} [get_ports {mic_wire[70]}];
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[70]}]; #SUR LES FUTURES BOARDS (rev 0.2)
# set_property PULLTYPE PULLUP [get_ports mic_wire[70]]

set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[71]}];
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[72]}];
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[73]}];
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[74]}];
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[75]}];
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[76]}];
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[77]}];
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[78]}];
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[79]}];
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[80]}];
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[81]}];
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[82]}];
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[83]}];
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[84]}];
set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[85]}];
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[86]}];
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[87]}];
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[88]}];
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[89]}];
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[90]}];
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[91]}];
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[92]}];
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[93]}];
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[94]}];
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[95]}];
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[96]}];
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[97]}];
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[98]}];
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[99]}];
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[100]}];
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[101]}];
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[102]}];
set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVCMOS33} [get_ports {mic_wire[103]}];
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[104]}];
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[105]}];
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[106]}];
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[107]}];
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[108]}];
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[109]}];
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[110]}];
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[111]}];
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[112]}];
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[113]}];
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[114]}];
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[115]}];
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[116]}];
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[117]}];
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[118]}];
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[119]}];
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[120]}];
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[121]}];
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[122]}];
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[123]}];
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[124]}];
set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[125]}];
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[126]}];
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[127]}];
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[128]}];
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[129]}];
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[130]}];
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[131]}];
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[132]}];
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[133]}];
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[134]}];
set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVCMOS33} [get_ports {mic_wire[135]}];
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[136]}];
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[137]}];
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[138]}];
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[139]}];
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[140]}];
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[141]}];
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[142]}];
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[143]}];
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[144]}];
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[145]}];
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[146]}];
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS33} [get_ports {mic_wire[147]}];
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[148]}];
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[149]}];
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33} [get_ports {mic_wire[150]}];
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[151]}];
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[152]}];
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[153]}];
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[154]}];
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[155]}];
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[156]}];
set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[157]}];
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[158]}];
set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[159]}];
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[160]}];
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[161]}];
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[162]}];
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[163]}];
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {mic_wire[164]}];
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS33} [get_ports {mic_wire[165]}];
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports {mic_wire[166]}];
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[167]}];
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[168]}];
set_property -dict {PACKAGE_PIN Y12 IOSTANDARD LVCMOS33} [get_ports {mic_wire[169]}];
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[170]}];
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[171]}];
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[172]}];
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {mic_wire[173]}];
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33} [get_ports {mic_wire[174]}];
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports {mic_wire[175]}];
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[176]}];
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33} [get_ports {mic_wire[177]}];
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS33} [get_ports {mic_wire[178]}];
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports {mic_wire[179]}];
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[180]}];
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33} [get_ports {mic_wire[181]}];
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports {mic_wire[182]}];
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33} [get_ports {mic_wire[183]}];
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33} [get_ports {mic_wire[184]}];
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[185]}];
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {mic_wire[186]}];
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[187]}];
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {mic_wire[188]}];
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS33} [get_ports {mic_wire[189]}];


## Board Clock: 100 MHz
set_property -dict {PACKAGE_PIN K4  IOSTANDARD LVCMOS33} [get_ports {ft_clk}];
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports {clk}];
create_clock -name clk -period 33.00 [get_ports {clk}];

create_clock -name ft_clk -period  15.1515  [get_ports ft_clk]

## Declare that these two clocks are asynchronous
set_clock_groups -asynchronous -group {clk} -group {ft_clk}

set_output_delay -clock [get_clocks  "*ft_clk*"] -min -4.5 [get_ports -filter { NAME =~  "*ft_data*"}]
set_output_delay -clock [get_clocks  "*ft_clk*"] -max 1.3 [get_ports -filter { NAME =~  "*ft_data*"}]

set_input_delay -clock ft_clk -min 3.5 [get_ports {ft_rxf_n ft_txe_n}]
set_input_delay -clock ft_clk -max -3.0 [get_ports {ft_rxf_n ft_txe_n}]
