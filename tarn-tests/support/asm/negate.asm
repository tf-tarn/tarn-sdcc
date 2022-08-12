;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"negate.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
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
;	src/negate.c: 3: char main(char argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/negate.c: 6: x = pic;
;; genAssign
	mov	r pic
;	src/negate.c: 7: pic = -x;
;; genUminus
	mov	alua r
	mov	alus il ,3	; not 
	mov	alua aluc
	mov	alus il ,4	; plus 
	mov	alub il ,1
	mov	pic aluc
;	src/negate.c: 8: x = pic;
;; genAssign
	mov	r pic
;	src/negate.c: 9: pic = -x;
;; genUminus
	mov	alua r
	mov	alus il ,3	; not 
	mov	alua aluc
	mov	alus il ,4	; plus 
	mov	alub il ,1
	mov	pic aluc
;	src/negate.c: 10: x = pic;
;; genAssign
	mov	r pic
;	src/negate.c: 11: pic = -x;
;; genUminus
	mov	alua r
	mov	alus il ,3	; not 
	mov	alua aluc
	mov	alus il ,4	; plus 
	mov	alub il ,1
	mov	pic aluc
;	src/negate.c: 12: x = pic;
;; genAssign
	mov	r pic
;	src/negate.c: 13: pic = -x;
;; genUminus
	mov	alua r
	mov	alus il ,3	; not 
	mov	alua aluc
	mov	alus il ,4	; plus 
	mov	alub il ,1
	mov	pic aluc
;	src/negate.c: 14: x = pic;
;; genAssign
	mov	r pic
;	src/negate.c: 15: pic = -x;
;; genUminus
	mov	alua r
	mov	alus il ,3	; not 
	mov	alua aluc
	mov	alus il ,4	; plus 
	mov	alub il ,1
	mov	pic aluc
;; genLabel
;	src/negate.c: 16: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
