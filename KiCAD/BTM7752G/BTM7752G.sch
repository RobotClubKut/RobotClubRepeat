EESchema Schematic File Version 2
LIBS:74xgxx
LIBS:74xx
LIBS:ac-dc
LIBS:actel
LIBS:adc-dac
LIBS:Altera
LIBS:analog_devices
LIBS:analog_switches
LIBS:atmel
LIBS:audio
LIBS:brooktre
LIBS:cmos_ieee
LIBS:cmos4000
LIBS:conn
LIBS:contrib
LIBS:cypress
LIBS:dc-dc
LIBS:device
LIBS:digital-audio
LIBS:diode
LIBS:display
LIBS:dsp
LIBS:elec-unifil
LIBS:ESD_Protection
LIBS:ftdi
LIBS:gennum
LIBS:graphic
LIBS:hc11
LIBS:intel
LIBS:interface
LIBS:ir
LIBS:Lattice
LIBS:linear
LIBS:logo
LIBS:maxim
LIBS:memory
LIBS:microchip
LIBS:microchip_dspic33dsc
LIBS:microchip_pic10mcu
LIBS:microchip_pic12mcu
LIBS:microchip_pic16mcu
LIBS:microchip_pic18mcu
LIBS:microchip_pic32mcu
LIBS:microcontrollers
LIBS:motor_drivers
LIBS:motorola
LIBS:msp430
LIBS:nordicsemi
LIBS:nxp_armmcu
LIBS:onsemi
LIBS:opto
LIBS:Oscillators
LIBS:philips
LIBS:power
LIBS:Power_Management
LIBS:powerint
LIBS:pspice
LIBS:references
LIBS:regul
LIBS:relays
LIBS:rfcom
LIBS:sensors
LIBS:silabs
LIBS:siliconi
LIBS:stm8
LIBS:stm32
LIBS:supertex
LIBS:switches
LIBS:texas
LIBS:transf
LIBS:transistors
LIBS:ttl_ieee
LIBS:valves
LIBS:video
LIBS:Xicor
LIBS:xilinx
LIBS:Zilog
LIBS:user_communication
LIBS:user_conn
LIBS:user_conn_KRP
LIBS:user_IC
LIBS:user_Passive
LIBS:user_regul
LIBS:user_sensor
LIBS:user_special
LIBS:user_SW
LIBS:user_μC
LIBS:user_drill
LIBS:RoboKUT_communication
LIBS:RoboKUT_conn
LIBS:RoboKUT_conn_KRP
LIBS:RoboKUT_IC
LIBS:RoboKUT_Passive
LIBS:RoboKUT_regul
LIBS:RoboKUT_sensor
LIBS:RoboKUT_special
LIBS:RoboKUT_SW
LIBS:RoboKUT_uC
LIBS:BTM7752G-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L TA48M05F U1
U 1 1 55BA4CAC
P 1400 1950
F 0 "U1" H 1500 1750 60  0000 C CNN
F 1 "TA48M05F" H 1400 2100 60  0000 C CNN
F 2 "user_IC:HSOP3-P-2" H 1400 1950 60  0001 C CNN
F 3 "" H 1400 1950 60  0000 C CNN
	1    1400 1950
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 55BA4CDF
P 2000 2100
F 0 "C2" H 2025 2200 50  0000 L CNN
F 1 "33u" H 2025 2000 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Radial_D5_L6_P2.5" H 2038 1950 30  0001 C CNN
F 3 "" H 2000 2100 60  0000 C CNN
	1    2000 2100
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 55BA4DF2
P 800 2100
F 0 "C1" H 825 2200 50  0000 L CNN
F 1 "0.33u" H 825 2000 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 838 1950 30  0001 C CNN
F 3 "" H 800 2100 60  0000 C CNN
	1    800  2100
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 55BA4EBD
P 2400 2150
F 0 "D1" H 2400 2250 50  0000 C CNN
F 1 "LED" H 2400 2050 50  0000 C CNN
F 2 "LEDs:LED-3MM" H 2400 2150 60  0001 C CNN
F 3 "" H 2400 2150 60  0000 C CNN
	1    2400 2150
	0    -1   -1   0   
$EndComp
$Comp
L R R1
U 1 1 55BA4F35
P 2400 2550
F 0 "R1" V 2480 2550 50  0000 C CNN
F 1 "1k" V 2400 2550 50  0000 C CNN
F 2 "Resistors_SMD:R_0603" V 2330 2550 30  0001 C CNN
F 3 "" H 2400 2550 30  0000 C CNN
	1    2400 2550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR01
U 1 1 55BA4FBE
P 2400 2800
F 0 "#PWR01" H 2400 2550 50  0001 C CNN
F 1 "GND" H 2400 2650 50  0000 C CNN
F 2 "" H 2400 2800 60  0000 C CNN
F 3 "" H 2400 2800 60  0000 C CNN
	1    2400 2800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 55BA516A
P 2000 2800
F 0 "#PWR02" H 2000 2550 50  0001 C CNN
F 1 "GND" H 2000 2650 50  0000 C CNN
F 2 "" H 2000 2800 60  0000 C CNN
F 3 "" H 2000 2800 60  0000 C CNN
	1    2000 2800
	1    0    0    -1  
