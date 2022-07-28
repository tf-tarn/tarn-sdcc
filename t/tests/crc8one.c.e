assembler was passed: -plosgffw crc8one.asm
--BEGIN ASM--
;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"crc8one.c"
	.optsdcc -mtarn
	
;; tarn_genAssemblerStart
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
	.section DATA,"rw"
_crc8_one_PARM_1:
	.ds	1
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; overlayable items in ram
;--------------------------------------------------------
;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.section DABS (ABS)
;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------
	.section HOME,"ax"
__interrupt_vect:
;; tarn_genIVT
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.section HOME
	.section GSINIT
	.section GSFINAL
	.section GSINIT
tarn_genInitStartup
	.section GSFINAL
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.section HOME,"ax"
	.section HOME,"ax"
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.section CODE,"ax"
;	t/tests/crc8one.c: 5: uint8_t crc8_one(uint8_t crc)
;	-----------------------------------------
;	 function crc8_one
;	-----------------------------------------
	_crc8_one:
;	t/tests/crc8one.c: 8: for (uint8_t i = 0; i < 8; i++)

	;; genAssign      
	mov	r zero
	L_6:

	;; genCmp
	mov	alus il ,9	; less-than 
	mov	alua r
	mov	alub il ,8
	mov	test aluc

	;; genIfx
	gotonz	L_26
	goto	L_4
	L_26:
;	t/tests/crc8one.c: 10: if (crc & 0x80)

	;; genAssign      
	lad	_crc8_one_PARM_1
	mov	x mem
;; genALUOp 0
;; TODO: if we have an ifx, then we must AND and then EQ!
	mov	alus il ,0	; and 
	mov	alua x
	mov	alub il ,128
;; ALU op has ifx!
	mov	alua aluc
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc

	;; genIfx
	gotonz	L_2
;	t/tests/crc8one.c: 12: crc = (crc << 1) ^ POLYNOMIAL;
;; genALUOp 4
;; TODO: if we have an ifx, then we must AND and then EQ!
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub x
	mov	x aluc
;; genALUOp 2
;; TODO: if we have an ifx, then we must AND and then EQ!
	mov	alus il ,2	; xor 
	mov	alua x
	mov	alub il ,7
	lad	_crc8_one_PARM_1
	mov	mem aluc

	;; genGoto
	goto	L_7
	L_2:
;	t/tests/crc8one.c: 16: crc <<= 1;
;; genALUOp 4
;; TODO: if we have an ifx, then we must AND and then EQ!
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub x
	lad	_crc8_one_PARM_1
	mov	mem aluc
	L_7:
;	t/tests/crc8one.c: 8: for (uint8_t i = 0; i < 8; i++)
;; genALUOp 4
;; TODO: if we have an ifx, then we must AND and then EQ!
	mov	alus il ,4	; plus 
	mov	alua r
	mov	alub il ,1
	mov	r aluc

	;; genGoto
	goto	L_6
	L_4:
;	t/tests/crc8one.c: 20: return crc;

	;; genReturn
	mov	jmpl stack
	mov	jmph stack
	lad	_crc8_one_PARM_1
	mov	stack mem
	jump
	L_8:
;	t/tests/crc8one.c: 21: }
;; genEndFunction 
;	t/tests/crc8one.c: 23: uint8_t main(uint8_t argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/crc8one.c: 24: return crc8_one(5);

	;; genAssign      
	lad	_crc8_one_PARM_1
	mov	mem il ,5
;; genCall
	goto	_crc8_one

	;; genReturn
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
	L_1:
;	t/tests/crc8one.c: 25: }
;; genEndFunction 
	.section CODE,"ax"
	.section CONST
	.section CABS (ABS)
--END ASM--
