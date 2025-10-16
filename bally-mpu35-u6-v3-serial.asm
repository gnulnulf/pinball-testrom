;
; @brief Testrom for Bally MPU35 U6 for use with uart
;
; @version 1.0
; @author Arco van Geest <arco@appeltaart.mine.nu>
; @copyright 2021-2025 Arco van Geest <arco@appeltaart.mine.nu> All right reserved.

; connect a UART-USB RX to J1-10 and set your baudrate to 19200
; If the 6800 clock differs too much from 520kHz then the baudrate can be a bit different.
; The test starts and if FAIL appears, the last test failed.
 

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
; ## Assembling
;
; assembler used: alfsembler http://john.ccac.rwth-aachen.de:8000/as/
; d:\Pinball\aswcurr\bin\asw.exe -cpu 6800 -A bally-mpu35-u6-v3-uart.asm
; d:\Pinball\aswcurr\bin\p2bin.exe bally-mpu35-u6-v3-uart.p
;
;
; @date 20210612 Arco van Geest Initial version first testrom
; @date 20250907 Arco van Geest Added UART support 

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
PRINTHEX_H rmb 1
PRINTHEX_L rmb 1
A_TO_X rmb 2
 
;DISPLAYBUF1 rmb 5*7	; byte per char for now
;SWITCH	rmb 8
UARTTMP rmb 1
UARTAX	rmb 2
DISPLAYCOUNT rmb 2
ZEROCOUNT rmb 2
BINTEMP rmb 1
DECTEMP rmb 1
DEC100 rmb 1
DEC10 rmb 1
DEC1 rmb 1


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
;VERSION SET "2025092701"

; memory map
;$0000-007F 6810 RAM
;$0088-008B 6821 PIA U10
;$0090-0093 6821 PIA U11
;$0200-02FF 5101 RAM (upper 4 bits only! - ROMs expect lower 4 bits to read high)
;$1000-17FF ROM U1 2716
;$5000-57FF ROM U2 2716
;$5800-5FFF ROM U6 2716


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
; * DATA
; ****************************************************

U8_STR: db "RAM U08",13,10,0
DIP_STR: db "Dipswitches:",13,10,0
DISPINT_STR: db "Display interrupt (300-400Hz):",13,10,0
ZEROCROSS_STR: db "Zero crossing interrupt (80-120Hz):",13,10,0
;FAIL_STR: db 10,"FAIL",13,10,0
SOFTFAIL_STR: db 10,"SOFT FAIL",13,10,0
OK_STR: db 10,"Board seems OK",13,10,0
HWINIT_STR: db "Hardware init",13,10,0
S55_STR: db "55",13,10,0
SAF_STR: db "AF",13,10,0
S5F_STR: db "5F",13,10,0
INC_STR: db "INC",13,10,0
U1_STR: db "ROM U01 - $1000",13,10,0
U2_STR: db "ROM U02 - $5000",13,10,0
HEX_STR: db "0123456789ABCDEF"


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
; SPXA_UART_PC_STR
; Send null terminated string from SP and continue on next address
; ****************************************************
; SP = start of string


SPXA_UART_PC_STR:
	tsx			; X=SP+1
	dex			; X=SP
	lda	0,x
	beq SPXA_UART_PC_STR_LEAVE	; null termination found


SPXA_UART_TX1:
	ldx #10
	clc
SPXA_UART_LOOP1: ; 6144 = 32 cycles?  500000/19200=26 500000/9600=52
	; gemeten 20000 * 33 = 660khz
	ldab	#$30	; 2 CB2 low
	bcc .SPXA_UART_0  ; 4
	ldab	#$38    ; 2 
							;[6/8]
.SPXA_UART_0:		
	
	stab PIAU11 + CRB ; 5 store low
	stab PIAU11 + CRB ; 5 store low

	nop					; 2

	sec					; 2
	ROR A				; 6
	dex					; 4
	bne SPXA_UART_LOOP1	; 4  [16]
	
	ins		; SP++
	bra SPXA_UART_PC_STR
	
SPXA_UART_PC_STR_LEAVE
	
	tsx		; X=SP+1
	;dex		; we need X=SP so -1
	jmp	$0,x



	
	

; ****************************************************
; SPXA_UART_TX
; set led without need of stack/memory
; use SP as return address
; ****************************************************
SPXA_UART_TX:
	ldx #10
	clc