$EndComp
$Comp
L BTM7752G U2
U 1 1 55BA57CF
P 6700 2500
F 0 "U2" H 6700 2400 60  0000 C CNN
F 1 "BTM7752G" H 6700 2500 60  0000 C CNN
F 2 "user_IC:PG-DSO-36" H 6700 2500 60  0001 C CNN
F 3 "" H 6700 2500 60  0000 C CNN
	1    6700 2500
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 55BA6146
P 7550 2800
F 0 "R2" V 7630 2800 50  0000 C CNN
F 1 "1k" V 7550 2800 50  0000 C CNN
F 2 "Resistors_SMD:R_0603" V 7480 2800 30  0001 C CNN
F 3 "" H 7550 2800 30  0000 C CNN
	1    7550 2800
	1    0    0    -1  
$EndComp
Text GLabel 7750 2450 2    60   Input ~ 0
IS1
Text GLabel 7850 2600 2    60   Input ~ 0
INH1
$Comp
L GND #PWR03
U 1 1 55BA6440
P 7550 3000
F 0 "#PWR03" H 7550 2750 50  0001 C CNN
F 1 "GND" H 7550 2850 50  0000 C CNN
F 2 "" H 7550 3000 60  0000 C CNN
F 3 "" H 7550 3000 60  0000 C CNN
	1    7550 3000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 55BA671C
P 5750 3000
F 0 "#PWR04" H 5750 2750 50  0001 C CNN
F 1 "GND" H 5750 2850 50  0000 C CNN
F 2 "" H 5750 3000 60  0000 C CNN
F 3 "" H 5750 3000 60  0000 C CNN
	1    5750 3000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR05
U 1 1 55BA6895
P 7350 3000
F 0 "#PWR05" H 7350 2750 50  0001 C CNN
F 1 "GND" H 7350 2850 50  0000 C CNN
F 2 "" H 7350 3000 60  0000 C CNN
F 3 "" H 7350 3000 60  0000 C CNN
	1    7350 3000
	1    0    0    -1  
$EndComp
Text GLabel 5050 2400 0    60   Input ~ 0
IN1_1
Text GLabel 5050 2500 0    60   Input ~ 0
IN1_2
$Comp
L +5V #PWR06
U 1 1 55BB1E10
P 2600 1950
F 0 "#PWR06" H 2600 1800 50  0001 C CNN
F 1 "+5V" H 2600 2090 50  0000 C CNN
F 2 "" H 2600 1950 60  0000 C CNN
F 3 "" H 2600 1950 60  0000 C CNN
	1    2600 1950
	1    0    0    -1  
$EndComp
$Comp
L CONN_4_KRP P1
U 1 1 55BB5C0B
P 4250 1200
F 0 "P1" H 4300 750 60  0000 C CNN
F 1 "CONN_4_KRP" H 4300 850 60  0000 C CNN
F 2 "user_conn:DF1E-4P_Streight" H 4250 1200 60  0001 C CNN
F 3 "" H 4250 1200 60  0000 C CNN
	1    4250 1200
	1    0    0    -1  
$EndComp
$Comp
L +9V #PWR07
U 1 1 55BB5EA6
P 5550 1050
F 0 "#PWR07" H 5550 900 50  0001 C CNN
F 1 "+9V" H 5550 1190 50  0000 C CNN
F 2 "" H 5550 1050 60  0000 C CNN
F 3 "" H 5550 1050 60  0000 C CNN
	1    5550 1050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 55BB5ED4
P 4750 1150
F 0 "#PWR08" H 4750 900 50  0001 C CNN
F 1 "GND" H 4750 1000 50  0000 C CNN
F 2 "" H 4750 1150 60  0000 C CNN
F 3 "" H 4750 1150 60  0000 C CNN
	1    4750 1150
	0    -1   -1   0   
$EndComp
Text GLabel 4950 1250 2    60   Input ~ 0
TX_1
Text GLabel 4950 1350 2    60   Input ~ 0
RX_1
$Comp
L +9V #PWR09
U 1 1 55BB82F1
P 700 1950
F 0 "#PWR09" H 700 1800 50  0001 C CNN
F 1 "+9V" H 700 2090 50  0000 C CNN
F 2 "" H 700 1950 60  0000 C CNN
F 3 "" H 700 1950 60  0000 C CNN
	1    700  1950
	1    0    0    -1  
$EndComp
$Comp
L CONN_RED_2_Power CN3
U 1 1 55BB9C26
P 8400 2500
F 0 "CN3" H 8500 2700 60  0000 C CNN
F 1 "CONN_RED_2_Power" H 8450 2200 60  0000 C CNN
F 2 "user_conn:CONN_RED_2P_STRAIGHT" H 8400 2500 60  0001 C CNN
F 3 "" H 8400 2500 60  0000 C CNN
	1    8400 2500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 55BBB4B4
P 2150 1600
F 0 "#PWR010" H 2150 1350 50  0001 C CNN
F 1 "GND" H 2150 1450 50  0000 C CNN
F 2 "" H 2150 1600 60  0000 C CNN
F 3 "" H 2150 1600 60  0000 C CNN
	1    2150 1600
	1    0    0    -1  
