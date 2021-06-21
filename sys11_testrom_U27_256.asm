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

	;cpu 6800
	; to fill eprom
	
	org $200


; variables
TEMP1	rmb 1
TEMP2	rmb 1
TEMPH	rmb 1
TEMPL   rmb 1
DISPLAYBUF1 rmb 16*2
DISPLAYBUF2 rmb 16
LINE1 rmb 16
LINE2 rmb 16
LINECNT rmb 1
		rmb 16
LAMPS rmb 8
LAMPCNT rmb 1
LOOPCOUNT1	rmb 1
LOOPCOUNT2	rmb 1
DUM1	rmb 1
SOUNDINDEX	rmb 1
ENDVARS
    org $7fe
ENDRAM rmb 1
	
	org	$8000
	;db "0123456789012345"
	db	"Williams SYS11  "
INFO:	db  "TESTROM   V1.0  12"
INFO3:	db  " !\"#$%&'()*+,-./012345 "

INFO2:	db  "0123456789ABCDEFHH"
	db  "arco@appeltaart."
	db  "mine.nu         "
	
	.include font.asm
DISPLAYDATA:
		db "ABCDEFGHIJKLMNOPQRSTU"
		
		
SOUNDDATA1:
	dw	$9063,$39ff,$ff7e,$9ce8,$7e9c,$fc7e,$9d23,$7e9d
	dw	$2e39,$ffff,$39ff,$ff7e,$98ba,$7e8c,$0339,$ffff
	dw	$39ff,$ff7e,$9ec1,$7e9e,$6539,$ffff,$39ff,$ff7e
	dw	$840c,$39ff,$ff39,$ffff,$39ff,$ff39,$ffff,$7e9e
	dw	$c67e,$9d4d,$7e8c,$007e,$8c06,$7e9d,$5739,$ffff
	dw	$39ff,$ff39,$ffff,$7e9e,$dd7e,$9f2c,$7ec5,$017e
	dw	$4003,$7e40,$007e,$9d1b,$39ff,$ff39,$ffff,$ffff
	dw	$6906,$3f06,$3706,$400f,$8ec1,$0d7e,$d66b,$8634
	dw	$b734,$018e,$c118,$7ec2,$fa7f,$0082,$bdc3,$61bd
	dw	$c3bf,$8ec1,$277e,$d66b,$bdc4,$9abd,$c4d4,$9682
	dw	$26e1,$bddf,$d97e,$c501,$0f8e,$c13e,$7ed6,$6b86
	dw	$34b7,$3401,$0926,$fd8e,$c14c,$7ec2,$fa7f,$0082
	dw	$bdc3,$61bd,$c3ac,$bdc3,$bf8e,$c15e,$7ed6,$6bbd
	dw	$c49a,$bdc4,$d496,$8226,$de7e,$c501,$9783,$df80
	dw	$d782,$d700,$9f86,$0f8e,$c17c,$7ed6,$6b17,$ce00
	dw	$3cff,$2800,$ce92,$7c09,$26fd,$ce70,$3cff,$2800
	dw	$ce92,$7c09,$26fd,$4a26,$e58e,$0046,$cec2,$5217
	dw	$4848,$4810,$0808,$4a26,$fb86,$717f,$2c02,$7f2c
	dw	$00b7,$2800,$a600,$b72c,$02a6,$01b7,$2c00,$0808
	dw	$86a6,$4a26,$fdb6,$2800,$4c85,$0726,$de4c,$cec2
	dw	$527f,$2c02,$7f2c,$00b7,$2800,$a600,$b72c,$02a6
	dw	$01b7,$2c00,$0808,$86a6,$4a26,$fdb6,$2800,$4c85
	dw	$0726,$de34,$308c,$003f,$272d,$8c00,$3827,$288c
	dw	$0031,$2723,$8c00,$2a27,$1e8c,$0023,$2719,$8c00
	dw	$1c27,$148c,$0015,$270f,$8c00,$0e27,$0a8c,$0007
	dw	$2705,$8c00,$0026,$177f,$2c02,$7f2c,$0086,$70b7
	dw	$2800,$ce80,$0009,$26fd,$308c,$0000,$2703,$7ec1
	dw	$9cc1,$0126,$037e,$c176,$9e86,$9683,$d682,$de80
	dw	$0d39,$7100,$7708,$0922,$3800,$3e00,$7318,$7900
	dw	$3e00,$5b08,$6d08,$0000,$7318,$7708,$3605,$3605
	dw	$7900,$3685,$7308,$7318,$3f00,$01a2,$3e00,$6d08
	dw	$0600,$0000,$7308,$0922,$7708,$3e00,$4f08,$7f08
	dw	$0000,$7308,$0922,$7708,$3e00,$6608,$0600,$0000
	dw	$7308,$0922,$7708,$3e00,$6608,$5b08,$0000,$7308
	dw	$0922,$7708,$3e00,$6d08,$6608,$0000,$7308,$0922
	dw	$7708,$3e00,$0600,$3f00,$0000,$7308,$0922,$7708
	dw	$0000,$0000,$0000,$0000,$0922,$7318,$3f10,$3e00
	dw	$5b08,$0700,$0000,$7318,$3f00,$3605,$3e00,$5b08
	dw	$7d08,$0000,$7318,$3f00,$3605,$b606,$9af6,$069b