SPXA_UART_LOOP: ; 6144 = 32 cycles?  500000/19200=26 500000/9600=52
	; gemeten 20000 * 33 = 660khz
	ldab	#$30	; 2 CB2 low
	bcc SPXA_UART_0  ; 4
	ldab	#$38    ; 2 
							;[6/8]
SPXA_UART_0:		
	
	stab PIAU11 + CRB ; 5 store low
	stab PIAU11 + CRB ; 5 store low

	nop					; 2

	sec					; 2
	ROR A				; 6
	dex					; 4
	bne SPXA_UART_LOOP	; 4  [16]
	
	tsx		; X=SP+1
	dex		; we need X=SP so -1
	jmp	$0,x
	


; ****************************************************
; SPX_FAIL
; try to send FAIL on serial out and hang
; ****************************************************
SPX_FAIL:

	lds #FAIL_STR
	jmp	SPXA_UART_PC_STR
FAIL_STR	dc.b 10,"FAIL",13,10,0
.HANGLOOP:	bne	.HANGLOOP

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
	psh a
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

; ------------------------------------------
; uart_tx_x_string = send 0 terminated string
; 
; ------------------------------------------
uart_tx_x_string:
	psh a
	psh b
uart_tx_x_string_loop:
	ldaa $0,X
	beq		uart_tx_x_string_end
	jsr	uart_tx_a
	inx
	bra uart_tx_x_string_loop
uart_tx_x_string_end:
	pul b
	pul a
	rts


; ------------------------------------------
; uart_tx_a = send single character
; 
; ------------------------------------------

uart_tx_a:
	; mask interrupts?
	psha
	pshb
;	stx	 UARTAX
	staa UARTTMP
	ldab PIAU11 + CRB	
	orab #$30
	stab PIAU11 + CRB ; CB2 as output
	

	lda #10
	clc
uart_tx_a_loop: ; 6144 = 32 cycles?  500000/19200=26 500000/9600=52
	; gemeten 20000 * 33 = 660khz
	; clock=528kHz ~27,5
	ldab PIAU11 + CRB	;4
	andb #$FF-$08		;2
	bcc uart_tx_a_0  ; 4
	orab #$08		 ; 2
							;[10/12]
						; -----
uart_tx_a_0:		
	stab PIAU11 + CRB ; 5 store low
	;stab PIAU11 + CRB ; 5 store low (5x=9600?)

;	nop					; 2
						; -----
	sec					; 2
	ROR 	UARTTMP		; 6
	deca				; 2
	bne uart_tx_a_loop	; 4  [14]
	
	;ldx	UARTAX
	
	pul b
	pul a
	rts
 
; ------------------------------------------
; send A as binary string
; 
; ------------------------------------------

uart_tx_bin:
	psha
	pshb
	staa BINTEMP
	ldab	#8
uart_tx_bin_loop:
	ldaa #'0'
	ror BINTEMP
	bcc .uart_tx_bin_0
	ldaa #'1'
.uart_tx_bin_0
	bsr uart_tx_a
	decb
	bne uart_tx_bin_loop
	pul b
	pul a
	rts
 
; ------------------------------------------
	
; send A as hex string
; 
; ------------------------------------------
uart_tx_hex:
	psha
	pshb
	staa PRINTHEX_H
	LSR PRINTHEX_H
	LSR PRINTHEX_H
	LSR PRINTHEX_H
	LSR PRINTHEX_H
	anda #$f
	staa PRINTHEX_L
	
	ldx #HEX_STR
	ldaa PRINTHEX_H
.HINCX
	beq .HINCXDONE
	inx
	deca
	bra .HINCX
	
.HINCXDONE	
	ldaa 0,X
	bsr uart_tx_a

	ldx #HEX_STR
	ldaa PRINTHEX_L
.LINCX
	beq .LINCXDONE
	inx
	deca
	bra .LINCX
	
.LINCXDONE	
	ldaa 0,X
	bsr uart_tx_a
	
	
	pul b
	pul a
	rts

; ------------------------------------------
	
; send A as decimal string
; 
; ------------------------------------------
uart_tx_dec:
	psha
	pshb
	staa DECTEMP
	clr b
.loop100
	cmpa #100
	blt .done100
	incb
	suba #100
	bra .loop100
	
.done100
	stab DEC100
	staa DECTEMP
	ldx #HEX_STR
	ldaa DEC100,X
	jsr uart_tx_a

	ldaa DECTEMP

	clr b