$EndComp
$Comp
L CONN_WHITE_5_RE CN4
U 1 1 55BC8FA3
P 6650 900
F 0 "CN4" H 6650 1125 60  0000 C CNN
F 1 "CONN_WHITE_5_RE" H 6650 475 60  0000 C CNN
F 2 "user_conn:DF1E-5P_Streight" H 6695 900 60  0001 C CNN
F 3 "" H 6695 900 60  0000 C CNN
	1    6650 900 
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR011
U 1 1 55BC91FF
P 6100 900
F 0 "#PWR011" H 6100 750 50  0001 C CNN
F 1 "+5V" H 6100 1040 50  0000 C CNN
F 2 "" H 6100 900 60  0000 C CNN
F 3 "" H 6100 900 60  0000 C CNN
	1    6100 900 
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR012
U 1 1 55BC9303
P 6100 800
F 0 "#PWR012" H 6100 550 50  0001 C CNN
F 1 "GND" H 6100 650 50  0000 C CNN
F 2 "" H 6100 800 60  0000 C CNN
F 3 "" H 6100 800 60  0000 C CNN
	1    6100 800 
	0    1    1    0   
$EndComp
Text GLabel 6100 1000 0    60   Input ~ 0
A
Text GLabel 6100 1100 0    60   Input ~ 0
B
Text GLabel 6100 1200 0    60   Input ~ 0
Z
$Comp
L PSOC3_CY8C38_FAMILY_100 U3
U 1 1 55BCAAB4
P 3900 7100
F 0 "U3" H 2300 10550 60  0000 C CNN
F 1 "PSOC3_CY8C38_FAMILY_100" H 3900 8700 60  0000 C CNN
F 2 "Housings_QFP:TQFP-100_14x14mm_Pitch0.5mm" H 3900 7100 60  0001 C CNN
F 3 "" H 3900 7100 60  0000 C CNN
	1    3900 7100
	1    0    0    -1  
$EndComp
$Comp
L +24V #PWR013
U 1 1 55BCC8FE
P 2400 800
F 0 "#PWR013" H 2400 650 50  0001 C CNN
F 1 "+24V" H 2400 940 50  0000 C CNN
F 2 "" H 2400 800 60  0000 C CNN
F 3 "" H 2400 800 60  0000 C CNN
	1    2400 800 
	1    0    0    -1  
$EndComp
$Comp
L +24V #PWR014
U 1 1 55BCD35D
P 7400 2350
F 0 "#PWR014" H 7400 2200 50  0001 C CNN
F 1 "+24V" H 7400 2490 50  0000 C CNN
F 2 "" H 7400 2350 60  0000 C CNN
F 3 "" H 7400 2350 60  0000 C CNN
	1    7400 2350
	1    0    0    -1  
$EndComp
$Comp
L +24V #PWR015
U 1 1 55BCD4D6
P 6000 2600
F 0 "#PWR015" H 6000 2450 50  0001 C CNN
F 1 "+24V" H 6000 2740 50  0000 C CNN
F 2 "" H 6000 2600 60  0000 C CNN
F 3 "" H 6000 2600 60  0000 C CNN
	1    6000 2600
	0    -1   -1   0   
$EndComp
$Comp
L SLIDE_SW SW2
U 1 1 55BCDBBC
P 4850 850
F 0 "SW2" H 5250 700 60  0000 C CNN
F 1 "SLIDE_SW" H 4850 1150 60  0000 C CNN
F 2 "user_SW:Slide_Switch_SMD" H 4850 850 60  0001 C CNN
F 3 "" H 4850 850 60  0000 C CNN
	1    4850 850 
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 55BCEF6A
P 2100 3500
F 0 "C3" H 2125 3600 50  0000 L CNN
F 1 "0.1u" H 2125 3400 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 2138 3350 30  0001 C CNN
F 3 "" H 2100 3500 60  0000 C CNN
	1    2100 3500
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR016
U 1 1 55BCF1B1
P 2100 3250
F 0 "#PWR016" H 2100 3100 50  0001 C CNN
F 1 "+5V" H 2100 3390 50  0000 C CNN
F 2 "" H 2100 3250 60  0000 C CNN
F 3 "" H 2100 3250 60  0000 C CNN
	1    2100 3250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR017
U 1 1 55BCF1E5
P 2100 3750
F 0 "#PWR017" H 2100 3500 50  0001 C CNN
F 1 "GND" H 2100 3600 50  0000 C CNN
F 2 "" H 2100 3750 60  0000 C CNN
F 3 "" H 2100 3750 60  0000 C CNN
	1    2100 3750
	1    0    0    -1  
$EndComp
$Comp
L C C6
U 1 1 55BCF520
P 4000 3150
F 0 "C6" H 4025 3250 50  0000 L CNN
F 1 "0.1u" H 4025 3050 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 4038 3000 30  0001 C CNN
F 3 "" H 4000 3150 60  0000 C CNN
	1    4000 3150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR018
