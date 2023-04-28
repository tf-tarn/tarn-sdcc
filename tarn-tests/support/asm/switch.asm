;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"switch.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
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
;	src/switch.c: 2: char main (char argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/switch.c: 4: char val = pic;
;; genAssign
	mov	r pic
;	src/switch.c: 6: while (val != '!') {
;; genLabel
L_main00109:
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	mov	alua r
	mov	alub il ,33
	mov	test aluc
;; genIfx
	gotonz	L_main00111
;	src/switch.c: 7: switch(val) {
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	mov	alua r
	mov	alub il ,97
	mov	test aluc
;; genIfx
	gotonz	L_main00101
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	mov	alua r
	mov	alub il ,101
	mov	test aluc
;; genIfx
	gotonz	L_main00102
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	mov	alua r
	mov	alub il ,105
	mov	test aluc
;; genIfx
	gotonz	L_main00103
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	mov	alua r
	mov	alub il ,111
	mov	test aluc
;; genIfx
	gotonz	L_main00104
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	mov	alua r
	mov	alub il ,117
	mov	test aluc
;; genIfx
	gotonz	L_main00105
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	mov	alua r
	mov	alub il ,255
	mov	test aluc
;; genIfx
	gotonz	L_main00108
;; genGoto
	goto	L_main00107
;	src/switch.c: 8: case 'a':
;; genLabel
L_main00101:
;	src/switch.c: 9: pic = '2';
;; genAssign
	mov	pic il ,50
;	src/switch.c: 10: break;
;; genGoto
	goto	L_main00108
;	src/switch.c: 11: case 'e':
;; genLabel
L_main00102:
;	src/switch.c: 12: pic = '4';
;; genAssign
	mov	pic il ,52
;	src/switch.c: 13: break;
;; genGoto
	goto	L_main00108
;	src/switch.c: 14: case 'i':
;; genLabel
L_main00103:
;	src/switch.c: 15: pic = '6';
;; genAssign
	mov	pic il ,54
;	src/switch.c: 16: break;
;; genGoto
	goto	L_main00108
;	src/switch.c: 17: case 'o':
;; genLabel
L_main00104:
;	src/switch.c: 18: pic = '8';
;; genAssign
	mov	pic il ,56
;	src/switch.c: 19: break;
;; genGoto
	goto	L_main00108
;	src/switch.c: 20: case 'u':
;; genLabel
L_main00105:
;	src/switch.c: 21: pic = '_';
;; genAssign
	mov	pic il ,95
;	src/switch.c: 22: break;
;; genGoto
	goto	L_main00108
;	src/switch.c: 25: default:
;; genLabel
L_main00107:
;	src/switch.c: 26: pic = val;
;; genAssign
	mov	pic r
;	src/switch.c: 29: }
;; genLabel
L_main00108:
;	src/switch.c: 30: val = pic;
;; genAssign
	mov	r pic
;; genGoto
	goto	L_main00109
;; genLabel
L_main00111:
;	src/switch.c: 32: pic = '.';
;; genAssign
	mov	pic il ,46
;	src/switch.c: 33: pic = '\n';
;; genAssign
	mov	pic il ,10
;	src/switch.c: 37: __endasm;
	halt
;; genLabel
;	src/switch.c: 38: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
