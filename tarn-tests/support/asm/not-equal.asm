;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"not_equal.c"
	
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
	.ds	1
_main_n_65536_2:
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
;	src/not-equal.c: 3: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/not-equal.c: 4: volatile unsigned char a = 1;
;; genAssign
	lad	_main_a_65536_2
	mov	mem il ,1
;	src/not-equal.c: 5: volatile unsigned int n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;	src/not-equal.c: 19: pic = '6';
;; genAssign
	mov	pic il ,54
;	src/not-equal.c: 20: while (n != 0) {
;; genLabel
L_main00101:
;; genIfx
;	implement me (invert=false, t=0, f=1)
	mov	alus il ,10	; equal-to 
;	has FALSE ifx
;	begin multibyte (2) comparison
;	compare byte 0
	mov	alua zero
	lad	_main_n_65536_2
	mov	alub mem
	mov	test aluc
;	not last -> jump to desired maybe
	gotonz	L_main00125
;	test failed; jump to undesired
	goto	L_main00126
;	emit desired maybe L_main00125
L_main00125:
;	next desired maybe is L_main00127
;	compare byte 1
	mov	alua zero
	lad	_main_n_65536_2 + 1
	mov	alub mem
	mov	test aluc
;	last -> jump to desired
	gotonz	L_main00103
;	test failed; jump to undesired
	goto	L_main00126
;	emit undesired L_main00126
L_main00126:
;	end multibyte comparison
;	src/not-equal.c: 21: pic = '7';
;; genAssign
	mov	pic il ,55
;	src/not-equal.c: 22: n = 0;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,0
;; genGoto
	goto	L_main00101
;; genLabel
L_main00103:
;	src/not-equal.c: 25: n = 0;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,0
;	src/not-equal.c: 27: pic = '8';
;; genAssign
	mov	pic il ,56
;	src/not-equal.c: 28: while (n == 0) {
;; genLabel
L_main00104:
;; genIfx
;	implement me (invert=false, t=1, f=0)
	mov	alus il ,10	; equal-to 
;	has TRUE ifx
;	begin multibyte (2) comparison
;	compare byte 0
	mov	alua zero
	lad	_main_n_65536_2
	mov	alub mem
	mov	test aluc
;	not last -> jump to desired maybe
	gotonz	L_main00128
;	test failed; jump to undesired
	goto	L_main00106
;	emit desired maybe L_main00128
L_main00128:
;	next desired maybe is L_main00130
;	compare byte 1
	mov	alua zero
	lad	_main_n_65536_2 + 1
	mov	alub mem
	mov	test aluc
;	last -> jump to desired
	gotonz	L_main00129
;	test failed; jump to undesired
	goto	L_main00106
;	emit undesired L_main00129
L_main00129:
;	end multibyte comparison
;	src/not-equal.c: 29: pic = '9';
;; genAssign
	mov	pic il ,57
;	src/not-equal.c: 30: n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;; genGoto
	goto	L_main00104
;; genLabel
L_main00106:
;	src/not-equal.c: 32: pic = '9' + 1;
;; genAssign
	mov	pic il ,58
;	src/not-equal.c: 42: __endasm;
	halt
;	src/not-equal.c: 44: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/not-equal.c: 45: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
