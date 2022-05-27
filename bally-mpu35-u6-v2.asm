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

; RAM
	org $0
; variables
TEMP1	rmb 1
TEMP2	rmb 1
TEMPH	rmb 1
TEMPL   rmb 1
DIP1	rmb 1
DIP9	rmb 1
DIP17	rmb 1
DIP25	rmb 1
DISPLAYBUF1 rmb 5*7	; byte per char for now
SWITCH	rmb 8

	org $7f
STACK	rmb 1


; NVRAM
	org $200
LAMPS rmb 16
DISPLAYBUF2	rmb 5*7

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


; ****************************************************
; SPXWAIT - procedure wait without need for memory
; 512kHz int, 8cycles DELAY= 16ns per loop
; 0.5s / 0.000016 = 31250 times
; use SP as return address
; use X as delay
; ****************************************************
SPXWAIT:
	dex
	bne SPXWAIT
	tsx		; X=SP+1
	dex		; we need X=SP so -1
	jmp	$0,x

; ****************************************************
; SPLEDON/SPLEDOFF
; set led without need of stack/memory
; use SP as return address
; ****************************************************
SPLEDOFF:
	ldaa	#$30	; led off
	bra SPLED
SPLEDON:
	ldaa	#$38	; led on
SPLED:
	STAA	PIAU11 + CRA
	tsx		; X=SP+1
	dex		; we need X=SP so -1
	jmp	$0,x
; ****************************************************
; * driver functions with memory
; ****************************************************
xwait:
	DEX
	BNE xwait
	rts
	
ledon:
	psha
	ldaa PIAU11 + CRA
	oraa	#$38
	staa PIAU11 + CRA
	pula
	rts

ledoff:
	psha
	ldaa PIAU11 + CRA
	oraa	#$30
	anda #$F7
	staa PIAU11 + CRA
	pula
	rts
	
	
lampstrobe:
	psha
	ldaa PIAU10 + CRB
	oraa	#$3c
	ldaa #$3c
	staa PIAU10 + CRB
	oraa	#$34
	anda #$F7
	ldaa #$34
	staa PIAU10 + CRB
	pula
	rts
	
	
displaystrobe:
	psha
	ldaa PIAU10 + CRA
	oraa	#$3c
	ldaa #$3c
	staa PIAU10 + CRA
	oraa	#$34
	anda #$F7
	ldaa #$34
	staa PIAU10 + CRA
	pula
	rts

; ****************************************************
; * DATA
; ****************************************************


; ****************************************************
; * START
; ****************************************************

START:
	SEI
	CLR		PIAU11 + CRA
	ldaa	#$38	; led on
	STAA	PIAU11 + CRA

	LDS	#TESTU11
	LDX	#1000
	BRA SPXWAIT
TESTU11:

	ldaa 	PIAU11 + CRA
	anda	#$3f
	suba	#$38
.HANGLOOP:	bne	.HANGLOOP


	ldaa	#$30	; led off
	STAA	PIAU11 + CRA

	LDS	#TESTU11OK
	LDX	#1000
	JMP SPXWAIT
TESTU11OK:

	ldaa	#$38	; led on
	STAA	PIAU11 + CRA

	LDS	#TESTU11OKA
	LDX	#31250
	JMP SPXWAIT
TESTU11OKA:

	ldaa	#$30	; led off
	STAA	PIAU11 + CRA

	LDS	#TESTU11OKB
	LDX	#31250
	JMP SPXWAIT
TESTU11OKB:
	LDS	#TESTU10
	JMP SPLEDON
	

TESTU10:
	CLR		PIAU10 + CRA
	CLR		PIAU10 + CRB

	ldaa	#$38	
	STAA	PIAU10 + CRA

	LDS	#TESTU10W
	LDX	#31250
	JMP SPXWAIT
TESTU10W:

	ldaa 	PIAU10 + CRA
	anda	#$3f
	suba	#$38
.HANGLOOP:	bne	.HANGLOOP
	LDS	#TESTU10OK
	JMP SPLEDOFF
	
TESTU10OK:
	LDS	#TESTU7
	LDX	#31250
	JMP SPXWAIT

TESTU7:
	LDS	#TESTU7B
	JMP SPLEDON
TESTU7B:
	LDS	#TESTU7C
	LDX	#31250
	JMP SPXWAIT
TESTU7C:
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

	LDS	#TESTU7OK
	JMP SPLEDOFF
TESTU7OK:
; from here we can use memory
	lds	#RAMU7SIZE-1

	ldb	#16
.loop:
	jsr ledon
	ldx #5120
	jsr xwait
	jsr ledoff
	ldx #5120
	jsr xwait
	decb
	bne .loop
START_HARDWARE_OK:
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