.loop10
	cmpa #10
	blt .done10
	incb
	suba #10
	bra .loop10
	
.done10
	stab DEC10
	staa DECTEMP
	ldx #HEX_STR
	ldaa DEC10,X
	jsr uart_tx_a


	ldab DECTEMP
	ldx #HEX_STR
	ldaa DECTEMP,X
	jsr uart_tx_a

	pul b
	pul a
	rts

	
; ****************************************************
; fail with memory
; try to send FAIL on serial out and hang
; ****************************************************
fail:
	ldx	#FAIL_STR
	jsr uart_tx_x_string
	.HANGLOOP:	bne	.HANGLOOP

; ****************************************************
; * START
; ****************************************************

START:
	SEI

START_HARDWARE_INIT:
; -------------------------------------------
; Hardware IO init
; -------------------------------------------	
	;ldx	#HWINIT_STR no stack yet
	;jsr uart_tx_x_string
	

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

	; try to turn on led
	CLR		PIAU11 + CRA
	ldaa	#$38	; led on
	STAA	PIAU11 + CRA

	lds #INIT_STR
	jmp	SPXA_UART_PC_STR
INIT_STR	
HELLO_STR: db "NFV MPU35 testrom",13,10
			db "(c)2025 Arco van Geest",13,10
			db "version: ","2025101601",13,10
			db	0

; -------------------------------------------
; U11 PIA pretest
; -------------------------------------------






	; sleep 1000 
;	LDS	#TESTU11
;	LDX	#1000
;	JMP SPXWAIT
TESTU11:
	; test if CRA on U11 is working
	ldaa 	PIAU11 + CRA
	anda	#$3f
	suba	#$38
	beq	.OK
	jmp	SPX_FAIL
.OK
;.HANGLOOP:	bne	.HANGLOOP



; -------------------------------------------
; U11 PIA pretest
; -------------------------------------------

	lds #U11_STR
	jmp	SPXA_UART_PC_STR
U11_STR	dc.b "U11",13,10,0

	
; ########################################################
; # Start without memory
	ldaa	#$30	; led off
	STAA	PIAU11 + CRA

;	LDS	#TESTU11OK
;	LDX	#1000
;	JMP SPXWAIT
;TESTU11OK:

	ldaa	#$38	; led on
	STAA	PIAU11 + CRA

;	LDS	#TESTU11OKA
;	LDX	#31250
;	JMP SPXWAIT
;TESTU11OKA:

	ldaa	#$30	; led off
	STAA	PIAU11 + CRA

;	LDS	#TESTU11OKB
;	LDX	#31250
;	JMP SPXWAIT
;TESTU11OKB:
	LDS	#TESTU10
	JMP SPLEDON
	
; -------------------------------------------
; U10 PIA pretest
; -------------------------------------------
TESTU10:
	lds #U10_STR
	jmp	SPXA_UART_PC_STR
U10_STR	dc.b "U10",13,10,0

	CLR		PIAU10 + CRA
	CLR		PIAU10 + CRB

	ldaa	#$38	
	STAA	PIAU10 + CRA

;	LDS	#TESTU10W
;	LDX	#31250
;	JMP SPXWAIT
;TESTU10W:

	ldaa 	PIAU10 + CRA
	anda	#$3f
	suba	#$38
	beq	.OK
	jmp	SPX_FAIL
.OK
;.HANGLOOP:	bne	.HANGLOOP
	LDS	#TESTU10OK
	JMP SPLEDOFF
TESTU10OK:

;	LDS	#TESTU7
;	LDX	#31250
;	JMP SPXWAIT

; -------------------------------------------
; U7 RAM Test
; -------------------------------------------

TESTU7:
	lds #U7_STR
	jmp	SPXA_UART_PC_STR
U7_STR	dc.b "U7",13,10,0


; D0-7
; 1-252 , read
; all 55
; all aa
; all ff
; all 0
	; LED ON
	LDS	#TESTU7B
	JMP SPLEDON
TESTU7B:



MEMTESTD:
	ldaa #'D'
	lds	#TXD
	JMP SPXA_UART_TX
TXD:

	; DATALINE D0
	ldaa #'0'
	lds	#TX0
	JMP SPXA_UART_TX
TX0:
	ldaa	#$01
	staa	$0
	cmpa	$0
	beq	.OK
	jmp	SPX_FAIL
.OK
;.HANGLOOP:	bne	.HANGLOOP

	; DATALINE D1
	ldaa #'1'
	lds	#TX1
	JMP SPXA_UART_TX