U 1 1 55BCF659
P 4150 3400
F 0 "#PWR018" H 4150 3150 50  0001 C CNN
F 1 "GND" H 4150 3250 50  0000 C CNN
F 2 "" H 4150 3400 60  0000 C CNN
F 3 "" H 4150 3400 60  0000 C CNN
	1    4150 3400
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR019
U 1 1 55BCF71F
P 4150 2950
F 0 "#PWR019" H 4150 2800 50  0001 C CNN
F 1 "+5V" H 4150 3090 50  0000 C CNN
F 2 "" H 4150 2950 60  0000 C CNN
F 3 "" H 4150 2950 60  0000 C CNN
	1    4150 2950
	1    0    0    -1  
$EndComp
Text GLabel 4350 3500 1    60   Input ~ 0
VCCD1
$Comp
L C C9
U 1 1 55BD1A54
P 6000 4400
F 0 "C9" H 6025 4500 50  0000 L CNN
F 1 "0.1u" H 6025 4300 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 6038 4250 30  0001 C CNN
F 3 "" H 6000 4400 60  0000 C CNN
	1    6000 4400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR020
U 1 1 55BD1C13
P 6150 4650
F 0 "#PWR020" H 6150 4400 50  0001 C CNN
F 1 "GND" H 6150 4500 50  0000 C CNN
F 2 "" H 6150 4650 60  0000 C CNN
F 3 "" H 6150 4650 60  0000 C CNN
	1    6150 4650
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR021
U 1 1 55BD1DC4
P 5900 4200
F 0 "#PWR021" H 5900 4050 50  0001 C CNN
F 1 "+5V" H 5900 4340 50  0000 C CNN
F 2 "" H 5900 4200 60  0000 C CNN
F 3 "" H 5900 4200 60  0000 C CNN
	1    5900 4200
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR022
U 1 1 55BD2219
P 6250 5200
F 0 "#PWR022" H 6250 5050 50  0001 C CNN
F 1 "+5V" H 6250 5340 50  0000 C CNN
F 2 "" H 6250 5200 60  0000 C CNN
F 3 "" H 6250 5200 60  0000 C CNN
	1    6250 5200
	1    0    0    -1  
$EndComp
$Comp
L C C11
U 1 1 55BD2449
P 6550 5550
F 0 "C11" H 6575 5650 50  0000 L CNN
F 1 "0.1u" H 6575 5450 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 6588 5400 30  0001 C CNN
F 3 "" H 6550 5550 60  0000 C CNN
	1    6550 5550
	1    0    0    -1  
$EndComp
$Comp
L C C10
U 1 1 55BD2486
P 6050 5550
F 0 "C10" H 6075 5650 50  0000 L CNN
F 1 "1u" H 6075 5450 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 6088 5400 30  0001 C CNN
F 3 "" H 6050 5550 60  0000 C CNN
	1    6050 5550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR023
U 1 1 55BD24E3
P 6250 5800
F 0 "#PWR023" H 6250 5550 50  0001 C CNN
F 1 "GND" H 6250 5650 50  0000 C CNN
F 2 "" H 6250 5800 60  0000 C CNN
F 3 "" H 6250 5800 60  0000 C CNN
	1    6250 5800
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR024
U 1 1 55BD2CE3
P 5400 7250
F 0 "#PWR024" H 5400 7100 50  0001 C CNN
F 1 "+5V" H 5400 7390 50  0000 C CNN
F 2 "" H 5400 7250 60  0000 C CNN
F 3 "" H 5400 7250 60  0000 C CNN
	1    5400 7250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR025
U 1 1 55BD30E3
P 5250 7550
F 0 "#PWR025" H 5250 7300 50  0001 C CNN
F 1 "GND" H 5250 7400 50  0000 C CNN
F 2 "" H 5250 7550 60  0000 C CNN
F 3 "" H 5250 7550 60  0000 C CNN
	1    5250 7550
	1    0    0    -1  
$EndComp
$Comp
L C C8
U 1 1 55BD311F
P 5250 7400
F 0 "C8" H 5275 7500 50  0000 L CNN
F 1 "0.1u" H 5275 7300 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 5288 7250 30  0001 C CNN
F 3 "" H 5250 7400 60  0000 C CNN
	1    5250 7400
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 55BD368C
P 3800 7550
F 0 "C5" H 3825 7650 50  0000 L CNN
F 1 "0.1u" H 3825 7450 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 3838 7400 30  0001 C CNN
F 3 "" H 3800 7550 60  0000 C CNN
	1    3800 7550
	1    0    0    -1  
$EndComp
$Comp
L C C7
U 1 1 55BD36D9
P 4000 7550
F 0 "C7" H 4025 7650 50  0000 L CNN
F 1 "1u" H 4025 7450 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 4038 7400 30  0001 C CNN
F 3 "" H 4000 7550 60  0000 C CNN
	1    4000 7550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR026
U 1 1 55BD38FA
P 3900 7700
F 0 "#PWR026" H 3900 7450 50  0001 C CNN
F 1 "GND" H 3900 7550 50  0000 C CNN
F 2 "" H 3900 7700 60  0000 C CNN
F 3 "" H 3900 7700 60  0000 C CNN
	1    3900 7700
	1    0    0    -1  
$EndComp
Text GLabel 4200 7400 3    60   Input ~ 0
VCCD1
$Comp
L C C4
U 1 1 55BD4185
P 2450 7400
F 0 "C4" H 2475 7500 50  0000 L CNN
F 1 "0.1u" H 2475 7300 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 2488 7250 30  0001 C CNN
F 3 "" H 2450 7400 60  0000 C CNN
	1    2450 7400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR027
U 1 1 55BD4272
P 2450 7550
F 0 "#PWR027" H 2450 7300 50  0001 C CNN
F 1 "GND" H 2450 7400 50  0000 C CNN
F 2 "" H 2450 7550 60  0000 C CNN
F 3 "" H 2450 7550 60  0000 C CNN
	1    2450 7550
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR028
U 1 1 55BD42B6
P 2450 7250
F 0 "#PWR028" H 2450 7100 50  0001 C CNN
F 1 "+5V" H 2450 7390 50  0000 C CNN
F 2 "" H 2450 7250 60  0000 C CNN
F 3 "" H 2450 7250 60  0000 C CNN
	1    2450 7250
	1    0    0    -1  
$EndComp
$Comp
L CONN_WHITE_5 CN2
U 1 1 55BD457B
P 1400 6150
F 0 "CN2" H 1400 6375 60  0000 C CNN
F 1 "CONN_WHITE_5" H 1400 5725 60  0000 C CNN
F 2 "user_conn:DF1E-5P_Streight" H 1400 6150 60  0001 C CNN
F 3 "" H 1400 6150 60  0000 C CNN
	1    1400 6150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR029
U 1 1 55BD48D8
P 1150 6350
F 0 "#PWR029" H 1150 6100 50  0001 C CNN
F 1 "GND" H 1150 6200 50  0000 C CNN
F 2 "" H 1150 6350 60  0000 C CNN
F 3 "" H 1150 6350 60  0000 C CNN
	1    1150 6350
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR030
U 1 1 55BD4B2B
P 1150 6450
F 0 "#PWR030" H 1150 6300 50  0001 C CNN
F 1 "+5V" H 1150 6590 50  0000 C CNN
F 2 "" H 1150 6450 60  0000 C CNN
F 3 "" H 1150 6450 60  0000 C CNN
	1    1150 6450
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR031
U 1 1 55BD57C0
P 1300 5300
F 0 "#PWR031" H 1300 5050 50  0001 C CNN
F 1 "GND" H 1300 5150 50  0000 C CNN
F 2 "" H 1300 5300 60  0000 C CNN
F 3 "" H 1300 5300 60  0000 C CNN
	1    1300 5300
	1    0    0    -1  
$EndComp
NoConn ~ 2100 4250
NoConn ~ 2100 4350
NoConn ~ 2100 4450
NoConn ~ 2100 4550
NoConn ~ 2100 4650
NoConn ~ 2100 4750
NoConn ~ 2100 4850
NoConn ~ 2100 4950
NoConn ~ 2100 5050
NoConn ~ 2100 5250
NoConn ~ 2100 5350
NoConn ~ 2100 5750
NoConn ~ 2100 5850
NoConn ~ 2100 5950
NoConn ~ 2100 6050
NoConn ~ 2100 6350
NoConn ~ 2100 6450
NoConn ~ 2100 6550
NoConn ~ 2100 6650
NoConn ~ 2800 7250
NoConn ~ 2900 7250
NoConn ~ 3000 7250
NoConn ~ 3100 7250
NoConn ~ 3300 7250
NoConn ~ 3500 7250
NoConn ~ 3600 7250
NoConn ~ 3700 7250
NoConn ~ 4300 7250
NoConn ~ 4400 7250
NoConn ~ 4500 7250
NoConn ~ 4700 7250
NoConn ~ 4800 7250
NoConn ~ 4900 7250
NoConn ~ 5000 7250
NoConn ~ 5700 6450
NoConn ~ 5700 6350
NoConn ~ 5700 6250
NoConn ~ 5700 6150
NoConn ~ 5700 5050
NoConn ~ 5700 4950
NoConn ~ 5700 4850
NoConn ~ 5700 4750
NoConn ~ 5700 4550
NoConn ~ 5700 4350
NoConn ~ 4900 3650
NoConn ~ 4800 3650
NoConn ~ 4700 3650
NoConn ~ 4600 3650
NoConn ~ 4500 3650
NoConn ~ 4400 3650
NoConn ~ 4300 3650
NoConn ~ 4200 3650
NoConn ~ 2800 3650
NoConn ~ 3000 3650
NoConn ~ 3100 3650
NoConn ~ 3200 3650
NoConn ~ 3300 3650
NoConn ~ 3400 3650
NoConn ~ 3600 3650
NoConn ~ 3700 3650
NoConn ~ 3800 3650
Text GLabel 4600 7400 3    60   Input ~ 0
A
Text GLabel 3400 7350 3    60   Input ~ 0
B
Text GLabel 3200 7350 3    60   Input ~ 0
Z
Text GLabel 5900 6550 2    60   Input ~ 0
IN1_1
Text GLabel 5900 6650 2    60   Input ~ 0
IN1_2
Text GLabel 5150 3500 1    60   Input ~ 0
IS1
Text GLabel 4950 3500 1    60   Input ~ 0
INH1
Text GLabel 3500 3500 1    60   Input ~ 0
TX_1
Text GLabel 2900 3500 1    60   Input ~ 0
RX_1
NoConn ~ 5700 4650
NoConn ~ 5700 4450
$Comp
L GND #PWR032
U 1 1 55BEB0A0
P 10100 5200
F 0 "#PWR032" H 10100 4950 50  0001 C CNN
F 1 "GND" H 10100 5050 50  0000 C CNN
F 2 "" H 10100 5200 60  0000 C CNN
F 3 "" H 10100 5200 60  0000 C CNN
	1    10100 5200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR033
U 1 1 55BEB0EA
P 9100 5200
F 0 "#PWR033" H 9100 4950 50  0001 C CNN
F 1 "GND" H 9100 5050 50  0000 C CNN
F 2 "" H 9100 5200 60  0000 C CNN
F 3 "" H 9100 5200 60  0000 C CNN
	1    9100 5200
	1    0    0    -1  
$EndComp
$Comp
L pad_2mm_1.7mm U4
U 1 1 55BEC56A
P 9100 5200
F 0 "U4" H 9100 5000 60  0000 C CNN
F 1 "pad_2mm_1.7mm" H 9100 5400 60  0000 C CNN
F 2 "user_drill:pad_2mm_1.7mm" H 9100 5200 60  0001 C CNN
F 3 "" H 9100 5200 60  0000 C CNN
	1    9100 5200
	1    0    0    -1  
$EndComp
$Comp
L pad_2mm_1.7mm U5
U 1 1 55BEC5CF
P 10100 5200
F 0 "U5" H 10100 5000 60  0000 C CNN
F 1 "pad_2mm_1.7mm" H 10100 5400 60  0000 C CNN
F 2 "user_drill:pad_2mm_1.7mm" H 10100 5200 60  0001 C CNN
F 3 "" H 10100 5200 60  0000 C CNN
	1    10100 5200
	1    0    0    -1  
$EndComp
$Comp
L CP C13
U 1 1 55BEDE90
P 2050 1000
F 0 "C13" H 2075 1100 50  0000 L CNN
F 1 "1000u" H 2075 900 50  0000 L CNN
F 2 "user_drill:C_Radial_D18_L36_P7.5_Horizon6" H 2088 850 30  0001 C CNN
F 3 "" H 2050 1000 60  0000 C CNN
	1    2050 1000
	1    0    0    -1  
$EndComp
$Comp
L CP C12
U 1 1 55BEDF01
P 1800 1000
F 0 "C12" H 1825 1100 50  0000 L CNN
F 1 "1000u" H 1825 900 50  0000 L CNN
F 2 "user_drill:C_Radial_D18_L36_P7.5_Horizon5" H 1838 850 30  0001 C CNN
F 3 "" H 1800 1000 60  0000 C CNN
	1    1800 1000
	1    0    0    -1  
$EndComp
$Comp
L LED D2
U 1 1 55BEFD7E
P 1400 1050
F 0 "D2" H 1400 1150 50  0000 C CNN
F 1 "LED" H 1400 950 50  0000 C CNN
F 2 "LEDs:LED-3MM" H 1400 1050 60  0001 C CNN
F 3 "" H 1400 1050 60  0000 C CNN
	1    1400 1050
	0    -1   -1   0   
$EndComp
$Comp
L R R3
U 1 1 55BF06B4
P 1400 1400
F 0 "R3" V 1480 1400 50  0000 C CNN
F 1 "10k" V 1400 1400 50  0000 C CNN
F 2 "Resistors_SMD:R_0603" V 1330 1400 30  0001 C CNN
F 3 "" H 1400 1400 30  0000 C CNN
	1    1400 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	700  1950 1000 1950
Wire Wire Line
	1800 1950 2600 1950
Connection ~ 2000 1950
Wire Wire Line
	2400 2350 2400 2400
Wire Wire Line
	2400 2700 2400 2800
Connection ~ 2400 1950
Wire Wire Line
	2000 2250 2000 2800
Wire Wire Line
	800  2250 800  2750
Wire Wire Line
	800  2750 2000 2750
Connection ~ 2000 2750
Wire Wire Line
	1400 2250 1400 2750
Connection ~ 1400 2750
Wire Wire Line
	6150 1950 6150 2200
Connection ~ 6150 2100
Connection ~ 6150 2150
Wire Wire Line
	7250 1950 7250 2200
Connection ~ 7250 2100
Connection ~ 7250 2150
Wire Wire Line
	6150 1950 7250 1950
Connection ~ 7250 2050
Connection ~ 6150 2050
Wire Wire Line
	6150 2750 6150 3000
Connection ~ 6150 2800
Connection ~ 6150 2850
Wire Wire Line
	7250 3000 7250 2750
Connection ~ 7250 2850
Connection ~ 7250 2800
Wire Wire Line
	6150 3000 7250 3000
Connection ~ 7250 2900
Connection ~ 6150 2900
Wire Wire Line
	6150 2550 6150 2700
Connection ~ 6150 2650
Connection ~ 6150 2600
Wire Wire Line
	7250 2550 7250 2700
Connection ~ 7250 2600
Connection ~ 7250 2650
Wire Wire Line
	6150 2250 6150 2400
Connection ~ 6150 2350
Connection ~ 6150 2300
Wire Wire Line
	7250 2250 7250 2400
