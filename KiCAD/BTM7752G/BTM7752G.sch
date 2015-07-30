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
L CONN_RED_2_Power CN?
U 1 1 55BA44BF
P 950 850
F 0 "CN?" H 1050 1050 60  0000 C CNN
F 1 "CONN_RED_2_Power" H 1000 550 60  0000 C CNN
F 2 "" H 950 850 60  0000 C CNN
F 3 "" H 950 850 60  0000 C CNN
	1    950  850 
	-1   0    0    1   
$EndComp
$Comp
L SLIDE_SW SW?
U 1 1 55BA4549
P 1350 1450
F 0 "SW?" H 1750 1300 60  0000 C CNN
F 1 "SLIDE_SW" H 1800 1400 60  0000 C CNN
F 2 "" H 1350 1450 60  0000 C CNN
F 3 "" H 1350 1450 60  0000 C CNN
	1    1350 1450
	-1   0    0    1   
$EndComp
$Comp
L C C?
U 1 1 55BA4608
P 1750 1400
F 0 "C?" H 1775 1500 50  0000 L CNN
F 1 "1u" H 1775 1300 50  0000 L CNN
F 2 "" H 1788 1250 30  0000 C CNN
F 3 "" H 1750 1400 60  0000 C CNN
	1    1750 1400
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BA462F
P 2100 1250
F 0 "R?" V 2180 1250 50  0000 C CNN
F 1 "4.7k" V 2100 1250 50  0000 C CNN
F 2 "" V 2030 1250 30  0000 C CNN
F 3 "" H 2100 1250 30  0000 C CNN
	1    2100 1250
	0    1    1    0   
$EndComp
$Comp
L Q_NMOS_GDS Q?
U 1 1 55BA4662
P 2500 1250
F 0 "Q?" H 2800 1300 50  0000 R CNN
F 1 "Q_NMOS_GDS" H 3150 1200 50  0000 R CNN
F 2 "" H 2700 1350 29  0000 C CNN
F 3 "" H 2500 1250 60  0000 C CNN
	1    2500 1250
	1    0    0    -1  
$EndComp
Text GLabel 2950 800  2    60   Input ~ 0
MGND
Text GLabel 2950 650  2    60   Input ~ 0
MV
$Comp
L GND #PWR?
U 1 1 55BA4AF5
P 2300 1650
F 0 "#PWR?" H 2300 1400 50  0001 C CNN
F 1 "GND" H 2300 1500 50  0000 C CNN
F 2 "" H 2300 1650 60  0000 C CNN
F 3 "" H 2300 1650 60  0000 C CNN
	1    2300 1650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 55BA4B40
P 1250 750
F 0 "#PWR?" H 1250 500 50  0001 C CNN
F 1 "GND" H 1250 600 50  0000 C CNN
F 2 "" H 1250 750 60  0000 C CNN
F 3 "" H 1250 750 60  0000 C CNN
	1    1250 750 
	0    -1   -1   0   
$EndComp
$Comp
L TA48M05F U?
U 1 1 55BA4CAC
P 1600 2500
F 0 "U?" H 1700 2300 60  0000 C CNN
F 1 "TA48M05F" H 1600 2650 60  0000 C CNN
F 2 "" H 1600 2500 60  0000 C CNN
F 3 "" H 1600 2500 60  0000 C CNN
	1    1600 2500
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 55BA4CDF
P 2200 2650
F 0 "C?" H 2225 2750 50  0000 L CNN
F 1 "47u" H 2225 2550 50  0000 L CNN
F 2 "" H 2238 2500 30  0000 C CNN
F 3 "" H 2200 2650 60  0000 C CNN
	1    2200 2650
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 55BA4DF2
P 1000 2650
F 0 "C?" H 1025 2750 50  0000 L CNN
F 1 "0.1u" H 1025 2550 50  0000 L CNN
F 2 "" H 1038 2500 30  0000 C CNN
F 3 "" H 1000 2650 60  0000 C CNN
	1    1000 2650
	1    0    0    -1  
$EndComp
$Comp
L LED D?
U 1 1 55BA4EBD
P 2600 2700
F 0 "D?" H 2600 2800 50  0000 C CNN
F 1 "LED" H 2600 2600 50  0000 C CNN
F 2 "" H 2600 2700 60  0000 C CNN
F 3 "" H 2600 2700 60  0000 C CNN
	1    2600 2700
	0    -1   -1   0   
$EndComp
$Comp
L R R?
U 1 1 55BA4F35
P 2600 3100
F 0 "R?" V 2680 3100 50  0000 C CNN
F 1 "R" V 2600 3100 50  0000 C CNN
F 2 "" V 2530 3100 30  0000 C CNN
F 3 "" H 2600 3100 30  0000 C CNN
	1    2600 3100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 55BA4FBE
P 2600 3350
F 0 "#PWR?" H 2600 3100 50  0001 C CNN
F 1 "GND" H 2600 3200 50  0000 C CNN
F 2 "" H 2600 3350 60  0000 C CNN
F 3 "" H 2600 3350 60  0000 C CNN
	1    2600 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 55BA516A
P 2200 3350
F 0 "#PWR?" H 2200 3100 50  0001 C CNN
F 1 "GND" H 2200 3200 50  0000 C CNN
F 2 "" H 2200 3350 60  0000 C CNN
F 3 "" H 2200 3350 60  0000 C CNN
	1    2200 3350
	1    0    0    -1  
$EndComp
$Comp
L BTM7752G U?
U 1 1 55BA57CF
P 5700 3700
F 0 "U?" H 5700 3600 60  0000 C CNN
F 1 "BTM7752G" H 5700 3700 60  0000 C CNN
F 2 "" H 5700 3700 60  0000 C CNN
F 3 "" H 5700 3700 60  0000 C CNN
	1    5700 3700
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BA6146
P 6550 4000
F 0 "R?" V 6630 4000 50  0000 C CNN
F 1 "1k" V 6550 4000 50  0000 C CNN
F 2 "" V 6480 4000 30  0000 C CNN
F 3 "" H 6550 4000 30  0000 C CNN
	1    6550 4000
	1    0    0    -1  
$EndComp
Text GLabel 6750 3650 2    60   Input ~ 0
IS
Text GLabel 6750 3800 2    60   Input ~ 0
INH
$Comp
L GND #PWR?
U 1 1 55BA6440
P 6550 4200
F 0 "#PWR?" H 6550 3950 50  0001 C CNN
F 1 "GND" H 6550 4050 50  0000 C CNN
F 2 "" H 6550 4200 60  0000 C CNN
F 3 "" H 6550 4200 60  0000 C CNN
	1    6550 4200
	1    0    0    -1  
$EndComp
Text GLabel 5000 3800 0    60   Input ~ 0
VS
$Comp
L GND #PWR?
U 1 1 55BA671C
P 4750 4200
F 0 "#PWR?" H 4750 3950 50  0001 C CNN
F 1 "GND" H 4750 4050 50  0000 C CNN
F 2 "" H 4750 4200 60  0000 C CNN
F 3 "" H 4750 4200 60  0000 C CNN
	1    4750 4200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 55BA6895
P 6350 4200
F 0 "#PWR?" H 6350 3950 50  0001 C CNN
F 1 "GND" H 6350 4050 50  0000 C CNN
F 2 "" H 6350 4200 60  0000 C CNN
F 3 "" H 6350 4200 60  0000 C CNN
	1    6350 4200
	1    0    0    -1  