ENDSOUNDDATA:




	org $A000
	

DATAA	equ 0
DATAB	equ 2
DDRA	equ 0
DDRB	equ 2
CRA		equ 1
CRB		equ	3

PIAU10	equ	$2100
PIAU10PDRA 	equ PIAU10 + DATAA
PIAU10PDRB 	equ PIAU10 + DATAB
PIAU10CRA 	equ PIAU10 + CRA
PIAU10CRB 	equ PIAU10 + CRB
PIAU10DDRA 	equ PIAU10 + DDRA
PIAU10DDRB 	equ PIAU10 + DDRB


PIAU38	equ	$3000
PIAU38PDRA 	equ PIAU38 + DATAA
PIAU38PDRB 	equ PIAU38 + DATAB
PIAU38CRA 	equ PIAU38 + CRA
PIAU38CRB 	equ PIAU38 + CRB
PIAU38DDRA 	equ PIAU38 + DDRA
PIAU38DDRB 	equ PIAU38 + DDRB


PIAU41	equ	$2c00
PIAU41PDRA 	equ PIAU41 + DATAA
PIAU41PDRB 	equ PIAU41 + DATAB
PIAU41CRA 	equ PIAU41 + CRA
PIAU41CRB 	equ PIAU41 + CRB
PIAU41DDRA 	equ PIAU41 + DDRA
PIAU41DDRB 	equ PIAU41 + DDRB

PIAU42	equ	$3400
PIAU42PDRA 	equ PIAU42 + DATAA
PIAU42PDRB 	equ PIAU42 + DATAB
PIAU42CRA 	equ PIAU42 + CRA
PIAU42CRB 	equ PIAU42 + CRB
PIAU42DDRA 	equ PIAU42 + DDRA
PIAU42DDRB 	equ PIAU42 + DDRB



PIAU54	equ	$2400
PIAU54PDRA 	equ PIAU54 + DATAA
PIAU54PDRB 	equ PIAU54 + DATAB
PIAU54CRA 	equ PIAU54 + CRA
PIAU54CRB 	equ PIAU54 + CRB
PIAU54DDRA 	equ PIAU54 + DDRA
PIAU54DDRB 	equ PIAU54 + DDRB

U28		equ	$2200
SOLENOIDS	equ U28

PIAU51		equ	$2800
PIAU51PDRA 	equ PIAU51 + DATAA
PIAU51PDRB 	equ PIAU51 + DATAB
PIAU51CRA 	equ PIAU51 + CRA
PIAU51CRB 	equ PIAU51 + CRB
PIAU51DDRA 	equ PIAU51 + DDRA
PIAU51DDRB 	equ PIAU51 + DDRB




LAMPSNOT:
		dc.b ~(1<<0)
		dc.b ~(1<<0)
		dc.b ~(1<<2)
		dc.b ~(1<<3)
		dc.b ~(1<<4)
		dc.b ~(1<<5)
		dc.b ~(1<<6)
		dc.b 127

