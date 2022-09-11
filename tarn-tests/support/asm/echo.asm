;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"echo.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_main_PARM_2
	.globl	_main_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
_main_byte_65536_2:
	.ds	1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd,"a"
;--------------------------------------------------------
; overlayable items in ram
;--------------------------------------------------------
;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------
	.section SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.section idata
;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------
	.section home,"ax"
__interrupt_vect:
;; tarn_genIVT
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.section home,"ax"
	.section static,"ax"
	.section post_static,"ax"
	.section static,"ax"
	.section post_static,"ax"
	goto	_main
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.section home,"ax"
	.section home,"ax"
__sdcc_program_startup:
	goto	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.section code,"ax"
;	src/echo.c: 3: uint8_t main (uint8_t argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/echo.c: 7: while (1) {
;; genLabel
L_main00104:
;	src/echo.c: 8: byte = pic;
;; genAssign
	lad	_main_byte_65536_2
	mov	mem pic
;	src/echo.c: 9: if (byte != 0xff) {
;; genCmpEQorNE
	;; test equality
	mov	alus il ,10	; equal-to 
;	has ifx
	mov	alua il ,255
	lad	_main_byte_65536_2
	mov	alub mem
	mov	test aluc
	gotonz	L_main00104
	goto	L_main00117
L_main00117:
;	src/echo.c: 10: pic = byte;
;; genAssign
	lad	_main_byte_65536_2
	mov	pic mem
;; genGoto
	goto	L_main00104
;; genLabel
;	src/echo.c: 13: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
