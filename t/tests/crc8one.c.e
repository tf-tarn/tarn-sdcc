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
	.ds	2
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; overlayable items in ram
;--------------------------------------------------------
	.area	OSEG (OVR,DATA)
_crc8_one_sloc0_1_0:
	.ds	2
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
;	t/tests/crc8one.c: 8: for (int i = 0; i < 8; i++)

	;; genAssign      
	lad	iTemp10
	mov	mem il ,0
	L_106:

	;; genCmp	0x558de531f5b0
;; TODO: set alus!
; symbol has 2 regs
	mov	alua iTemp10 ,0
	mov	alub il ,8
	mov	test aluc ,0

	;; genIfx	0x558de531f5b0
; TODO: REVERSE THIS!
	gotonz	L_00104
;	t/tests/crc8one.c: 10: if (crc & 0x80)

	;; genAssign      
	lad	_crc8_one_PARM_1
	mov	stack mem ,0
	lad	iTemp2
	mov	mem stack ,0
;; genALUOp 0
	mov	alus il ,0
; symbol has 1 regs
	mov	alua iTemp2 ,0
	mov	alub il ,128
;	t/tests/crc8one.c: 12: crc = (crc << 1) ^ POLYNOMIAL;
;; genALUOp 4
	mov	alus il ,4
; symbol has 1 regs
	mov	alua iTemp2 ,0
; symbol has 1 regs
	mov	alub iTemp2 ,0
;; genALUOp 2
	mov	alus il ,2
; symbol has 1 regs
	mov	alua iTemp5 ,0
	mov	alub il ,7

	;; genGoto
	goto	L_00107
	L_102:
;	t/tests/crc8one.c: 16: crc <<= 1;
;; genALUOp 4
	mov	alus il ,4
; symbol has 1 regs
	mov	alua iTemp2 ,0
; symbol has 1 regs
	mov	alub iTemp2 ,0
	L_107:
;	t/tests/crc8one.c: 8: for (int i = 0; i < 8; i++)
;; genALUOp 4
	mov	alus il ,4
; symbol has 2 regs
	mov	alua iTemp10 ,0
	mov	alub il ,1

	;; genGoto
	goto	L_00106
	L_104:
;	t/tests/crc8one.c: 20: return crc;

	;; genReturn
	mov	jmpl stack
	mov	jmph stack
	lad	_crc8_one_PARM_1
	mov	stack mem
	jump
	L_108:
;	t/tests/crc8one.c: 21: }
;; genEndFunction 
;	t/tests/crc8one.c: 23: int main(int argc, char **argv) {
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
;; genCast        

	;; genReturn
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
	L_101:
;	t/tests/crc8one.c: 25: }
;; genEndFunction 
	.section CODE,"ax"
	.section CONST
	.section CABS (ABS)
--END ASM--
Got cost 0.0001
Got cost 0
Got cost 0
Got cost 0.0001
Got cost 0
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Hello, there should be a label here.
Hello, there should be a label here.
Hello, there should be a label here.
Hello, there should be a label here.
intelligible IC:
	(unknown) (346)
Hello, there should be a label here.
Got cost 0
Got cost 0.0001
Got cost 0
Got cost 0
Got cost 0.0001
Got cost 0.0001
Got cost 0.0001
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
Got cost 0
intelligible IC:
	(unknown) (346)
Hello, there should be a label here.
