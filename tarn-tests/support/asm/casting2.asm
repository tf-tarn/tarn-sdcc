;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"casting2.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_val2
	.globl	_val1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_val1:
	.ds	2
_val2:
	.ds	2
_main_PARM_1:
	.ds	2
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
;	src/casting2.c: 4: int main (int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/casting2.c: 5: val1 = pic;
;; genCast
	lad	_val1
	mov	mem zero
	lad	_val1 + 1
	mov	mem pic
;	src/casting2.c: 6: val2 = val1;
;; genAssign
	lad	_val1
	mov	stack mem ; hi
	lad	_val1 + 1
	mov	stack mem ; lo
	lad	_val2 + 1
	mov	mem stack ; lo
	lad	_val2
	mov	mem stack ; hi
;	src/casting2.c: 8: return val1;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,lo8(_val1)
	mov	stack il ,hi8(_val1)
	jump
;; genLabel
;	src/casting2.c: 9: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
