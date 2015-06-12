EESchema Schematic File Version 2
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
LIBS:HubBoard-cache
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
L PSOC3_CY8C38_FAMILY_100 U1
U 1 1 5578950C
P 5900 5400
F 0 "U1" H 4300 8850 60  0000 C CNN
F 1 "PSOC3_CY8C38_FAMILY_100" H 5900 6900 60  0000 C CNN
F 2 "" H 5900 5400 60  0000 C CNN
F 3 "" H 5900 5400 60  0000 C CNN
	1    5900 5400
	1    0    0    -1  
$EndComp
$Comp
L C 0.1u1
U 1 1 557898C2
P 4150 1750
F 0 "0.1u1" H 4175 1850 50  0000 L CNN
F 1 "C" H 4175 1650 50  0000 L CNN
F 2 "" H 4188 1600 30  0000 C CNN
F 3 "" H 4150 1750 60  0000 C CNN
	1    4150 1750
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR2
U 1 1 55789955
P 4150 1550
F 0 "#PWR2" H 4150 1400 50  0001 C CNN
F 1 "+5V" H 4150 1690 50  0000 C CNN
F 2 "" H 4150 1550 60  0000 C CNN
F 3 "" H 4150 1550 60  0000 C CNN
	1    4150 1550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR3
U 1 1 55789979
P 4150 2000
F 0 "#PWR3" H 4150 1750 50  0001 C CNN
F 1 "GND" H 4150 1850 50  0000 C CNN
F 2 "" H 4150 2000 60  0000 C CNN
F 3 "" H 4150 2000 60  0000 C CNN
	1    4150 2000
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR6
U 1 1 557899AC
P 4850 1400
F 0 "#PWR6" H 4850 1250 50  0001 C CNN
F 1 "+5V" H 4850 1540 50  0000 C CNN
F 2 "" H 4850 1400 60  0000 C CNN
F 3 "" H 4850 1400 60  0000 C CNN
	1    4850 1400
	1    0    0    -1  
$EndComp
$Comp
L C 1u1
U 1 1 557899C2
P 4850 1550
F 0 "1u1" H 4875 1650 50  0000 L CNN
F 1 "C" H 4875 1450 50  0000 L CNN
F 2 "" H 4888 1400 30  0000 C CNN
F 3 "" H 4850 1550 60  0000 C CNN
	1    4850 1550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR7
U 1 1 55789A06
P 4850 1700
F 0 "#PWR7" H 4850 1450 50  0001 C CNN
F 1 "GND" H 4850 1550 50  0000 C CNN
F 2 "" H 4850 1700 60  0000 C CNN
F 3 "" H 4850 1700 60  0000 C CNN
	1    4850 1700
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR9
U 1 1 55789C08
P 6000 1200
F 0 "#PWR9" H 6000 1050 50  0001 C CNN
F 1 "+5V" H 6000 1340 50  0000 C CNN
F 2 "" H 6000 1200 60  0000 C CNN
F 3 "" H 6000 1200 60  0000 C CNN
	1    6000 1200
	1    0    0    -1  
$EndComp
$Comp
L C 0.1u4
U 1 1 55789C1F
P 6000 1350
F 0 "0.1u4" H 6025 1450 50  0000 L CNN
F 1 "C" H 6025 1250 50  0000 L CNN
F 2 "" H 6038 1200 30  0000 C CNN
F 3 "" H 6000 1350 60  0000 C CNN
	1    6000 1350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR10
U 1 1 55789C5E
P 6150 1600
F 0 "#PWR10" H 6150 1350 50  0001 C CNN
F 1 "GND" H 6150 1450 50  0000 C CNN
F 2 "" H 6150 1600 60  0000 C CNN
F 3 "" H 6150 1600 60  0000 C CNN
	1    6150 1600
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR11
U 1 1 55789CA8
P 6350 1550
F 0 "#PWR11" H 6350 1400 50  0001 C CNN
F 1 "+5V" H 6350 1690 50  0000 C CNN
F 2 "" H 6350 1550 60  0000 C CNN
F 3 "" H 6350 1550 60  0000 C CNN
	1    6350 1550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR1
