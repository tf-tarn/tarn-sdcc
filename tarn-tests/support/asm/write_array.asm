;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"write_array.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
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
;	src/write_array.c: 5: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 6: pic = array[0];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 0)
	mov	adl il ,lo8(_array + 0)
	mov	pic mem
;	src/write_array.c: 7: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 8: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 9: pic = array[1];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 1)
	mov	adl il ,lo8(_array + 1)
	mov	pic mem
;	src/write_array.c: 10: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 11: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 12: pic = array[2];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 2)
	mov	adl il ,lo8(_array + 2)
	mov	pic mem
;	src/write_array.c: 13: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 14: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 15: pic = array[3];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 3)
	mov	adl il ,lo8(_array + 3)
	mov	pic mem
;	src/write_array.c: 16: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 17: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 18: pic = array[4];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 4)
	mov	adl il ,lo8(_array + 4)
	mov	pic mem
;	src/write_array.c: 19: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 21: pic = '\n';
;; genAssign
	mov	pic il ,10
;	src/write_array.c: 22: array[index++] = 5;
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
; implement me (gen.c:2353)
	mov	stack r
	add_8s_16	_array ; 1
	lad	_main_sloc0_1_0
	mov	mem x
	lad	_main_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc0_1_0
	load_address_from_ptr _main_sloc0_1_0
	mov	mem il ,5
;	src/write_array.c: 23: array[index++] = 4;
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
; implement me (gen.c:2353)
	mov	stack r
	add_8s_16	_array ; 1
	lad	_main_sloc1_1_0
	mov	mem x
	lad	_main_sloc1_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc1_1_0
	load_address_from_ptr _main_sloc1_1_0
	mov	mem il ,4
;	src/write_array.c: 24: array[index++] = 3;
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
; implement me (gen.c:2353)
	mov	stack r
	add_8s_16	_array ; 1
	lad	_main_sloc2_1_0
	mov	mem x
	lad	_main_sloc2_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc2_1_0
	load_address_from_ptr _main_sloc2_1_0
	mov	mem il ,3
;	src/write_array.c: 25: array[index++] = 2;
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
; implement me (gen.c:2353)
	mov	stack r
	add_8s_16	_array ; 1
	lad	_main_sloc3_1_0
	mov	mem x
	lad	_main_sloc3_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc3_1_0
	load_address_from_ptr _main_sloc3_1_0
	mov	mem il ,2
;	src/write_array.c: 26: array[index++] = 1;
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
; implement me (gen.c:2353)
	mov	stack r
	add_8s_16	_array ; 1
	lad	_main_sloc4_1_0
	mov	mem x
	lad	_main_sloc4_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc4_1_0
	load_address_from_ptr _main_sloc4_1_0
	mov	mem il ,1
;	src/write_array.c: 28: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 29: pic = array[0];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 0)
	mov	adl il ,lo8(_array + 0)
	mov	pic mem
;	src/write_array.c: 30: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 31: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 32: pic = array[1];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 1)
	mov	adl il ,lo8(_array + 1)
	mov	pic mem
;	src/write_array.c: 33: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 34: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 35: pic = array[2];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 2)
	mov	adl il ,lo8(_array + 2)
	mov	pic mem
;	src/write_array.c: 36: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 37: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 38: pic = array[3];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 3)
	mov	adl il ,lo8(_array + 3)
	mov	pic mem
;	src/write_array.c: 39: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 40: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 41: pic = array[4];
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adh il ,hi8(_array + 4)
	mov	adl il ,lo8(_array + 4)
	mov	pic mem
;	src/write_array.c: 42: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 44: pic = '\n';
;; genAssign
	mov	pic il ,10
;	src/write_array.c: 46: pic = 0x0e;
;; genAssign
	mov	pic il ,14
;	src/write_array.c: 47: pic = index;
;; genAssign
	lad	_index
	mov	pic mem
;	src/write_array.c: 48: pic = 0x0f;
;; genAssign
	mov	pic il ,15
;	src/write_array.c: 50: pic = '\n';
;; genAssign
	mov	pic il ,10
;	src/write_array.c: 52: while (1);
;; genLabel
L_main00102:
;; genGoto
	goto	L_main00102
;	src/write_array.c: 54: return 0;
;; genLabel
;	src/write_array.c: 55: }
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
