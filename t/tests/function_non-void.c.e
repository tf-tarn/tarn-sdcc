;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"function_non_void.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_f
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
;	t/tests/function_non-void.c: 1: char f() {
;	-----------------------------------------
;	 function f
;	-----------------------------------------
	_f:
;	t/tests/function_non-void.c: 2: return 9;

	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,9
	jump
;	t/tests/function_non-void.c: 3: }
;; genEndFunction 
;	t/tests/function_non-void.c: 4: char main (char argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/function_non-void.c: 5: char val = f();
	;; call function
	mov	stack hi8(L_ret_6)
	mov	stack lo8(L_ret_6)
	goto	_f
	L_ret_6:
	mov	r stack

	;; assign
;	genAssign: registers r, r same; skipping assignment
;	t/tests/function_non-void.c: 6: return val;

	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/function_non-void.c: 7: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section initr
	.section cabs