U 1 1 55789F4A
P 3300 3550
F 0 "#PWR1" H 3300 3300 50  0001 C CNN
F 1 "GND" H 3300 3400 50  0000 C CNN
F 2 "" H 3300 3550 60  0000 C CNN
F 3 "" H 3300 3550 60  0000 C CNN
	1    3300 3550
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR4
U 1 1 5578A295
P 4400 5650
F 0 "#PWR4" H 4400 5500 50  0001 C CNN
F 1 "+5V" H 4400 5790 50  0000 C CNN
F 2 "" H 4400 5650 60  0000 C CNN
F 3 "" H 4400 5650 60  0000 C CNN
	1    4400 5650
	1    0    0    -1  
$EndComp
$Comp
L C 0.1u2
U 1 1 5578A2C9
P 4400 5800
F 0 "0.1u2" H 4425 5900 50  0000 L CNN
F 1 "C" H 4425 5700 50  0000 L CNN
F 2 "" H 4438 5650 30  0000 C CNN
F 3 "" H 4400 5800 60  0000 C CNN
	1    4400 5800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR5
U 1 1 5578A2FD
P 4400 5950
F 0 "#PWR5" H 4400 5700 50  0001 C CNN
F 1 "GND" H 4400 5800 50  0000 C CNN
F 2 "" H 4400 5950 60  0000 C CNN
F 3 "" H 4400 5950 60  0000 C CNN
	1    4400 5950
	1    0    0    -1  
$EndComp
$Comp
L C 0.1u3
U 1 1 5578A41E
P 5700 6050
F 0 "0.1u3" H 5725 6150 50  0000 L CNN
F 1 "C" H 5725 5950 50  0000 L CNN
F 2 "" H 5738 5900 30  0000 C CNN
F 3 "" H 5700 6050 60  0000 C CNN
	1    5700 6050
	1    0    0    -1  
$EndComp
$Comp
L C 1u2
U 1 1 5578A455
P 6100 6050
F 0 "1u2" H 6125 6150 50  0000 L CNN
F 1 "C" H 6125 5950 50  0000 L CNN
F 2 "" H 6138 5900 30  0000 C CNN
F 3 "" H 6100 6050 60  0000 C CNN
	1    6100 6050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR8
U 1 1 5578A4CC
P 5900 6300
F 0 "#PWR8" H 5900 6050 50  0001 C CNN
F 1 "GND" H 5900 6150 50  0000 C CNN
F 2 "" H 5900 6300 60  0000 C CNN
F 3 "" H 5900 6300 60  0000 C CNN
	1    5900 6300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR14
U 1 1 5578A89C
P 7350 5950
F 0 "#PWR14" H 7350 5700 50  0001 C CNN
F 1 "GND" H 7350 5800 50  0000 C CNN
F 2 "" H 7350 5950 60  0000 C CNN
F 3 "" H 7350 5950 60  0000 C CNN
	1    7350 5950
	1    0    0    -1  
$EndComp
$Comp
L C 0.1u5
U 1 1 5578A8B7
P 7350 5800
F 0 "0.1u5" H 7375 5900 50  0000 L CNN
F 1 "C" H 7375 5700 50  0000 L CNN
F 2 "" H 7388 5650 30  0000 C CNN
F 3 "" H 7350 5800 60  0000 C CNN
	1    7350 5800
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR13
U 1 1 5578A916
P 7350 5650
F 0 "#PWR13" H 7350 5500 50  0001 C CNN
F 1 "+5V" H 7350 5790 50  0000 C CNN
F 2 "" H 7350 5650 60  0000 C CNN
F 3 "" H 7350 5650 60  0000 C CNN
	1    7350 5650
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR15
U 1 1 5578ACDF
P 8000 2350
F 0 "#PWR15" H 8000 2200 50  0001 C CNN
F 1 "+5V" H 8000 2490 50  0000 C CNN
F 2 "" H 8000 2350 60  0000 C CNN
F 3 "" H 8000 2350 60  0000 C CNN
	1    8000 2350
	1    0    0    -1  
$EndComp
$Comp
L C 0.1u6
U 1 1 5578ACFB
P 8000 2500
F 0 "0.1u6" H 8025 2600 50  0000 L CNN
F 1 "C" H 8025 2400 50  0000 L CNN
F 2 "" H 8038 2350 30  0000 C CNN
F 3 "" H 8000 2500 60  0000 C CNN
	1    8000 2500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR16
