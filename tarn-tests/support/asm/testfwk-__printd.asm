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
___printd_sloc1_1_0:
	.ds	1
___printd_sloc2_1_0:
	.ds	2
___printd_sloc3_1_0:
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
;	src/testfwk-__printd.c: 6: __div(int num, int denom)
;; genLabel
;	-----------------------------------------
;	 function __div
;	-----------------------------------------
	___div:
;	src/testfwk-__printd.c: 9: while (num >= denom) {
;; genAssign
	mov	r il ,0
	mov	x il ,0
;; genLabel
L___div00101:
;; genCmp
	mov	alus il ,9	; less-than 
	compare_16m_16m__t	9 ___div_PARM_1 ___div_PARM_2 L___div00103
;	src/testfwk-__printd.c: 10: q++;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack x
	mov	stack r
	add_16s_8	1
;	no need to move registers to themselves
;	src/testfwk-__printd.c: 11: num -= denom;
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
;	src/testfwk-__printd.c: 13: return q;
	mov	jmpl stack
	mov	jmph stack
	mov	stack x
	mov	stack r
	jump
;; genLabel
;	src/testfwk-__printd.c: 14: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 17: __mod (int num, int denom)
;; genLabel
;	-----------------------------------------
;	 function __mod
;	-----------------------------------------
	___mod:
;	src/testfwk-__printd.c: 19: while (num >= denom) {
;; genLabel
L___mod00101:
;; genCmp
	mov	alus il ,9	; less-than 
	compare_16m_16m__t	9 ___mod_PARM_1 ___mod_PARM_2 L___mod00103
;	src/testfwk-__printd.c: 20: num -= denom;
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
;	src/testfwk-__printd.c: 22: return num;
	mov	jmpl stack
	mov	jmph stack
	lad	___mod_PARM_1 + 0
	mov	stack mem
	lad	___mod_PARM_1 + 1
	mov	stack mem
	jump
;; genLabel
;	src/testfwk-__printd.c: 23: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 26: __prints (const char *s)
;; genLabel
;	-----------------------------------------
;	 function __prints
;	-----------------------------------------
	___prints:
;	src/testfwk-__printd.c: 30: while ('\0' != (c = *s)) {
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
;	src/testfwk-__printd.c: 31: pic = c;
;; genAssign
	mov	pic x
;	src/testfwk-__printd.c: 32: ++s;
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
;	src/testfwk-__printd.c: 34: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 37: __printd (int n)
;; genLabel
;	-----------------------------------------
;	 function __printd
;	-----------------------------------------
	___printd:
;	src/testfwk-__printd.c: 39: if (0 == n) {
;; genIfx
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) comparison
	mov	alua zero
	lad	___printd_PARM_1
	mov	alub mem
	mov	test aluc
	gotonz	L___printd00139
	goto	L___printd00109
L___printd00139:
	mov	alua zero
	lad	___printd_PARM_1 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L___printd00140
	goto	L___printd00109
L___printd00140:
;	end multibyte comparison
;	src/testfwk-__printd.c: 40: pic = '0';
;; genAssign
	mov	pic il ,48
;; genGoto
	goto	L___printd00111
;; genLabel
L___printd00109:
;	src/testfwk-__printd.c: 43: char MEMSPACE_BUF *p = &buf[sizeof (buf) - 1];
;	src/testfwk-__printd.c: 44: char neg = 0;
;; genAssign
	lad	___printd_sloc1_1_0 + 0
	mov	mem zero
;	src/testfwk-__printd.c: 46: buf[sizeof(buf) - 1] = '\0';
;; genPointerSet
;; genPointerSet: operand size 2, 1
	mov	adh il ,hi8(___printd_buf_131072_13 + 5)
	mov	adl il ,lo8(___printd_buf_131072_13 + 5)
	mov	mem il ,0
;	src/testfwk-__printd.c: 48: if (0 > n) {
;; genCmp
	mov	alus il ,11	; greater-than 
	compare_16l_16m__f	11 0 ___printd_PARM_1 L___printd00116
;	src/testfwk-__printd.c: 49: n = -n;
;; genUminus
	mov	alus il ,3
	lad	___printd_PARM_1 + 0
	mov	alua mem
	mov	stack aluc
	lad	___printd_PARM_1 + 1
	mov	alua mem
	mov	stack aluc
	add_16s_8	1
	lad	___printd_PARM_1 + 1
	mov	mem r
	lad	___printd_PARM_1 + 0
	mov	mem x
	restore_rx
;	src/testfwk-__printd.c: 50: neg = 1;
;; genAssign
	lad	___printd_sloc1_1_0 + 0
	mov	mem il ,1
;	src/testfwk-__printd.c: 53: while (0 != n) {
;; genLabel
L___printd00116:
;; genAssign
	lad	___printd_sloc2_1_0 + 0
	mov	mem il ,hi8(___printd_buf_131072_13 + 5)
	lad	___printd_sloc2_1_0 + 1
	mov	mem il ,lo8(___printd_buf_131072_13 + 5)
;; genLabel
L___printd00103:
;; genIfx
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) comparison
	mov	alua zero
	lad	___printd_PARM_1
	mov	alub mem
	mov	test aluc
	gotonz	L___printd00144
	goto	L___printd00145
L___printd00144:
	mov	alua zero
	lad	___printd_PARM_1 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L___printd00118
	goto	L___printd00145
L___printd00145:
;	end multibyte comparison
;	src/testfwk-__printd.c: 54: --p;
;; genALUOp
;;	ALU minus (16)
;;	ALU operand size 2 2 1
	lad	___printd_sloc2_1_0 + 0
	mov	stack mem
	lad	___printd_sloc2_1_0 + 1
	mov	stack mem
	add_16s_16l	65535
	lad	___printd_sloc2_1_0 + 0
	mov	mem x
	lad	___printd_sloc2_1_0 + 1
	mov	mem r
	restore_rx
;	src/testfwk-__printd.c: 55: *p = '0' + __mod (n, 10);
;; genAssign
	lad	___printd_PARM_1
	mov	stack mem ; hi
	lad	___printd_PARM_1 + 1
	mov	stack mem ; lo
	lad	___mod_PARM_1 + 1
	mov	mem stack ; lo
	lad	___mod_PARM_1
	mov	mem stack ; hi
;; genAssign
	lad	___mod_PARM_2 + 0
	mov	mem il ,0
	lad	___mod_PARM_2 + 1
	mov	mem il ,10
;; genCall
	mov	stack il ,hi8(L___printd00147)
	mov	stack il ,lo8(L___printd00147)
	goto	___mod
L___printd00147:
;	result: reg? mem? remat? spilt? nregs regs label
;	        yes                     2     x,        
	mov	r stack
	mov	x stack
;; genCast
; no need to copy a register to itself
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alua r
	mov	alus il ,4	; plus 
	mov	alub il ,48
	mov	r aluc
;; genPointerSet
;; genPointerSet: operand size 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          ___printd_sloc2_1_0
	load_address_from_ptr	___printd_sloc2_1_0
	mov	mem r
;	src/testfwk-__printd.c: 56: n = __div (n, 10);
;; genAssign
	lad	___printd_PARM_1
	mov	stack mem ; hi
	lad	___printd_PARM_1 + 1
	mov	stack mem ; lo
	lad	___div_PARM_1 + 1
	mov	mem stack ; lo
	lad	___div_PARM_1
	mov	mem stack ; hi
;; genAssign
	lad	___div_PARM_2 + 0
	mov	mem il ,0
	lad	___div_PARM_2 + 1
	mov	mem il ,10
;; genCall
	mov	stack il ,hi8(L___printd00148)
	mov	stack il ,lo8(L___printd00148)
	goto	___div
L___printd00148:
	lad	___printd_sloc3_1_0 + 1
	mov	mem stack
	lad	___printd_sloc3_1_0 + 0
	mov	mem stack
;; genAssign
; aop_move debug (gen.c:1168)
;	dest operand AOP_DIR
;	  size = 2
;	  location = ___printd_PARM_1 (direct)
;	src  operand AOP_SPILL
;	  size = 2
;	  location = ___printd_sloc3_1_0+0 (immediate)
	lad	___printd_sloc3_1_0 + 0
	mov	stack mem
	lad	___printd_PARM_1 + 0
	mov	mem stack
	lad	___printd_sloc3_1_0 + 1
	mov	stack mem
	lad	___printd_PARM_1 + 1
	mov	mem stack
;; genGoto
	goto	L___printd00103
;; genLabel
L___printd00118:
;; genAssign
	lad	___printd_sloc2_1_0 + 0
	mov	x mem
	lad	___printd_sloc2_1_0 + 1
	mov	r mem
;	src/testfwk-__printd.c: 59: if (neg)
;; genIfx
;	load_reg: spilt
	lad	___printd_sloc1_1_0
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L___printd00107
;	src/testfwk-__printd.c: 60: pic = '-';
;; genAssign
	mov	pic il ,45
;; genLabel
L___printd00107:
;	src/testfwk-__printd.c: 62: __prints(p);
;; genAssign
	lad	___prints_PARM_1 + 1
	mov	mem r
	lad	___prints_PARM_1 + 0
	mov	mem x
;; genCall
	mov	stack il ,hi8(L___printd00149)
	mov	stack il ,lo8(L___printd00149)
	goto	___prints
L___printd00149:
	; function returns nothing
;; genLabel
L___printd00111:
;	src/testfwk-__printd.c: 64: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 66: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/testfwk-__printd.c: 67: __printd(0);
;; genAssign
	lad	___printd_PARM_1 + 0
	mov	mem il ,0
	lad	___printd_PARM_1 + 1
	mov	mem il ,0
;; genCall
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	___printd
L_main00103:
	; function returns nothing
;	src/testfwk-__printd.c: 68: __printd(99);
;; genAssign
	lad	___printd_PARM_1 + 0
	mov	mem il ,0
	lad	___printd_PARM_1 + 1
	mov	mem il ,99
;; genCall
	mov	stack il ,hi8(L_main00104)
	mov	stack il ,lo8(L_main00104)
	goto	___printd
L_main00104:
	; function returns nothing
;	src/testfwk-__printd.c: 69: __printd(1123);
;; genAssign
	lad	___printd_PARM_1 + 0
	mov	mem il ,4
	lad	___printd_PARM_1 + 1
	mov	mem il ,99
;; genCall
	mov	stack il ,hi8(L_main00105)
	mov	stack il ,lo8(L_main00105)
	goto	___printd
L_main00105:
	; function returns nothing
;	src/testfwk-__printd.c: 70: __printd(45678);
;; genAssign
	lad	___printd_PARM_1 + 0
	mov	mem il ,178
	lad	___printd_PARM_1 + 1
	mov	mem il ,110
;; genCall
	mov	stack il ,hi8(L_main00106)
	mov	stack il ,lo8(L_main00106)
	goto	___printd
L_main00106:
	; function returns nothing
;	src/testfwk-__printd.c: 71: __printd(9012);
;; genAssign
	lad	___printd_PARM_1 + 0
	mov	mem il ,35
	lad	___printd_PARM_1 + 1
	mov	mem il ,52
;; genCall
	mov	stack il ,hi8(L_main00107)
	mov	stack il ,lo8(L_main00107)
	goto	___printd
L_main00107:
	; function returns nothing
;	src/testfwk-__printd.c: 75: __endasm;
	halt
;	src/testfwk-__printd.c: 77: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/testfwk-__printd.c: 78: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
