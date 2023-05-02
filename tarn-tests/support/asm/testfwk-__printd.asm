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
	.globl	___ok
	.globl	__putchar
	.globl	___printd
	.globl	___prints
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	___ok_PARM_3
	.globl	___ok_PARM_2
	.globl	___ok_PARM_1
	.globl	__putchar_PARM_1
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
___printd_sloc2_1_0:
	.ds	1
___printd_sloc3_1_0:
	.ds	2
___printd_sloc4_1_0:
	.ds	2
___printd_sloc5_1_0:
	.ds	2
__putchar_PARM_1:
	.ds	1
___ok_PARM_1:
	.ds	2
___ok_PARM_2:
	.ds	2
___ok_PARM_3:
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
	.ds	1
___prints_sloc1_1_0:
	.ds	1
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
	mov	r zero
	mov	x zero
;; genLabel
L___div00101:
;; genCmp
;	begin multibyte (2) comparison
	lad	___div_PARM_1
	mov	alua mem
	lad	___div_PARM_2
	mov	alub mem
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,9	; less-than 
	gotonz	L___div00116
	mov	test aluc
	goto	L___div00117
L___div00116:
	lad	___div_PARM_1 + 1
	mov	alua mem
	lad	___div_PARM_2 + 1
	mov	alub mem
	mov	test aluc
L___div00117:
	gotonz	L___div00103
;	src/testfwk-__printd.c: 10: q++;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack x
	mov	stack r
	add_16s_8	1
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
;	begin multibyte (2) comparison
	lad	___mod_PARM_1
	mov	alua mem
	lad	___mod_PARM_2
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
	lad	___prints_PARM_1 + 0
	mov	x mem
	lad	___prints_PARM_1 + 1
	mov	r mem
;; genLabel
L___prints00101:
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
	mov	adl r
	mov	adh x
	mov	stack mem
	lad	___prints_sloc0_1_0 + 0
	mov	mem stack
;; genAssign
	lad	___prints_sloc0_1_0 + 0
	mov	stack mem
	lad	___prints_sloc1_1_0 + 0
	mov	mem stack
;; genIfx
;	load_reg: spilt
	lad	___prints_sloc0_1_0
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L___prints00104
;	src/testfwk-__printd.c: 31: pic = c;
;; genAssign
	lad	___prints_sloc1_1_0 + 0
	mov	pic mem
;	src/testfwk-__printd.c: 32: ++s;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack x
	mov	stack r
	add_16s_8	1
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
;	begin multibyte (2) comparison
	lad	___printd_PARM_1
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,10	; equal-to 
	gotonz	L___printd00140
	mov	test aluc
	goto	L___printd00141
L___printd00140:
	lad	___printd_PARM_1 + 1
	mov	alua mem
	mov	alub zero
	mov	test aluc
L___printd00141:
	gotonz	L___printd00139
	goto	L___printd00109
L___printd00139:
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
	lad	___printd_sloc2_1_0 + 0
	mov	mem zero
;	src/testfwk-__printd.c: 46: buf[sizeof(buf) - 1] = '\0';
;; genPointerSet
;; genPointerSet: operand size 2, 1
	mov	adh il ,hi8(___printd_buf_131072_13 + 5)
	mov	adl il ,lo8(___printd_buf_131072_13 + 5)
	mov	mem il ,0