; PIAU10_CA1 n.c.
; PIAU51_PA4 diagnostic led
INITPIA:
	; set all PIA's as output
	; select DDR 
	CLR		PIAU10CRA
	CLR		PIAU10CRB
	CLR		PIAU38CRA 
	CLR		PIAU38CRB
	CLR		PIAU41CRA
	CLR		PIAU41CRB
	CLR		PIAU42CRA
	CLR		PIAU42CRB
	CLR		PIAU51CRA
	CLR		PIAU51CRB
	CLR		PIAU54CRA
	CLR		PIAU54CRB
	
	; FF is all ports output
	ldaa	#$FF
	STAA	PIAU10DDRA
	STAA	PIAU10DDRB
	clr		PIAU38DDRA ;switch input
	STAA	PIAU38DDRB
	STAA	PIAU41DDRA
	STAA	PIAU41DDRB
	STAA	PIAU42DDRA
	STAA	PIAU42DDRB
	STAA	PIAU51DDRA
	STAA	PIAU51DDRB
	STAA	PIAU54DDRA
	STAA	PIAU54DDRB

	; 4 = select data register
	ldaa	#$04
	STAA	PIAU10CRA
	STAA	PIAU10CRB
	;STAA	PIAU38CRA
	STAA	PIAU38CRB
	STAA	PIAU41CRA
	STAA	PIAU41CRB
	STAA	PIAU42CRA
	STAA	PIAU42CRB
	STAA	PIAU51CRA
	STAA	PIAU51CRB
	STAA	PIAU54CRA
	STAA	PIAU54CRB

	ldaa	#$55
	STAA	PIAU10DDRA
	STAA	PIAU10DDRB
	STAA	PIAU38DDRB
	STAA	PIAU41DDRA
	STAA	PIAU41DDRB
	STAA	PIAU42DDRA
	STAA	PIAU42DDRB
	STAA	PIAU51DDRA
	STAA	PIAU51DDRB
	STAA	PIAU54DDRA
	STAA	PIAU54DDRB

	rts
PIADATA:
	; PIA is in datamode
	ldaa #$34
	STAA	PIAU10CRA
	STAA	PIAU10CRB
	;STAA	PIAU38CRA
	STAA	PIAU38CRB
	STAA	PIAU41CRA
	STAA	PIAU41CRB
	STAA	PIAU42CRA
	STAA	PIAU42CRB
	STAA	PIAU51CRA
	STAA	PIAU51CRB
	STAA	PIAU54CRA
	STAA	PIAU54CRB
	rts

DIAGON:
	ldaa	PIAU51CRA
	oraa	#4
	staa	PIAU51CRA
	ldaa PIAU10PDRA
	oraa	#(1<<4)
	staa PIAU10PDRA
	rts

DIAGOFF:
	ldaa	PIAU51CRA
	oraa	#4
	staa	PIAU51CRA
	ldaa PIAU10PDRA
	oraa	#(1<<4)
	staa PIAU10PDRA
	rts

WAITX:	
		LDX		#62500/256
		;LDX		#62500

WAITXa:	
		DEX
		BNE WAITXa
		rts
