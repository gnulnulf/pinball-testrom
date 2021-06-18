;
; @brief Testrom for Williams System11 (U27)
;
; @version 1.0
; @author Arco van Geest <arco@appeltaart.mine.nu>
; @copyright 2021 Arco van Geest <arco@appeltaart.mine.nu> All right reserved.


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
; aswcurr/bin/asw.exe -cpu 6800 -A  sys11_testrom.asm && \
; aswcurr/bin/p2bin.exe  sys11_testrom.p 
;
;
; @date 20210612 Arco van Geest Initial version

	cpu 6800
	; to fill eprom
	org	$8000
	db	0
	
	org $A000
	

DATAA	equ 0
DATAB	equ 2
DDRA	equ 0
DDRB	equ 2
CRA		equ 1
CRB		equ	3

PIAU10	equ	$2100
PIAU38	equ	$3000
PIAU41	equ	$2c00
PIAU42	equ	$3400
PIAU51	equ	$2800
PIAU54	equ	$2400
U28		equ	$2200

; PIAU10_CA1 n.c.
; PIAU51_PA4 diagnostic led

START:
; CRA
;   7   |   6   |  5 4 3   |   2  | 1 0
; IRQA1 | IRQA2 | CA2 CTRL | DDRA | CA1
ALLOFF:
	; solenoids
	CLR		U28

	; select DDR 
	CLR		PIAU10 + CRA
	CLR		PIAU10 + CRB
	CLR		PIAU38 + CRA
	CLR		PIAU38 + CRB
	CLR		PIAU41 + CRA
	CLR		PIAU41 + CRB
	CLR		PIAU42 + CRA
	CLR		PIAU42 + CRB
	CLR		PIAU51 + CRA
	CLR		PIAU51 + CRB
	CLR		PIAU54 + CRA
	CLR		PIAU54 + CRB
	
	; FF is all ports output
	ldaa	#$FF
	STAA	PIAU10 + DDRA
	STAA	PIAU10 + DDRB
	STAA	PIAU38 + DDRA
	STAA	PIAU38 + DDRB
	STAA	PIAU41 + DDRA
	STAA	PIAU41 + DDRB
	STAA	PIAU42 + DDRA
	STAA	PIAU42 + DDRB
	STAA	PIAU51 + DDRA
	STAA	PIAU51 + DDRB
	STAA	PIAU54 + DDRA
	STAA	PIAU54 + DDRB
	
	; 4 = select data register
	ldaa	#$04
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU38 + CRA
	STAA	PIAU38 + CRB
	STAA	PIAU41 + CRA
	STAA	PIAU41 + CRB
	STAA	PIAU42 + CRA
	STAA	PIAU42 + CRB
	STAA	PIAU51 + CRA
	STAA	PIAU51 + CRB
	STAA	PIAU54 + CRA
	STAA	PIAU54 + CRB
	
	; clear all outputs
	ldaa	#$00
	STAA	PIAU10 + DATAA
	STAA	PIAU10 + DATAB
	STAA	PIAU38 + DATAA
	STAA	PIAU38 + DATAB
	STAA	PIAU41 + DATAA
	STAA	PIAU41 + DATAB
	STAA	PIAU42 + DATAA
	STAA	PIAU42 + DATAB
	STAA	PIAU51 + DATAA
	STAA	PIAU51 + DATAB
	STAA	PIAU54 + DATAA
	STAA	PIAU54 + DATAB
	
	;CA2/CB2 output and follow (bit3=data)
	ldaa	#$30
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU38 + CRA
	STAA	PIAU38 + CRB
	STAA	PIAU41 + CRA
	STAA	PIAU41 + CRB
	STAA	PIAU42 + CRA
	STAA	PIAU42 + CRB
	STAA	PIAU51 + CRA
	STAA	PIAU51 + CRB
	STAA	PIAU54 + CRA
	STAA	PIAU54 + CRB

;
; EXT4Mhz/ 1MHz int, 8cycles DELAY= 8ns per loop
; 0.5s / 0.000008 = 62500 times

		LDX		#62500
DELAY1:	DEX
		BNE DELAY1