TX1:
	ldaa	#$02
	staa	$0
	cmpa	$0
	beq	.OK
	jmp	SPX_FAIL
.OK
;.HANGLOOP:	bne	.HANGLOOP

	; DATALINE D2
	ldaa #'2'
	lds	#TX2
	JMP SPXA_UART_TX
TX2:
	ldaa	#$04
	staa	$0
	cmpa	$0
	beq	.OK
	jmp	SPX_FAIL
.OK
;.HANGLOOP:	bne	.HANGLOOP
	; DATALINE D3
	ldaa #'3'
	lds	#TX3
	JMP SPXA_UART_TX
TX3:
	ldaa	#$08
	staa	$0
	cmpa	$0
	beq	.OK
	jmp	SPX_FAIL
.OK
;.HANGLOOP:	bne	.HANGLOOP
	; DATALINE D4
	ldaa #'4'
	lds	#TX4
	JMP SPXA_UART_TX
TX4:
	ldaa	#$10
	staa	$0
	cmpa	$0
	beq	.OK
	jmp	SPX_FAIL
.OK
;.HANGLOOP:	bne	.HANGLOOP
	; DATALINE D5
	ldaa #'5'
	lds	#TX5
	JMP SPXA_UART_TX
TX5:
	ldaa	#$20
	staa	$0
	cmpa	$0
	beq	.OK
	jmp	SPX_FAIL
.OK
;.HANGLOOP:	bne	.HANGLOOP
	; DATALINE D6
	ldaa #'6'
	lds	#TX6
	JMP SPXA_UART_TX
TX6:
	ldaa	#$40
	staa	$0
	cmpa	$0
	beq	.OK
	jmp	SPX_FAIL
.OK
;.HANGLOOP:	bne	.HANGLOOP
	; DATALINE D7
	ldaa #'7'
	lds	#TX7
	JMP SPXA_UART_TX
TX7:
	ldaa	#$80
	staa	$0
	cmpa	$0
	beq	.OK
	jmp	SPX_FAIL
.OK
; crlf in next string
; datalines checked


	lds #U7_INC_STR
	jmp	SPXA_UART_PC_STR
U7_INC_STR	dc.b 13,10,"Increments",13,10,0
	

; test individual values
MEMTESTINC:
; write 252-124 to ram
	ldx		#RAMU7SIZE-1
	ldaa	#252
MINCLOOP:
	staa	RAMU7,X
	deca
	DEX
	bne 	MINCLOOP
; read the expected value	
	ldx		#RAMU7SIZE-1
	ldaa	#252
MINCLOOPr:
	cmpa	RAMU7,X
.HANGLOOP:	bne	.HANGLOOP
	deca
	DEX
	bne 	MINCLOOPr

	lds #U7_55_STR
	jmp	SPXA_UART_PC_STR
U7_55_STR	dc.b "0x55",13,10,0

; test with all $55
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

; test with all $aa
	lds #U7_AA_STR
	jmp	SPXA_UART_PC_STR
U7_AA_STR	dc.b "0xAA",13,10,0


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

; -------------------------------------------
; Stack!
; -------------------------------------------


; -------------------------------------------
; Hello
; -------------------------------------------
	
;	ldx	#HELLO_STR
;	jsr uart_tx_x_string

; -------------------------------------------
; U8 5101
; -------------------------------------------

	ldx	#U8_STR
	jsr uart_tx_x_string
		
	ldaa #'D'
	jsr uart_tx_a
	; DATALINE D4
	ldaa #'4'
	jsr uart_tx_a
	ldaa	#$1f
	staa	$200
	cmpa	$200
	beq	.OK
	jmp	SPX_FAIL
.OK
	
	; DATALINE D5
	ldaa #'5'
	jsr uart_tx_a
	ldaa	#$2f
	staa	$200
	cmpa	$200
	beq	.OK5
	jmp	SPX_FAIL
.OK5

	; DATALINE D6
	ldaa #'6'
	jsr uart_tx_a
	ldaa	#$4f
	staa	$200
	cmpa	$200
	beq	.OK6
	jmp	SPX_FAIL
.OK6

	; DATALINE D7
	ldaa #'7'
	jsr uart_tx_a
	ldaa	#$8f
	staa	$200
	cmpa	$200
	beq	.OK7
	jmp	SPX_FAIL
