;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"test_buf.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_main_PARM_2
	.globl	_main_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
_main_buf_65536_2:
	.ds	6
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
;	src/test_buf.c: 3: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/test_buf.c: 6: char *p = &buf[sizeof (buf) - 1];
;	src/test_buf.c: 9: buf[sizeof(buf) - 1] = '\0';
;; genPointerSet
;; genPointerSet: operand size 2, 1
	mov	adh il ,hi8(_main_buf_65536_2 + 5)
	mov	adl il ,lo8(_main_buf_65536_2 + 5)
	mov	mem il ,0
;	src/test_buf.c: 11: *--p = 'a';
;; genPointerSet
;; genPointerSet: operand size 2, 1
	mov	adh il ,hi8(_main_buf_65536_2 + 4)
	mov	adl il ,lo8(_main_buf_65536_2 + 4)
	mov	mem il ,97
;	src/test_buf.c: 12: *--p = 'b';
;; genPointerSet
;; genPointerSet: operand size 2, 1
	mov	adh il ,hi8(_main_buf_65536_2 + 3)
	mov	adl il ,lo8(_main_buf_65536_2 + 3)
	mov	mem il ,98
;	src/test_buf.c: 13: *--p = 'c';
;; genPointerSet
;; genPointerSet: operand size 2, 1
	mov	adh il ,hi8(_main_buf_65536_2 + 2)
	mov	adl il ,lo8(_main_buf_65536_2 + 2)
	mov	mem il ,99
;	src/test_buf.c: 14: *--p = 'd';
;; genPointerSet
;; genPointerSet: operand size 2, 1
	mov	adh il ,hi8(_main_buf_65536_2 + 1)
	mov	adl il ,lo8(_main_buf_65536_2 + 1)
	mov	mem il ,100
;	src/test_buf.c: 15: *--p = 'e';
;; genPointerSet
;; genPointerSet: operand size 2, 1
	mov	adh il ,hi8(_main_buf_65536_2 + 0)
	mov	adl il ,lo8(_main_buf_65536_2 + 0)
	mov	mem il ,101
;	src/test_buf.c: 17: for (char i = 0; i < sizeof buf; ++i) {
;; genAssign
	mov	r zero
;; genLabel
L_main00103:
;; genCmp
	mov	alus il ,9	; less-than 
	mov	alua r
	mov	alub il ,6
	mov	test aluc
;; genIfx
	gotonz	L_main00118
	goto	L_main00101
L_main00118:
;	src/test_buf.c: 18: pic = buf[i];
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack r
	add_8s_16	_main_buf_65536_2 + 0
	lad	_main_sloc0_1_0 + 1
	mov	mem r
	lad	_main_sloc0_1_0 + 0
	mov	mem x
	restore_rx
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc0_1_0
	load_address_from_ptr	_main_sloc0_1_0
	mov	pic mem
;	src/test_buf.c: 17: for (char i = 0; i < sizeof buf; ++i) {
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alua r
	mov	alus il ,4	; plus 
	mov	alub il ,1
	mov	r aluc
;; genGoto
	goto	L_main00103
;; genLabel
L_main00101:
;	src/test_buf.c: 23: __endasm;
	halt
;; genLabel
;	src/test_buf.c: 24: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
