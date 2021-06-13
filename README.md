# Pinball testrom

Inspired by the work of Leon Borré I started my own testrom because I wanted some extra tests.

## usage

Burn the image to an 27256 or 28256 prom. 

If you use a 28356 you need an adapter (28256 pin1 to socket pin27)

## assemble

assembler used: alfsembler http://john.ccac.rwth-aachen.de:8000/as/
```
aswcurr/bin/asw.exe -cpu 6800 -A  sys11_testrom_U27_256.asm && \
aswcurr/bin/p2bin.exe  sys11_testrom_U27_256.p 
```