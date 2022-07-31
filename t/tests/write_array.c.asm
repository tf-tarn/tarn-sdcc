;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"write_array.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_index
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_array
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section .data,"w"
_array:
	.ds	5
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd
_index:
	.ds	1
;--------------------------------------------------------
; overlayable items in ram
;--------------------------------------------------------
	.area	_overlay
_main_sloc0_1_0:
	.ds	2
_main_sloc1_1_0:
	.ds	2
_main_sloc2_1_0:
	.ds	2
_main_sloc3_1_0:
	.ds	2
_main_sloc4_1_0:
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
;	sdcc-dev/tests/write_array.c: 3: char main (char argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	sdcc-dev/tests/write_array.c: 5: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 6: pic = array[0];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 0)
	mov	adl il ,lo8(_array + 0)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 7: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 8: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 9: pic = array[1];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 1)
	mov	adl il ,lo8(_array + 1)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 10: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 11: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 12: pic = array[2];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 2)
	mov	adl il ,lo8(_array + 2)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 13: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 14: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 15: pic = array[3];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 3)
	mov	adl il ,lo8(_array + 3)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 16: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 17: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 18: pic = array[4];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 4)
	mov	adl il ,lo8(_array + 4)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 19: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 21: pic = '\n';
	;; assign
	mov	pic il, 10
;	sdcc-dev/tests/write_array.c: 22: array[index++] = 5;
	;; assign
	lad	_index
	mov	r mem
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	lad	_index
	mov	alua mem
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;;	ALU plus (4)
	add_8r_16	r _array ; 1
	lad	_main_sloc0_1_0
	mov	mem x
	lad	_main_sloc0_1_0 + 1
	mov	mem r
;; genPointerSet: operand size 2, 1
	mov	adh x
	mov	adl r
	mov	mem il ,5
;	sdcc-dev/tests/write_array.c: 23: array[index++] = 4;
	;; assign
	lad	_index
	mov	r mem
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	lad	_index
	mov	alua mem
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;;	ALU plus (4)
	add_8r_16	r _array ; 1
	lad	_main_sloc1_1_0
	mov	mem x
	lad	_main_sloc1_1_0 + 1
	mov	mem r
;; genPointerSet: operand size 2, 1
	mov	adh x
	mov	adl r
	mov	mem il ,4
;	sdcc-dev/tests/write_array.c: 24: array[index++] = 3;
	;; assign
	lad	_index
	mov	r mem
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	lad	_index
	mov	alua mem
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;;	ALU plus (4)
	add_8r_16	r _array ; 1
	lad	_main_sloc2_1_0
	mov	mem x
	lad	_main_sloc2_1_0 + 1
	mov	mem r
;; genPointerSet: operand size 2, 1
	mov	adh x
	mov	adl r
	mov	mem il ,3
;	sdcc-dev/tests/write_array.c: 25: array[index++] = 2;
	;; assign
	lad	_index
	mov	r mem
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	lad	_index
	mov	alua mem
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;;	ALU plus (4)
	add_8r_16	r _array ; 1
	lad	_main_sloc3_1_0
	mov	mem x
	lad	_main_sloc3_1_0 + 1
	mov	mem r
;; genPointerSet: operand size 2, 1
	mov	adh x
	mov	adl r
	mov	mem il ,2
;	sdcc-dev/tests/write_array.c: 26: array[index++] = 1;
	;; assign
	lad	_index
	mov	r mem
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	lad	_index
	mov	alua mem
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;;	ALU plus (4)
	add_8r_16	r _array ; 1
	lad	_main_sloc4_1_0
	mov	mem x
	lad	_main_sloc4_1_0 + 1
	mov	mem r
;; genPointerSet: operand size 2, 1
	mov	adh x
	mov	adl r
	mov	mem il ,1
;	sdcc-dev/tests/write_array.c: 28: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 29: pic = array[0];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 0)
	mov	adl il ,lo8(_array + 0)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 30: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 31: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 32: pic = array[1];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 1)
	mov	adl il ,lo8(_array + 1)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 33: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 34: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 35: pic = array[2];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 2)
	mov	adl il ,lo8(_array + 2)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 36: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 37: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 38: pic = array[3];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 3)
	mov	adl il ,lo8(_array + 3)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 39: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 40: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 41: pic = array[4];
;; genPointerGet: operand size 2, 1, 1
	mov	adh il ,hi8(_array + 4)
	mov	adl il ,lo8(_array + 4)
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 42: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 44: pic = '\n';
	;; assign
	mov	pic il, 10
;	sdcc-dev/tests/write_array.c: 46: pic = 0x0e;
	;; assign
	mov	pic il, 14
;	sdcc-dev/tests/write_array.c: 47: pic = index;
	;; assign
	lad	_index
	mov	pic mem
;	sdcc-dev/tests/write_array.c: 48: pic = 0x0f;
	;; assign
	mov	pic il, 15
;	sdcc-dev/tests/write_array.c: 50: pic = '\n';
	;; assign
	mov	pic il, 10
;	sdcc-dev/tests/write_array.c: 52: while (1);
	L_2:
	;; goto
	goto	L_2
;	sdcc-dev/tests/write_array.c: 54: return 0;
;	sdcc-dev/tests/write_array.c: 55: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section initr
__xinit__index:
	.byte	#0x00	; 0
	.section cabs