U 1 1 5578AD23
P 8000 2650
F 0 "#PWR16" H 8000 2400 50  0001 C CNN
F 1 "GND" H 8000 2500 50  0000 C CNN
F 2 "" H 8000 2650 60  0000 C CNN
F 3 "" H 8000 2650 60  0000 C CNN
	1    8000 2650
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR17
U 1 1 5578ADC3
P 8050 3450
F 0 "#PWR17" H 8050 3300 50  0001 C CNN
F 1 "+5V" H 8050 3590 50  0000 C CNN
F 2 "" H 8050 3450 60  0000 C CNN
F 3 "" H 8050 3450 60  0000 C CNN
	1    8050 3450
	1    0    0    -1  
$EndComp
$Comp
L C 0.1u7
U 1 1 5578AE50
P 8300 3900
F 0 "0.1u7" H 8325 4000 50  0000 L CNN
F 1 "C" H 8325 3800 50  0000 L CNN
F 2 "" H 8338 3750 30  0000 C CNN
F 3 "" H 8300 3900 60  0000 C CNN
	1    8300 3900
	1    0    0    -1  
$EndComp
$Comp
L C 1u3
U 1 1 5578AECF
P 7850 3900
F 0 "1u3" H 7875 4000 50  0000 L CNN
F 1 "C" H 7875 3800 50  0000 L CNN
F 2 "" H 7888 3750 30  0000 C CNN
F 3 "" H 7850 3900 60  0000 C CNN
	1    7850 3900
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR18
U 1 1 5578AFD3
P 8050 4050
F 0 "#PWR18" H 8050 3800 50  0001 C CNN
F 1 "GND" H 8050 3900 50  0000 C CNN
F 2 "" H 8050 4050 60  0000 C CNN
F 3 "" H 8050 4050 60  0000 C CNN
	1    8050 4050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR20
U 1 1 5578B330
P 8350 2650
F 0 "#PWR20" H 8350 2400 50  0001 C CNN
F 1 "GND" H 8350 2500 50  0000 C CNN
F 2 "" H 8350 2650 60  0000 C CNN
F 3 "" H 8350 2650 60  0000 C CNN
	1    8350 2650
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR19
U 1 1 5578B34F
P 8350 2350
F 0 "#PWR19" H 8350 2200 50  0001 C CNN
F 1 "+5V" H 8350 2490 50  0000 C CNN
F 2 "" H 8350 2350 60  0000 C CNN
F 3 "" H 8350 2350 60  0000 C CNN
	1    8350 2350
	1    0    0    -1  
$EndComp
$Comp
L C 1u4
U 1 1 5578B36E
P 8350 2500
F 0 "1u4" H 8375 2600 50  0000 L CNN
F 1 "C" H 8375 2400 50  0000 L CNN
F 2 "" H 8388 2350 30  0000 C CNN
F 3 "" H 8350 2500 60  0000 C CNN
	1    8350 2500
	1    0    0    -1  
$EndComp
$Comp
L Crystal Y1
U 1 1 5578A5C0
P 6550 5950
F 0 "Y1" H 6550 6100 50  0000 C CNN
F 1 "Crystal" H 6550 5800 50  0000 C CNN
F 2 "" H 6550 5950 60  0000 C CNN
F 3 "" H 6550 5950 60  0000 C CNN
	1    6550 5950
	-1   0    0    1   
$EndComp
$Comp
L C 15p1
U 1 1 5578A7B3
P 6350 6200
F 0 "15p1" H 6150 6100 50  0000 L CNN
F 1 "C" H 6375 6100 50  0000 L CNN
F 2 "" H 6388 6050 30  0000 C CNN
F 3 "" H 6350 6200 60  0000 C CNN
	1    6350 6200
	1    0    0    -1  
$EndComp
$Comp
L C 15p2
U 1 1 5578A7FC
P 6750 6200
F 0 "15p2" H 6775 6300 50  0000 L CNN
F 1 "C" H 6775 6100 50  0000 L CNN
F 2 "" H 6788 6050 30  0000 C CNN
F 3 "" H 6750 6200 60  0000 C CNN
	1    6750 6200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR12
U 1 1 5578A9B2
P 6550 6350
F 0 "#PWR12" H 6550 6100 50  0001 C CNN
F 1 "GND" H 6550 6200 50  0000 C CNN
F 2 "" H 6550 6350 60  0000 C CNN
F 3 "" H 6550 6350 60  0000 C CNN
	1    6550 6350
	1    0    0    -1  
$EndComp
$Comp
L DF3_UART U?
U 1 1 5578C07A
P 950 5500
F 0 "U?" H 1200 5250 60  0000 C CNN
F 1 "DF3_UART" H 950 5800 60  0000 C CNN
F 2 "" H 900 5500 60  0000 C CNN
F 3 "" H 900 5500 60  0000 C CNN
	1    950  5500
	0    -1   -1   0   
