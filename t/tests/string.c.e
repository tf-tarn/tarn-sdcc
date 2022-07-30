;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"string.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_main_PARM_2
	.globl	_main_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section .data,"w"
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
	.section static
	.section post_static
	.section static
	.section post_static
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.section home,"ax"
	.section home,"ax"
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.section .text,"ax"
;	t/tests/string.c: 1: char main (char argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/string.c: 3: const char *s = "foobar";
;	t/tests/string.c: 4: pic = s[0];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(___str_0 + 0)
	mov	adl il ,lo8(___str_0 + 0)
	mov	pic mem
;	t/tests/string.c: 5: pic = s[1];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(___str_0 + 1)
	mov	adl il ,lo8(___str_0 + 1)
	mov	pic mem
;	t/tests/string.c: 6: return 0;

	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;	t/tests/string.c: 7: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section const
___str_0:
	.ascii	"foobar"
	.byte 0x00
	.section .text,"ax"
	.section initr
	.section cabs
has remat: ___str_0 + 0
has remat: ___str_0 + 0
has remat: ___str_0 + 0
has remat: ___str_0 + 0
has remat: ___str_0 + 0
has remat: ___str_0 + 0
has remat: ___str_0 + 0
has remat: ___str_0 + 0
has remat: ___str_0 + 0
has remat: ___str_0 + 1
has remat: ___str_0 + 1
has remat: ___str_0 + 1
has remat: ___str_0 + 1
has remat: ___str_0 + 1
has remat: ___str_0 + 1
has remat: ___str_0 + 1
has remat: ___str_0 + 1
has remat: ___str_0 + 1
has remat: ___str_0 + 0
has remat: ___str_0 + 1
