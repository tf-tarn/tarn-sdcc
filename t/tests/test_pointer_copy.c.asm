;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"test_pointer_copy.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
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
	.section .data,"w"
_vvv:
	.ds	2
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd
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
;	t/tests/test_pointer_copy.c: 3: int main (int argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/test_pointer_copy.c: 4: const char *msg = "foo";
;; genAddrOf: operand size 2, 4, 1
	mov	r il ,lo8(___str_0 + 0)
	mov	x il ,hi8(___str_0 + 0)
;; genCast        
;	t/tests/test_pointer_copy.c: 7: pic = msg[(char)0];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(___str_0 + 0)
	mov	adl il ,lo8(___str_0 + 0)
	mov	pic mem
;	t/tests/test_pointer_copy.c: 11: pic = msg[(char)1];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(___str_0 + 1)
	mov	adl il ,lo8(___str_0 + 1)
	mov	pic mem
;	t/tests/test_pointer_copy.c: 15: vvv = msg;
	;; assign
	lad	_vvv
	mov	mem x ; hi
	lad	_vvv + 1
	mov	mem r ; lo
;	t/tests/test_pointer_copy.c: 18: pic = vvv[(char)0];
;; genPointerGet: operand size 2, 1, 1
	lad	_vvv + 0
	mov	stack mem
	lad	_vvv + 1
	mov	stack mem
	mov	adl stack
	mov	adh stack
	mov	stack mem
	mov	pic stack
;	t/tests/test_pointer_copy.c: 22: pic = vvv[(char)1];
;;	ALU plus (4)
	lad	_vvv
	mov	stack mem
	lad	_vvv + 1
	mov	stack mem
	add_16s_16l	1
	lad	_main_sloc0_1_0
	mov	mem x
	lad	_main_sloc0_1_0 + 1
	mov	mem r
;; genPointerGet: operand size 2, 1, 1
	lad	_main_sloc0_1_0 + 0
	mov	stack mem
	lad	_main_sloc0_1_0 + 1
	mov	stack mem
	mov	adl stack
	mov	adh stack
	mov	stack mem
	mov	pic stack
;	t/tests/test_pointer_copy.c: 26: while (1);
	L_2:
	;; goto
	goto	L_2
;	t/tests/test_pointer_copy.c: 28: return 0;
;	t/tests/test_pointer_copy.c: 29: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section const
___str_0:
	.ascii	"foo"
	.byte 0x00
	.section .text,"ax"
	.section initr
	.section cabs
