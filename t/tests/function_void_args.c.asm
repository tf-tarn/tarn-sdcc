;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"function_void_args.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_g
	.globl	_var
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_g_PARM_2
	.globl	_g_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_g_PARM_1:
	.ds	1
_g_PARM_2:
	.ds	1
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
;	t/tests/function_void_args.c: 2: void g(char a, char b) {
;	-----------------------------------------
;	 function g
;	-----------------------------------------
	_g:
;	t/tests/function_void_args.c: 3: var = a+b;
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	lad	_g_PARM_1
	mov	alua mem
	lad	_g_PARM_2
	mov	alub mem
	lad	_var
	mov	mem aluc
;	t/tests/function_void_args.c: 4: }
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
;	t/tests/function_void_args.c: 5: char main (char argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/function_void_args.c: 6: g(1, 2);
	lad	_g_PARM_1
	mov	mem il ,1
	lad	_g_PARM_2
	mov	mem il ,2
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	_g
L_main00103:
	; function returns nothing
;	t/tests/function_void_args.c: 7: return var;
	mov	jmpl stack
	mov	jmph stack
	lad	_var
	mov	stack mem
	jump
;	t/tests/function_void_args.c: 8: }
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr
__xinit__var:
	.byte	#0x00	; 0
	.section cabs