.OK7
	ldaa #13
	jsr uart_tx_a
	ldaa #10
	jsr uart_tx_a

	ldx	#INC_STR
	jsr uart_tx_x_string


U8MEMTESTINC:
; fill incremental
	ldx		#RAMU8
	ldab	#RAMU8SIZE-1
	ldaa	#$df	; first prime under 16 =13<<4
	staa TEMP1
	
.U8LOOPi:
	staa	0,X
	suba #$10
	cmpa #$ff
	bne .u8nowrap
	ldaa	#$df
.u8nowrap

	INX
	decb
	bne 	.U8LOOPi

; compare
	ldx		#RAMU8
	ldab	#RAMU8SIZE-1
	ldaa	#$df
.U8LOOPci:
	cmpa	0,X
	beq	.OK
	jmp	SPX_FAIL
.OK
	suba #$10
	cmpa #$ff
	bne .nowrapci
	ldaa	#$df
.nowrapci
	INX
	decb
	bne 	.U8LOOPci

	ldx	#S5F_STR
	jsr uart_tx_x_string

U8MEMTEST5F:
; fill $5F
	ldx		#RAMU8
	ldab	#RAMU8SIZE-1
	ldaa	#$5f
.U8LOOP:
	staa	0,X
	INX
	dec b
	bne 	.U8LOOP

; compare
	ldx		#RAMU8
	ldab	#RAMU8SIZE-1
	ldaa	#$5f
.U8LOOPc:
	cmpa	0,X
	beq	.OK
	jmp	SPX_FAIL
.OK
	INX
	decb
	bne 	.U8LOOPc


	ldx	#SAF_STR
	jsr uart_tx_x_string


;	staa $2

U8MEMTESTAF:
; fill $AF
	ldx		#RAMU8
	ldab	#RAMU8SIZE-1
	ldaa	#$af
.U8LOOPa:
	staa	0,X
	INX
	dec b
	bne 	.U8LOOPa

; compare
	ldx		#RAMU8
	ldab	#RAMU8SIZE-1
	ldaa	#$af
.U8LOOPca:
	cmpa	0,X
	beq	.OK
	jmp	SPX_FAIL
.OK
	INX
	decb
	bne 	.U8LOOPca



; -------------------------------------------
; Dip switches
; -------------------------------------------
	

	ldx	#DIP_STR
	jsr uart_tx_x_string

; get dipswitches
; inactive
; CB2=0
; U10-A5,6,7=0

; added a lot of waits to let all ports "settle"


	
;	ldaa #$3c	; CA2 off select output
;	staa PIAU10 + CRA
	ldaa  PIAU10 + CRA
	anda	#~($04)
	staa  PIAU10 + CRA
	
	ldab #$ff
	stab PIAU10 + DDRA	; all switch strobes output
	oraa #$4
	staa  PIAU10 + CRA

	clr PIAU10 + DATAA	; all switch strobes off 
	
	
	
; get 25-32	
	; CB2 on , switchstrobe DIP25-32 off
	ldaa  PIAU10 + CRB
	oraa	#$38+$04	; CB2 high sel DATA
;	anda	#~($04) ; sel DDR
	staa  PIAU10 + CRB
	ldaa PIAU10 + DATAB	; switchdata
	staa DIP25

	ldaa  PIAU10 + CRB
	oraa	#$04	; sel DATA
	anda	#~($08) ; CB2 low
	staa  PIAU10 + CRB


	; set PIA10A to DATAA
	ldaa  PIAU10 + CRA
	oraa	#$04	; sel DATA
	staa  PIAU10 + CRA

	ldx #5120
	jsr xwait

; 	ldaa $4000 breakpoints, BPR 4000
; get 17-24
	ldaa #$80
	staa PIAU10 + DATAA	; switchprobe dip17

	ldx #5120
	jsr xwait

	ldaa PIAU10 + DATAB	; switchdata
	staa DIP17


; get 9-16
	ldx #5120
	jsr xwait

	ldaa #$40
	staa PIAU10 + DATAA	; switchprobe dip9

	ldx #5120
	jsr xwait

	ldaa PIAU10 + DATAB	; switchdata
	staa DIP9
	
; get 1-8
	ldx #5120
	jsr xwait
	
	ldaa #$20
	staa PIAU10 + DATAA	; switchprobe dip1
	
	ldx #5120
	jsr xwait
	
	ldaa PIAU10 + DATAB	; switchdata
	staa DIP1


	clr PIAU10 + DATAA	; clear switch strobes

