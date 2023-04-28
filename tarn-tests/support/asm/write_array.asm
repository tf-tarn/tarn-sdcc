;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"write_array.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
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
	.section data,"w"
_array:
	.ds	5
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd,"a"
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
	.ds	1
_main_sloc4_1_0:
	.ds	2
_main_sloc5_1_0:
	.ds	1
_main_sloc6_1_0:
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
;	src/write_array.c: 3: char main (char argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/write_array.c: 5: pic = array[0];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 0)
	mov	adl il ,lo8(_array + 0)
	mov	pic mem
;	src/write_array.c: 6: pic = array[1];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 1)
	mov	adl il ,lo8(_array + 1)
	mov	pic mem
;	src/write_array.c: 7: pic = array[2];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 2)
	mov	adl il ,lo8(_array + 2)
	mov	pic mem
;	src/write_array.c: 8: pic = array[3];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 3)
	mov	adl il ,lo8(_array + 3)
	mov	pic mem
;	src/write_array.c: 9: pic = array[4];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 4)
	mov	adl il ,lo8(_array + 4)
	mov	pic mem
;	src/write_array.c: 11: array[index++] = '5';
;; genAssign
	lad	_index
	mov	r mem
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	lad	_index
	mov	alua mem
	mov	alus il ,4	; plus 
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack r
	add_8s_16	_array + 0
	lad	_main_sloc0_1_0 + 0
	mov	mem x
	lad	_main_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc0_1_0
	load_address_from_ptr	_main_sloc0_1_0
	mov	mem il ,53
;	src/write_array.c: 12: array[index++] = '4';
;; genAssign
	lad	_index
	mov	r mem
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	lad	_index
	mov	alua mem
	mov	alus il ,4	; plus 
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack r
	add_8s_16	_array + 0
	lad	_main_sloc1_1_0 + 0
	mov	mem x
	lad	_main_sloc1_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc1_1_0
	load_address_from_ptr	_main_sloc1_1_0
	mov	mem il ,52
;	src/write_array.c: 13: array[index++] = '3';
;; genAssign
	lad	_index
	mov	r mem
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	lad	_index
	mov	alua mem
	mov	alus il ,4	; plus 
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack r
	add_8s_16	_array + 0
	lad	_main_sloc2_1_0 + 0
	mov	mem x
	lad	_main_sloc2_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc2_1_0
	load_address_from_ptr	_main_sloc2_1_0
	mov	mem il ,51
;	src/write_array.c: 14: array[index++] = '2';
;; genAssign
	lad	_index
	mov	stack mem
	lad	_main_sloc3_1_0 + 0
	mov	mem stack
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	lad	_index
	mov	alua mem
	mov	alus il ,4	; plus 
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_main_sloc3_1_0 + 0
	mov	stack mem
	add_8s_16	_array
	lad	_main_sloc4_1_0 + 0
	mov	mem x
	lad	_main_sloc4_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc4_1_0
	load_address_from_ptr	_main_sloc4_1_0
	mov	mem il ,50
;	src/write_array.c: 15: array[index++] = '1';
;; genAssign
	lad	_index
	mov	stack mem
	lad	_main_sloc5_1_0 + 0
	mov	mem stack
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	lad	_index
	mov	alua mem
	mov	alus il ,4	; plus 
	mov	alub il ,1
	lad	_index
	mov	mem aluc
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_main_sloc5_1_0 + 0
	mov	stack mem
	add_8s_16	_array
	lad	_main_sloc6_1_0 + 0
	mov	mem x
	lad	_main_sloc6_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc6_1_0
	load_address_from_ptr	_main_sloc6_1_0
	mov	mem il ,49
;	src/write_array.c: 17: pic = array[0];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 0)
	mov	adl il ,lo8(_array + 0)
	mov	pic mem
;	src/write_array.c: 18: pic = array[1];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 1)
	mov	adl il ,lo8(_array + 1)
	mov	pic mem
;	src/write_array.c: 19: pic = array[2];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 2)
	mov	adl il ,lo8(_array + 2)
	mov	pic mem
;	src/write_array.c: 20: pic = array[3];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 3)
	mov	adl il ,lo8(_array + 3)
	mov	pic mem
;	src/write_array.c: 21: pic = array[4];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 4)
	mov	adl il ,lo8(_array + 4)
	mov	pic mem
;	src/write_array.c: 23: pic = index;
;; genAssign
	lad	_index
	mov	pic mem
;	src/write_array.c: 27: __endasm;
	halt
;	src/write_array.c: 29: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
;	src/write_array.c: 30: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
__xinit__index:
	.byte	#0x00	; 0
	.section cabs