$EndComp
$Comp
L DF3_UART U?
U 1 1 5578D54D
P 950 6100
F 0 "U?" H 1200 5850 60  0000 C CNN
F 1 "DF3_UART" H 950 6400 60  0000 C CNN
F 2 "" H 900 6100 60  0000 C CNN
F 3 "" H 900 6100 60  0000 C CNN
	1    950  6100
	0    -1   -1   0   
$EndComp
$Comp
L DF3_UART U?
U 1 1 5578D824
P 950 6700
F 0 "U?" H 1200 6450 60  0000 C CNN
F 1 "DF3_UART" H 950 7000 60  0000 C CNN
F 2 "" H 900 6700 60  0000 C CNN
F 3 "" H 900 6700 60  0000 C CNN
	1    950  6700
	0    -1   -1   0   
$EndComp
$Comp
L DF3_UART U?
U 1 1 5578D965
P 950 7300
F 0 "U?" H 1200 7050 60  0000 C CNN
F 1 "DF3_UART" H 950 7600 60  0000 C CNN
F 2 "" H 900 7300 60  0000 C CNN
F 3 "" H 900 7300 60  0000 C CNN
	1    950  7300
	0    -1   -1   0   
$EndComp
Text GLabel 1200 5350 2    60   Input ~ 0
RX_1
Text GLabel 1200 5450 2    60   Input ~ 0
TX_1
Text GLabel 1200 5950 2    60   Input ~ 0
RX_2
Text GLabel 1200 6050 2    60   Input ~ 0
TX_2
Text GLabel 1200 6550 2    60   Input ~ 0
RX_3
Text GLabel 1200 6650 2    60   Input ~ 0
TX_3
Text GLabel 1200 7150 2    60   Input ~ 0
RX_4
Text GLabel 1200 7250 2    60   Input ~ 0
TX_4
$Comp
L GND #PWR?
U 1 1 5578F5B9
P 1400 7350
F 0 "#PWR?" H 1400 7100 50  0001 C CNN
F 1 "GND" H 1400 7200 50  0000 C CNN
F 2 "" H 1400 7350 60  0000 C CNN
F 3 "" H 1400 7350 60  0000 C CNN
	1    1400 7350
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR?
U 1 1 5578F665
P 1400 7450
F 0 "#PWR?" H 1400 7300 50  0001 C CNN
F 1 "+5V" H 1450 7600 50  0000 C CNN
F 2 "" H 1400 7450 60  0000 C CNN
F 3 "" H 1400 7450 60  0000 C CNN
	1    1400 7450
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 5578F69D
P 1350 6750
F 0 "#PWR?" H 1350 6500 50  0001 C CNN
F 1 "GND" H 1350 6600 50  0000 C CNN
F 2 "" H 1350 6750 60  0000 C CNN
F 3 "" H 1350 6750 60  0000 C CNN
	1    1350 6750
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR?
U 1 1 5578F6A3
P 1350 6850
F 0 "#PWR?" H 1350 6700 50  0001 C CNN
F 1 "+5V" H 1400 7000 50  0000 C CNN
F 2 "" H 1350 6850 60  0000 C CNN
F 3 "" H 1350 6850 60  0000 C CNN
	1    1350 6850
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 5578F8F6
P 1350 6150
F 0 "#PWR?" H 1350 5900 50  0001 C CNN
F 1 "GND" H 1350 6000 50  0000 C CNN
F 2 "" H 1350 6150 60  0000 C CNN
F 3 "" H 1350 6150 60  0000 C CNN
	1    1350 6150
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR?
U 1 1 5578F8FC
P 1350 6250
F 0 "#PWR?" H 1350 6100 50  0001 C CNN
F 1 "+5V" H 1400 6400 50  0000 C CNN
F 2 "" H 1350 6250 60  0000 C CNN
F 3 "" H 1350 6250 60  0000 C CNN
	1    1350 6250
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 5578FA32
P 1350 5550
F 0 "#PWR?" H 1350 5300 50  0001 C CNN
F 1 "GND" H 1350 5400 50  0000 C CNN
F 2 "" H 1350 5550 60  0000 C CNN
F 3 "" H 1350 5550 60  0000 C CNN
	1    1350 5550
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR?
U 1 1 5578FA38
P 1350 5650
F 0 "#PWR?" H 1350 5500 50  0001 C CNN
F 1 "+5V" H 1400 5800 50  0000 C CNN
F 2 "" H 1350 5650 60  0000 C CNN
F 3 "" H 1350 5650 60  0000 C CNN
	1    1350 5650
	0    1    1    0   
