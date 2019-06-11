-README-

Working uart connection with the computer

Ground, Tx and Rx are respectively on pins 12, 13 and 14
Baud rate is 9600

Displays input from Rx on the 2 first 7 segments displays

Trig and echo from the sensor connect on pins 15 and 16 respectively.

To use, connect the uart to the computer, then open a serial term on the 
com port (9600 baud) and press 'v' (0x76) to get the reading in 
centimeters from the sensor.