ALL55:

	; select DDR 
	CLR		PIAU10 + CRA
	CLR		PIAU10 + CRB
	CLR		PIAU38 + CRA
	CLR		PIAU38 + CRB
	CLR		PIAU41 + CRA
	CLR		PIAU41 + CRB
	CLR		PIAU42 + CRA
	CLR		PIAU42 + CRB
	CLR		PIAU51 + CRA
	CLR		PIAU51 + CRB
	CLR		PIAU54 + CRA
	CLR		PIAU54 + CRB

	; FF is all ports output
	ldaa	#$FF
	STAA	PIAU10 + DDRA
	STAA	PIAU10 + DDRB
	STAA	PIAU38 + DDRA
	STAA	PIAU38 + DDRB
	STAA	PIAU41 + DDRA
	STAA	PIAU41 + DDRB
	STAA	PIAU42 + DDRA
	STAA	PIAU42 + DDRB
	STAA	PIAU51 + DDRA
	STAA	PIAU51 + DDRB
	STAA	PIAU54 + DDRA
	STAA	PIAU54 + DDRB
	
	; 4 = select data register
	ldaa	#$04
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU38 + CRA
	STAA	PIAU38 + CRB
	STAA	PIAU41 + CRA
	STAA	PIAU41 + CRB
	STAA	PIAU42 + CRA
	STAA	PIAU42 + CRB
	STAA	PIAU51 + CRA
	STAA	PIAU51 + CRB
	STAA	PIAU54 + CRA
	STAA	PIAU54 + CRB
	
	; set all outputs
	ldaa	#$55
	STAA	PIAU10 + DATAA
	STAA	PIAU10 + DATAB
	STAA	PIAU38 + DATAA
	STAA	PIAU38 + DATAB
	STAA	PIAU41 + DATAA
	STAA	PIAU41 + DATAB
	STAA	PIAU42 + DATAA
	STAA	PIAU42 + DATAB
	STAA	PIAU51 + DATAA
	STAA	PIAU51 + DATAB
	STAA	PIAU54 + DATAA
	STAA	PIAU54 + DATAB
	
	;CA2/CB2 output and follow (bit3=data)
	ldaa	#$38
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU38 + CRA
	STAA	PIAU38 + CRB
	STAA	PIAU41 + CRA
	STAA	PIAU41 + CRB
	STAA	PIAU42 + CRA
	STAA	PIAU42 + CRB
	STAA	PIAU51 + CRA
	STAA	PIAU51 + CRB
	STAA	PIAU54 + CRA
	STAA	PIAU54 + CRB
;
; EXT4Mhz/ 1MHz int, 8cycles DELAY= 8ns per loop
; 0.5s / 0.000008 = 62500 times
		LDX		#62500
DELAY2:	DEX
		BNE DELAY2




ALLON:

	; select DDR 
	CLR		PIAU10 + CRA
	CLR		PIAU10 + CRB
	CLR		PIAU38 + CRA
	CLR		PIAU38 + CRB
	CLR		PIAU41 + CRA
	CLR		PIAU41 + CRB
	CLR		PIAU42 + CRA
	CLR		PIAU42 + CRB
	CLR		PIAU51 + CRA
	CLR		PIAU51 + CRB
	CLR		PIAU54 + CRA
	CLR		PIAU54 + CRB

	; FF is all ports output
	ldaa	#$FF
	STAA	PIAU10 + DDRA
	STAA	PIAU10 + DDRB
	STAA	PIAU38 + DDRA
	STAA	PIAU38 + DDRB
	STAA	PIAU41 + DDRA
	STAA	PIAU41 + DDRB
	STAA	PIAU42 + DDRA
	STAA	PIAU42 + DDRB
	STAA	PIAU51 + DDRA
	STAA	PIAU51 + DDRB
	STAA	PIAU54 + DDRA
	STAA	PIAU54 + DDRB
	
	; 4 = select data register
	ldaa	#$04
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU38 + CRA
	STAA	PIAU38 + CRB
	STAA	PIAU41 + CRA
	STAA	PIAU41 + CRB
	STAA	PIAU42 + CRA
	STAA	PIAU42 + CRB
	STAA	PIAU51 + CRA
	STAA	PIAU51 + CRB
	STAA	PIAU54 + CRA
	STAA	PIAU54 + CRB
	
	; set all outputs
	ldaa	#$FF
	STAA	PIAU10 + DATAA
	STAA	PIAU10 + DATAB
	STAA	PIAU38 + DATAA
	STAA	PIAU38 + DATAB
	STAA	PIAU41 + DATAA
	STAA	PIAU41 + DATAB
	STAA	PIAU42 + DATAA
	STAA	PIAU42 + DATAB
	STAA	PIAU51 + DATAA
	STAA	PIAU51 + DATAB
	STAA	PIAU54 + DATAA
	STAA	PIAU54 + DATAB
	
	;CA2/CB2 output and follow (bit3=data)
	ldaa	#$38
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU38 + CRA
	STAA	PIAU38 + CRB
	STAA	PIAU41 + CRA
	STAA	PIAU41 + CRB
	STAA	PIAU42 + CRA
	STAA	PIAU42 + CRB
	STAA	PIAU51 + CRA
	STAA	PIAU51 + CRB
	STAA	PIAU54 + CRA
	STAA	PIAU54 + CRB
