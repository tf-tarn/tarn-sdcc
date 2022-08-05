;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"assignment_big.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_vvv
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_vvv:
	.ds	2
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
;	t/tests/assignment_big.c: 2: char main (char argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/assignment_big.c: 3: const char *msg = "foo";
;; genAddrOf: operand size 2, 4, 1
	mov	r il ,lo8(___str_0 + 0)
	mov	x il ,hi8(___str_0 + 0)
;; genCast        
	lad	_vvv
	mov	mem x ; hi
	lad	_vvv + 1
	mov	mem r ; lo
;	t/tests/assignment_big.c: 7: return vvv[0];
;; genPointerGet: operand size 2, 1, 1
	load_address_from_ptr	_vvv
	mov	r mem
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/assignment_big.c: 8: }
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section const
___str_0:
	.ascii	"foo"
	.byte 0x00
	.section code,"ax"
	.section initr
	.section cabs