$EndComp
Text GLabel 4550 3600 0    60   Input ~ 0
IN1
Text GLabel 4550 3700 0    60   Input ~ 0
IN2
$Comp
L TLP621-2 U?
U 1 1 55BA6DCC
P 4650 6350
F 0 "U?" H 4650 5850 60  0000 C CNN
F 1 "TLP621-2" H 4650 5950 60  0000 C CNN
F 2 "" H 4700 6300 60  0000 C CNN
F 3 "" H 4700 6300 60  0000 C CNN
	1    4650 6350
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 55BA7147
P 5800 6500
F 0 "#PWR?" H 5800 6350 50  0001 C CNN
F 1 "+5V" H 5800 6640 50  0000 C CNN
F 2 "" H 5800 6500 60  0000 C CNN
F 3 "" H 5800 6500 60  0000 C CNN
	1    5800 6500
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BA7175
P 5650 6650
F 0 "R?" V 5730 6650 50  0000 C CNN
F 1 "1k" V 5650 6650 50  0000 C CNN
F 2 "" V 5580 6650 30  0000 C CNN
F 3 "" H 5650 6650 30  0000 C CNN
	1    5650 6650
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BA71D2
P 5500 6700
F 0 "R?" V 5580 6700 50  0000 C CNN
F 1 "300" V 5500 6700 50  0000 C CNN
F 2 "" V 5430 6700 30  0000 C CNN
F 3 "" H 5500 6700 30  0000 C CNN
	1    5500 6700
	1    0    0    -1  
$EndComp
$Comp
L Q_NMOS_GDS Q?
U 1 1 55BA7233
P 5550 7050
F 0 "Q?" H 5850 7100 50  0000 R CNN
F 1 "Q_NMOS_GDS" H 6200 7000 50  0000 R CNN
F 2 "" H 5750 7150 29  0000 C CNN
F 3 "" H 5550 7050 60  0000 C CNN
	1    5550 7050
	1    0    0    -1  
$EndComp
Text GLabel 5750 7350 2    60   Input ~ 0
MGND
$Comp
L R R?
U 1 1 55BA8375
P 5750 5600
F 0 "R?" V 5830 5600 50  0000 C CNN
F 1 "1k" V 5750 5600 50  0000 C CNN
F 2 "" V 5680 5600 30  0000 C CNN
F 3 "" H 5750 5600 30  0000 C CNN
	1    5750 5600
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BA837B
P 5600 5650
F 0 "R?" V 5680 5650 50  0000 C CNN
F 1 "300" V 5600 5650 50  0000 C CNN
F 2 "" V 5530 5650 30  0000 C CNN
F 3 "" H 5600 5650 30  0000 C CNN
	1    5600 5650
	1    0    0    -1  
$EndComp
$Comp
L Q_NMOS_GDS Q?
U 1 1 55BA8381
P 5650 6000
F 0 "Q?" H 5950 6050 50  0000 R CNN
F 1 "Q_NMOS_GDS" H 6300 5950 50  0000 R CNN
F 2 "" H 5850 6100 29  0000 C CNN
F 3 "" H 5650 6000 60  0000 C CNN
	1    5650 6000
	1    0    0    -1  
$EndComp
Text GLabel 5850 6300 2    60   Input ~ 0
SIG_GND
Text GLabel 5900 5450 2    60   Input ~ 0
SIG_VCC
$Comp
L +5V #PWR?
U 1 1 55BA8D00
P 3750 6000
F 0 "#PWR?" H 3750 5850 50  0001 C CNN
F 1 "+5V" H 3750 6140 50  0000 C CNN
F 2 "" H 3750 6000 60  0000 C CNN
F 3 "" H 3750 6000 60  0000 C CNN
	1    3750 6000
	1    0    0    -1  