;	src/testfwk-__printd.c: 48: if (0 > n) {
;; genCmp
;	begin multibyte (2) comparison
	mov	alua zero
	lad	___printd_PARM_1
	mov	alub mem
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,11	; greater-than 
	gotonz	L___printd00143
	mov	test aluc
	goto	L___printd00144
L___printd00143:
	mov	alua zero
	lad	___printd_PARM_1 + 1
	mov	alub mem
	mov	test aluc
L___printd00144:
	gotonz	L___printd00142
	goto	L___printd00116
L___printd00142:
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
	lad	___printd_sloc2_1_0 + 0
	mov	mem il ,1
;	src/testfwk-__printd.c: 53: while (0 != n) {
;; genLabel
L___printd00116:
;; genAssign
	lad	___printd_sloc3_1_0 + 0
	mov	mem il ,hi8(___printd_buf_131072_13 + 5)
	lad	___printd_sloc3_1_0 + 1
	mov	mem il ,lo8(___printd_buf_131072_13 + 5)
;; genLabel
L___printd00103:
;; genIfx
;	begin multibyte (2) comparison
	lad	___printd_PARM_1
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,10	; equal-to 
	gotonz	L___printd00146
	mov	test aluc
	goto	L___printd00147
L___printd00146:
	lad	___printd_PARM_1 + 1
	mov	alua mem
	mov	alub zero
	mov	test aluc
L___printd00147:
	gotonz	L___printd00118
;	src/testfwk-__printd.c: 55: *--p = '0' + __mod (n, 10);
;; genALUOp
;;	ALU minus (16)
;;	ALU operand size 2 2 1
	lad	___printd_sloc3_1_0 + 0
	mov	stack mem
	lad	___printd_sloc3_1_0 + 1
	mov	stack mem
	add_16s_16l	65535
	lad	___printd_sloc3_1_0 + 0
	mov	mem x
	lad	___printd_sloc3_1_0 + 1
	mov	mem r
	restore_rx
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
	mov	stack il ,hi8(L___printd00148)
	mov	stack il ,lo8(L___printd00148)
	goto	___mod
L___printd00148:
	lad	___printd_sloc4_1_0 + 1
	mov	mem stack
	lad	___printd_sloc4_1_0 + 0
	mov	mem stack
;; genCast
	lad	___printd_sloc4_1_0 + 1
	mov	r mem
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
;	           yes         yes    2          ___printd_sloc3_1_0
	load_address_from_ptr	___printd_sloc3_1_0
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
	mov	stack il ,hi8(L___printd00149)
	mov	stack il ,lo8(L___printd00149)
	goto	___div
L___printd00149:
	lad	___printd_sloc5_1_0 + 1
	mov	mem stack
	lad	___printd_sloc5_1_0 + 0
	mov	mem stack
;; genAssign
	lad	___printd_sloc5_1_0 + 0
	mov	stack mem
	lad	___printd_PARM_1 + 0
	mov	mem stack
	lad	___printd_sloc5_1_0 + 1
	mov	stack mem
	lad	___printd_PARM_1 + 1
	mov	mem stack
;; genGoto
	goto	L___printd00103
;; genLabel
L___printd00118:
;; genAssign
	lad	___printd_sloc3_1_0 + 0
	mov	x mem
	lad	___printd_sloc3_1_0 + 1
	mov	r mem
;	src/testfwk-__printd.c: 59: if (neg)
;; genIfx
;	load_reg: spilt
	lad	___printd_sloc2_1_0
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
	mov	stack il ,hi8(L___printd00150)
	mov	stack il ,lo8(L___printd00150)
	goto	___prints
L___printd00150:
	; function returns nothing
;; genLabel
L___printd00111:
;	src/testfwk-__printd.c: 64: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 66: _putchar(char c) {
;; genLabel
;	-----------------------------------------
;	 function _putchar
;	-----------------------------------------
	__putchar:
;	src/testfwk-__printd.c: 67: pic = c;
;; genAssign
	lad	__putchar_PARM_1 + 0
	mov	pic mem
;; genLabel
;	src/testfwk-__printd.c: 68: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 70: void __ok (__code const char *szCond, __code const char *szFile, int line)
;; genLabel
;	-----------------------------------------
;	 function __ok
;	-----------------------------------------
	___ok:
;	src/testfwk-__printd.c: 72: __prints("--- OK: \"");
;; genCast
	lad	___prints_PARM_1
	mov	mem il ,hi8(___str_0 + 0) ; hi
	lad	___prints_PARM_1 + 1
	mov	mem il ,lo8(___str_0 + 0) ; lo
;; genCall
	mov	stack il ,hi8(L___ok00103)
	mov	stack il ,lo8(L___ok00103)
	goto	___prints
L___ok00103:
	; function returns nothing
;	src/testfwk-__printd.c: 73: __prints(szCond);
;; genCast
	lad	___ok_PARM_1
	mov	stack mem ; hi
	lad	___ok_PARM_1 + 1
	mov	stack mem ; lo
	lad	___prints_PARM_1 + 1
	mov	mem stack ; lo
	lad	___prints_PARM_1
	mov	mem stack ; hi
;; genCall
	mov	stack il ,hi8(L___ok00104)
	mov	stack il ,lo8(L___ok00104)
	goto	___prints
L___ok00104:
	; function returns nothing
;	src/testfwk-__printd.c: 74: __prints(" at ");
;; genCast
	lad	___prints_PARM_1
	mov	mem il ,hi8(___str_1 + 0) ; hi
	lad	___prints_PARM_1 + 1
	mov	mem il ,lo8(___str_1 + 0) ; lo
;; genCall
	mov	stack il ,hi8(L___ok00105)
	mov	stack il ,lo8(L___ok00105)
	goto	___prints
L___ok00105:
	; function returns nothing
;	src/testfwk-__printd.c: 75: __prints(szFile);
;; genCast
	lad	___ok_PARM_2
	mov	stack mem ; hi
	lad	___ok_PARM_2 + 1
	mov	stack mem ; lo
	lad	___prints_PARM_1 + 1
	mov	mem stack ; lo
	lad	___prints_PARM_1
	mov	mem stack ; hi
;; genCall
	mov	stack il ,hi8(L___ok00106)
	mov	stack il ,lo8(L___ok00106)
	goto	___prints
L___ok00106:
	; function returns nothing
;	src/testfwk-__printd.c: 76: _putchar(':');
;; genAssign
	lad	__putchar_PARM_1 + 0
	mov	mem il ,58
;; genCall
	mov	stack il ,hi8(L___ok00107)
	mov	stack il ,lo8(L___ok00107)
	goto	__putchar
L___ok00107:
	; function returns nothing
;	src/testfwk-__printd.c: 77: __printd(line);
;; genAssign
	lad	___ok_PARM_3
	mov	stack mem ; hi
	lad	___ok_PARM_3 + 1
	mov	stack mem ; lo
	lad	___printd_PARM_1 + 1
	mov	mem stack ; lo
	lad	___printd_PARM_1
	mov	mem stack ; hi
;; genCall
	mov	stack il ,hi8(L___ok00108)
	mov	stack il ,lo8(L___ok00108)
	goto	___printd
L___ok00108:
	; function returns nothing
;	src/testfwk-__printd.c: 78: _putchar('\n');
;; genAssign
	lad	__putchar_PARM_1 + 0
	mov	mem il ,10
;; genCall
	mov	stack il ,hi8(L___ok00109)
	mov	stack il ,lo8(L___ok00109)
	goto	__putchar
L___ok00109:
	; function returns nothing
;; genLabel
;	src/testfwk-__printd.c: 79: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/testfwk-__printd.c: 81: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/testfwk-__printd.c: 82: __printd(0);
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
;	src/testfwk-__printd.c: 83: __printd(99);
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
;	src/testfwk-__printd.c: 84: __printd(1123);
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
;	src/testfwk-__printd.c: 85: __printd(45678);
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
;	src/testfwk-__printd.c: 86: __printd(9012);
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
;	src/testfwk-__printd.c: 88: __ok("condition", "<filename>", 99);
;; genAddrOf
;; genAddrOf: operand size 2, 10, 1
	lad	___ok_PARM_1
	mov	mem il ,hi8(___str_2 + 0)
	lad	___ok_PARM_1 + 1
	mov	mem il ,lo8(___str_2 + 0)
;; genAddrOf
;; genAddrOf: operand size 2, 11, 1
	lad	___ok_PARM_2
	mov	mem il ,hi8(___str_3 + 0)
	lad	___ok_PARM_2 + 1
	mov	mem il ,lo8(___str_3 + 0)
;; genAssign
	lad	___ok_PARM_3 + 0
	mov	mem il ,0
	lad	___ok_PARM_3 + 1
	mov	mem il ,99
;; genCall
	mov	stack il ,hi8(L_main00108)
	mov	stack il ,lo8(L_main00108)
	goto	___ok
L_main00108:
	; function returns nothing
;	src/testfwk-__printd.c: 92: __endasm;
	halt
;	src/testfwk-__printd.c: 94: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/testfwk-__printd.c: 95: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section const
___str_0:
	.ascii	"--- OK: "
	.byte 0x22
	.byte 0x00
	.section code,"ax"
	.section const
___str_1:
	.ascii	" at "
	.byte 0x00
	.section code,"ax"
	.section const
___str_2:
	.ascii	"condition"
	.byte 0x00
	.section code,"ax"
	.section const
___str_3:
	.ascii	"<filename>"
	.byte 0x00
	.section code,"ax"
	.section initr,"a"
	.section cabs
