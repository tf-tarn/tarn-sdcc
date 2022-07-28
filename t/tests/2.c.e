assembler was passed: -plosgffw 2.asm
--BEGIN ASM--
;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"2.c"
	.optsdcc -mtarn
	
;; tarn_genAssemblerStart
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_multiply_or_divide
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_multiply_or_divide_PARM_3
	.globl	_multiply_or_divide_PARM_2
	.globl	_multiply_or_divide_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section DATA,"rw"
_multiply_or_divide_PARM_1:
	.ds	1
_multiply_or_divide_PARM_2:
	.ds	1
_multiply_or_divide_PARM_3:
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
;	t/tests/2.c: 3: int multiply_or_divide(int which, int a, int b) {
;	-----------------------------------------
;	 function multiply_or_divide
;	-----------------------------------------
	_multiply_or_divide:
;	t/tests/2.c: 4: switch(which) {

	;; genCmpEQorNE
	mov	alus il ,10
	lad	_multiply_or_divide_PARM_1
	mov	alua mem
	mov	alub zero
	mov	test aluc ,0

	;; genIfx
	gotonz	L_1

	;; genCmpEQorNE
	mov	alus il ,10
	lad	_multiply_or_divide_PARM_1
	mov	alua mem
	mov	alub il ,1
	mov	test aluc ,0

	;; genIfx
	gotonz	L_2

	;; genGoto
	goto	L_3
;	t/tests/2.c: 5: case 0:
	L_1:
;	t/tests/2.c: 6: return a * b;

	;; genAssign      
	lad	_multiply_or_divide_PARM_2
	mov	stack mem ,0
	lad	__muluchar_PARM_1
	mov	mem stack ,0

	;; genAssign      
	lad	_multiply_or_divide_PARM_3
	mov	stack mem ,0
	lad	__muluchar_PARM_2
	mov	mem stack ,0
;; genCall
	goto	__muluchar

	;; genReturn
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/2.c: 7: case 1:
	L_2:
;	t/tests/2.c: 8: return a / b;

	;; genAssign      
	lad	_multiply_or_divide_PARM_2
	mov	stack mem ,0
	lad	__divuchar_PARM_1
	mov	mem stack ,0

	;; genAssign      
	lad	_multiply_or_divide_PARM_3
	mov	stack mem ,0
	lad	__divuchar_PARM_2
	mov	mem stack ,0
;; genCall
	goto	__divuchar

	;; genReturn
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/2.c: 9: }
	L_3:
;	t/tests/2.c: 11: if (a) {

	;; genIfx
	mov	test _multiply_or_divide_PARM_2 ,0
	gotonz	L_21
	goto	L_5
	L_21:
;	t/tests/2.c: 12: a = 4;

	;; genAssign      
	lad	_multiply_or_divide_PARM_2
	mov	mem il ,4

	;; genGoto
	goto	L_6
	L_5:
;	t/tests/2.c: 14: a = b;

	;; genAssign      
	lad	_multiply_or_divide_PARM_3
	mov	stack mem ,0
	lad	_multiply_or_divide_PARM_2
	mov	mem stack ,0
	L_6:
;	t/tests/2.c: 17: return a;

	;; genReturn
	mov	jmpl stack
	mov	jmph stack
	lad	_multiply_or_divide_PARM_2
	mov	stack mem
	jump
	L_7:
;	t/tests/2.c: 18: }
;; genEndFunction 
;	t/tests/2.c: 20: int main (int argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/2.c: 21: return 0;

	;; genReturn
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
	L_1:
;	t/tests/2.c: 22: }
;; genEndFunction 
	.section CODE,"ax"
	.section CONST
	.section CABS (ABS)
--END ASM--