; show binary
	ldaa DIP1
	jsr uart_tx_bin

	ldaa #' '
	jsr uart_tx_a

	ldaa DIP9
	jsr uart_tx_bin

	ldaa #' '
	jsr uart_tx_a

	ldaa DIP17
	jsr uart_tx_bin

	ldaa #' '
	jsr uart_tx_a

	ldaa DIP25
	jsr uart_tx_bin

	ldaa #13
	jsr uart_tx_a
	
	ldaa #10
	jsr uart_tx_a

; -------------------------------------------
; ROM U1 Test
; -------------------------------------------
	
	ldx #U1_STR
	jsr uart_tx_x_string

;	ldaa $4000
	lda #81		; $1000 % 251 +1
	ldx #$1000
ROMU1_LOOP
	cmpa 0,x
	beq	.OK1
	jmp	SPX_FAIL
.OK1
	inca
	inx
	cmpa #253
	bne	.nowrap1
	ldaa #1
.nowrap1
	cpx #$1800
	bne ROMU1_LOOP
	
; -------------------------------------------
; ROM U2 Test
; -------------------------------------------
	
	ldx #U2_STR
	jsr uart_tx_x_string

	lda #150		; $5000 % 251 +1
	ldx #$5000

ROMU2_LOOP
	cmpa 0,x
	beq	.OK2
	jmp	SPX_FAIL
.OK2
	inca
	inx
	cmpa #253
	bne	.nowrap2
	ldaa #1
.nowrap2
	cpx #$5800
	bne ROMU2_LOOP
	
; -------------------------------------------
; test_display_interrupt frequency
; -------------------------------------------
		
test_display_int:
	ldx	#DISPINT_STR
	jsr uart_tx_x_string

	clr DISPLAYCOUNT
	clr DISPLAYCOUNT+1
	ldb PIAU11+CRA
	orab #$1	; enable interrupt A
	stab PIAU11+CRA
	cli
.loopb:

; 500000c/s * 0,25s = 125000c 
; loopcount = (125000-3)/8

	ldx #15324	;3 
.loopx
	dex			;  4
	bne .loopx	;  4

	sei	; and disable interrupts
	ldb PIAU11+CRA
	andb #~($3)	; disable interrupt A
	stab PIAU11+CRA
	

;	ldaa $4000
	; DISPLAYCLOUNT = 328Hz/4 = 82 = $52
	; min 300Hz = 75
	; max 400Hz = 100

	ldaa DISPLAYCOUNT
	jsr uart_tx_hex
	ldaa DISPLAYCOUNT+1
	jsr uart_tx_hex

	ldaa #13
	jsr uart_tx_a
	ldaa #10
	jsr uart_tx_a

	ldaa #75
	cmpa DISPLAYCOUNT
	bls	.OKd1
	;jmp	SPX_FAIL
		ldx	#FAIL_STR
	jsr uart_tx_x_string
.OKd1

	ldaa #100
	cmpa DISPLAYCOUNT
	bgt	.OKd2
	;jmp	SPX_FAIL
		ldx	#FAIL_STR
	jsr uart_tx_x_string
.OKd2

	

; -------------------------------------------
; test zero crossing input
; -------------------------------------------
		
test_zero_int:
	ldx	#ZEROCROSS_STR
	jsr uart_tx_x_string

	clr ZEROCOUNT
	clr ZEROCOUNT+1
	ldb PIAU10+CRB
	orab #$1	; enable interrupt B
	stab PIAU10+CRB
	cli
.loopb:

; 500000c/s * 0,25s = 125000c 
; loopcount = (125000-3)/8


	ldx #15324	;3
.loopx
	dex			;  4
	bne .loopx	;  4

	sei	; and disable interrupts
	ldb PIAU10+CRB
	andb #~($3)	; disable interrupt B
	stab PIAU10+CRB	

	; DISPLAYCLOUNT = 100Hz/4 = 25
	; min 80Hz = 20
	; max 120Hz = 30
	; instable 555 18-40

	ldaa ZEROCOUNT
	jsr uart_tx_hex
	ldaa ZEROCOUNT+1
	jsr uart_tx_hex
	ldaa #13
	jsr uart_tx_a
	ldaa #10
	jsr uart_tx_a

	ldaa #18
	cmpa ZEROCOUNT
	bls	.OK
	;jmp	SPX_FAIL
	ldx	#SOFTFAIL_STR
	jsr uart_tx_x_string