$EndComp
Text GLabel 4100 2550 0    60   Input ~ 0
RX_1
Text GLabel 4100 2650 0    60   Input ~ 0
TX_1
Text GLabel 4100 3050 0    60   Input ~ 0
RX_2
Text GLabel 4100 3150 0    60   Input ~ 0
TX_2
Text GLabel 4100 4050 0    60   Input ~ 0
RX_3
Text GLabel 4100 4150 0    60   Input ~ 0
TX_3
Text GLabel 4100 4650 0    60   Input ~ 0
RX_4
Text GLabel 4100 4750 0    60   Input ~ 0
TX_4
$Comp
L TA48M05F U?
U 1 1 557923D1
P 1150 4500
F 0 "U?" H 1250 4300 60  0000 C CNN
F 1 "TA48M05F" H 1150 4650 60  0000 C CNN
F 2 "" H 1150 4500 60  0000 C CNN
F 3 "" H 1150 4500 60  0000 C CNN
	1    1150 4500
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 55792810
P 1650 4500
F 0 "#PWR?" H 1650 4350 50  0001 C CNN
F 1 "+5V" H 1650 4640 50  0000 C CNN
F 2 "" H 1650 4500 60  0000 C CNN
F 3 "" H 1650 4500 60  0000 C CNN
	1    1650 4500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 55792898
P 1150 4800
F 0 "#PWR?" H 1150 4550 50  0001 C CNN
F 1 "GND" H 1150 4650 50  0000 C CNN
F 2 "" H 1150 4800 60  0000 C CNN
F 3 "" H 1150 4800 60  0000 C CNN
	1    1150 4800
	1    0    0    -1  
$EndComp
$Comp
L C 33u
U 1 1 55792B54
P 1600 4650
F 0 "33u" H 1625 4750 50  0000 L CNN
F 1 "C" H 1625 4550 50  0000 L CNN
F 2 "" H 1638 4500 30  0000 C CNN
F 3 "" H 1600 4650 60  0000 C CNN
	1    1600 4650
	1    0    0    -1  
$EndComp
$Comp
L +9V #PWR?
U 1 1 55792B92
P 650 4500
F 0 "#PWR?" H 650 4350 50  0001 C CNN
F 1 "+9V" H 650 4640 50  0000 C CNN
F 2 "" H 650 4500 60  0000 C CNN
F 3 "" H 650 4500 60  0000 C CNN
	1    650  4500
	1    0    0    -1  
$EndComp
$Comp
L C 0.1u
U 1 1 55792C1D
P 700 4650
F 0 "0.1u" H 725 4750 50  0000 L CNN
F 1 "C" H 725 4550 50  0000 L CNN
F 2 "" H 738 4500 30  0000 C CNN
F 3 "" H 700 4650 60  0000 C CNN
	1    700  4650
	1    0    0    -1  
$EndComp
$Comp
L NJM2360A U?
U 1 1 557945F0
P 10100 5950
F 0 "U?" H 10100 5650 60  0000 C CNN
F 1 "NJM2360A" H 10100 6300 60  0000 C CNN
F 2 "" H 10100 5950 60  0000 C CNN
F 3 "" H 10100 5950 60  0000 C CNN
	1    10100 5950
	1    0    0    -1  
$EndComp
$Comp
L +24V #PWR?
U 1 1 5579516E
P 11000 5650
F 0 "#PWR?" H 11000 5500 50  0001 C CNN
F 1 "+24V" H 11000 5790 50  0000 C CNN
F 2 "" H 11000 5650 60  0000 C CNN
F 3 "" H 11000 5650 60  0000 C CNN
	1    11000 5650
	1    0    0    -1  
$EndComp
$Comp
L CP1 100u
U 1 1 55795218
P 11000 6150
F 0 "100u" H 11025 6250 50  0000 L CNN
F 1 "CP1" H 11025 6050 50  0000 L CNN
F 2 "" H 11000 6150 60  0000 C CNN
F 3 "" H 11000 6150 60  0000 C CNN
	1    11000 6150
	1    0    0    -1  
