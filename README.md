# Pinball testrom

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