ALLOFF:
	; solenoids
	CLR		U28

	; select DDR 
	CLR		PIAU10 + CRA
	CLR		PIAU10 + CRB

	CLR		PIAU38 + CRB
	CLR		PIAU41 + CRA
	CLR		PIAU41 + CRB
	CLR		PIAU42 + CRA
	CLR		PIAU42 + CRB
	;CLR		PIAU51 + CRA
	CLR		PIAU51 + CRB
	CLR		PIAU54 + CRA
	CLR		PIAU54 + CRB
	
	; FF is all ports output
	ldaa	#$FF
	STAA	PIAU10 + DDRA
	STAA	PIAU10 + DDRB

	STAA	PIAU38 + DDRB
	STAA	PIAU41 + DDRA
	STAA	PIAU41 + DDRB
	STAA	PIAU42 + DDRA
	STAA	PIAU42 + DDRB
	;STAA	PIAU51 + DDRA
	STAA	PIAU51 + DDRB
	STAA	PIAU54 + DDRA
	STAA	PIAU54 + DDRB
	
	; 4 = select data register
	ldaa	#$04
	STAA	PIAU10 + CRA
	STAA	PIAU10 + CRB

	STAA	PIAU38 + CRB
	STAA	PIAU41 + CRA
	STAA	PIAU41 + CRB
	STAA	PIAU42 + CRA
	STAA	PIAU42 + CRB
	;STAA	PIAU51 + CRA
	STAA	PIAU51 + CRB
	STAA	PIAU54 + CRA
	STAA	PIAU54 + CRB
	
	; clear all outputs
	ldaa	#$FF
	STAA	PIAU10 + DATAA
	STAA	PIAU10 + DATAB

	STAA	PIAU38 + DATAB
	STAA	PIAU41 + DATAA
	STAA	PIAU41 + DATAB
	STAA	PIAU42 + DATAA
	STAA	PIAU42 + DATAB
	;STAA	PIAU51 + DATAA
	STAA	PIAU51 + DATAB
	STAA	PIAU54 + DATAA
	STAA	PIAU54 + DATAB
	
	;CA2/CB2 output and follow (bit3=data)
	ldaa	#$30
	STAA	PIAU10CRA
	STAA	PIAU10CRB
	STAA	PIAU38CRA
	STAA	PIAU38CRB
	STAA	PIAU41CRA
	STAA	PIAU41CRB
	STAA	PIAU42CRA
	STAA	PIAU42CRB
	;STAA	PIAU51CRA
	STAA	PIAU51CRB
	STAA	PIAU54CRA
	STAA	PIAU54CRB

	; 4 = select data register
	ldaa	#$04
	STAA	PIAU10CRA
	STAA	PIAU10CRB
	STAA	PIAU38CRA
	STAA	PIAU38CRB
	STAA	PIAU41CRA
	STAA	PIAU41CRB
	STAA	PIAU42CRA
	STAA	PIAU42CRB
	;STAA	PIAU51CRA
	STAA	PIAU51CRB
	STAA	PIAU54CRA
	STAA	PIAU54CRB
	rts
	
ALLON:

	; select DDR 
	CLR		PIAU10CRA
	CLR		PIAU10CRB
	CLR		PIAU38CRA
	CLR		PIAU38CRB
	CLR		PIAU41CRA
	CLR		PIAU41CRB
	CLR		PIAU42CRA
	CLR		PIAU42CRB
	;CLR		PIAU51CRA
	CLR		PIAU51CRB
	CLR		PIAU54CRA
	CLR		PIAU54CRB

	; FF is all ports output
	ldaa	#$FF
	STAA	PIAU10DDRA
	STAA	PIAU10DDRB

	STAA	PIAU38DDRB
	STAA	PIAU41DDRA
	STAA	PIAU41DDRB
	STAA	PIAU42DDRA
	STAA	PIAU42DDRB
	;STAA	PIAU51DDRA
	STAA	PIAU51DDRB
	STAA	PIAU54DDRA
	STAA	PIAU54DDRB
	
	; 4 = select data register
	ldaa	#$04
	STAA	PIAU10CRA
	STAA	PIAU10CRB

	STAA	PIAU38CRB
	STAA	PIAU41CRA
	STAA	PIAU41CRB
	STAA	PIAU42CRA
	STAA	PIAU42CRB
	;STAA	PIAU51CRA
	STAA	PIAU51CRB
	STAA	PIAU54CRA
	STAA	PIAU54CRB
	
	; set all outputs
	ldaa	#$FF
	STAA	PIAU10PDRA
	STAA	PIAU10PDRB
	STAA	PIAU38PDRA
	STAA	PIAU38PDRB
	STAA	PIAU41PDRA
	STAA	PIAU41PDRB
	STAA	PIAU42PDRA
	STAA	PIAU42PDRB
	;STAA	PIAU51PDRA
	STAA	PIAU51PDRB
	STAA	PIAU54PDRA
	STAA	PIAU54PDRB
	
	;CA2/CB2 output and follow (bit3=data)
	ldaa	#$38
	STAA	PIAU10CRA
	STAA	PIAU10CRB
	STAA	PIAU38CRA
	STAA	PIAU38CRB
	STAA	PIAU41CRA
	STAA	PIAU41CRB
	STAA	PIAU42CRA
	STAA	PIAU42CRB
	;STAA	PIAU51CRA
	STAA	PIAU51CRB
	STAA	PIAU54CRA
	STAA	PIAU54CRB
	
	rts
DISPLAYROWA:
	rts
	
INITVARS:
	ldx #ENDVARS
.loop:
	clr 0,X
	dex
	bne .loop
	
	lda #1
	staa LAMPCNT
	staa LINECNT


	ldab #$f
	ldaa #'A'
	ldx #LINE1
