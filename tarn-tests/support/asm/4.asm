;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"4.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
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
	.section data,"w"
_array	=	0x8000
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd,"a"
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
;	src/4.c: 3: char main (char argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/4.c: 4: array[index] = 5;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_index
	mov	stack mem
	add_8s_16	_array
	lad	_main_sloc0_1_0 + 0
	mov	mem x
	lad	_main_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc0_1_0
	load_address_from_ptr _main_sloc0_1_0
	mov	mem il ,5
;	src/4.c: 5: return 0;
	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
;	src/4.c: 6: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
__xinit__index:
	.byte	#0x01	; 1
	.section cabs