.OK

	ldaa #40
	cmpa ZEROCOUNT
	bgt	.OK2
	;jmp	SPX_FAIL
	ldx	#SOFTFAIL_STR
	jsr uart_tx_x_string
.OK2

	


; -------------------------------------------
; END TEST
; -------------------------------------------
	ldx	#OK_STR
	jsr uart_tx_x_string
	
; some happy blinking		
	ldb	#16
.loopok:
	jsr ledon
	ldx #5120
	jsr xwait
	jsr ledoff
	ldx #5120
	jsr xwait
	decb
	bne .loopok
	
	
	JMP START
	
	
	
	
; -------------------------------------------
; REST IS OLD TESTROM
; -------------------------------------------
	
	
	
	

;	
;	
;	
;	
;	
;; -------------------------------------------
;; Hardware OK
;; -------------------------------------------
;	
;START_HARDWARE_OK:
;	; select DDR
;	CLR		PIAU10 + CRA
;	CLR		PIAU10 + CRB
;	CLR		PIAU11 + CRA
;	CLR		PIAU11 + CRB
;
;	; FF is all ports output exepct U10-B
;	ldaa	#$FF
;	STAA	PIAU10 + DDRA ;switch colum + DISPLAY_SEGMENT+ DISPLAY LATCH
;	CLR		PIAU10 + DDRB ;switch return row
;	STAA	PIAU11 + DDRA ; DISPLAY LATCH+DISPLAY GIGIT
;	STAA	PIAU11 + DDRB ; SOUND + SOLENOIDS
;
;	; 4 = select data register
;	ldaa	#$04
;	STAA	PIAU10 + CRA
;	STAA	PIAU10 + CRB
;	STAA	PIAU11 + CRA
;	STAA	PIAU11 + CRB
;
;
;
;; fill lamps
;	ldaa #$5f
;	ldx	#LAMPS
;	staa $0,x
;	staa $1,x
;	staa $2,x
;	staa $3,x
;	staa $4,x
;	staa $5,x
;	staa $6,x
;	staa $7,x
;
;
;; fill display
;	ldaa #$0f
;	ldab	#5*7+1
;	ldx #DISPLAYBUF2
;.loop	
;	staa $0,x
;	adda #$10
;	oraa #$0f
;	inx
;	decb
;	bne .loop
;
;
;;.brek bra .brek 
;
;mainloop:
;
;
;
;
;
;
;
;; push lamps
;; 0-3 = index
;; 4-7 = lampdata
;; strobe1 = u10cb2
;; Fc clear index c
;; dF set data d on index c
;; can it be combined ?
;
;; 14514
;; inhibit=1 all outputs 0 on strobe
;; inhibit=0 address 1 on strobe
;
;lamptest:
;	ldaa PIAU10 + CRA
;	oraa	#$4	; select data
;	;lda #$04
;	staa PIAU10 + CRA
;
;	ldab #$f0 	;start at lamp address 0
;	ldx #LAMPS
;	
;.lamploop
;;strobe
;	; set channel and clear all 
;	stab PIAU10 + DATAA
;	jsr lampstrobe	; strobe lamp data
;	ldaa $0,X	; data in high, F in low
;	; and/ora address ?
;	staa PIAU10 + DATAA	; push lampdata 0=on
;	jsr lampstrobe	; strobe lampdata
;	inx
;	incb
;	bne .lamploop
;	
;; display loop
;
;	ldaa #$34
;	staa PIAU10 + CRA	; displaystrobe
;	staa PIAU11 + CRA	; lampstrobe 2
;	staa PIAU10 + CRB	; lampstrobe 1
;	
;	ldx #DISPLAYBUF2
;	ldb	#2
;.displayloop1
;	ldaa #$34			; 
;	staa PIAU10 + CRA	; displaystrobe CA2=0
;	
;	tba
;	oraa #$1	; strobe 5
;	staa PIAU11 + DATAA
;	
;	ldaa 0,X			;display 1
;	anda	#$fe
;	staa PIAU10 + DATAA
;	
;	ldaa 7,X			;display 2
;	anda	#$fd
;	staa PIAU10 + DATAA
;
;	ldaa 14,X			;display 3
;	anda	#$fb
;	staa PIAU10 + DATAA
;	
;	ldaa 21,X			;display 4
;	anda	#$f7
;	staa PIAU10 + DATAA
;
;	;display 5
;	stab PIAU11 + DATAA	
;	ldaa 28,X			;display 5
;	staa PIAU10 + DATAA
;
;
;	ldaa #$3c
;	staa PIAU10 + CRA	; displaystrobe CA2=1
;
;	inx
;	aslb
;	bne .displayloop1
;
;
;	
;	jmp mainloop
;	jmp lamptest
;.brek bra .brek 
;	
	



