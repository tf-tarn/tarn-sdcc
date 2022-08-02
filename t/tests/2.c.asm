;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"2.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
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
	.section .data,"w"
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
; ram data
;--------------------------------------------------------
	.section initd
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
;	t/tests/2.c: 3: int multiply_or_divide(int which, int a, int b) {
;; genLabel
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
;	line 531
	gotonz	L_multiply_or_divide00101
	;; test equality
	mov	alus il ,10	; equal-to 
	lad	_multiply_or_divide_PARM_1
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
	;; If x
;	line 531
	gotonz	L_multiply_or_divide00102
	;; goto
;	line 531
	goto	L_multiply_or_divide00103
;	t/tests/2.c: 5: case 0:
;; genLabel
;	line 1435
L_multiply_or_divide00101:
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
	mov	stack il ,hi8(L_multiply_or_divide00121)
	mov	stack il ,lo8(L_multiply_or_divide00121)
	goto	__muluchar
;	line 907
L_multiply_or_divide00121:
	mov	r stack
	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/2.c: 7: case 1:
;; genLabel
;	line 1435
L_multiply_or_divide00102:
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
	mov	stack il ,hi8(L_multiply_or_divide00122)
	mov	stack il ,lo8(L_multiply_or_divide00122)
	goto	__divuchar
;	line 907
L_multiply_or_divide00122:
	mov	r stack
	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/2.c: 9: }
;; genLabel
;	line 1435
L_multiply_or_divide00103:
;	t/tests/2.c: 11: if (a) {
	;; If x
	lad	_multiply_or_divide_PARM_2
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
;	line 531
	gotonz	L_multiply_or_divide00105
;	t/tests/2.c: 12: a = 4;
	;; assign
	lad	_multiply_or_divide_PARM_2
	mov	mem il ,4
	;; goto
;	line 531
	goto	L_multiply_or_divide00106
;; genLabel
;	line 1435
L_multiply_or_divide00105:
;	t/tests/2.c: 14: a = b;
	;; assign
	lad	_multiply_or_divide_PARM_3
	mov	stack mem
	lad	_multiply_or_divide_PARM_2
	mov	mem stack
;; genLabel
;	line 1435
L_multiply_or_divide00106:
;	t/tests/2.c: 17: return a;
	;; return
	mov	jmpl stack
	mov	jmph stack
	lad	_multiply_or_divide_PARM_2
	mov	stack mem
	jump
;; genLabel
;	line 1435
;	t/tests/2.c: 18: }
;; genEndFunction 
;	t/tests/2.c: 20: int main (int argc, char **argv) {
;; genLabel
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
;; genLabel
;	line 1435
;	t/tests/2.c: 22: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section initr
	.section cabs