.bloop
	staa 0,x
	inx
	inca
	decb
	bne .bloop

	ldab #$f
	ldaa #'H'
	ldx #LINE2
.bloop2
	staa 0,x
	inx
	inca
	decb
	bne .bloop2
	
	
; lamps
	ldaa #~(1<<0)
	staa LAMPS	
	ldaa #~(1<<1)
	staa LAMPS+1
	ldaa #~(1<<2)
	staa LAMPS+2
	ldaa #~(1<<3)
	staa LAMPS+3
	ldaa #~(1<<4)
	staa LAMPS+4
	ldaa #~(1<<5)
	staa LAMPS+5
	ldaa #~(1<<6)
	staa LAMPS+6
	ldaa #127
	staa LAMPS+7
	
	
	cli		; enable interrupt
	rts ;/INITVARS
	
CHAR14 MACRO index
	ldaa LINE1 + index
	cmpa	#32
	bne .nospace
	clr DISPLAYBUF1+(2*index)
	clr DISPLAYBUF1+(2*index)+1
	bra next
.nospace
	cmpa	#32
	bge		.ok1
	ldaa #32
.ok1:	suba	#32
	ldx #LCD14FONT
$$xadda1:
	inx
	inx
	deca
	bne $$xadda1
	
	ldaa 0,x
	staa DISPLAYBUF1+(2*index)
	inx
	ldaa 0,x
	staa DISPLAYBUF1+(2*index)+1
next	
	ENDM	;CHAR14

CHAR7 MACRO index
	ldaa LINE2 + index
	cmpa	#32
	bge		.ok1
	ldaa #32
.ok1:	suba	#32
	ldx #LCD7FONT
$$xadda1:
	inx
	deca
	bne $$xadda1
	
	ldaa 0,x
	staa DISPLAYBUF2+index
	
	ENDM	;/CHAR7


PRINTLINES:
	CHAR14 index=0
	CHAR14 index=1
	CHAR14 index=2
	CHAR14 index=3
	CHAR14 index=4
	CHAR14 index=5
	CHAR14 index=6
	CHAR14 index=7
	CHAR14 index=8
	CHAR14 index=9
	CHAR14 index=10
	CHAR14 index=11
	CHAR14 index=12
	CHAR14 index=13
	CHAR14 index=14
	CHAR14 index=15

	CHAR7 index=0
	CHAR7 index=1
	CHAR7 index=2
	CHAR7 index=3
	CHAR7 index=4
	CHAR7 index=5
	CHAR7 index=6
	CHAR7 index=7
	CHAR7 index=8
	CHAR7 index=9
	CHAR7 index=10
	CHAR7 index=11
	CHAR7 index=12
	CHAR7 index=13
	CHAR7 index=14
	CHAR7 index=15
	rts
	
SHOWLAMPS:
	ldaa	#$04		;pia data
	STAA	PIAU54CRA
	STAA	PIAU54CRB

	; turn off lamps
	ldaa	#$ff
	staa PIAU54PDRA


	ldx #LAMPS
	ldab	#1
	ldaa LAMPCNT
	deca

.lampindex
	cmpa	#0
	beq .done
	
	rolb
	inx
	deca
	bra .lampindex
.done
	
	
	stab PIAU54PDRB	;row

	ldab	0,X
	stab PIAU54PDRA	;data

	ldaa LAMPCNT
	deca
	cmpa #0
	bne .notnull
	ldaa #$8
.notnull
	staa LAMPCNT
	rts		;/SHOWLAMPS

DISPLAYIT:
	ldaa	#$04
	STAA	PIAU51CRA
	STAA	PIAU41CRA
	STAA	PIAU41CRB
	STAA	PIAU51CRB
	
	clr 	PIAU41PDRA
	clr 	PIAU41PDRB
	clr		PIAU51PDRB
	
	ldx	#DISPLAYBUF1

	; set row and leave other output bits
	ldaa PIAU51PDRA
	anda #$f0
	adda LINECNT
	staa PIAU51PDRA

	lda	LINECNT
.xadda:
	inx
	inx
	deca
	bne .xadda
	dex
	dex
	
	ldaa 0,X
	staa PIAU41PDRA

	ldaa 1,X
	staa PIAU41PDRB
	
	ldx	#DISPLAYBUF2
	lda	LINECNT
