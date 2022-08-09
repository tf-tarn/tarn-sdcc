;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"2.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
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
	.section data,"w"
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
;	src/2.c: 3: int multiply_or_divide(int which, int a, int b) {
;; genLabel
;	-----------------------------------------
;	 function multiply_or_divide
;	-----------------------------------------
	_multiply_or_divide:
;	src/2.c: 4: switch(which) {
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	lad	_multiply_or_divide_PARM_1
	mov	alua mem
	mov	alub zero
	mov	test aluc
;; genIfx
	gotonz	L_multiply_or_divide00101
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	lad	_multiply_or_divide_PARM_1
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
;; genIfx
	gotonz	L_multiply_or_divide00102
;; genGoto
	goto	L_multiply_or_divide00103
;	src/2.c: 5: case 0:
;; genLabel
L_multiply_or_divide00101:
;	src/2.c: 6: return a * b;
;; genAssign
	lad	_multiply_or_divide_PARM_2
	mov	stack mem
	lad	__muluchar_PARM_1
	mov	mem stack
;; genAssign
	lad	_multiply_or_divide_PARM_3
	mov	stack mem
	lad	__muluchar_PARM_2
	mov	mem stack
	mov	stack il ,hi8(L_multiply_or_divide00121)
	mov	stack il ,lo8(L_multiply_or_divide00121)
	goto	__muluchar
L_multiply_or_divide00121:
	mov	r stack
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	src/2.c: 7: case 1:
;; genLabel
L_multiply_or_divide00102:
;	src/2.c: 8: return a / b;
;; genAssign
	lad	_multiply_or_divide_PARM_2
	mov	stack mem
	lad	__divuchar_PARM_1
	mov	mem stack
;; genAssign
	lad	_multiply_or_divide_PARM_3
	mov	stack mem
	lad	__divuchar_PARM_2
	mov	mem stack
	mov	stack il ,hi8(L_multiply_or_divide00122)
	mov	stack il ,lo8(L_multiply_or_divide00122)
	goto	__divuchar
L_multiply_or_divide00122:
	mov	r stack
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	src/2.c: 9: }
;; genLabel
L_multiply_or_divide00103:
;	src/2.c: 11: if (a) {
;; genIfx
	lad	_multiply_or_divide_PARM_2
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_multiply_or_divide00105
;	src/2.c: 12: a = 4;
;; genAssign
	lad	_multiply_or_divide_PARM_2
	mov	mem il ,4
;; genGoto
	goto	L_multiply_or_divide00106
;; genLabel
L_multiply_or_divide00105:
;	src/2.c: 14: a = b;
;; genAssign
	lad	_multiply_or_divide_PARM_3
	mov	stack mem
	lad	_multiply_or_divide_PARM_2
	mov	mem stack
;; genLabel
L_multiply_or_divide00106:
;	src/2.c: 17: return a;
	mov	jmpl stack
	mov	jmph stack
	lad	_multiply_or_divide_PARM_2
	mov	stack mem
	jump
;; genLabel
;	src/2.c: 18: }
;; genEndFunction  = 
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/2.c: 20: int main (int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/2.c: 21: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
;	src/2.c: 22: }
;; genEndFunction  = 
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