$EndComp
Text GLabel 3350 6500 0    60   Input ~ 0
IS_IN
Text GLabel 3350 6800 0    60   Input ~ 0
MGND
$Comp
L Q_NMOS_GDS Q?
U 1 1 55BA9532
P 3650 6500
F 0 "Q?" H 3950 6550 50  0000 R CNN
F 1 "Q_NMOS_GDS" H 4300 6450 50  0000 R CNN
F 2 "" H 3850 6600 29  0000 C CNN
F 3 "" H 3650 6500 60  0000 C CNN
	1    3650 6500
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BA9665
P 4100 6300
F 0 "R?" V 4180 6300 50  0000 C CNN
F 1 "180" V 4100 6300 50  0000 C CNN
F 2 "" V 4030 6300 30  0000 C CNN
F 3 "" H 4100 6300 30  0000 C CNN
	1    4100 6300
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 55BA993A
P 3400 6650
F 0 "R?" V 3480 6650 50  0000 C CNN
F 1 "1k" V 3400 6650 50  0000 C CNN
F 2 "" V 3330 6650 30  0000 C CNN
F 3 "" H 3400 6650 30  0000 C CNN
	1    3400 6650
	1    0    0    -1  
$EndComp
Text GLabel 3250 7350 0    60   Input ~ 0
INH_IN
Text GLabel 3250 7650 0    60   Input ~ 0
SIG_GND
$Comp
L Q_NMOS_GDS Q?
U 1 1 55BAAAA1
P 3550 7350
F 0 "Q?" H 3850 7400 50  0000 R CNN
F 1 "Q_NMOS_GDS" H 4200 7300 50  0000 R CNN
F 2 "" H 3750 7450 29  0000 C CNN
F 3 "" H 3550 7350 60  0000 C CNN
	1    3550 7350
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BAAAA7
P 4000 7150
F 0 "R?" V 4080 7150 50  0000 C CNN
F 1 "180" V 4000 7150 50  0000 C CNN
F 2 "" V 3930 7150 30  0000 C CNN
F 3 "" H 4000 7150 30  0000 C CNN
	1    4000 7150
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 55BAAAB1
P 3300 7500
F 0 "R?" V 3380 7500 50  0000 C CNN
F 1 "1k" V 3300 7500 50  0000 C CNN
F 2 "" V 3230 7500 30  0000 C CNN
F 3 "" H 3300 7500 30  0000 C CNN
	1    3300 7500
	1    0    0    -1  
$EndComp
Text GLabel 3300 7050 0    60   Input ~ 0
SIG_VCC
$Comp
L +5VD #PWR?
U 1 1 55BAF1A1
P 2800 2500
F 0 "#PWR?" H 2800 2350 50  0001 C CNN
F 1 "+5VD" H 2800 2640 50  0000 C CNN
F 2 "" H 2800 2500 60  0000 C CNN
F 3 "" H 2800 2500 60  0000 C CNN
	1    2800 2500
	1    0    0    -1  
$EndComp
$Comp
L TA48M05F U?
U 1 1 55BB0707
P 1350 6800
F 0 "U?" H 1450 6600 60  0000 C CNN
F 1 "TA48M05F" H 1350 6950 60  0000 C CNN
F 2 "" H 1350 6800 60  0000 C CNN
F 3 "" H 1350 6800 60  0000 C CNN
	1    1350 6800
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 55BB070D
P 1950 6950
F 0 "C?" H 1975 7050 50  0000 L CNN
F 1 "47u" H 1975 6850 50  0000 L CNN
F 2 "" H 1988 6800 30  0000 C CNN
F 3 "" H 1950 6950 60  0000 C CNN
	1    1950 6950
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 55BB0713
P 750 6950
F 0 "C?" H 775 7050 50  0000 L CNN
F 1 "0.1u" H 775 6850 50  0000 L CNN
F 2 "" H 788 6800 30  0000 C CNN
F 3 "" H 750 6950 60  0000 C CNN
	1    750  6950
	1    0    0    -1  
$EndComp
$Comp
L LED D?
U 1 1 55BB0719
P 2350 7000
F 0 "D?" H 2350 7100 50  0000 C CNN
F 1 "LED" H 2350 6900 50  0000 C CNN
F 2 "" H 2350 7000 60  0000 C CNN
F 3 "" H 2350 7000 60  0000 C CNN
	1    2350 7000
	0    -1   -1   0   
