;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"test_big_addition.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
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
;	src/test_big_addition.c: 3: int main (int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/test_big_addition.c: 4: const char *msg = "foo";
;	src/test_big_addition.c: 6: pic = msg[(char)0];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(___str_0 + 0)
	mov	adl il ,lo8(___str_0 + 0)
	mov	pic mem
;	src/test_big_addition.c: 7: pic = ' ';
;; genAssign
	mov	pic il ,32
;	src/test_big_addition.c: 8: pic = msg[(char)1];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(___str_0 + 1)
	mov	adl il ,lo8(___str_0 + 1)
	mov	pic mem
;	src/test_big_addition.c: 9: pic = '\n';
;; genAssign
	mov	pic il ,10
;	src/test_big_addition.c: 11: vvv = msg;
;; genAssign
	lad	_vvv
	mov	mem il ,hi8(___str_0 + 0) ; hi
	lad	_vvv + 1
	mov	mem il ,lo8(___str_0 + 0) ; lo
;	src/test_big_addition.c: 13: pic = vvv[(char)0];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	lad	_vvv + 0
	mov	stack mem
	lad	_vvv + 1
	mov	stack mem
	mov	adl stack
	mov	adh stack
	mov	pic mem
;	src/test_big_addition.c: 14: pic = ' ';
;; genAssign
	mov	pic il ,32
;	src/test_big_addition.c: 15: pic = vvv[(char)1];
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_vvv
	mov	stack mem
	lad	_vvv + 1
	mov	stack mem
	add_16s_8	1
;	Not moving register r to itself.
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adl r
	mov	adh x
	mov	pic mem
;	src/test_big_addition.c: 16: pic = '\n';
;; genAssign
	mov	pic il ,10
;	src/test_big_addition.c: 20: __endasm;
	halt
;	src/test_big_addition.c: 22: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/test_big_addition.c: 23: }
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
	.section initr,"a"
	.section cabs
