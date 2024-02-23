;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"bitwise.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_test_long
	.globl	_test_int
	.globl	_test_char
	.globl	_main_PARM_2
	.globl	_main_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_test_char_a_65536_1:
	.ds	1
_test_char_b_65536_1:
	.ds	1
_test_int_a_65536_2:
	.ds	2
_test_int_b_65536_2:
	.ds	2
_test_long_a_65536_3:
	.ds	4
_test_long_b_65536_3:
	.ds	4
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
_test_int_sloc0_1_0:
	.ds	1
	.area	_overlay
_test_long_sloc1_1_0:
	.ds	4
_test_long_sloc2_1_0:
	.ds	4
_test_long_sloc3_1_0:
	.ds	4
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
;	src/bitwise.c: 3: void test_char() {
;; genLabel
;	-----------------------------------------
;	 function test_char
;	-----------------------------------------
	_test_char:
;	src/bitwise.c: 4: volatile char a = 0x30;
;; genAssign
	lad	_test_char_a_65536_1 + 0
	mov	mem il ,48
;	src/bitwise.c: 5: volatile char b = 0x20;
;; genAssign
	lad	_test_char_b_65536_1 + 0
	mov	mem il ,32
;	src/bitwise.c: 7: pic = a & b;
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 1 1 1
;	begin bitwise ALU operation
	mov	alus il ,0	; and 
	lad	_test_char_a_65536_1 + 0
	mov	alua mem
	lad	_test_char_b_65536_1 + 0
	mov	alub mem
	mov	pic aluc
;	end bitwise ALU operation
;	src/bitwise.c: 8: pic = a | b;
;; genALUOp
;;	ALU or (1)
;;	ALU operand size 1 1 1
;	begin bitwise ALU operation
	mov	alus il ,1	; or 
	lad	_test_char_a_65536_1 + 0
	mov	alua mem
	lad	_test_char_b_65536_1 + 0
	mov	alub mem
	mov	pic aluc
;	end bitwise ALU operation
;	src/bitwise.c: 9: pic = a ^ b;
;; genALUOp
;;	ALU xor (2)
;;	ALU operand size 1 1 1
;	begin bitwise ALU operation
	mov	alus il ,2	; xor 
	lad	_test_char_a_65536_1 + 0
	mov	alua mem
	lad	_test_char_b_65536_1 + 0
	mov	alub mem
	mov	pic aluc
;	end bitwise ALU operation
;; genLabel
;	src/bitwise.c: 11: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/bitwise.c: 13: void test_int() {
;; genLabel
;	-----------------------------------------
;	 function test_int
;	-----------------------------------------
	_test_int:
;	src/bitwise.c: 14: volatile int a = 0xee30;
;; genAssign
	lad	_test_int_a_65536_2 + 0
	mov	mem il ,238
	lad	_test_int_a_65536_2 + 1
	mov	mem il ,48
;	src/bitwise.c: 15: volatile int b = 0xbb20;
;; genAssign
	lad	_test_int_b_65536_2 + 0
	mov	mem il ,187
	lad	_test_int_b_65536_2 + 1
	mov	mem il ,32
;	src/bitwise.c: 17: pic = (a & b) >> 8;
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 2 2 2
;	begin bitwise ALU operation
	mov	alus il ,0	; and 
	lad	_test_int_a_65536_2 + 1
	mov	alua mem
	lad	_test_int_b_65536_2 + 1
	mov	alub mem
	mov	x aluc
	lad	_test_int_a_65536_2 + 0
	mov	alua mem
	lad	_test_int_b_65536_2 + 0
	mov	alub mem
	mov	r aluc
;	end bitwise ALU operation
;; genGetByte      = 
;	offset = 1, 0
	mov	pic x
;	src/bitwise.c: 18: pic = a & b;
;; genCast
	lad	_test_int_a_65536_2 + 1
	mov	r mem
;; genCast
	lad	_test_int_b_65536_2 + 1
	mov	x mem
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 1 1 1
;	begin bitwise ALU operation
	mov	alus il ,0	; and 
	mov	alua r
	mov	alub x
	mov	pic aluc
;	end bitwise ALU operation
;	src/bitwise.c: 19: pic = (a | b) >> 8;
;; genALUOp
;;	ALU or (1)
;;	ALU operand size 2 2 2
;	begin bitwise ALU operation
	mov	alus il ,1	; or 
	lad	_test_int_a_65536_2 + 1
	mov	alua mem
	lad	_test_int_b_65536_2 + 1
	mov	alub mem
	mov	x aluc
	lad	_test_int_a_65536_2 + 0
	mov	alua mem
	lad	_test_int_b_65536_2 + 0
	mov	alub mem
	mov	r aluc
;	end bitwise ALU operation
;; genGetByte      = 
;	offset = 1, 0
	mov	pic x
;	src/bitwise.c: 20: pic = a | b;
;; genCast
	lad	_test_int_a_65536_2 + 1
	mov	r mem
;; genCast
	lad	_test_int_b_65536_2 + 1
	mov	x mem
;; genALUOp
;;	ALU or (1)
;;	ALU operand size 1 1 1
;	begin bitwise ALU operation
	mov	alus il ,1	; or 
	mov	alua r
	mov	alub x
	mov	pic aluc
;	end bitwise ALU operation
;	src/bitwise.c: 21: pic = (a ^ b) >> 8;
;; genALUOp
;;	ALU xor (2)
;;	ALU operand size 2 2 2
;	begin bitwise ALU operation
	mov	alus il ,2	; xor 
	lad	_test_int_a_65536_2 + 1
	mov	alua mem
	lad	_test_int_b_65536_2 + 1
	mov	alub mem
	mov	x aluc
	lad	_test_int_a_65536_2 + 0
	mov	alua mem
	lad	_test_int_b_65536_2 + 0
	mov	alub mem
	mov	r aluc
;	end bitwise ALU operation
;; genGetByte      = 
;	offset = 1, 0
	mov	pic x
;	src/bitwise.c: 22: pic = a ^ b;
;; genCast
	lad	_test_int_a_65536_2 + 1
	mov	r mem
;; genCast
	lad	_test_int_b_65536_2 + 1
	mov	stack mem
	lad	_test_int_sloc0_1_0 + 0
	mov	mem stack
	lad	_test_int_b_65536_2 + 0
	mov	stack mem
	lad	_test_int_sloc0_1_0 + 1
	mov	mem stack
;; genALUOp
;;	ALU xor (2)
;;	ALU operand size 1 1 1
;	begin bitwise ALU operation
	mov	alus il ,2	; xor 
	mov	alua r
	lad	_test_int_sloc0_1_0 + 0
	mov	alub mem
	mov	pic aluc
;	end bitwise ALU operation
;; genLabel
;	src/bitwise.c: 24: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/bitwise.c: 26: void test_long() {
;; genLabel
;	-----------------------------------------
;	 function test_long
;	-----------------------------------------
	_test_long:
;	src/bitwise.c: 27: volatile long a = 0x0e03ee30;
;; genAssign
	lad	_test_long_a_65536_3 + 0
	mov	mem il ,14
	lad	_test_long_a_65536_3 + 1
	mov	mem il ,3
	lad	_test_long_a_65536_3 + 2
	mov	mem il ,238
	lad	_test_long_a_65536_3 + 3
	mov	mem il ,48
;	src/bitwise.c: 28: volatile long b = 0x020bbb20;
;; genAssign
	lad	_test_long_b_65536_3 + 0
	mov	mem il ,2
	lad	_test_long_b_65536_3 + 1
	mov	mem il ,11
	lad	_test_long_b_65536_3 + 2
	mov	mem il ,187
	lad	_test_long_b_65536_3 + 3
	mov	mem il ,32
;	src/bitwise.c: 32: long r = a & b;
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 4 4 4
;	begin bitwise ALU operation
	mov	alus il ,0	; and 
	lad	_test_long_a_65536_3 + 3
	mov	alua mem
	lad	_test_long_b_65536_3 + 3
	mov	alub mem
	lad	_test_long_sloc1_1_0 + 3
	mov	mem aluc
	lad	_test_long_a_65536_3 + 2
	mov	alua mem
	lad	_test_long_b_65536_3 + 2
	mov	alub mem
	lad	_test_long_sloc1_1_0 + 2
	mov	mem aluc
	lad	_test_long_a_65536_3 + 1
	mov	alua mem
	lad	_test_long_b_65536_3 + 1
	mov	alub mem
	lad	_test_long_sloc1_1_0 + 1
	mov	mem aluc
	lad	_test_long_a_65536_3 + 0
	mov	alua mem
	lad	_test_long_b_65536_3 + 0
	mov	alub mem
	lad	_test_long_sloc1_1_0 + 0
	mov	mem aluc
;	end bitwise ALU operation
;	src/bitwise.c: 34: pic = r >> 24;
;; genGetByte      = 
;	offset = 3, 0
	lad	_test_long_sloc1_1_0 + 0
	mov	pic mem
;	src/bitwise.c: 35: pic = r >> 16;
;; genGetByte      = 
;	offset = 2, 1
	lad	_test_long_sloc1_1_0 + 1
	mov	pic mem
;	src/bitwise.c: 36: pic = r >> 8;
;; genGetByte      = 
;	offset = 1, 2
	lad	_test_long_sloc1_1_0 + 2
	mov	pic mem
;	src/bitwise.c: 37: pic = r;
;; genCast
	lad	_test_long_sloc1_1_0 + 3
	mov	pic mem
;	src/bitwise.c: 39: r = a | b;
;; genALUOp
;;	ALU or (1)
;;	ALU operand size 4 4 4
;	begin bitwise ALU operation
	mov	alus il ,1	; or 
	lad	_test_long_a_65536_3 + 3
	mov	alua mem
	lad	_test_long_b_65536_3 + 3
	mov	alub mem
	lad	_test_long_sloc2_1_0 + 3
	mov	mem aluc
	lad	_test_long_a_65536_3 + 2
	mov	alua mem
	lad	_test_long_b_65536_3 + 2
	mov	alub mem
	lad	_test_long_sloc2_1_0 + 2
	mov	mem aluc
	lad	_test_long_a_65536_3 + 1
	mov	alua mem
	lad	_test_long_b_65536_3 + 1
	mov	alub mem
	lad	_test_long_sloc2_1_0 + 1
	mov	mem aluc
	lad	_test_long_a_65536_3 + 0
	mov	alua mem
	lad	_test_long_b_65536_3 + 0
	mov	alub mem
	lad	_test_long_sloc2_1_0 + 0
	mov	mem aluc
;	end bitwise ALU operation
;	src/bitwise.c: 41: pic = r >> 24;
;; genGetByte      = 
;	offset = 3, 0
	lad	_test_long_sloc2_1_0 + 0
	mov	pic mem
;	src/bitwise.c: 42: pic = r >> 16;
;; genGetByte      = 
;	offset = 2, 1
	lad	_test_long_sloc2_1_0 + 1
	mov	pic mem
;	src/bitwise.c: 43: pic = r >> 8;
;; genGetByte      = 
;	offset = 1, 2
	lad	_test_long_sloc2_1_0 + 2
	mov	pic mem
;	src/bitwise.c: 44: pic = r;
;; genCast
	lad	_test_long_sloc2_1_0 + 3
	mov	pic mem
;	src/bitwise.c: 46: r = a ^ b;
;; genALUOp
;;	ALU xor (2)
;;	ALU operand size 4 4 4
;	begin bitwise ALU operation
	mov	alus il ,2	; xor 
	lad	_test_long_a_65536_3 + 3
	mov	alua mem
	lad	_test_long_b_65536_3 + 3
	mov	alub mem
	lad	_test_long_sloc3_1_0 + 3
	mov	mem aluc
	lad	_test_long_a_65536_3 + 2
	mov	alua mem
	lad	_test_long_b_65536_3 + 2
	mov	alub mem
	lad	_test_long_sloc3_1_0 + 2
	mov	mem aluc
	lad	_test_long_a_65536_3 + 1
	mov	alua mem
	lad	_test_long_b_65536_3 + 1
	mov	alub mem
	lad	_test_long_sloc3_1_0 + 1
	mov	mem aluc
	lad	_test_long_a_65536_3 + 0
	mov	alua mem
	lad	_test_long_b_65536_3 + 0
	mov	alub mem
	lad	_test_long_sloc3_1_0 + 0
	mov	mem aluc
;	end bitwise ALU operation
;	src/bitwise.c: 48: pic = r >> 24;
;; genGetByte      = 
;	offset = 3, 0
	lad	_test_long_sloc3_1_0 + 0
	mov	pic mem
;	src/bitwise.c: 49: pic = r >> 16;
;; genGetByte      = 
;	offset = 2, 1
	lad	_test_long_sloc3_1_0 + 1
	mov	pic mem
;	src/bitwise.c: 50: pic = r >> 8;
;; genGetByte      = 
;	offset = 1, 2
	lad	_test_long_sloc3_1_0 + 2
	mov	pic mem
;	src/bitwise.c: 51: pic = r;
;; genCast
	lad	_test_long_sloc3_1_0 + 3
	mov	pic mem
;; genLabel
;	src/bitwise.c: 53: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/bitwise.c: 96: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/bitwise.c: 98: pic = 0xff;
;; genAssign
	mov	pic il ,255
;	src/bitwise.c: 99: test_char();
;; genCall
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	_test_char
L_main00103:
	; function returns nothing
;	src/bitwise.c: 101: test_int();
;; genCall
	mov	stack il ,hi8(L_main00104)
	mov	stack il ,lo8(L_main00104)
	goto	_test_int
L_main00104:
	; function returns nothing
;	src/bitwise.c: 103: test_long();
;; genCall
	mov	stack il ,hi8(L_main00105)
	mov	stack il ,lo8(L_main00105)
	goto	_test_long
L_main00105:
	; function returns nothing
;	src/bitwise.c: 105: pic = 0xff;
;; genAssign
	mov	pic il ,255
;	src/bitwise.c: 109: __endasm;
	halt
;; genLabel
;	src/bitwise.c: 110: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