.xadda2:
	inx
	deca
	bne .xadda2
	dex
	
	ldaa 0,X
	staa PIAU51PDRB
	
	dec LINECNT
	bne .ok
	ldaa #$f
	staa LINECNT
.ok:
	rts
	
COPYXLINE1:
	ldaa	0,x
	staa	LINE1
	ldaa	1,x
	staa	LINE1+1
	ldaa	2,x
	staa	LINE1+2
	ldaa	3,x
	staa	LINE1+3
	ldaa	4,x
	staa	LINE1+4
	ldaa	5,x
	staa	LINE1+5
	ldaa	6,x
	staa	LINE1+6
	ldaa	7,x
	staa	LINE1+7
	ldaa	8,x
	staa	LINE1+8
	ldaa	9,x
	staa	LINE1+9
	ldaa	10,x
	staa	LINE1+10
	ldaa	11,x
	staa	LINE1+11
	ldaa	12,x
	staa	LINE1+12
	ldaa	13,x
	staa	LINE1+13
	ldaa	14,x
	staa	LINE1+14
	ldaa	15,x
	staa	LINE1+15
	rts
	
COPYXLINE2:
	ldaa	0,x
	staa	LINE2
	ldaa	1,x
	staa	LINE2+1
	ldaa	2,x
	staa	LINE2+2
	ldaa	3,x
	staa	LINE2+3
	ldaa	4,x
	staa	LINE2+4
	ldaa	5,x
	staa	LINE2+5
	ldaa	6,x
	staa	LINE2+6
	ldaa	7,x
	staa	LINE2+7
	ldaa	8,x
	staa	LINE2+8
	ldaa	9,x
	staa	LINE2+9
	ldaa	10,x
	staa	LINE2+10
	ldaa	11,x
	staa	LINE2+11
	ldaa	12,x
	staa	LINE2+12
	ldaa	13,x
	staa	LINE2+13
	ldaa	14,x
	staa	LINE2+14
	ldaa	15,x
	staa	LINE2+15
	rts
	
BGSOUNDRESET:
	; strobe is U42 CB2
	; low active, so set high
	ldaa	PIAU42CRB
	;eora	#$8		;toggle CA2
	;anda	#~$8		;clr CA2
	oraa	#$8		;set CA2
	oraa	#$4 	;select pdr
	ldaa #$3c
	staa	PIAU42CRB

	; reset is U42 CA2
	; low active
	ldaa	PIAU42CRA
	;eora	#$8		;toggle CA2
	anda	#~$8		;clr CA2
	;ora	#$8		;set CA2
	oraa	#$4 	;select pdr
	ldaa #$34
	staa	PIAU42CRA

	;leave reset low for a short while
	LDX		#2500
.delay:	
	DEX
	BNE .delay

	; high, normal operation
	ldaa	PIAU42CRA
	;eora	#$8		;toggle CA2
	;anda	#~$8		;clr CA2
	oraa	#$8		;set CA2
	oraa	#$4 	;select pdr
	ldaa #$3c
	staa	PIAU42CRA
	rts
	
BGSOUNDB:
	
	ldaa	PIAU42CRB
	;eora	#$8		;toggle CB2
	;anda	#~$8		;clr CB2
	oraa	#$8		;set CB2
	
	oraa	#$4 	;select pdr
	ldaa #$3c
	staa	PIAU42CRB
;	ldab	#$55
	stab	PIAU42PDRB

	ldaa	PIAU42CRB
	;eora	#$8		;toggle CA2
	anda	#~$8		;clr CA2
	;ora	#$8		;set CA2
	oraa	#$4 	;select pdr
	ldaa #$34
	staa	PIAU42CRB

		
		
	ldaa	PIAU42CRB
	;eora	#$8		;toggle CA2
	;anda	#~$8		;clr CA2
	oraa	#$8		;set CA2
	oraa	#$4 	;select pdr
	ldaa #$3c
	staa	PIAU42CRB
	;staa LAMPS+1
	jsr TOGGLEDIAG
	rts
	
	
