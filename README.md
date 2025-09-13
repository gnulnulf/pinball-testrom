# Pinball testrom

## MPU35-V3

Test a MPU35 board and read serial output with the status on J4-10 (solenoid bank/select)

When the clock is near 520kHz then it should work with 19200 8n1.
Connect a USB-UART to ground and J4-10 to RX.

The test loops if successfull. FAIL always points to the last message.

This is a work in progress and at the moment it tests:
- PIA U11
- PIA U10
- RAM U7
- RAM U8
- ROM U1 ( u1_mpu35_1000_81.716 )
- ROM U2 ( u2_mpu35_5000_150.716 )
- Show dipswitch state (no fail)
- Display interrupt generator
- Zero crossing interrupt (soft fail)

2bdone:
- arduino to test edge pins (23017?)
- arduino to create zero crossing
- arduino to press NMI/Self test switch
- auto detect clock speed (needs divider)
- display on arduino to make it standalone


## MPU35-V2

Blink lights and show data on displays

## V1
Inspired by the work of Leon Borré I started my own testrom because I wanted some extra tests.

After poweron all PIA's PA,PB,CA2 and CB2 wil blink with the following patterns:
```
  00000000
  01010101
  11111111
  10101010
```

## New 
I am trying to create a working set doing all lamps, display etc.

## usage

Burn the image to an 27256 or 28256 prom. 

If you use a 28256 you need an adapter (28256 pin1 to socket pin27)




The NMI ( diagnostic switch) triggers the memory test.

## assemble

assembler used: alfsembler http://john.ccac.rwth-aachen.de:8000/as/
```
aswcurr/bin/asw.exe -cpu 6800 -A  sys11_testrom_U27_256.asm && \
aswcurr/bin/p2bin.exe  sys11_testrom_U27_256.p 
```


```
d:\Pinball\aswcurr\bin\asw.exe -cpu 6800 -A bally-mpu35-u6-v1.asm
d:\Pinball\aswcurr\bin\p2bin.exe bally-mpu35-u6-v1.p
copy /y bally-mpu35-u6-v1.bin d:\Pinball\roms\hglbtrtr\720-35_6.716
```