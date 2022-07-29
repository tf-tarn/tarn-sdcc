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
	.section data,"rw"
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
	.section data,"rw"
;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------
	.section text,"ax"
__interrupt_vect:
;; tarn_genIVT
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.section text
	.section GSINIT
	.section GSFINAL
	.section GSINIT
tarn_genInitStartup
	.section GSFINAL
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.section text,"ax"
	.section text,"ax"
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.section text,"ax"
;	t/tests/2.c: 3: int multiply_or_divide(int which, int a, int b) {
;	-----------------------------------------
;	 function multiply_or_divide
;	-----------------------------------------
	_multiply_or_divide:
;	t/tests/2.c: 4: switch(which) {

	;; test equality
	mov	alus il ,10	; equal-to 
	lad	_multiply_or_divide_PARM_1
	mov	alua mem
	mov	alub zero
	mov	test aluc

	;; If x
	gotonz	L_1

	;; test equality
	mov	alus il ,10	; equal-to 
	lad	_multiply_or_divide_PARM_1
	mov	alua mem
	mov	alub il ,1
	mov	test aluc

	;; If x
	gotonz	L_2

	;; goto
	goto	L_3
;	t/tests/2.c: 5: case 0:
	L_1:
;	t/tests/2.c: 6: return a * b;

	;; assign
	lad	_multiply_or_divide_PARM_2
	mov	stack mem
	lad	__muluchar_PARM_1
	mov	mem stack

	;; assign
	lad	_multiply_or_divide_PARM_3
	mov	stack mem
	lad	__muluchar_PARM_2
	mov	mem stack
;; call function
	goto	__muluchar

	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/2.c: 7: case 1:
	L_2:
;	t/tests/2.c: 8: return a / b;

	;; assign
	lad	_multiply_or_divide_PARM_2
	mov	stack mem
	lad	__divuchar_PARM_1
	mov	mem stack

	;; assign
	lad	_multiply_or_divide_PARM_3
	mov	stack mem
	lad	__divuchar_PARM_2
	mov	mem stack
;; call function
	goto	__divuchar

	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/2.c: 9: }
	L_3:
;	t/tests/2.c: 11: if (a) {

	;; If x
	lad	_multiply_or_divide_PARM_2
	mov	test mem
	gotonz	L_24
	goto	L_5
	L_24:
;	t/tests/2.c: 12: a = 4;

	;; assign
	lad	_multiply_or_divide_PARM_2
	mov	mem il ,4

	;; goto
	goto	L_6
	L_5:
;	t/tests/2.c: 14: a = b;

	;; assign
	lad	_multiply_or_divide_PARM_3
	mov	stack mem
	lad	_multiply_or_divide_PARM_2
	mov	mem stack
	L_6:
;	t/tests/2.c: 17: return a;

	;; return
	mov	jmpl stack
	mov	jmph stack
	lad	_multiply_or_divide_PARM_2
	mov	stack mem
	jump
;	t/tests/2.c: 18: }
;; genEndFunction 
;	t/tests/2.c: 20: int main (int argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/2.c: 21: return 0;

	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;	t/tests/2.c: 22: }
;; genEndFunction 
	.section text,"ax"
	.section rodata
	.section rodata
--END ASM--
