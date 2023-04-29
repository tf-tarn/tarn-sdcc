;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"testfwk___div.c"
	
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
___div_PARM_1:
	.ds	2
___div_PARM_2:
	.ds	2
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
_main_sloc0_1_0:
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
;	src/testfwk-__div.c: 4: __div(int num, int denom)
;; genLabel
;	-----------------------------------------
;	 function __div
;	-----------------------------------------
	___div:
;	src/testfwk-__div.c: 7: while (num >= denom)
;; genAssign
	mov	r zero
	mov	x zero
;; genLabel
L___div00101:
;; genCmp
	mov	alus il ,9	; less-than 
	compare_16m_16m__t	9 ___div_PARM_1 ___div_PARM_2 L___div00103
;	src/testfwk-__div.c: 9: q++;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack x
	mov	stack r
	add_16s_8	1
;	src/testfwk-__div.c: 10: num -= denom;
;; genALUOp
;;	ALU minus (16)
;;	ALU operand size 2 2 2
	sub_16m_16m	___div_PARM_1 ___div_PARM_2
	lad	___div_PARM_1 + 1
	mov	mem r
	lad	___div_PARM_1 + 0
	mov	mem x
	restore_rx
;; genGoto
	goto	L___div00101
;; genLabel
L___div00103:
;	src/testfwk-__div.c: 12: return q;
	mov	jmpl stack
	mov	jmph stack
	mov	stack x
	mov	stack r
	jump
;; genLabel
;	src/testfwk-__div.c: 13: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__div.c: 15: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/testfwk-__div.c: 16: int a = __div(0x3241, 17);
;; genAssign
	lad	___div_PARM_1 + 0
	mov	mem il ,50
	lad	___div_PARM_1 + 1
	mov	mem il ,65
;; genAssign
	lad	___div_PARM_2 + 0
	mov	mem il ,0
	lad	___div_PARM_2 + 1
	mov	mem il ,17
;; genCall
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	___div
L_main00103:
	lad	_main_sloc0_1_0 + 1
	mov	mem stack
	lad	_main_sloc0_1_0 + 0
	mov	mem stack
;; genAssign
	lad	_main_sloc0_1_0 + 0
	mov	x mem
	lad	_main_sloc0_1_0 + 1
	mov	r mem
;	src/testfwk-__div.c: 18: pic = (a >> 8) & 0xff;
;; genGetByte      = 
;	left operand AOP_REG
;	  size = 2
;	  registers = x r 
;	right operand AOP_LIT
;	  size = 2
;	  value = 00 08 
;	result operand AOP_SFR
;	  size = 1
;	offset = 1, 0
	mov	pic x
;	src/testfwk-__div.c: 19: pic = a & 0xff;
;; genCast
	mov	pic r
;	src/testfwk-__div.c: 28: __endasm;
	halt
;	src/testfwk-__div.c: 30: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/testfwk-__div.c: 31: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
