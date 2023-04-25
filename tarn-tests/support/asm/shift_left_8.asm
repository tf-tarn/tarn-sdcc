;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"shift_left_8.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
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
;	src/shift_left_8.c: 5: int main (int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/shift_left_8.c: 6: val1 = pic; // a
;; genAssign
	lad	_val1
	mov	mem pic
;	src/shift_left_8.c: 7: val2 = pic; // b
;; genAssign
	lad	_val2
	mov	mem pic
;	src/shift_left_8.c: 8: val3 = (val1 << 8) + val2;
;; genCast
	mov	x zero
	lad	_val1
	mov	r mem
;; genLeftShift
	lad	_main_sloc0_1_0 + 1
	mov	mem zero
	lad	_main_sloc0_1_0
	mov	mem r
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_val2
	mov	stack mem
	load_stack_from_ptr	_main_sloc0_1_0
	add_8s_16s
	lad	_val3 + 1
	mov	mem r
	lad	_val3 + 0
	mov	mem x
	restore_rx
;	src/shift_left_8.c: 12: pic = *(0 + (char*)(&val3)); // b
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_val3 + 0)
	mov	adl il ,lo8(_val3 + 0)
	mov	pic mem
;	src/shift_left_8.c: 13: pic = *(1 + (char*)(&val3)); // a
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_val3 + 1)
	mov	adl il ,lo8(_val3 + 1)
	mov	pic mem
;	src/shift_left_8.c: 14: return val1;
	mov	jmpl stack
	mov	jmph stack
	mov	stack x
	mov	stack r
	jump
;; genLabel
;	src/shift_left_8.c: 15: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