Connection ~ 7250 2300
Connection ~ 7250 2350
Wire Wire Line
	7250 2450 7750 2450
Connection ~ 7550 2450
Wire Wire Line
	7250 2500 7400 2500
Wire Wire Line
	7400 2500 7400 2600
Wire Wire Line
	7550 2450 7550 2650
Wire Wire Line
	7550 2950 7550 3000
Wire Wire Line
	6000 2600 6150 2600
Wire Wire Line
	5750 2350 5750 3000
Wire Wire Line
	5750 2350 6150 2350
Wire Wire Line
	7250 2650 7350 2650
Wire Wire Line
	7350 2650 7350 3000
Wire Wire Line
	6150 2450 5850 2450
Wire Wire Line
	5850 2450 5850 2400
Wire Wire Line
	5850 2400 5550 2400
Wire Wire Line
	5550 2500 6150 2500
Wire Wire Line
	7400 2350 7250 2350
Wire Wire Line
	4600 1050 4750 1050
Wire Wire Line
	4600 1150 4750 1150
Wire Wire Line
	4600 1250 4950 1250
Wire Wire Line
	4600 1350 4950 1350
Connection ~ 800  1950
Wire Wire Line
	7150 3000 7150 3200
Wire Wire Line
	7150 3200 8200 3200
Wire Wire Line
	8200 3200 8200 2600
Connection ~ 7150 3000
Wire Wire Line
	7200 1950 7200 1900
Wire Wire Line
	7200 1900 8200 1900
Wire Wire Line
	8200 1900 8200 2450
Connection ~ 7200 1950
Wire Wire Line
	6100 800  6400 800 
Wire Wire Line
	6100 900  6400 900 
Wire Wire Line
	6100 1000 6400 1000
Wire Wire Line
	6100 1100 6400 1100
Wire Wire Line
	6100 1200 6400 1200
Wire Wire Line
	2400 850  2400 800 
Wire Wire Line
	4850 1050 5550 1050
Connection ~ 4950 1050
Wire Wire Line
	2100 3250 2100 3350
Wire Wire Line
	2100 3300 2700 3300
Wire Wire Line
	2700 3300 2700 3650
Connection ~ 2100 3300
Wire Wire Line
	2100 3650 2100 3750
Wire Wire Line
	4000 3300 4000 3650
Wire Wire Line
	4000 3400 4150 3400
Connection ~ 4000 3400
Wire Wire Line
	3900 2950 4150 2950
Wire Wire Line
	4000 2950 4000 3000
Wire Wire Line
	3900 2950 3900 3650
Connection ~ 4000 2950
Wire Wire Line
	4100 3650 4100 3600
Wire Wire Line
	4100 3600 4350 3600
Wire Wire Line
	4350 3600 4350 3500
Wire Wire Line
	5700 4250 6000 4250
Wire Wire Line
	6000 4550 6000 5150
Wire Wire Line
	6000 5150 5700 5150
Wire Wire Line
	6000 4650 6150 4650
Connection ~ 6000 4650
Wire Wire Line
	5900 4200 5900 4250
Connection ~ 5900 4250
Wire Wire Line
	5700 5250 6550 5250
Wire Wire Line
	6550 5250 6550 5400
Wire Wire Line
	6250 5250 6250 5200
Connection ~ 6250 5250
Wire Wire Line
	6050 5700 6050 5750
Wire Wire Line
	6050 5750 6550 5750
Wire Wire Line
	6550 5750 6550 5700
Wire Wire Line
	6250 5350 6250 5800
Connection ~ 6250 5750
Wire Wire Line
	5700 5350 6250 5350
Wire Wire Line
	5700 5450 5800 5450
Wire Wire Line
	5800 5450 5800 5400
Wire Wire Line
	5800 5400 6050 5400
Wire Wire Line
	5100 7250 5400 7250
Connection ~ 5250 7250
Wire Wire Line
	3800 7250 3800 7400
Wire Wire Line
	4000 7250 4000 7400
Wire Wire Line
	3800 7700 4000 7700
Connection ~ 3900 7700
Wire Wire Line
	4000 7350 4200 7350
Wire Wire Line
	4200 7350 4200 7400
Connection ~ 4000 7350
Wire Wire Line
	3900 7250 3900 7700
Wire Wire Line
	2450 7250 2700 7250
Wire Wire Line
	1150 6250 1100 6250
Wire Wire Line
	1100 6250 1100 5650
Wire Wire Line
	1100 5650 2100 5650
Wire Wire Line
	2100 6150 1850 6150
Wire Wire Line
	1850 6150 1850 5800
Wire Wire Line
	1850 5800 1000 5800
Wire Wire Line
	1000 5800 1000 6050
Wire Wire Line
	1000 6050 1150 6050
Wire Wire Line
	2100 6250 1700 6250
Wire Wire Line
	1700 6250 1700 5900
Wire Wire Line
	1700 5900 950  5900
Wire Wire Line
	950  5900 950  6150
Wire Wire Line
	950  6150 1150 6150
Wire Wire Line
	1450 5550 2100 5550
Wire Wire Line
	1450 5150 1450 5550
Wire Wire Line
	1450 5300 1300 5300