$EndComp
$Comp
L R 0.33
U 1 1 55795307
P 10800 5650
F 0 "0.33" V 10880 5650 50  0000 C CNN
F 1 "R" V 10800 5650 50  0000 C CNN
F 2 "" V 10730 5650 30  0000 C CNN
F 3 "" H 10800 5650 30  0000 C CNN
	1    10800 5650
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 55795741
P 11000 6300
F 0 "#PWR?" H 11000 6050 50  0001 C CNN
F 1 "GND" H 11000 6150 50  0000 C CNN
F 2 "" H 11000 6300 60  0000 C CNN
F 3 "" H 11000 6300 60  0000 C CNN
	1    11000 6300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5579576E
P 9800 6300
F 0 "#PWR?" H 9800 6050 50  0001 C CNN
F 1 "GND" H 9800 6150 50  0000 C CNN
F 2 "" H 9800 6300 60  0000 C CNN
F 3 "" H 9800 6300 60  0000 C CNN
	1    9800 6300
	1    0    0    -1  
$EndComp
$Comp
L INDUCTOR 220u
U 1 1 5579580E
P 9150 5900
F 0 "220u" V 9100 5900 50  0000 C CNN
F 1 "INDUCTOR" V 9250 5900 50  0000 C CNN
F 2 "" H 9150 5900 60  0000 C CNN
F 3 "" H 9150 5900 60  0000 C CNN
	1    9150 5900
	0    -1   -1   0   
$EndComp
$Comp
L D D?
U 1 1 557960D1
P 9450 6150
F 0 "D?" H 9450 6250 50  0000 C CNN
F 1 "D" H 9450 6050 50  0000 C CNN
F 2 "" H 9450 6150 60  0000 C CNN
F 3 "" H 9450 6150 60  0000 C CNN
	1    9450 6150
	0    1    1    0   
$EndComp
Wire Wire Line
	4150 1550 4150 1600
Wire Wire Line
	4150 1900 4150 2000
Wire Wire Line
	4150 1600 4700 1600
Wire Wire Line
	4700 1600 4700 1950
Wire Wire Line
	6000 1200 5900 1200
Wire Wire Line
	5900 1200 5900 1950
Wire Wire Line
	6000 1500 6000 1950
Wire Wire Line
	6000 1550 6150 1550
Wire Wire Line
	6150 1550 6150 1600
Connection ~ 6000 1550
Wire Wire Line
	6100 1950 6100 1850
Wire Wire Line
	6100 1850 6350 1850
Wire Wire Line
	6350 1850 6350 1550
Wire Wire Line
	3300 3450 4100 3450
Wire Wire Line
	3300 3450 3300 3550
Wire Wire Line
	4100 3750 3450 3750
Wire Wire Line
	3450 3450 3450 3850
Connection ~ 3450 3450
Wire Wire Line
	3450 3850 4100 3850
Connection ~ 3450 3750
Wire Wire Line
	4400 5650 4700 5650
Wire Wire Line
	4700 5650 4700 5550
Wire Wire Line
	5800 5550 5800 5650
Wire Wire Line
	5800 5650 5700 5650
Wire Wire Line
	5700 5650 5700 5900
Wire Wire Line
	6000 5550 6000 5650
Wire Wire Line
	6000 5650 6100 5650
Wire Wire Line
	6100 5650 6100 5900
Wire Wire Line
	5900 5550 5900 6300
Wire Wire Line
	5700 6200 6100 6200
Connection ~ 5900 6200
Wire Wire Line
	7100 5550 7100 5650
Wire Wire Line
	7100 5650 7350 5650
Wire Wire Line
	7700 2550 7700 2350
Wire Wire Line
	7700 2350 8000 2350
Wire Wire Line
	8000 2650 7850 2650
Wire Wire Line
	7850 2650 7850 3450
Wire Wire Line
	7850 3450 7700 3450
Wire Wire Line
	7700 3550 8300 3550
Wire Wire Line
	8050 3550 8050 3450
Wire Wire Line
	8300 3550 8300 3750
Connection ~ 8050 3550
Wire Wire Line
	7700 3750 7850 3750
Wire Wire Line
	7850 4050 8300 4050
Wire Wire Line
	7700 3650 8050 3650
Wire Wire Line
	8050 3650 8050 4050
Connection ~ 8050 4050
Wire Wire Line
	6400 5950 6350 5950
Wire Wire Line
	6350 5900 6350 6050
Wire Wire Line
	6700 5950 6750 5950