$EndComp
$Comp
L R R?
U 1 1 55BB071F
P 2350 7400
F 0 "R?" V 2430 7400 50  0000 C CNN
F 1 "R" V 2350 7400 50  0000 C CNN
F 2 "" V 2280 7400 30  0000 C CNN
F 3 "" H 2350 7400 30  0000 C CNN
	1    2350 7400
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 55BB1458
P 2550 6800
F 0 "#PWR?" H 2550 6650 50  0001 C CNN
F 1 "+5V" H 2550 6940 50  0000 C CNN
F 2 "" H 2550 6800 60  0000 C CNN
F 3 "" H 2550 6800 60  0000 C CNN
	1    2550 6800
	1    0    0    -1  
$EndComp
Text GLabel 2450 7650 2    60   Input ~ 0
MGND
Wire Wire Line
	2250 1250 2300 1250
Wire Wire Line
	2950 800  2600 800 
Wire Wire Line
	2600 800  2600 1050
Wire Wire Line
	1750 1550 2600 1550
Wire Wire Line
	2600 1550 2600 1450
Wire Wire Line
	2350 900  1150 900 
Wire Wire Line
	1450 1250 1950 1250
Connection ~ 1200 900 
Wire Wire Line
	1200 900  1200 1250
Wire Wire Line
	1200 1250 1350 1250
Connection ~ 1250 1250
Connection ~ 1750 1250
Wire Wire Line
	2300 1550 2300 1650
Connection ~ 2300 1550
Wire Wire Line
	1150 750  1250 750 
Wire Wire Line
	2350 650  2350 900 
Wire Wire Line
	2350 650  2950 650 
Wire Wire Line
	1000 2500 1200 2500
Wire Wire Line
	2000 2500 2800 2500
Connection ~ 2200 2500
Wire Wire Line
	2600 2900 2600 2950
Wire Wire Line
	2600 3250 2600 3350
Connection ~ 2600 2500
Wire Wire Line
	2200 2800 2200 3350
Wire Wire Line
	1000 2800 1000 3300
Wire Wire Line
	1000 3300 2200 3300
Connection ~ 2200 3300
Wire Wire Line
	1600 2800 1600 3300
Connection ~ 1600 3300
Wire Wire Line
	5150 3150 5150 3400
Connection ~ 5150 3300
Connection ~ 5150 3350
Wire Wire Line
	6250 3150 6250 3400
Connection ~ 6250 3300
Connection ~ 6250 3350
Wire Wire Line
	5150 3150 6250 3150
Connection ~ 6250 3250
Connection ~ 5150 3250
Wire Wire Line
	5150 3950 5150 4200
Connection ~ 5150 4000
Connection ~ 5150 4050
Wire Wire Line
	6250 3950 6250 4200
Connection ~ 6250 4050
Connection ~ 6250 4000
Wire Wire Line
	6250 4200 5150 4200
Connection ~ 6250 4100
Connection ~ 5150 4100
Wire Wire Line
	5150 3750 5150 3900
Connection ~ 5150 3850
Connection ~ 5150 3800
Wire Wire Line
	6250 3750 6250 3900
Connection ~ 6250 3800
Connection ~ 6250 3850
Wire Wire Line
	5150 3450 5150 3600
Connection ~ 5150 3550
Connection ~ 5150 3500
Wire Wire Line
	6250 3450 6250 3600
Connection ~ 6250 3500
Connection ~ 6250 3550
Wire Wire Line
	6250 3650 6750 3650
Connection ~ 6550 3650
Wire Wire Line
	6250 3700 6400 3700
Wire Wire Line
	6400 3700 6400 3800
Wire Wire Line
	6400 3800 6750 3800
Wire Wire Line
	6550 3650 6550 3850
Wire Wire Line
	6550 4150 6550 4200
Wire Wire Line
	5000 3800 5150 3800
Wire Wire Line
	4750 3550 4750 4200
Wire Wire Line
	4750 3550 5150 3550
Wire Wire Line
	6250 3850 6350 3850
Wire Wire Line
	6350 3850 6350 4200
