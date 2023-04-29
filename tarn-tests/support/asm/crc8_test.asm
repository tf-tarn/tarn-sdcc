;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"crc8_test.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_crc8_one
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_crc8_one_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_crc8_one_PARM_1:
	.ds	1
_main_PARM_1:
	.ds	1
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
;	src/crc8_test.c: 7: uint8_t crc8_one(uint8_t crc)
;; genLabel
;	-----------------------------------------
;	 function crc8_one
;	-----------------------------------------
	_crc8_one:
;	src/crc8_test.c: 10: for (uint8_t i = 0; i < 8; i++)
;; genAssign
	mov	r zero
;; genLabel
L_crc8_one00106:
;; genCmp
	mov	alus il ,9	; less-than 
	mov	alua r
	mov	alub il ,8
	mov	test aluc
;; genIfx
	gotonz	L_crc8_one00125
	goto	L_crc8_one00104
L_crc8_one00125:
;	src/crc8_test.c: 12: if (crc & 0x80)
;; genAssign
	lad	_crc8_one_PARM_1 + 0
	mov	x mem
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 2 1 1
	mov	alua x
	mov	alus il ,0	; and 
	mov	alub il ,128
;; ALU op has ifx!
	mov	alua aluc
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
;; genIfx
	gotonz	L_crc8_one00102
;	src/crc8_test.c: 14: crc = (crc << 1) ^ POLYNOMIAL;
;; genLeftShift
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alua x
	mov	alus il ,4	; plus 
	mov	alub x
	mov	x aluc
;; genALUOp
;;	ALU xor (2)
;;	ALU operand size 1 1 1
	mov	alua x
	mov	alus il ,2	; xor 
	mov	alub il ,7
	lad	_crc8_one_PARM_1 + 0
	mov	mem aluc
;; genGoto
	goto	L_crc8_one00107
;; genLabel
L_crc8_one00102:
;	src/crc8_test.c: 18: crc <<= 1;
;; genLeftShift
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alua x
	mov	alus il ,4	; plus 
	mov	alub x
	lad	_crc8_one_PARM_1 + 0
	mov	mem aluc
;; genLabel
L_crc8_one00107:
;	src/crc8_test.c: 10: for (uint8_t i = 0; i < 8; i++)
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alua r
	mov	alus il ,4	; plus 
	mov	alub il ,1
	mov	r aluc
;; genGoto
	goto	L_crc8_one00106
;; genLabel
L_crc8_one00104:
;	src/crc8_test.c: 22: return crc;
	mov	jmpl stack
	mov	jmph stack
	lad	_crc8_one_PARM_1
	mov	stack mem
	jump
;; genLabel
;	src/crc8_test.c: 23: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/crc8_test.c: 25: uint8_t main (uint8_t argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/crc8_test.c: 26: while (1) {
;; genLabel
L_main00102:
;	src/crc8_test.c: 27: pic = crc8_one(pic);
;; genAssign
	lad	_crc8_one_PARM_1
	mov	mem pic
;; genCall
	mov	stack il ,hi8(L_main00110)
	mov	stack il ,lo8(L_main00110)
	goto	_crc8_one
L_main00110:
	mov	r stack
;; genAssign
	mov	pic r
;; genGoto
	goto	L_main00102
;; genLabel
;	src/crc8_test.c: 29: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