Wire Wire Line
	6750 5700 6750 6050
Wire Wire Line
	6300 5550 6300 5900
Wire Wire Line
	6300 5900 6350 5900
Connection ~ 6350 5950
Wire Wire Line
	6400 5550 6400 5700
Wire Wire Line
	6400 5700 6750 5700
Connection ~ 6750 5950
Wire Wire Line
	6350 6350 6750 6350
Wire Wire Line
	1050 5350 1200 5350
Wire Wire Line
	1050 5450 1200 5450
Wire Wire Line
	1050 5950 1200 5950
Wire Wire Line
	1050 6050 1200 6050
Wire Wire Line
	1050 6550 1200 6550
Wire Wire Line
	1050 6650 1200 6650
Wire Wire Line
	1050 7150 1200 7150
Wire Wire Line
	1050 7250 1200 7250
Wire Wire Line
	1050 5550 1350 5550
Wire Wire Line
	1050 5650 1350 5650
Wire Wire Line
	1050 6150 1350 6150
Wire Wire Line
	1050 6250 1350 6250
Wire Wire Line
	1050 6750 1350 6750
Wire Wire Line
	1050 6850 1350 6850
Wire Wire Line
	1050 7350 1400 7350
Wire Wire Line
	1050 7450 1400 7450
Wire Wire Line
	1550 4500 1650 4500
Wire Wire Line
	650  4500 750  4500
Wire Wire Line
	700  4800 1600 4800
Connection ~ 1150 4800
Wire Wire Line
	10950 5650 11000 5650
Wire Wire Line
	10400 6000 11000 6000
Wire Wire Line
	11000 6000 11000 5650
Wire Wire Line
	9800 5800 9800 5650
Wire Wire Line
	9800 5650 10650 5650
Wire Wire Line
	10400 5800 10400 5650
Connection ~ 10400 5650
Wire Wire Line
	10400 5900 10500 5900
Wire Wire Line
	10500 5900 10500 5650
Connection ~ 10500 5650
Wire Wire Line
	9800 6100 9800 6300
Wire Wire Line
	9450 5900 9800 5900
Wire Wire Line
	9450 5900 9450 6000
$Comp
L C 470p
U 1 1 557963A3
P 9700 6150
F 0 "470p" H 9600 6250 50  0000 L CNN
F 1 "C" H 9725 6050 50  0000 L CNN
F 2 "" H 9738 6000 30  0000 C CNN
F 3 "" H 9700 6150 60  0000 C CNN
	1    9700 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	9800 6000 9700 6000
$Comp
L GND #PWR?
U 1 1 5579648D
P 9700 6300
F 0 "#PWR?" H 9700 6050 50  0001 C CNN
F 1 "GND" H 9700 6150 50  0000 C CNN
F 2 "" H 9700 6300 60  0000 C CNN
F 3 "" H 9700 6300 60  0000 C CNN
	1    9700 6300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 557964BD
P 9450 6300
F 0 "#PWR?" H 9450 6050 50  0001 C CNN
F 1 "GND" H 9450 6150 50  0000 C CNN
F 2 "" H 9450 6300 60  0000 C CNN
F 3 "" H 9450 6300 60  0000 C CNN
	1    9450 6300
	1    0    0    -1  
$EndComp
$Comp
L CP1 470u
U 1 1 5579659F
P 8850 6100
F 0 "470u" H 8875 6200 50  0000 L CNN
F 1 "CP1" H 8875 6000 50  0000 L CNN
F 2 "" H 8850 6100 60  0000 C CNN
F 3 "" H 8850 6100 60  0000 C CNN
	1    8850 6100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 55796617
P 8850 6300
F 0 "#PWR?" H 8850 6050 50  0001 C CNN
F 1 "GND" H 8850 6150 50  0000 C CNN
F 2 "" H 8850 6300 60  0000 C CNN
F 3 "" H 8850 6300 60  0000 C CNN
	1    8850 6300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8850 6250 8850 6300
Wire Wire Line
	8850 5900 8850 5950
$Comp
L +9V #PWR?
U 1 1 5579673F
P 8650 5900
F 0 "#PWR?" H 8650 5750 50  0001 C CNN
F 1 "+9V" H 8650 6040 50  0000 C CNN
F 2 "" H 8650 5900 60  0000 C CNN
F 3 "" H 8650 5900 60  0000 C CNN
	1    8650 5900
	1    0    0    -1  
