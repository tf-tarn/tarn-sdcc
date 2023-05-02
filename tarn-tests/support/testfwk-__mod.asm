;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"testfwk___mod.c"
	
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
___mod_PARM_1:
	.ds	2
___mod_PARM_2:
	.ds	2
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
_main_sloc0_1_0:
	.ds	2
_main_sloc1_1_0:
	.ds	2
_main_sloc2_1_0:
	.ds	2
_main_sloc3_1_0:
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
;	src/testfwk-__mod.c: 4: __mod (int num, int denom)
;; genLabel
;	-----------------------------------------
;	 function __mod
;	-----------------------------------------
	___mod:
;	src/testfwk-__mod.c: 6: while (num >= denom)
;; genLabel
L___mod00101:
;; genCmp
;	begin multibyte (2) comparison
	lad	___mod_PARM_1 + 0
	mov	alua mem
	lad	___mod_PARM_2 + 0
	mov	alub mem
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,9	; less-than 
	gotonz	L___mod00115
	mov	test aluc
	goto	L___mod00116
L___mod00115:
	lad	___mod_PARM_1 + 1
	mov	alua mem
	lad	___mod_PARM_2 + 1
	mov	alub mem
	mov	test aluc
L___mod00116:
	gotonz	L___mod00103
;	src/testfwk-__mod.c: 8: num -= denom;
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
;	src/testfwk-__mod.c: 10: return num;
	mov	jmpl stack
	mov	jmph stack
	lad	___mod_PARM_1 + 0
	mov	stack mem
	lad	___mod_PARM_1 + 1
	mov	stack mem
	jump
;; genLabel
;	src/testfwk-__mod.c: 11: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__mod.c: 13: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/testfwk-__mod.c: 14: int a = __mod(18, 5);
;; genAssign
	lad	___mod_PARM_1 + 0
	mov	mem il ,0
	lad	___mod_PARM_1 + 1
	mov	mem il ,18
;; genAssign
	lad	___mod_PARM_2 + 0
	mov	mem il ,0
	lad	___mod_PARM_2 + 1
	mov	mem il ,5
;; genCall
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	___mod
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
;	src/testfwk-__mod.c: 16: pic = (a >> 8) & 0xff;
;; genGetByte      = 
;	offset = 1, 0
	mov	pic x
;	src/testfwk-__mod.c: 17: pic = a & 0xff;
;; genCast
	mov	pic r
;	src/testfwk-__mod.c: 19: a = __mod(18, 17);
;; genAssign
	lad	___mod_PARM_1 + 0
	mov	mem il ,0
	lad	___mod_PARM_1 + 1
	mov	mem il ,18
;; genAssign
	lad	___mod_PARM_2 + 0
	mov	mem il ,0
	lad	___mod_PARM_2 + 1
	mov	mem il ,17
;; genCall
	mov	stack il ,hi8(L_main00104)
	mov	stack il ,lo8(L_main00104)
	goto	___mod
L_main00104:
	lad	_main_sloc1_1_0 + 1
	mov	mem stack
	lad	_main_sloc1_1_0 + 0
	mov	mem stack
;; genAssign
	lad	_main_sloc1_1_0 + 0
	mov	x mem
	lad	_main_sloc1_1_0 + 1
	mov	r mem
;	src/testfwk-__mod.c: 20: pic = (a >> 8) & 0xff;
;; genGetByte      = 
;	offset = 1, 0
	mov	pic x
;	src/testfwk-__mod.c: 21: pic = a & 0xff;
;; genCast
	mov	pic r
;	src/testfwk-__mod.c: 23: a = __mod(0xffff, 0xfffe);
;; genAssign
	lad	___mod_PARM_1 + 0
	mov	mem il ,255
	lad	___mod_PARM_1 + 1
	mov	mem il ,255
;; genAssign
	lad	___mod_PARM_2 + 0
	mov	mem il ,255
	lad	___mod_PARM_2 + 1
	mov	mem il ,254
;; genCall
	mov	stack il ,hi8(L_main00105)
	mov	stack il ,lo8(L_main00105)
	goto	___mod
L_main00105:
	lad	_main_sloc2_1_0 + 1
	mov	mem stack
	lad	_main_sloc2_1_0 + 0
	mov	mem stack
;; genAssign
	lad	_main_sloc2_1_0 + 0
	mov	x mem
	lad	_main_sloc2_1_0 + 1
	mov	r mem
;	src/testfwk-__mod.c: 24: pic = (a >> 8) & 0xff;
;; genGetByte      = 
;	offset = 1, 0
	mov	pic x
;	src/testfwk-__mod.c: 25: pic = a & 0xff;
;; genCast
	mov	pic r
;	src/testfwk-__mod.c: 27: a = __mod(0x3241, 997);
;; genAssign
	lad	___mod_PARM_1 + 0
	mov	mem il ,50
	lad	___mod_PARM_1 + 1
	mov	mem il ,65
;; genAssign
	lad	___mod_PARM_2 + 0
	mov	mem il ,3
	lad	___mod_PARM_2 + 1
	mov	mem il ,229
;; genCall
	mov	stack il ,hi8(L_main00106)
	mov	stack il ,lo8(L_main00106)
	goto	___mod
L_main00106:
	lad	_main_sloc3_1_0 + 1
	mov	mem stack
	lad	_main_sloc3_1_0 + 0
	mov	mem stack
;; genAssign
	lad	_main_sloc3_1_0 + 0
	mov	x mem
	lad	_main_sloc3_1_0 + 1
	mov	r mem
;	src/testfwk-__mod.c: 28: pic = (a >> 8) & 0xff;
;; genGetByte      = 
;	offset = 1, 0
	mov	pic x
;	src/testfwk-__mod.c: 29: pic = a & 0xff;
;; genCast
	mov	pic r
;	src/testfwk-__mod.c: 38: __endasm;
	halt
;	src/testfwk-__mod.c: 40: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/testfwk-__mod.c: 41: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
