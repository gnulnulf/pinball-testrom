;
; @brief Testrom for Bally MPU35 U6
;
; @version 1.0
; @author Arco van Geest <arco@appeltaart.mine.nu>
; @copyright 2022 Arco van Geest <arco@appeltaart.mine.nu> All right reserved.


;	This testrom is free software: you can redistribute it and/or modify
;	it under the terms of the GNU General Public License as published by
;	the Free Software Foundation, either version 3 of the License, or
;	(at your option) any later version.

;	This testrom is distributed in the hope that it will be useful,
;	but WITHOUT ANY WARRANTY; without even the implied warranty of
;	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;	GNU General Public License for more details.

;	You should have received a copy of the GNU General Public License
;	along with this file.  If not, see <http://www.gnu.org/licenses/>.

; inspired by the testroms from Leon Borré
; 
;
; After poweron all PIA's PA,PB,CA2 and CB2 wil blink.
; Patterns:
; 00000000
; 01010101
; 11111111
; 10101010

; The NMI ( diagnostic switch) triggers the memory test.
;

; ## Assembling
;
; assembler used: alfsembler http://john.ccac.rwth-aachen.de:8000/as/
; d:\Pinball\aswcurr\bin\asw.exe -cpu 6800 -A bally-mpu35-u6-v1.asm
; d:\Pinball\aswcurr\bin\p2bin.exe bally-mpu35-u6-v1.p
;
;
; @date 20210612 Arco van Geest Initial version

	cpu 6800
	; to fill eprom

	org	$5800

	
;	org $A000
	

DATAA	equ 0
DATAB	equ 2
DDRA	equ 0
DDRB	equ 2
CRA		equ 1
CRB		equ	3

;$0000-007F 6810 RAM
;$0088-008B 6821 PIA U10
;$0090-0093 6821 PIA U11
;$0200-02FF 5101 RAM (upper 4 bits only! - ROMs expect lower 4 bits to read high)


PIAU10		equ	$0088
PIAU11		equ	$0090
RAMU7		equ $0000
RAMU7SIZE	equ $80
RAMU8		equ $0200
RAMU8SIZE	equ $100




; PIAU10_CA1 self test switch
; PIAU10_CB1 zero crossing
; PIAU11_CA1 display interrupt
; PIAU11_CB1 J5-32 (pulled down)

; PIAU10_CA2 display enable
; PIAU10_CB2 S25-32 + LAMPSTROBE1
; PIAU11_CA2 diagnostic led + LAMPSTROBE2
; PIAU11_CB2 SOLENOID/SOUNDSELECT

START:
; CRA
;   7   |   6   |  5 4 3   |   2  | 1 0
; IRQA1 | IRQA2 | CA2 CTRL | DDRA | CA1
ONLYBLINK:
	; select DDR
	CLR		PIAU10 + CRA
	CLR		PIAU10 + CRB
	CLR		PIAU11 + CRA
	CLR		PIAU11 + CRB

	; FF is all ports output exepct U10-B
	ldaa	#$FF
	STAA	PIAU10 + DDRA ;switch colum + DISPLAY_SEGMENT+ DISPLAY LATCH
	CLR		PIAU10 + DDRB ;switch return row
	STAA	PIAU11 + DDRA ; DISPLAY LATCH+DISPLAY GIGIT
	STAA	PIAU11 + DDRB ; SOUND + SOLENOIDS

	; 4 = select data register
	ldaa	#$04
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU11 + CRA
	STAA	PIAU11 + CRB
	
	; clear all outputs
	ldab	#$ff
	tba

BLINKLOOP:
	tba
	STAA	PIAU10 + DATAA
;	STAA	PIAU10 + DATAB
	STAA	PIAU11 + DATAA
	STAA	PIAU11 + DATAB
	decb	


	;CA2/CB2 output and follow (bit3=data)
	ldaa	#$30
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU11 + CRA
	STAA	PIAU11 + CRB

; 512kHz int, 8cycles DELAY= 16ns per loop
; 0.5s / 0.000016 = 31250 times

		LDX		#31250
DELAY0b:	DEX
		BNE DELAY0b
		
		
			;CA2/CB2 output and follow (bit3=data)
	ldaa	#$38
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU11 + CRA
	STAA	PIAU11 + CRB

; 512kHz int, 8cycles DELAY= 16ns per loop
; 0.5s / 0.000016 = 31250 times

		LDX		#31250
DELAY0a:	DEX
		BNE DELAY0a
		
		
		
		
		
		BRA BLINKLOOP
		
IRQ:
SWI:

	JMP START


NMI:


MEMTEST:
;
; set RAM to 01010101
MEMTEST55:
	ldx		#RAMU7SIZE-1
	ldaa	#$55
M55LOOP:
	staa	RAMU7,X
	DEX
	bne 	M55LOOP
	staa	RAMU7,X

	ldx		#RAMU7SIZE-2
	ldaa	#$00
M55LOOPa:
	staa	RAMU7,X
	DEX
	bne 	M55LOOPa
	staa	RAMU7,X
	ldaa	RAMU7+RAMU7SIZE-1
	suba	#$55
	bne	MEMTEST55

MEMTESTAA:
	ldx		#RAMU7SIZE-1
	ldaa	#$aa
MAALOOP:
	staa	RAMU7,X
	DEX
	bne 	MAALOOP
	staa	RAMU7,X

	ldx		#RAMU7SIZE-2
	ldaa	#$00
MAALOOPa:
	staa	RAMU7,X
	DEX
	bne 	MAALOOPa
	staa	RAMU7,X
	ldaa	RAMU7+RAMU7SIZE-1
	suba	#$aa
	bne	MEMTESTAA



;	staa	RAMU7;
;	ldaa	#$00
;	staa	RAMU7 & ~(1<<10)
;	staa	RAMU7 & ~(1<<9)
;	staa	RAMU7 & ~(1<<8)
;	staa	RAMU7 & ~(1<<7)
;	staa	RAMU7 & ~(1<<6)
;	staa	RAMU7 & ~(1<<5)
;	staa	RAMU7 & ~(1<<4)
;	staa	RAMU7 & ~(1<<3)
;	staa	RAMU7 & ~(1<<2)
;	staa	RAMU7 & ~(1<<1)
;	staa	RAMU7 & ~(1<<0)

; check if 7ff is still 01010101
;	ldaa	RAMU7
;	suba	#$55
;	bne	MEMTEST55
;
; set 7ff to 10101010
; clear all variants with one cleared address bit
;MEMTESTAA:
;	ldaa	#$AA
;	staa	RAMU7
;	
;	ldaa	#$00
;	staa	RAMU7 & ~(1<<10)
;	staa	RAMU7 & ~(1<<9)
;	staa	RAMU7 & ~(1<<8)
;	staa	RAMU7 & ~(1<<7)
;	staa	RAMU7 & ~(1<<6)
;	staa	RAMU7 & ~(1<<5)
;	staa	RAMU7 & ~(1<<4)
;	staa	RAMU7 & ~(1<<3)
;	staa	RAMU7 & ~(1<<2)
;	staa	RAMU7 & ~(1<<1)
;	staa	RAMU7 & ~(1<<0)
;
;	ldaa	RAMU7
;	suba	#$AA
;	bne	MEMTESTAA
	JMP START

		

VECTOR:
; VECTOR table;
	org $5FF8
; IRQ vector
	dw 	IRQ
; SWI vector
	dw 	SWI
; NMI vector
	dw 	NMI
; reset vector
	dw 	START
