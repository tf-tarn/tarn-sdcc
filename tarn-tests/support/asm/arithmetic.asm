;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"arithmetic.c"
	
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
_main_a_65536_2:
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
;	src/arithmetic.c: 3: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/arithmetic.c: 4: volatile int a = 0x1024;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,16
	lad	_main_a_65536_2 + 1
	mov	mem il ,36
;	src/arithmetic.c: 7: if (a + 5 == (0x1024 + 5)) {
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 2
	add_16m_16l	_main_a_65536_2 5
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) comparison
	mov	alua il ,41
	mov	alub r
	mov	test aluc
	gotonz	L_main00129
	goto	L_main00130
L_main00129:
	mov	alua il ,16
	mov	alub x
	mov	test aluc
	gotonz	L_main00130
	goto	L_main00102
;	emit end of comparison label
L_main00130:
;	end multibyte comparison
;	src/arithmetic.c: 8: pic = 1;
;; genAssign
	mov	pic il ,1
;; genGoto
	goto	L_main00103
;; genLabel
L_main00102:
;	src/arithmetic.c: 10: pic = 0;
;; genAssign
	mov	pic il ,0
;; genLabel
L_main00103:
;	src/arithmetic.c: 13: if (a + 5 != (0x1024 + 5)) {
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 2
	add_16m_16l	_main_a_65536_2 5
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) comparison
	mov	alua il ,41
	mov	alub r
	mov	test aluc
	gotonz	L_main00132
	goto	L_main00133
L_main00132:
	mov	alua il ,16
	mov	alub x
	mov	test aluc
	gotonz	L_main00105
;	emit end of comparison label
L_main00133:
;	end multibyte comparison
;	src/arithmetic.c: 14: pic = 0;
;; genAssign
	mov	pic il ,0
;; genGoto
	goto	L_main00106
;; genLabel
L_main00105:
;	src/arithmetic.c: 16: pic = 2;
;; genAssign
	mov	pic il ,2
;; genLabel
L_main00106:
;	src/arithmetic.c: 19: if (a + 5 != (0x1024 + 5)) {
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 2
	add_16m_16l	_main_a_65536_2 5
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) comparison
	mov	alua il ,41
	mov	alub r
	mov	test aluc
	gotonz	L_main00135
	goto	L_main00136
L_main00135:
	mov	alua il ,16
	mov	alub x
	mov	test aluc
	gotonz	L_main00108
;	emit end of comparison label
L_main00136:
;	end multibyte comparison
;	src/arithmetic.c: 20: pic = 3;
;; genAssign
	mov	pic il ,3
;; genLabel
L_main00108:
;	src/arithmetic.c: 22: if (a + 5 == (0x1024 + 5)) {
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 2
	add_16m_16l	_main_a_65536_2 5
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) comparison
	mov	alua il ,41
	mov	alub r
	mov	test aluc
	gotonz	L_main00138
	goto	L_main00139
L_main00138:
	mov	alua il ,16
	mov	alub x
	mov	test aluc
	gotonz	L_main00139
	goto	L_main00110
;	emit end of comparison label
L_main00139:
;	end multibyte comparison
;	src/arithmetic.c: 23: pic = 3;
;; genAssign
	mov	pic il ,3
;; genLabel
L_main00110:
;	src/arithmetic.c: 25: pic = 4;
;; genAssign
	mov	pic il ,4
;; genLabel
;	src/arithmetic.c: 32: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
