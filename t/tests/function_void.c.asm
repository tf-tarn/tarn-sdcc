;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"function_void.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_g
	.globl	_var
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
_var:
	.ds	1
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
;	sdcc-dev/tests/function_void.c: 2: void g() {
;	-----------------------------------------
;	 function g
;	-----------------------------------------
	_g:
;	sdcc-dev/tests/function_void.c: 3: var = 1;
	;; assign
	lad	_var
	mov	mem il ,1
;	sdcc-dev/tests/function_void.c: 4: }
;; genEndFunction 
;	sdcc-dev/tests/function_void.c: 5: char main (char argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	sdcc-dev/tests/function_void.c: 6: g();
	;; call function
	mov	stack hi8(L_ret_4)
	mov	stack lo8(L_ret_4)
	goto	_g
	L_ret_4:
	; function returns nothing
;	sdcc-dev/tests/function_void.c: 7: return var;
	;; return
	mov	jmpl stack
	mov	jmph stack
	lad	_var
	mov	stack mem
	jump
;	sdcc-dev/tests/function_void.c: 8: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section initr
__xinit__var:
	.byte	#0x00	; 0
	.section cabs