$EndComp
$Comp
L R 6.2k
U 1 1 557968D0
P 8550 6050
F 0 "6.2k" V 8630 6050 50  0000 C CNN
F 1 "R" V 8550 6050 50  0000 C CNN
F 2 "" V 8480 6050 30  0000 C CNN
F 3 "" H 8550 6050 30  0000 C CNN
	1    8550 6050
	1    0    0    -1  
$EndComp
$Comp
L R 1k
U 1 1 55796963
P 8400 6200
F 0 "1k" V 8480 6200 50  0000 C CNN
F 1 "R" V 8400 6200 50  0000 C CNN
F 2 "" V 8330 6200 30  0000 C CNN
F 3 "" H 8400 6200 30  0000 C CNN
	1    8400 6200
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 55796C02
P 8250 6300
F 0 "#PWR?" H 8250 6050 50  0001 C CNN
F 1 "GND" H 8250 6150 50  0000 C CNN
F 2 "" H 8250 6300 60  0000 C CNN
F 3 "" H 8250 6300 60  0000 C CNN
	1    8250 6300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8250 6200 8250 6300
Text GLabel 10400 6100 2    60   Input ~ 0
Vth
Text GLabel 8550 6200 2    60   Input ~ 0
Vth
Wire Wire Line
	8550 5900 8850 5900
Connection ~ 8650 5900
$Comp
L CONN_WHITE_5 CN?
U 1 1 55793AC8
P 3050 4600
F 0 "CN?" H 3050 4825 60  0000 C CNN
F 1 "CONN_WHITE_5" H 3050 4175 60  0000 C CNN
F 2 "" H 3050 4600 60  0000 C CNN
F 3 "" H 3050 4600 60  0000 C CNN
	1    3050 4600
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 55793CDD
P 2800 4900
F 0 "#PWR?" H 2800 4750 50  0001 C CNN
F 1 "+5V" H 2700 5050 50  0000 C CNN
F 2 "" H 2800 4900 60  0000 C CNN
F 3 "" H 2800 4900 60  0000 C CNN
	1    2800 4900
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 55793D11
P 2800 4800
F 0 "#PWR?" H 2800 4550 50  0001 C CNN
F 1 "GND" H 2850 4650 50  0000 C CNN
F 2 "" H 2800 4800 60  0000 C CNN
F 3 "" H 2800 4800 60  0000 C CNN
	1    2800 4800
	0    1    1    0   
$EndComp
Wire Wire Line
	4100 3950 2650 3950
Wire Wire Line
	2650 3950 2650 4700
Wire Wire Line
	2650 4700 2800 4700
Wire Wire Line
	3250 4550 4100 4550
Wire Wire Line
	3250 4550 3250 4300
Wire Wire Line
	3250 4300 2500 4300
Wire Wire Line
	2500 4300 2500 4600
Wire Wire Line
	2500 4600 2800 4600
Wire Wire Line
	4100 4450 3350 4450
Wire Wire Line
	3350 4450 3350 4250
Wire Wire Line
	3350 4250 2450 4250
Wire Wire Line
	2450 4250 2450 4500
Wire Wire Line
	2450 4500 2800 4500
$Comp
L Mini-B U?
U 1 1 557957B3
P 5250 6300
F 0 "U?" H 5250 6150 60  0000 C CNN
F 1 "Mini-B" H 5250 6050 60  0000 C CNN
F 2 "" H 5250 6300 60  0000 C CNN
F 3 "" H 5250 6300 60  0000 C CNN
	1    5250 6300
	-1   0    0    1   
$EndComp
Wire Wire Line
	5700 5550 5700 5600
Wire Wire Line
	5700 5600 5650 5600
Wire Wire Line
	5650 5600 5650 5900
Wire Wire Line
	5650 5900 5150 5900
Wire Wire Line
	5150 5900 5150 6250
Wire Wire Line
	5600 5550 5600 5850
Wire Wire Line
	5600 5850 5250 5850
Wire Wire Line
	5250 5850 5250 6250
$Comp
L GND #PWR?
U 1 1 557971DF
P 5450 6250
F 0 "#PWR?" H 5450 6000 50  0001 C CNN
F 1 "GND" H 5450 6100 50  0000 C CNN
F 2 "" H 5450 6250 60  0000 C CNN
F 3 "" H 5450 6250 60  0000 C CNN
	1    5450 6250
	-1   0    0    1   
$EndComp
$EndSCHEMATC