Wire Wire Line
	5150 3650 4850 3650
Wire Wire Line
	4850 3650 4850 3600
Wire Wire Line
	4850 3600 4550 3600
Wire Wire Line
	4550 3700 5150 3700
Wire Wire Line
	5500 6500 5800 6500
Wire Wire Line
	5650 6800 5650 6850
Wire Wire Line
	5500 6500 5500 6550
Connection ~ 5650 6500
Wire Wire Line
	5650 7350 5650 7250
Connection ~ 5350 6850
Wire Wire Line
	5500 6850 5350 6850
Connection ~ 5650 7350
Wire Wire Line
	5600 5450 5900 5450
Wire Wire Line
	5750 5750 5750 5800
Wire Wire Line
	5600 5450 5600 5500
Connection ~ 5750 5450
Wire Wire Line
	5750 6300 5750 6200
Wire Wire Line
	5600 5800 5450 5800
Connection ~ 5750 6300
Wire Wire Line
	5450 5800 5450 6150
Connection ~ 5450 6000
Wire Wire Line
	4300 6150 3750 6150
Wire Wire Line
	3750 6150 3750 6000
Wire Wire Line
	4300 6300 4250 6300
Wire Wire Line
	3950 6300 3750 6300
Wire Wire Line
	3350 6500 3450 6500
Wire Wire Line
	3750 6800 3750 6700
Wire Wire Line
	3350 6800 3750 6800
Connection ~ 3400 6800
Connection ~ 3400 6500
Wire Wire Line
	3850 7150 3650 7150
Wire Wire Line
	3250 7350 3350 7350
Wire Wire Line
	3650 7650 3650 7550
Wire Wire Line
	3250 7650 3650 7650
Connection ~ 3300 7650
Connection ~ 3300 7350
Wire Wire Line
	4300 6450 3850 6450
Wire Wire Line
	4150 6600 4300 6600
Wire Wire Line
	3850 6450 3850 7050
Wire Wire Line
	3850 7050 3300 7050
Wire Wire Line
	5000 6450 5350 6450
Wire Wire Line
	5350 6450 5350 7050
Wire Wire Line
	5000 6600 5200 6600
Wire Wire Line
	5200 6600 5200 7350
Connection ~ 5200 7350
Wire Wire Line
	5200 7350 5750 7350
Wire Wire Line
	5850 6300 5000 6300
Wire Wire Line
	5450 6150 5000 6150
Wire Wire Line
	4150 7150 4150 6600
Wire Wire Line
	700  6800 950  6800
Wire Wire Line
	1750 6800 2550 6800
Connection ~ 1950 6800
Wire Wire Line
	2350 7200 2350 7250
Wire Wire Line
	2350 7550 2350 7650
Connection ~ 2350 6800
Wire Wire Line
	1950 7100 1950 7650
Wire Wire Line
	750  7100 750  7600
Wire Wire Line
	750  7600 1950 7600
Connection ~ 1950 7600
Wire Wire Line
	1350 7100 1350 7600
Connection ~ 1350 7600
Wire Wire Line
	1950 7650 2450 7650
Connection ~ 2350 7650
Text GLabel 700  6800 0    60   Input ~ 0
MV
Connection ~ 750  6800
$Comp
L TLP621-2 U?
U 1 1 55BB276D
P 8950 5150
F 0 "U?" H 8950 4650 60  0000 C CNN
F 1 "TLP621-2" H 8950 4750 60  0000 C CNN
F 2 "" H 9000 5100 60  0000 C CNN
F 3 "" H 9000 5100 60  0000 C CNN
	1    8950 5150
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 55BB2773
P 10100 5300
F 0 "#PWR?" H 10100 5150 50  0001 C CNN
F 1 "+5V" H 10100 5440 50  0000 C CNN
F 2 "" H 10100 5300 60  0000 C CNN
F 3 "" H 10100 5300 60  0000 C CNN
	1    10100 5300
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BB2779
P 9950 5450
F 0 "R?" V 10030 5450 50  0000 C CNN
F 1 "1k" V 9950 5450 50  0000 C CNN
F 2 "" V 9880 5450 30  0000 C CNN
F 3 "" H 9950 5450 30  0000 C CNN
	1    9950 5450
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BB277F
P 9800 5500
F 0 "R?" V 9880 5500 50  0000 C CNN
F 1 "300" V 9800 5500 50  0000 C CNN
F 2 "" V 9730 5500 30  0000 C CNN
F 3 "" H 9800 5500 30  0000 C CNN
	1    9800 5500
	1    0    0    -1  