SOUNDB:
	ldaa	PIAU10CRA
	;eora	#$8		;toggle CA2
	;anda	#~$8		;clr CA2
	oraa	#$8		;set CA2
	oraa	#$4 	;select pdr
	ldaa #$3c
	staa	PIAU10CRA

	; sound data
	stab	PIAU10PDRA

	ldaa	PIAU10CRA
	;eora	#$8		;toggle Cx2
	anda	#~$8		;clr Cx2
	;ora	#$8		;set Cx2
	
	oraa	#$4 	;select pdr
	ldaa #$34
	staa	PIAU10CRA
	
	ldaa	PIAU10CRA
	;eora	#$8		;toggle Cx2
	;anda	#~$8		;clr Cx2
	oraa	#$8		;set Cx2
	oraa	#$4 	;select pdr
	ldaa #$3c
	staa	PIAU10CRA
	;staa LAMPS+2
	rts	;SOUNDB
	
TOGGLEDIAG:
	ldaa	PIAU51CRA
	eora	#$8		;toggle CA2
	oraa	#$4 	;select pdr
	staa	PIAU51CRA
	ldaa	PIAU51PDRA
	eora	#(1<<4)	;toggle PA4
	staa	PIAU51PDRA
	rts	;/TOGGLEDIAG
	
; #################################################3
; # START2
START2:
	lds	#$7ff
	;sei			;disable interrupt
	clr	SOLENOIDS	; disable solonoids
	jsr INITVARS
	jsr INITPIA
	ldx #INFO
	jsr COPYXLINE1
	ldx #INFO2
	jsr COPYXLINE2

	jsr PRINTLINES
	clr LOOPCOUNT1
	clr LOOPCOUNT2

	ldaa #$0
	staa SOUNDINDEX

	jsr BGSOUNDRESET
	jsr WAITX
	ldaa #$aa
	staa LAMPS


	ldab #$90
	jsr SOUNDB
	ldab #$63
	jsr SOUNDB
	ldab #$39
	jsr SOUNDB
	ldab #$ff 
	jsr SOUNDB
	ldab #$ff
	jsr SOUNDB
	ldab #$7e 
	jsr SOUNDB
	ldab #$9c
	jsr SOUNDB
	ldab #$e8 
	jsr SOUNDB
	ldab #$7e
	jsr SOUNDB
	ldab #$9c
	jsr SOUNDB
	
	ldx #SOUNDDATA1
.sloop:
	ldab 0,X
	inx
	jsr SOUNDB
	cpx	#ENDSOUNDDATA
	ble	.sloop

LOOPJE:
;	ldab #$f
;DIAGLOOP:;
;	stab U28
;	lda #0
;	ABA
;	ldx	#DISPLAYDATA
;X;NOMEM
;	inx
;	deca
;	bne XNOMEM
	; x=b
	
	
;	jsr DIAGON
;	jsr ALLON
;	jsr PIADATA

;	ldaa 0,X
;	staa PIAU41PDRA

;	ldaa 1,X
;	staa PIAU41PDRB

;	stab PIAU51PDRA

	;rol LAMPS
	;ror LAMPS+1
	inc LOOPCOUNT2
	ldaa LOOPCOUNT2
	;staa LAMPS+6

	;ldab	SOUNDINDEX
	;stab LAMPS+6
	;jsr SOUNDB
	

	inc LOOPCOUNT2
	ldaa LOOPCOUNT2
	;staa LAMPS+7
	cmpa #250
	bne	.norol
	clr LOOPCOUNT2
	
	;jsr TOGGLEDIAG
	inc LOOPCOUNT1
	ldaa LOOPCOUNT1
	cmpa #20
	bne	.norol2
	clr LOOPCOUNT1

	ldab	SOUNDINDEX
	jsr BGSOUNDB
	
	ldab	SOUNDINDEX
	jsr SOUNDB
	inc SOUNDINDEX

.norol2

	ldaa LAMPS
	rola
	rol LAMPS
	
	ldaa LAMPS+1
	rora
	ror LAMPS+1

	ldaa LAMPS+2
	rola
	rol LAMPS+2
	
	ldaa LAMPS+3
	rora
	ror LAMPS+3

	ldaa LAMPS+4
	rola
	rol LAMPS+4

	ldaa LAMPS+5
	rora
	ror LAMPS+5
	;rol LAMPS+6
	;ror LAMPS+7
	
	
.norol

;	jsr DISPLAYIT
;	jsr SHOWLAMPS
	jsr WAITX
	
