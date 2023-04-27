;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"testfwk___prints.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	___prints
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	___prints_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
___div_PARM_1:
	.ds	2
___div_PARM_2:
	.ds	2
___mod_PARM_1:
	.ds	2
___mod_PARM_2:
	.ds	2
___prints_PARM_1:
	.ds	2
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd,"a"
;--------------------------------------------------------
; overlayable items in ram
;--------------------------------------------------------
	.area	_overlay
___prints_sloc0_1_0:
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
;	src/testfwk-__prints.c: 6: __div(int num, int denom)
;; genLabel
;	-----------------------------------------
;	 function __div
;	-----------------------------------------
	___div:
;	src/testfwk-__prints.c: 9: while (num >= denom)
;; genAssign
	mov	r il ,0
	mov	x il ,0
;; genLabel
L___div00101:
;; genCmp
	mov	alus il ,9	; less-than 
;	has TRUE ifx
	compare_16m_16m__t	9 ___div_PARM_1 ___div_PARM_2 L___div00103
;	src/testfwk-__prints.c: 11: q++;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack x
	mov	stack r
	add_16s_8	1
;	no need to move registers to themselves
;	src/testfwk-__prints.c: 12: num -= denom;
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
;	src/testfwk-__prints.c: 14: return q;
	mov	jmpl stack
	mov	jmph stack
	mov	stack x
	mov	stack r
	jump
;; genLabel
;	src/testfwk-__prints.c: 15: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__prints.c: 18: __mod (int num, int denom)
;; genLabel
;	-----------------------------------------
;	 function __mod
;	-----------------------------------------
	___mod:
;	src/testfwk-__prints.c: 20: while (num >= denom)
;; genLabel
L___mod00101:
;; genCmp
	mov	alus il ,9	; less-than 
;	has TRUE ifx
	compare_16m_16m__t	9 ___mod_PARM_1 ___mod_PARM_2 L___mod00103
;	src/testfwk-__prints.c: 22: num -= denom;
;; genALUOp
;;	ALU minus (16)
;;	ALU operand size 2 2 2
	sub_16m_16m	___mod_PARM_1 ___mod_PARM_2
	lad	___mod_PARM_1 + 1
	mov	mem r
	lad	___mod_PARM_1 + 0
	mov	mem x
	restore_rx
;; genGoto
	goto	L___mod00101
;; genLabel
L___mod00103:
;	src/testfwk-__prints.c: 24: return num;
	mov	jmpl stack
	mov	jmph stack
	lad	___mod_PARM_1 + 0
	mov	stack mem
	lad	___mod_PARM_1 + 1
	mov	stack mem
	jump
;; genLabel
;	src/testfwk-__prints.c: 25: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__prints.c: 28: __prints (const char *s)
;; genLabel
;	-----------------------------------------
;	 function __prints
;	-----------------------------------------
	___prints:
;	src/testfwk-__prints.c: 32: while ('\0' != (c = *s))
;; genAssign
	lad	___prints_PARM_1
	mov	stack mem
	lad	___prints_sloc0_1_0 + 0
	mov	mem stack
	lad	___prints_PARM_1 + 1
	mov	stack mem
	lad	___prints_sloc0_1_0 + 1
	mov	mem stack
;; genLabel
L___prints00101:
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          ___prints_sloc0_1_0
	load_address_from_ptr	___prints_sloc0_1_0
	mov	r mem
;; genAssign
	mov	x r
;; genIfx
	mov	alua r
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L___prints00104
;	src/testfwk-__prints.c: 34: pic = c;
;; genAssign
	mov	pic x
;	src/testfwk-__prints.c: 35: ++s;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	___prints_sloc0_1_0 + 0
	mov	stack mem
	lad	___prints_sloc0_1_0 + 1
	mov	stack mem
	add_16s_8	1
	lad	___prints_sloc0_1_0 + 0
	mov	mem x
	lad	___prints_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genGoto
	goto	L___prints00101
;; genLabel
L___prints00104:
;	src/testfwk-__prints.c: 37: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__prints.c: 39: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/testfwk-__prints.c: 40: __prints("foobar");
;; genCast
;; genAssign
	lad	___prints_PARM_1
	mov	mem il ,hi8(___str_0 + 0) ; hi
	lad	___prints_PARM_1 + 1
	mov	mem il ,lo8(___str_0 + 0) ; lo
;; genCall
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	___prints
L_main00103:
	; function returns nothing
;	src/testfwk-__prints.c: 44: __endasm;
	halt
;	src/testfwk-__prints.c: 46: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/testfwk-__prints.c: 47: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section const
___str_0:
	.ascii	"foobar"
	.byte 0x00
	.section code,"ax"
	.section initr,"a"
	.section cabs