assembler was passed: -plosgffw 1.asm
--BEGIN ASM--
;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"1.c"
	.optsdcc -mtarn
	
;; tarn_genAssemblerStart
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_main_PARM_2
	.globl	_main_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section DATA,"rw"
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; overlayable items in ram
;--------------------------------------------------------
;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.section DABS (ABS)
;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------
	.section HOME,"ax"
__interrupt_vect:
;; tarn_genIVT
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.section HOME
	.section GSINIT
	.section GSFINAL
	.section GSINIT
tarn_genInitStartup
	.section GSFINAL
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.section HOME,"ax"
	.section HOME,"ax"
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.section CODE,"ax"
;	t/tests/1.c: 1: int main (int argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/1.c: 2: return 0;

	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
	L_1:
;	t/tests/1.c: 3: }
;; genEndFunction 
	.section CODE,"ax"
	.section CONST
	.section CABS (ABS)
--END ASM--