;	clr PIAU41PDRA
;	clr PIAU41PDRB
;	clr PIAU42PDRA
	
;	jsr DIAGOFF
;	jsr ALLOFF
;	jsr PIADATA
;	stab PIAU51PDRA
;	clr PIAU41PDRA
	;jsr DISPLAYIT
	;jsr WAITX

	;decb
	;bne DIAGLOOP
	bra LOOPJE
	
	; set all outputs
	ldaa	#$55
	CLR	PIAU10PDRA
	CLR	PIAU10PDRB
	CLR	PIAU38PDRB
	CLR	PIAU41PDRA
	CLR	PIAU41PDRB
	CLR	PIAU42PDRA
	CLR	PIAU42PDRB
	CLR	PIAU51PDRA
	CLR	PIAU51PDRB
	CLR	PIAU54PDRA
	CLR	PIAU54PDRB
	
	
	
	; SET DIAGNOSTCS ON

	
	ldaa #$ff 
	staa	PIAU54PDRA


	;ldab	PIAU51PDRA
	;orab	#(1<<4)
	;stab	PIAU51PDRA


	ldaa	#$04
	STAA	PIAU51 + CRA
	
	ldaa	#$f
	staa PIAU54+DATAA

		ldab	#$ff
W2:		ldaa	#$f
V2:	ldaa #$55	
	staa PIAU54PDRA
	staa PIAU51PDRA
	
		LDX		#62500
DELAY2a:	
		DEX
		BNE DELAY2a
		
		deca
		bne V2
		
		decb
		bne W2



	ldaa	#$55
RAM0:
	ldx		#$799
	; for now just a wait...
RAM0L:	
	ldaa #$04

	staa	PIAU42PDRB
	staa	PIAU54+DATAA
	
	
	dex
	bne RAM0L

	; test memory
	; 6802 has 128 bytes/32 retainable
	; test only 32...127?
	; if /RE then external ram $000-$7FF 
	; if memory OK, stack
	; memory fail blink all

	; SET DIAGNOSTCS OFF
	; PIA is in datamode
D:	ldaa #$04
	STAA	PIAU51CRA
	;ldab	PIAU51PDRA
	;andb	#~(1<<4)
	clr	PIAU51PDRA

	; char=A
	;ldx		#LCD14FONT+'A'-32
	;ldaa 	0,x
	ldaa	#$55
	staa	PIAU41PDRA
	;inx
	;ldaa 	0,x
	ldaa	#$aa
	stab	PIAU41PDRB

	; char=A
	;ldx		#LCD7FONT+'5'-32
	ldaa 	0,x
	ldaa	#$55
	staa	PIAU42PDRA
	
DODISPLAY:
	ldaa	#$ff
DISPLAYLOOP:
	
	ldab	#$55
	;andb	PIAU51PDRA
	;oraa	PIAU51PDRA
	stab	PIAU51PDRA
	;ldaa #$55	
	staa PIAU54PDRA
	;staa PIAU51PDRA
	; debug
	staa	PIAU42PDRB
	
	ldx		#5000
wait1:
	dex
	bne		wait1
	
	;cmpa	#0
	deca
	bne	DISPLAYLOOP
	jmp START2

	; cpu irq==1ms?
	;DISPLAY_WIL11A display1 ( &PIAU41 alpha , &PIAU51 7seg , &PIAU42 widget);
	; display == blanking	
	; lamps PIAU54
	; display 
	; lamps
	;all others blink


START:
; CRA
;   7   |   6   |  5 4 3   |   2  | 1 0
; IRQA1 | IRQA2 | CA2 CTRL | DDRA | CA1

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

	ldaa	#$04
	STAA	PIAU51 + CRA

		ldab	#$ff
W:		ldaa	#$f
V:		staa PIAU51PDRA
		LDX		#62500
DELAY2:	
		DEX
		BNE DELAY2
		
		deca
		bne V
		
		decb
		bne W




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



		jmp	START2
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

IRQVEC:
	sei
	jsr DISPLAYIT
	jsr SHOWLAMPS
	rti
	
SWIVEC:
	rti


; VECTOR table
	.org $FFF8
	dw	IRQVEC
	dw	SWIVEC
	dw 	NMI ;NMI Vector
	dw 	START2	; reset vector