;
; EXT4Mhz/ 1MHz int, 8cycles DELAY= 8ns per loop
; 0.5s / 0.000008 = 62500 times
		LDX		#62500
DELAY3:	DEX
		BNE DELAY3


ALLAA:

	; select DDR 
	CLR		PIAU10 + CRA
	CLR		PIAU10 + CRB
	CLR		PIAU38 + CRA
	CLR		PIAU38 + CRB
	CLR		PIAU41 + CRA
	CLR		PIAU41 + CRB
	CLR		PIAU42 + CRA
	CLR		PIAU42 + CRB
	CLR		PIAU51 + CRA
	CLR		PIAU51 + CRB
	CLR		PIAU54 + CRA
	CLR		PIAU54 + CRB

	; FF is all ports output
	ldaa	#$FF
	STAA	PIAU10 + DDRA
	STAA	PIAU10 + DDRB
	STAA	PIAU38 + DDRA
	STAA	PIAU38 + DDRB
	STAA	PIAU41 + DDRA
	STAA	PIAU41 + DDRB
	STAA	PIAU42 + DDRA
	STAA	PIAU42 + DDRB
	STAA	PIAU51 + DDRA
	STAA	PIAU51 + DDRB
	STAA	PIAU54 + DDRA
	STAA	PIAU54 + DDRB
	
	; 4 = select data register
	ldaa	#$04
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU38 + CRA
	STAA	PIAU38 + CRB
	STAA	PIAU41 + CRA
	STAA	PIAU41 + CRB
	STAA	PIAU42 + CRA
	STAA	PIAU42 + CRB
	STAA	PIAU51 + CRA
	STAA	PIAU51 + CRB
	STAA	PIAU54 + CRA
	STAA	PIAU54 + CRB
	
	; set all outputs
	ldaa	#$AA
	STAA	PIAU10 + DATAA
	STAA	PIAU10 + DATAB
	STAA	PIAU38 + DATAA
	STAA	PIAU38 + DATAB
	STAA	PIAU41 + DATAA
	STAA	PIAU41 + DATAB
	STAA	PIAU42 + DATAA
	STAA	PIAU42 + DATAB
	STAA	PIAU51 + DATAA
	STAA	PIAU51 + DATAB
	STAA	PIAU54 + DATAA
	STAA	PIAU54 + DATAB
	
	;CA2/CB2 output and follow (bit3=data)
	ldaa	#$38
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB
	STAA	PIAU38 + CRA
	STAA	PIAU38 + CRB
	STAA	PIAU41 + CRA
	STAA	PIAU41 + CRB
	STAA	PIAU42 + CRA
	STAA	PIAU42 + CRB
	STAA	PIAU51 + CRA
	STAA	PIAU51 + CRB
	STAA	PIAU54 + CRA
	STAA	PIAU54 + CRB
;
; EXT4Mhz/ 1MHz int, 8cycles DELAY= 8ns per loop
; 0.5s / 0.000008 = 62500 times
		LDX		#62500
DELAY4:	DEX
		BNE DELAY4



		jmp	START
; LOOP BACK TO START

;
; NMI
;
NMI:

;
; set 7ff to 01010101
; clear all variants with one cleared address bit
MEMTEST55:
	ldaa	#$55
	staa	$07FF
	ldaa	#$00
	staa	$07FF & ~(1<<10)
	staa	$07FF & ~(1<<9)
	staa	$07FF & ~(1<<8)
	staa	$07FF & ~(1<<7)
	staa	$07FF & ~(1<<6)
	staa	$07FF & ~(1<<5)
	staa	$07FF & ~(1<<4)
	staa	$07FF & ~(1<<3)
	staa	$07FF & ~(1<<2)
	staa	$07FF & ~(1<<1)
	staa	$07FF & ~(1<<0)

; check if 7ff is still 01010101
	ldaa	$07FF
	suba	#$55
	bne	MEMTEST55
;
; set 7ff to 10101010
; clear all variants with one cleared address bit
MEMTESTAA:
	ldaa	#$AA
	staa	$07FF
	
	ldaa	#$00
	staa	$07FF & ~(1<<10)
	staa	$07FF & ~(1<<9)
	staa	$07FF & ~(1<<8)
	staa	$07FF & ~(1<<7)
	staa	$07FF & ~(1<<6)
	staa	$07FF & ~(1<<5)
	staa	$07FF & ~(1<<4)
	staa	$07FF & ~(1<<3)
	staa	$07FF & ~(1<<2)
	staa	$07FF & ~(1<<1)
	staa	$07FF & ~(1<<0)

	ldaa	$07FF
	suba	#$AA
	bne	MEMTESTAA

; normal operation
	jmp	START


; VECTOR table
	org $FFFC
; NMI vector
	dw 	NMI 
; reset vector
	dw 	START