; fill lamps
	ldaa #$5f
	ldx	#LAMPS
	staa $0,x
	staa $1,x
	staa $2,x
	staa $3,x
	staa $4,x
	staa $5,x
	staa $6,x
	staa $7,x


; fill display
	ldaa #$0f
	ldab	#5*7+1
	ldx #DISPLAYBUF2
.loop	
	staa $0,x
	adda #$10
	oraa #$0f
	inx
	decb
	bne .loop

; get dipswitches
	ldaa #$3c	; CB2 on , switchstrobe DIP25-32 on, datareg
	staa PIAU10 + CRB
	
	ldaa #$34	; CA2 off select output
	staa PIAU10 + CRA
	clr PIAU10 + DATAA	; all switch strobes off 
	;nop
	ldaa PIAU10 + DATAB	; switchdata
	staa DIP25
	ldaa #$34	; CB2 off , switchstrobe DIP25-32 off
	staa PIAU10 + CRB
	
	ldaa #$80
	staa PIAU10 + DATAA	; switchprobe dip17
	;nop
	ldaa PIAU10 + DATAB	; switchdata
	staa DIP17
	
	ldaa #$40
	staa PIAU10 + DATAA	; switchprobe dip9
	;nop
	ldaa PIAU10 + DATAB	; switchdata
	staa DIP9
	
	ldaa #$20
	staa PIAU10 + DATAA	; switchprobe dip1
	;nop
	ldaa PIAU10 + DATAB	; switchdata
	staa DIP1

;.brek bra .brek 

mainloop:


; get swithes
	ldaa #$34	; Cx2 off , switchstrobe DIP25-32 off
	staa PIAU10 + CRB
	staa PIAU10 + CRA

	ldab #1
	ldx	#SWITCH
.switchloop
	stab PIAU10 + DATAA	; switchprobe 
	;nop
	ldaa PIAU10 + DATAB	; switchdata
	staa 0,X
	inx
	aslb
	bne .switchloop




; push lamps
; 0-3 = index
; 4-7 = lampdata
; strobe1 = u10cb2
; Fc clear index c
; dF set data d on index c
; can it be combined ?

; 14514
; inhibit=1 all outputs 0 on strobe
; inhibit=0 address 1 on strobe

lamptest:
	ldaa PIAU10 + CRA
	oraa	#$4	; select data
	;lda #$04
	staa PIAU10 + CRA

	ldab #$f0 	;start at lamp address 0
	ldx #LAMPS
	
.lamploop
;strobe
	; set channel and clear all 
	stab PIAU10 + DATAA
	jsr lampstrobe	; strobe lamp data
	ldaa $0,X	; data in high, F in low
	; and/ora address ?
	staa PIAU10 + DATAA	; push lampdata 0=on
	jsr lampstrobe	; strobe lampdata
	inx
	incb
	bne .lamploop
	

; display 
	ldx #DISPLAYBUF2
	
	ldaa #$0e	; display 1
.displayloop2
	STAA TEMP1
	ldb	#2		; display digit
.displayloop1

	stab PIAU11 + DATAA

	;ldaa #$3c
	;staa PIAU10 + CRA
	
	ldaa	0,X	;dF
	staa PIAU10 + DATAA
	anda #$f0
	oraa	TEMP1	;display 1 strobe
	staa PIAU10 + DATAA
	jsr displaystrobe
	
	;ldaa #$34
	;staa PIAU10 + CRA
	
	inx
	aslb
	bne .displayloop1

	ldaa TEMP1
	asla
	oraa #$1
	anda #$0f
;	bne .displayloop2
	
	jmp mainloop
	
	; display 5
		ldb	#2		; display digit
.displayloop5
	orab #$1	; strobe 5
	stab PIAU11 + DATAA
	andb #$fe
	
	ldaa	0,X	;dF
	staa PIAU10 + DATAA
	anda #$f0
	oraa	$f	;display 1-4 off
	staa PIAU10 + DATAA
	jsr displaystrobe
	
	
	inx
	aslb
	bne .displayloop5
	
	
	
	jmp mainloop
	bra lamptest
.brek bra .brek 
	
	



	ldaa #$50	; data
	staa TEMP1
.uloop
	ldab #$f	;index
.lloop	
	ldx #1000
	jsr xwait
	
	tba
	; strobe
	oraa TEMP1
	staa PIAU10 + DATAA
	
	ldaa PIAU10 + CRB
	oraa	#$38
	staa PIAU10 + CRB
	oraa	#$30
	anda #$F7
	staa PIAU10 + CRB
	
	decb
	bne .lloop
	ldaa TEMP1
	eora #$f0
	anda #$f0
	staa TEMP1
	bra .uloop


BREAK: bra BREAK




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


;
; set RAM to 01010101




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
