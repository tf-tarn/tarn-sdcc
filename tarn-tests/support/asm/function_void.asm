;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"function_void.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
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
	.section data,"w"
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd,"a"
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
;	src/function_void.c: 2: void g() {
;; genLabel
;	-----------------------------------------
;	 function g
;	-----------------------------------------
	_g:
;	src/function_void.c: 3: var = 1;
;; genAssign
	lad	_var
	mov	mem il ,1
;; genLabel
;	src/function_void.c: 4: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/function_void.c: 5: char main (char argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/function_void.c: 6: g();
;; genCall
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	_g
L_main00103:
	; function returns nothing
;	src/function_void.c: 7: return var;
	mov	jmpl stack
	mov	jmph stack
	lad	_var
	mov	stack mem
	jump
;; genLabel
;	src/function_void.c: 8: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
__xinit__var:
	.byte	#0x00	; 0
	.section cabs