$EndComp
$Comp
L Q_NMOS_GDS Q?
U 1 1 55BB2785
P 9850 5850
F 0 "Q?" H 10150 5900 50  0000 R CNN
F 1 "Q_NMOS_GDS" H 10500 5800 50  0000 R CNN
F 2 "" H 10050 5950 29  0000 C CNN
F 3 "" H 9850 5850 60  0000 C CNN
	1    9850 5850
	1    0    0    -1  
$EndComp
Text GLabel 10050 6150 2    60   Input ~ 0
MGND
$Comp
L R R?
U 1 1 55BB278C
P 10050 4400
F 0 "R?" V 10130 4400 50  0000 C CNN
F 1 "1k" V 10050 4400 50  0000 C CNN
F 2 "" V 9980 4400 30  0000 C CNN
F 3 "" H 10050 4400 30  0000 C CNN
	1    10050 4400
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BB2792
P 9900 4450
F 0 "R?" V 9980 4450 50  0000 C CNN
F 1 "300" V 9900 4450 50  0000 C CNN
F 2 "" V 9830 4450 30  0000 C CNN
F 3 "" H 9900 4450 30  0000 C CNN
	1    9900 4450
	1    0    0    -1  
$EndComp
$Comp
L Q_NMOS_GDS Q?
U 1 1 55BB2798
P 9950 4800
F 0 "Q?" H 10250 4850 50  0000 R CNN
F 1 "Q_NMOS_GDS" H 10600 4750 50  0000 R CNN
F 2 "" H 10150 4900 29  0000 C CNN
F 3 "" H 9950 4800 60  0000 C CNN
	1    9950 4800
	1    0    0    -1  
$EndComp
Text GLabel 10150 5100 2    60   Input ~ 0
MGND
Text GLabel 7650 5300 0    60   Input ~ 0
IN2_IN
Text GLabel 7650 5600 0    60   Input ~ 0
SIG_GND
$Comp
L Q_NMOS_GDS Q?
U 1 1 55BB27A8
P 7950 5300
F 0 "Q?" H 8250 5350 50  0000 R CNN
F 1 "Q_NMOS_GDS" H 8600 5250 50  0000 R CNN
F 2 "" H 8150 5400 29  0000 C CNN
F 3 "" H 7950 5300 60  0000 C CNN
	1    7950 5300
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BB27AE
P 8400 5100
F 0 "R?" V 8480 5100 50  0000 C CNN
F 1 "180" V 8400 5100 50  0000 C CNN
F 2 "" V 8330 5100 30  0000 C CNN
F 3 "" H 8400 5100 30  0000 C CNN
	1    8400 5100
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 55BB27B4
P 7700 5450
F 0 "R?" V 7780 5450 50  0000 C CNN
F 1 "1k" V 7700 5450 50  0000 C CNN
F 2 "" V 7630 5450 30  0000 C CNN
F 3 "" H 7700 5450 30  0000 C CNN
	1    7700 5450
	1    0    0    -1  
