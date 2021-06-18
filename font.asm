;/** 
;*	Font 7-Segment LCD/LED
;*
;*     -----a-----
;*    |           |
;*    f           b
;*    |           |
;*     -----g-----
;*    |           |
;*    e           c
;*    |           |
;*     -----d-----
;*                  *P	  
;* Font and character definition based on MAX8650 datasheet
;* 
;*/

;/** 7 segment font */
;const int8_t lcdFont7[] PROGMEM =
;{
;//    Pgfedcba
	;org $8000
GETLCD7:
		
	db "LCD7FONT"
LCD7FONT:
	db	%00000000 	
	; <Blank> code32
	db %00000000 	
	; !
	db %00100010 	;/ "
	db %00000000 	;/ #
	db %00000000 	;/ $
	db %00000000 	;/ %
	db %00000000 	;/ &
	db %00000000 	;/ '
	db %00000000 	;/ (
	db %00000000 	;/ )
	db %00000000 	;/ *
	db %00000000 	;/ +
	db %00000000 	;/ ,
	db %01000000   ; //-
	db %10000000   ; //.
	db %00000000 	;/ /
					;
	;// met comma   ;
	db %10111111 	;/0
	db %10000110 	;/1
	db %11011011 	;/2
	db %11001111 	;/3
	db %11100110 	;/4
	db %11101101 	;/5
	db %11111101 	;/6
	db %10000111 	;/7
	db %11111111 	;/8
	db %11101111 	;/9
	db %00000100 	;/ :
	db %00010100 	;/ ;
	db %00100100 	;/ <
	db %00001000 	;/ =
	db %00000001 	;/ >
	db %00101000 	;/ ?
	db %00001010 	;/ @
TEST7A:					;
	db %01110111 	;/A
	db %01111100 	;/B
	db %00111001 	;/C
	db %01011110 	;/D
	db %01111001 	;/E
	db %01110001	;	//F
	db %00111101 	;/ G
	db %01110110 	;/ H
	db %00000100 	;/ I
	db %00011110 	;/ J
	db %00110100 	;/ K
	db %00111000 	;/ L
	db %00110111 	;/ M
	db %01010100 	;/ N
					;
	db %01011100 	;/ O
	db %01110011 	;/ P
	db %01100111 	;/ Q
	db %01010000 	;/ R
	db %01101101 	;/ S
	db %01111000 	;/ T
	db %00011100 	;/ U
	db %00111000 	;/ V
	db %00111110 	;/ W
	db %01110110 	;/ X
	db %01110010 	;/ Y
	db %01011011 	;/ Z


	
;/* Font 14-Segment LCD/LED
;* 
;*     -----a-----
;*    | \   |   / |
;*    f  h  i  j  b
;*    |   \ | /   |
;*     -g1-- --g2-   g1=g g2=G
;*    |   / | \   |
;*    e  m  l  k  c
;*    | /   |   \ |
;*     -----d-----
;*                  *P
;*	               ,K 
;* Font and character definition based on MAX8650 datasheet
;*
;*/
;/** 14 segment font */
;       KPmlkjihGgfedcba
;       PmlkGjihKgfedcba
	db "LCD14FONT"
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000

LCD14FONT:
	dw %0000000000000000 	; <Blank> code32
	dw %0010001000000000 	; !
	dw %0000000000100010 	; "
	dw %0000000000000000 	; #
	dw %0000000000000000 	; $
	dw %0100010000100100 	; %
	dw %0000000000000000 	; &
	dw %0000000100000000 	; '
	dw %0000000000111001 	; (
	dw %0000000000001111 	; )
	dw %0111111101000000 	; *
	dw %0010101001000000 	; +
	dw %0100000000000000 	; ,
	dw %0000100001000000 	; -
	dw %0100000000000000 	; .
	dw %0000000000000000 	; /
	dw %0100010000111111 	; 0
	dw %0000000000000110 	; 1
	dw %0000100001011011 	; 2
	dw %0000100000001111 	; 3
	dw %0000100001100110 	; 4
	dw %0000100001101101 	; 5
	dw %0000100001111101 	; 6
	dw %0000000000000111 	; 7
	dw %0000100001111111 	; 8
	dw %0000100001101111 	; 9
	dw %0000010000000000 	; :
	dw %0001010000000000 	; ;
	dw %0010010000000000 	; <
	dw %0000100001001000 	; =
	dw %0000000100000000 	; >
	dw %0010100000000011 	; ?
	dw %0000101000111011 	; @
TEST14A:
	dw %0000100001110111 	; A
	dw %0010101000001111 	; B
	dw %0000000000111001 	; C
	dw %0010001000001111 	; D
	dw %0000000001111001 	; E
	dw %0000000001110001 	; F
	dw %0000100000111101 	; G
	dw %0000100001110110 	; H
	dw %0010001000001001 	; I
	dw %0000000000011110 	; J
	dw %0001010001110000 	; K
	dw %0000000000111000 	; L
	dw %0000001000110111 	; M
	dw %0001000100110110 	; N
	dw %0000000000111111 	; O
	dw %0000100001110011 	; P
	dw %0001000000111111 	; Q
	dw %0001100001110011 	; R
	dw %0000100001101101 	; S
	dw %0010001000000001 	; T
	dw %0000000000111110 	; U
	dw %0100010000110000 	; V
	dw %0101000000110110 	; W
	dw %0101010100000000 	; X
	dw %0010010100000000 	; Y
	dw %0100010000001001 	; Z
	
	
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000

	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000
		dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000
		dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000
		dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000
		dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000	
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000	
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000	
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000	
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000	
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000	
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000	
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000
		dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000
		dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000 
	dw %0000000000000000