;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"4.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_index
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_array
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section .data,"w"
_array:
	.ds	4
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd
_index:
	.ds	1
;--------------------------------------------------------
; overlayable items in ram
;--------------------------------------------------------
	.area	_overlay
_main_sloc0_1_0:
	.ds	2
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
;	t/tests/4.c: 3: char main (char argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/4.c: 4: array[index] = 5;
;;	ALU plus (4)
	; remat: _array + 0
	lad	_index
	mov	stack mem
	mov	stack il ,lo8(_array + 0)
	mov	stack il ,hi8(_array + 0)
	add_8s_16s
	lad	_main_sloc0_1_0
	mov	mem x
	lad	_main_sloc0_1_0 + 1
	mov	mem r
;; genPointerSet: operand size 2, 1
	mov	adh x
	mov	adl r
	mov	mem il ,5
;	t/tests/4.c: 5: return 0;
	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;	t/tests/4.c: 6: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section initr
__xinit__index:
	.byte	#0x01	; 1
	.section cabs