$EndComp
Text GLabel 7550 6150 0    60   Input ~ 0
IN1_IN
Text GLabel 7550 6450 0    60   Input ~ 0
SIG_GND
$Comp
L Q_NMOS_GDS Q?
U 1 1 55BB27BC
P 7850 6150
F 0 "Q?" H 8150 6200 50  0000 R CNN
F 1 "Q_NMOS_GDS" H 8500 6100 50  0000 R CNN
F 2 "" H 8050 6250 29  0000 C CNN
F 3 "" H 7850 6150 60  0000 C CNN
	1    7850 6150
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 55BB27C2
P 8300 5950
F 0 "R?" V 8380 5950 50  0000 C CNN
F 1 "180" V 8300 5950 50  0000 C CNN
F 2 "" V 8230 5950 30  0000 C CNN
F 3 "" H 8300 5950 30  0000 C CNN
	1    8300 5950
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 55BB27C8
P 7600 6300
F 0 "R?" V 7680 6300 50  0000 C CNN
F 1 "1k" V 7600 6300 50  0000 C CNN
F 2 "" V 7530 6300 30  0000 C CNN
F 3 "" H 7600 6300 30  0000 C CNN
	1    7600 6300
	1    0    0    -1  
$EndComp
Text GLabel 7600 5850 0    60   Input ~ 0
SIG_VCC
Wire Wire Line
	9800 5300 10100 5300
Wire Wire Line
	9950 5600 9950 5650
Wire Wire Line
	9800 5300 9800 5350
Connection ~ 9950 5300
Wire Wire Line
	9950 6150 9950 6050
Connection ~ 9650 5650
Wire Wire Line
	9800 5650 9650 5650
Connection ~ 9950 6150
Wire Wire Line
	9900 4250 10200 4250
Wire Wire Line
	10050 4550 10050 4600
Wire Wire Line
	9900 4250 9900 4300
Connection ~ 10050 4250
Wire Wire Line
	10050 5100 10050 5000
Wire Wire Line
	9900 4600 9750 4600
Connection ~ 10050 5100
Wire Wire Line
	9750 4600 9750 4950
Connection ~ 9750 4800
Wire Wire Line
	7950 4950 8600 4950
Wire Wire Line
	8600 5100 8550 5100
Wire Wire Line
	8250 5100 8050 5100
Wire Wire Line
	7650 5300 7750 5300
Wire Wire Line
	8050 5600 8050 5500
Wire Wire Line
	7650 5600 8050 5600
Connection ~ 7700 5600
Connection ~ 7700 5300
Wire Wire Line
	8150 5950 7950 5950
Wire Wire Line
	7550 6150 7650 6150
Wire Wire Line
	7950 6450 7950 6350
Wire Wire Line
	7550 6450 7950 6450
Connection ~ 7600 6450
Connection ~ 7600 6150
Wire Wire Line
	8600 5250 8150 5250
Wire Wire Line
	8450 5400 8600 5400
Wire Wire Line
	8150 5250 8150 5850
Wire Wire Line
	8150 5850 7600 5850
Wire Wire Line
	9300 5250 9650 5250
Wire Wire Line
	9650 5250 9650 5850
Wire Wire Line
	9300 5400 9500 5400
Wire Wire Line
	9500 5400 9500 6150
Connection ~ 9500 6150
Wire Wire Line
	9500 6150 10050 6150
Wire Wire Line
	10150 5100 9300 5100
Wire Wire Line
	9750 4950 9300 4950
Wire Wire Line
	8450 5950 8450 5400
Text GLabel 7950 4950 0    60   Input ~ 0
SIG_VCC
$Comp
L +5V #PWR?
U 1 1 55BB3A5D
P 10200 4250
F 0 "#PWR?" H 10200 4100 50  0001 C CNN
F 1 "+5V" H 10200 4390 50  0000 C CNN
F 2 "" H 10200 4250 60  0000 C CNN
F 3 "" H 10200 4250 60  0000 C CNN
	1    10200 4250
	1    0    0    -1  
$EndComp
Text GLabel 10250 4600 2    60   Input ~ 0
IN2_OUT
Wire Wire Line
	10050 4600 10250 4600
Text GLabel 10150 5650 2    60   Input ~ 0
IN1_OUT
Wire Wire Line
	9950 5650 10150 5650
$EndSCHEMATC
