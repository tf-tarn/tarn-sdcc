;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"shift_left_8_2.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_val3
	.globl	_val2
	.globl	_val1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_val1:
	.ds	1
_val2:
	.ds	1
_val3:
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
	.area	_overlay
_main_sloc0_1_0:
	.ds	2
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
;	src/shift_left_8.2.c: 5: int main (int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/shift_left_8.2.c: 6: val1 = pic;
;; genAssign
	lad	_val1
	mov	mem pic
;	src/shift_left_8.2.c: 7: val2 = pic;
;; genAssign
	lad	_val2
	mov	mem pic
;	src/shift_left_8.2.c: 8: val3 = (val1 << 8) + val2;
;; genCast
	lad	_main_sloc0_1_0
	mov	mem zero
	lad	_val1
	mov	stack mem
	lad	_main_sloc0_1_0 + 1
	mov	mem stack
;; genLeftShift
	mov	r mem
	lad	_main_sloc0_1_0 + 1
	mov	x mem
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack x
	mov	stack r
	lad	_val2
	mov	stack mem
	add_8s_16s
	lad	_val3
	mov	mem x
	lad	_val3 + 1
	mov	mem r
	restore_rx
;	src/shift_left_8.2.c: 10: return val1;
	mov	jmpl stack
	mov	jmph stack
; implement me (gen.c:1297)
	jump
;; genLabel
;	src/shift_left_8.2.c: 11: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs