;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"testfwk___printd.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	___printd
	.globl	___prints
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	___printd_PARM_1
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
___printd_PARM_1:
	.ds	2
___printd_buf_131072_13:
	.ds	6
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
;	src/testfwk-__printd.c: 6: __div(int num, int denom)
;; genLabel
;	-----------------------------------------
;	 function __div
;	-----------------------------------------
	___div:
;	src/testfwk-__printd.c: 9: while (num >= denom)
;; genAssign
	mov	r il ,0
	mov	x il ,0
;; genLabel
L___div00101:
;; genCmp
	mov	alus il ,9	; less-than 
;	has TRUE ifx
	compare_16m_16m__t	9 ___div_PARM_1 ___div_PARM_2 L___div00103
;	src/testfwk-__printd.c: 11: q++;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack x
	mov	stack r
	add_16s_8	1
;	no need to move registers to themselves
;	src/testfwk-__printd.c: 12: num -= denom;
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
;	src/testfwk-__printd.c: 14: return q;
	mov	jmpl stack
	mov	jmph stack
	mov	stack x
	mov	stack r
	jump
;; genLabel
;	src/testfwk-__printd.c: 15: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 18: __mod (int num, int denom)
;; genLabel
;	-----------------------------------------
;	 function __mod
;	-----------------------------------------
	___mod:
;	src/testfwk-__printd.c: 20: while (num >= denom)
;; genLabel
L___mod00101:
;; genCmp
	mov	alus il ,9	; less-than 
;	has TRUE ifx
	compare_16m_16m__t	9 ___mod_PARM_1 ___mod_PARM_2 L___mod00103
;	src/testfwk-__printd.c: 22: num -= denom;
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
;	src/testfwk-__printd.c: 24: return num;
	mov	jmpl stack
	mov	jmph stack
	lad	___mod_PARM_1 + 0
	mov	stack mem
	lad	___mod_PARM_1 + 1
	mov	stack mem
	jump
;; genLabel
;	src/testfwk-__printd.c: 25: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 28: __prints (const char *s)
;; genLabel
;	-----------------------------------------
;	 function __prints
;	-----------------------------------------
	___prints:
;	src/testfwk-__printd.c: 32: while ('\0' != (c = *s))
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
;	src/testfwk-__printd.c: 34: pic = c;
;; genAssign
	mov	pic x
;	src/testfwk-__printd.c: 35: ++s;
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
;	src/testfwk-__printd.c: 37: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 40: __printd (int n)
;; genLabel
;	-----------------------------------------
;	 function __printd
;	-----------------------------------------
	___printd:
;	src/testfwk-__printd.c: 42: if (0 == n)
;; genIfx
	mov	alus il ,10	; equal-to 
;	has TRUE ifx
;	begin multibyte (2) comparison
;	compare byte 0
	mov	alua zero
	lad	___printd_PARM_1
	mov	alub mem
	mov	test aluc
	gotonz	L___printd00122
	goto	L___printd00106
L___printd00122:
;	compare byte 1
	mov	alua zero
	lad	___printd_PARM_1 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L___printd00123
	goto	L___printd00106
L___printd00123:
;	end multibyte comparison
;	src/testfwk-__printd.c: 44: pic = '0';
;; genAssign
	mov	pic il ,48
;; genGoto
	goto	L___printd00108
;; genLabel
L___printd00106:
;	src/testfwk-__printd.c: 49: char MEMSPACE_BUF *p = &buf[sizeof (buf) - 1];
;	src/testfwk-__printd.c: 50: char neg = 0;
;; genAssign
	mov	r zero
;	src/testfwk-__printd.c: 52: buf[sizeof(buf) - 1] = '\0';
;; genPointerSet
;; genPointerSet: operand size 2, 1
	mov	adh il ,hi8(___printd_buf_131072_13 + 5)
	mov	adl il ,lo8(___printd_buf_131072_13 + 5)
	mov	mem il ,0
;	src/testfwk-__printd.c: 54: if (0 > n)
;; genCmp
	mov	alus il ,11	; greater-than 
;	has FALSE ifx
	compare_16l_16m__f	11 0 ___printd_PARM_1 L___printd00102
;	src/testfwk-__printd.c: 57: neg = 1;
;; genAssign
	mov	r il ,1
;; genLabel
L___printd00102:
;	src/testfwk-__printd.c: 66: if (neg)
;; genIfx
	mov	alua r
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L___printd00104
;	src/testfwk-__printd.c: 67: pic = '-';
;; genAssign
	mov	pic il ,45
;; genLabel
L___printd00104:
;	src/testfwk-__printd.c: 69: __prints(p);
;; genAssign
	lad	___prints_PARM_1
	mov	mem il ,hi8(___printd_buf_131072_13 + 5) ; hi
	lad	___prints_PARM_1 + 1
	mov	mem il ,lo8(___printd_buf_131072_13 + 5) ; lo
;; genCall
	mov	stack il ,hi8(L___printd00127)
	mov	stack il ,lo8(L___printd00127)
	goto	___prints
L___printd00127:
	; function returns nothing
;; genLabel
L___printd00108:
;	src/testfwk-__printd.c: 71: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 73: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/testfwk-__printd.c: 76: __printd(99);
;; genAssign
	lad	___printd_PARM_1 + 0
	mov	mem il ,0
	lad	___printd_PARM_1 + 1
	mov	mem il ,99
;; genCall
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	___printd
L_main00103:
	; function returns nothing
;	src/testfwk-__printd.c: 82: __endasm;
	halt
;	src/testfwk-__printd.c: 84: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/testfwk-__printd.c: 85: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