;	ldaa #$50	; data
;	staa TEMP1
;.uloop
;	ldab #$f	;index
;.lloop	
;	ldx #1000
;	jsr xwait
;	
;	tba
;	; strobe
;	oraa TEMP1
;	staa PIAU10 + DATAA
;	
;	ldaa PIAU10 + CRB
;	oraa	#$38
;	staa PIAU10 + CRB
;	oraa	#$30
;	anda #$F7
;	staa PIAU10 + CRB
;	
;	decb
;	bne .lloop
;	ldaa TEMP1
;	eora #$f0
;	anda #$f0
;	staa TEMP1
;	bra .uloop
;
;
;BREAK: bra BREAK


;
;
;; CRA
;;   7   |   6   |  5 4 3   |   2  | 1 0
;; IRQA1 | IRQA2 | CA2 CTRL | DDRA | CA1
;ONLYBLINK:
;	; select DDR
;	CLR		PIAU10 + CRA
;	CLR		PIAU10 + CRB
;	CLR		PIAU11 + CRA
;	CLR		PIAU11 + CRB
;
;	; FF is all ports output exepct U10-B
;	ldaa	#$FF
;	STAA	PIAU10 + DDRA ;switch colum + DISPLAY_SEGMENT+ DISPLAY LATCH
;	CLR		PIAU10 + DDRB ;switch return row
;	STAA	PIAU11 + DDRA ; DISPLAY LATCH+DISPLAY GIGIT
;	STAA	PIAU11 + DDRB ; SOUND + SOLENOIDS
;
;	; 4 = select data register
;	ldaa	#$04
;	STAA	PIAU10 + CRA
;	STAA	PIAU10 + CRB
;	STAA	PIAU11 + CRA
;	STAA	PIAU11 + CRB
;	
;	; clear all outputs
;	ldab	#$ff
;	tba
;
;BLINKLOOP:
;	tba
;	STAA	PIAU10 + DATAA
;;	STAA	PIAU10 + DATAB
;	STAA	PIAU11 + DATAA
;	STAA	PIAU11 + DATAB
;	decb	
;
;
;	;CA2/CB2 output and follow (bit3=data)
;	ldaa	#$30
;	STAA	PIAU10 + CRA
;	STAA	PIAU10 + CRB
;	STAA	PIAU11 + CRA
;	STAA	PIAU11 + CRB
;
;; 512kHz int, 8cycles DELAY= 16ns per loop
;; 0.5s / 0.000016 = 31250 times
;
;		LDX		#31250
;DELAY0b:	DEX
;		BNE DELAY0b
;		
;		
;			;CA2/CB2 output and follow (bit3=data)
;	ldaa	#$38
;	STAA	PIAU10 + CRA
;	STAA	PIAU10 + CRB
;	STAA	PIAU11 + CRA
;	STAA	PIAU11 + CRB
;
;; 512kHz int, 8cycles DELAY= 16ns per loop
;; 0.5s / 0.000016 = 31250 times
;
;		LDX		#31250
;DELAY0a:	DEX
;		BNE DELAY0a
;		
;		
;		
;		
;		
;		BRA BLINKLOOP
;		
IRQ:
	SEI
	
; get display interrupt
	ldaa PIAU11+CRA
	tab			; savestate 
	anda #~($40) ; IRQA1-flag
	beq	.noirqa
	inc	DISPLAYCOUNT
	bcc	.noc
	inc	DISPLAYCOUNT+1
.noc
	oraa #$04
	staa PIAU11+CRA
	ldaa PIAU11+DATAA

	stab PIAU11+CRA
.noirqa:


; get zero crossing interrupt
	ldaa PIAU10+CRB
	tab			; savestate 
	anda #~($40) ; IRQB1-flag
	beq	.znoirqa
	inc	ZEROCOUNT
	bcc	.znoc
	inc	ZEROCOUNT+1
.znoc
	oraa #$04		;select data
	staa PIAU10+CRB
	ldaa PIAU10+DATAB ; read data to clear irq

	stab PIAU10+CRB
.znoirqa:


	RTI
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
