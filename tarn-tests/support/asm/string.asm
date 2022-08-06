;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"string.c"
	
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
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd
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
; interrupt vector
;--------------------------------------------------------
	.section home,"ax"
__interrupt_vect:
;; tarn_genIVT
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.section home
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
;	src/string.c: 1: char main (char argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/string.c: 3: const char *s = "foobar";
;	src/string.c: 4: pic = s[0];
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(___str_0 + 0)
	mov	adl il ,lo8(___str_0 + 0)
	mov	pic mem
;	src/string.c: 5: pic = s[1];
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(___str_0 + 1)
	mov	adl il ,lo8(___str_0 + 1)
	mov	pic mem
;	src/string.c: 6: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;	src/string.c: 7: }
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section const
___str_0:
	.ascii	"foobar"
	.byte 0x00
	.section code,"ax"
	.section initr
	.section cabs