Wire Wire Line
	2100 5450 1450 5450
Connection ~ 1450 5450
Wire Wire Line
	2100 5150 1450 5150
Connection ~ 1450 5300
Wire Wire Line
	4650 1050 4650 650 
Wire Wire Line
	4650 650  4750 650 
Connection ~ 4650 1050
Wire Wire Line
	4850 650  5100 650 
Wire Wire Line
	5100 650  5100 1050
Connection ~ 5100 1050
Connection ~ 4950 650 
Wire Wire Line
	4600 7400 4600 7250
Wire Wire Line
	3200 7250 3200 7350
Wire Wire Line
	3400 7250 3400 7350
Wire Wire Line
	5700 6550 5900 6550
Wire Wire Line
	5700 6650 5900 6650
Wire Wire Line
	2900 3650 2900 3500
Wire Wire Line
	3500 3650 3500 3500
Wire Wire Line
	4950 3500 5000 3500
Wire Wire Line
	5000 3500 5000 3650
Wire Wire Line
	5100 3650 5100 3500
Wire Wire Line
	5100 3500 5150 3500
Connection ~ 2400 850 
Connection ~ 2050 850 
Connection ~ 1800 850 
Wire Wire Line
	1250 1550 2150 1550
Wire Wire Line
	2150 1550 2150 1600
Wire Wire Line
	2050 1150 2050 1550
Connection ~ 2050 1550
Wire Wire Line
	1800 1150 1800 1550
Connection ~ 1800 1550
$Comp
L R R4
U 1 1 55BF2C54
P 5400 2400
F 0 "R4" V 5480 2400 50  0000 C CNN
F 1 "4.7k" V 5400 2400 50  0000 C CNN
F 2 "Resistors_SMD:R_0603" V 5330 2400 30  0001 C CNN
F 3 "" H 5400 2400 30  0000 C CNN
	1    5400 2400
	0    1    1    0   
$EndComp
$Comp
L R R5
U 1 1 55BF310F
P 5400 2500
F 0 "R5" V 5480 2500 50  0000 C CNN
F 1 "4.7k" V 5400 2500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603" V 5330 2500 30  0001 C CNN
F 3 "" H 5400 2500 30  0000 C CNN
	1    5400 2500
	0    1    1    0   
$EndComp
Wire Wire Line
	5050 2400 5250 2400
Wire Wire Line
	5050 2500 5250 2500
$Comp
L R R6
U 1 1 55BF37FA
P 7600 2600
F 0 "R6" V 7680 2600 50  0000 C CNN
F 1 "4.7k" V 7600 2600 50  0000 C CNN
F 2 "Resistors_SMD:R_0603" V 7530 2600 30  0001 C CNN
F 3 "" H 7600 2600 30  0000 C CNN
	1    7600 2600
	0    1    1    0   
$EndComp
Wire Wire Line
	7400 2600 7450 2600
Wire Wire Line
	7750 2600 7850 2600
$Comp
L DF22L-2P CN1
U 1 1 55BF666B
P 900 1200
F 0 "CN1" H 950 1400 60  0000 C CNN
F 1 "DF22L-2P" H 900 850 60  0000 C CNN
F 2 "user_conn:CONN_RED_2P_STRAIGHT" H 850 1200 60  0001 C CNN
F 3 "" H 850 1200 60  0000 C CNN
	1    900  1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 850  1250 1150
Wire Wire Line
	1250 1150 1100 1150
Connection ~ 1400 850 
Wire Wire Line
	1100 1300 1250 1300
Wire Wire Line
	1250 1300 1250 1550
Connection ~ 1400 1550
Wire Wire Line
	1250 850  2400 850 
$Comp
L pad_2mm_1.7mm U6
U 1 1 55BFAF50
P 9200 4400
F 0 "U6" H 9200 4200 60  0000 C CNN
F 1 "pad_2mm_1.7mm" H 9200 4600 60  0000 C CNN
F 2 "user_drill:pad_2mm_1.7mm" H 9200 4400 60  0001 C CNN
F 3 "" H 9200 4400 60  0000 C CNN
	1    9200 4400
	1    0    0    -1  
$EndComp
$Comp
L +24V #PWR034
U 1 1 55BFB38C
P 9200 4400
F 0 "#PWR034" H 9200 4250 50  0001 C CNN
F 1 "+24V" H 9200 4540 50  0000 C CNN
F 2 "" H 9200 4400 60  0000 C CNN
F 3 "" H 9200 4400 60  0000 C CNN
	1    9200 4400
	1    0    0    -1  
$EndComp
$Comp
L D D3
U 1 1 55BFC9BE
P 7450 2800
F 0 "D3" H 7450 2900 50  0000 C CNN
F 1 "D" H 7450 2700 50  0000 C CNN
F 2 "user_drill:SOD-523_1" H 7450 2800 60  0001 C CNN
F 3 "" H 7450 2800 60  0000 C CNN
	1    7450 2800
	0    1    1    0   
$EndComp
Wire Wire Line
	7450 2450 7450 2650
Connection ~ 7450 2450
Wire Wire Line
	7450 2950 7450 3000
Wire Wire Line
	7450 3000 7550 3000
Connection ~ 7550 3000
$EndSCHEMATC