;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"ifelse.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_litbitint
	.globl	_test_int
	.globl	_test_char
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_litbitint_PARM_1
	.globl	_test_int_PARM_1
	.globl	_test_char_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_test_char_PARM_1:
	.ds	1
_test_int_PARM_1:
	.ds	2
_litbitint_PARM_1:
	.ds	2
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
_main_a_65536_14:
	.ds	1
_main_n_65536_14:
	.ds	2
_main_sloc0_1_0:
	.ds	2
_main_sloc1_1_0:
	.ds	2
_main_sloc2_1_0:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd,"a"
;--------------------------------------------------------
; overlayable items in ram
;--------------------------------------------------------
	.area	_overlay
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
;	src/ifelse.c: 3: char test_char(char a) {
;; genLabel
;	-----------------------------------------
;	 function test_char
;	-----------------------------------------
	_test_char:
;	src/ifelse.c: 4: if (a == 0) {
;; genIfx
	lad	_test_char_PARM_1
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_test_char00121
	goto	L_test_char00102
L_test_char00121:
;	src/ifelse.c: 5: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
L_test_char00102:
;	src/ifelse.c: 8: if (a == 1) {
;; genCmpEQorNE
	;; compare
	mov	alus il ,10	; equal-to 
;	begin single-byte comparison
	lad	_test_char_PARM_1 + 0
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
;	end single-byte comparison
;; genIfx
	gotonz	L_test_char00122
	goto	L_test_char00104
L_test_char00122:
;	src/ifelse.c: 9: return 7;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,7
	jump
;; genLabel
L_test_char00104:
;	src/ifelse.c: 12: if (a == 0) {
;; genIfx
	lad	_test_char_PARM_1
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_test_char00123
	goto	L_test_char00106
L_test_char00123:
;	src/ifelse.c: 13: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
L_test_char00106:
;	src/ifelse.c: 16: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
;	src/ifelse.c: 17: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/ifelse.c: 19: char test_int(int n) {
;; genLabel
;	-----------------------------------------
;	 function test_int
;	-----------------------------------------
	_test_int:
;	src/ifelse.c: 20: if (n == 0) {
;; genIfx
	;; compare
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
;	compare byte 0
	mov	alua zero
	lad	_test_int_PARM_1 + 0
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to next comparison
	gotonz	L_test_int00121
;	Otherwise, skip all remaining comparisons and go to the end
	goto	L_test_int00122
;	emit next comparison label L_test_int00121
L_test_int00121:
;	next next comparison label is L_test_int00123
;	compare byte 1
	mov	alua zero
	lad	_test_int_PARM_1 + 1
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to end of comparison sequence and fall through
	gotonz	L_test_int00122
;	Otherwise jump to true branch.
	goto	L_test_int00102
;	emit end of comparison sequence label
L_test_int00122:
;	end multibyte equality check
;	src/ifelse.c: 21: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
L_test_int00102:
;	src/ifelse.c: 24: if (n == 1) {
;; genCmpEQorNE
	;; compare
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
;	compare byte 0
	mov	alua zero
	lad	_test_int_PARM_1 + 0
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to next comparison
	gotonz	L_test_int00124
;	Otherwise, skip all remaining comparisons and go to the end
	goto	L_test_int00125
;	emit next comparison label L_test_int00124
L_test_int00124:
;	next next comparison label is L_test_int00126
;	compare byte 1
	mov	alua il ,1
	lad	_test_int_PARM_1 + 1
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to end of comparison sequence and fall through.
	gotonz	L_test_int00125
;	Otherwise jump to the false branch.
	goto	L_test_int00104
;	emit end of comparison sequence label
L_test_int00125:
;	end multibyte equality check
;	src/ifelse.c: 25: return 8;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,8
	jump
;; genLabel
L_test_int00104:
;	src/ifelse.c: 28: if (n == 0) {
;; genIfx
	;; compare
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
;	compare byte 0
	mov	alua zero
	lad	_test_int_PARM_1 + 0
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to next comparison
	gotonz	L_test_int00127
;	Otherwise, skip all remaining comparisons and go to the end
	goto	L_test_int00128
;	emit next comparison label L_test_int00127
L_test_int00127:
;	next next comparison label is L_test_int00129
;	compare byte 1
	mov	alua zero
	lad	_test_int_PARM_1 + 1
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to end of comparison sequence and fall through
	gotonz	L_test_int00128
;	Otherwise jump to true branch.
	goto	L_test_int00106
;	emit end of comparison sequence label
L_test_int00128:
;	end multibyte equality check
;	src/ifelse.c: 29: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
L_test_int00106:
;	src/ifelse.c: 32: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
;	src/ifelse.c: 33: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/ifelse.c: 35: int litbitint (unsigned int a)
;; genLabel
;	-----------------------------------------
;	 function litbitint
;	-----------------------------------------
	_litbitint:
;	src/ifelse.c: 37: register unsigned int b = a + 1; /* Suggest allocating b to accumulator */
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 2
	add_16m_16l	_litbitint_PARM_1 1
;	src/ifelse.c: 39: if (b & 0x0001)
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 2 2 2
	mov	stack r
	mov	stack x
	add_16s_16l	1
	;; compare
;	has TRUE and FALSE branch
	mov	alus il ,10	; equal-to 
;	begin single-byte comparison
	mov	alua zero
	mov	alua r
	mov	test aluc
;	end single-byte comparison
;	set true
	mov	test il ,0
	goto	L_litbitint00124
;	set false
	mov	test il ,1
;	restore r,x
L_litbitint00124:
	restore_rx
	gotonz	L_litbitint00108
;	src/ifelse.c: 40: return(0);
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
L_litbitint00108:
;	src/ifelse.c: 41: else if (b & 0x0004)
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 2 2 2
	mov	stack r
	mov	stack x
	add_16s_16l	4
	;; compare
;	has TRUE and FALSE branch
	mov	alus il ,10	; equal-to 
;	begin single-byte comparison
	mov	alua zero
	mov	alua r
	mov	test aluc
;	end single-byte comparison
;	set true
	mov	test il ,0
	goto	L_litbitint00127
;	set false
	mov	test il ,1
;	restore r,x
L_litbitint00127:
	restore_rx
	gotonz	L_litbitint00105
;	src/ifelse.c: 42: return(1);
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,1
	mov	stack il ,0
	jump
;; genLabel
L_litbitint00105:
;	src/ifelse.c: 43: else if (b & 0x2010)
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 2 2 2
	mov	stack r
	mov	stack x
	add_16s_16l	8208
;; genIfx
	;; compare
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
;	compare byte 0
	mov	alua zero
	mov	alub x
	mov	test aluc
;	If comparison is true, jump to next comparison
	gotonz	L_litbitint00130
;	Otherwise, skip all remaining comparisons and go to the end
	goto	L_litbitint00131
;	emit next comparison label L_litbitint00130
L_litbitint00130:
;	next next comparison label is L_litbitint00132
;	compare byte 1
	mov	alua zero
	mov	alub r
	mov	test aluc
;	If comparison is true, skip statement body.
	gotonz	L_litbitint00102
;	Otherwise fall through.
;	emit end of comparison sequence label
L_litbitint00131:
;	end multibyte equality check
;	src/ifelse.c: 44: return(2);
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,2
	mov	stack il ,0
	jump
;; genLabel
L_litbitint00102:
;	src/ifelse.c: 46: return(3);
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,3
	mov	stack il ,0
	jump
;; genLabel
;	src/ifelse.c: 47: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/ifelse.c: 49: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/ifelse.c: 50: volatile unsigned char a = 1;
;; genAssign
	lad	_main_a_65536_14 + 0
	mov	mem il ,1
;	src/ifelse.c: 51: volatile unsigned int n = 1;
;; genAssign
	lad	_main_n_65536_14 + 0
	mov	mem il ,0
	lad	_main_n_65536_14 + 1
	mov	mem il ,1
;	src/ifelse.c: 53: if (a == 1) {
;; genCmpEQorNE
	;; compare
	mov	alus il ,10	; equal-to 
;	begin single-byte comparison
	lad	_main_a_65536_14 + 0
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
;	end single-byte comparison
;; genIfx
	gotonz	L_main00159
	goto	L_main00102
L_main00159:
;	src/ifelse.c: 54: pic = 1;
;; genAssign
	mov	pic il ,1
;; genGoto
	goto	L_main00103
;; genLabel
L_main00102:
;	src/ifelse.c: 56: pic = 0;
;; genAssign
	mov	pic il ,0
;; genLabel
L_main00103:
;	src/ifelse.c: 59: if (a == 0) {
;; genIfx
	lad	_main_a_65536_14
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00160
	goto	L_main00105
L_main00160:
;	src/ifelse.c: 60: pic = 0;
;; genAssign
	mov	pic il ,0
;; genGoto
	goto	L_main00106
;; genLabel
L_main00105:
;	src/ifelse.c: 62: pic = 2;
;; genAssign
	mov	pic il ,2
;; genLabel
L_main00106:
;	src/ifelse.c: 65: if (n == 1) {
;; genCmpEQorNE
	;; compare
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
;	compare byte 0
	mov	alua zero
	lad	_main_n_65536_14 + 0
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to next comparison
	gotonz	L_main00161
;	Otherwise, skip all remaining comparisons and go to the end
	goto	L_main00162
;	emit next comparison label L_main00161
L_main00161:
;	next next comparison label is L_main00163
;	compare byte 1
	mov	alua il ,1
	lad	_main_n_65536_14 + 1
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to end of comparison sequence and fall through.
	gotonz	L_main00162
;	Otherwise jump to the false branch.
	goto	L_main00108
;	emit end of comparison sequence label
L_main00162:
;	end multibyte equality check
;	src/ifelse.c: 66: pic = 3;
;; genAssign
	mov	pic il ,3
;; genGoto
	goto	L_main00109
;; genLabel
L_main00108:
;	src/ifelse.c: 68: pic = 0;
;; genAssign
	mov	pic il ,0
;; genLabel
L_main00109:
;	src/ifelse.c: 71: if (n == 0) {
;; genIfx
	;; compare
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
;	compare byte 0
	mov	alua zero
	lad	_main_n_65536_14 + 0
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to next comparison
	gotonz	L_main00164
;	Otherwise, skip all remaining comparisons and go to the end
	goto	L_main00165
;	emit next comparison label L_main00164
L_main00164:
;	next next comparison label is L_main00166
;	compare byte 1
	mov	alua zero
	lad	_main_n_65536_14 + 1
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to end of comparison sequence and fall through
	gotonz	L_main00165
;	Otherwise jump to true branch.
	goto	L_main00111
;	emit end of comparison sequence label
L_main00165:
;	end multibyte equality check
;	src/ifelse.c: 72: pic = 0;
;; genAssign
	mov	pic il ,0
;; genGoto
	goto	L_main00112
;; genLabel
L_main00111:
;	src/ifelse.c: 74: pic = 4;
;; genAssign
	mov	pic il ,4
;; genLabel
L_main00112:
;	src/ifelse.c: 77: if (a == 0) {
;; genIfx
	lad	_main_a_65536_14
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00167
	goto	L_main00117
L_main00167:
;	src/ifelse.c: 78: pic = 0;
;; genAssign
	mov	pic il ,0
;; genGoto
	goto	L_main00118
;; genLabel
L_main00117:
;	src/ifelse.c: 79: } else if (a == 1) {
;; genCmpEQorNE
	;; compare
	mov	alus il ,10	; equal-to 
;	begin single-byte comparison
	lad	_main_a_65536_14 + 0
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
;	end single-byte comparison
;; genIfx
	gotonz	L_main00168
	goto	L_main00114
L_main00168:
;	src/ifelse.c: 80: pic = 5;
;; genAssign
	mov	pic il ,5
;; genGoto
	goto	L_main00118
;; genLabel
L_main00114:
;	src/ifelse.c: 82: pic = 0;
;; genAssign
	mov	pic il ,0
;; genLabel
L_main00118:
;	src/ifelse.c: 85: if (n == 0) {
;; genIfx
	;; compare
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
;	compare byte 0
	mov	alua zero
	lad	_main_n_65536_14 + 0
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to next comparison
	gotonz	L_main00169
;	Otherwise, skip all remaining comparisons and go to the end
	goto	L_main00170
;	emit next comparison label L_main00169
L_main00169:
;	next next comparison label is L_main00171
;	compare byte 1
	mov	alua zero
	lad	_main_n_65536_14 + 1
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to end of comparison sequence and fall through
	gotonz	L_main00170
;	Otherwise jump to true branch.
	goto	L_main00123
;	emit end of comparison sequence label
L_main00170:
;	end multibyte equality check
;	src/ifelse.c: 86: pic = 0;
;; genAssign
	mov	pic il ,0
;; genGoto
	goto	L_main00124
;; genLabel
L_main00123:
;	src/ifelse.c: 87: } else if (n == 1) {
;; genCmpEQorNE
	;; compare
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
;	compare byte 0
	mov	alua zero
	lad	_main_n_65536_14 + 0
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to next comparison
	gotonz	L_main00172
;	Otherwise, skip all remaining comparisons and go to the end
	goto	L_main00173
;	emit next comparison label L_main00172
L_main00172:
;	next next comparison label is L_main00174
;	compare byte 1
	mov	alua il ,1
	lad	_main_n_65536_14 + 1
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to end of comparison sequence and fall through.
	gotonz	L_main00173
;	Otherwise jump to the false branch.
	goto	L_main00120
;	emit end of comparison sequence label
L_main00173:
;	end multibyte equality check
;	src/ifelse.c: 88: pic = 6;
;; genAssign
	mov	pic il ,6
;; genGoto
	goto	L_main00124
;; genLabel
L_main00120:
;	src/ifelse.c: 90: pic = 0;
;; genAssign
	mov	pic il ,0
;; genLabel
L_main00124:
;	src/ifelse.c: 93: pic = test_char(a);
;; genAssign
	lad	_main_a_65536_14
	mov	stack mem
	lad	_test_char_PARM_1
	mov	mem stack
;; genCall
	mov	stack il ,hi8(L_main00175)
	mov	stack il ,lo8(L_main00175)
	goto	_test_char
L_main00175:
	mov	r stack
;; genAssign
	mov	pic r
;	src/ifelse.c: 94: pic = test_int(a);
;; genCast
	lad	_main_a_65536_14 + 0
	mov	stack mem
	lad	_test_int_PARM_1 + 1
	mov	mem stack
	lad	_test_int_PARM_1 + 0
	mov	mem zero
;; genCall
	mov	stack il ,hi8(L_main00176)
	mov	stack il ,lo8(L_main00176)
	goto	_test_int
L_main00176:
	mov	r stack
;; genAssign
	mov	pic r
;	src/ifelse.c: 96: pic = 0xff;
;; genAssign
	mov	pic il ,255
;	src/ifelse.c: 98: int x = litbitint (0x0001u - 1);
;; genAssign
	lad	_litbitint_PARM_1 + 0
	mov	mem il ,0
	lad	_litbitint_PARM_1 + 1
	mov	mem il ,0
;; genCall
	mov	stack il ,hi8(L_main00177)
	mov	stack il ,lo8(L_main00177)
	goto	_litbitint
L_main00177:
	; function returns nothing
;	src/ifelse.c: 99: int y = litbitint (0x8fe8u - 1);
;; genAssign
	lad	_litbitint_PARM_1 + 0
	mov	mem il ,143
	lad	_litbitint_PARM_1 + 1
	mov	mem il ,231
;; genCall
	mov	stack il ,hi8(L_main00178)
	mov	stack il ,lo8(L_main00178)
	goto	_litbitint
L_main00178:
	lad	_main_sloc0_1_0 + 1
	mov	mem stack
	lad	_main_sloc0_1_0 + 0
	mov	mem stack
;; genAssign
	lad	_main_sloc0_1_0 + 0
	mov	stack mem
	lad	_main_sloc1_1_0 + 0
	mov	mem stack
	lad	_main_sloc0_1_0 + 1
	mov	stack mem
	lad	_main_sloc1_1_0 + 1
	mov	mem stack
;	src/ifelse.c: 100: int z = litbitint (0x3030u - 1);
;; genAssign
	lad	_litbitint_PARM_1 + 0
	mov	mem il ,48
	lad	_litbitint_PARM_1 + 1
	mov	mem il ,47
;; genCall
	mov	stack il ,hi8(L_main00179)
	mov	stack il ,lo8(L_main00179)
	goto	_litbitint
L_main00179:
	; function returns nothing
;	src/ifelse.c: 104: pic = y >> 8;
;; genGetByte      = 
;	offset = 1, 0
	lad	_main_sloc1_1_0 + 1
	mov	pic mem
;	src/ifelse.c: 105: pic = y;
;; genCast
	lad	_main_sloc1_1_0 + 1
	mov	pic mem
;	src/ifelse.c: 109: pic = 0xff;
;; genAssign
	mov	pic il ,255
;	src/ifelse.c: 112: pic = (litbitint (0x8fe8u - 1) == 3);
;; genAssign
	lad	_litbitint_PARM_1 + 0
	mov	mem il ,143
	lad	_litbitint_PARM_1 + 1
	mov	mem il ,231
;; genCall
	mov	stack il ,hi8(L_main00180)
	mov	stack il ,lo8(L_main00180)
	goto	_litbitint
L_main00180:
	lad	_main_sloc2_1_0 + 1
	mov	mem stack
	lad	_main_sloc2_1_0 + 0
	mov	mem stack
;; genCmpEQorNE
	;; compare
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
;	compare byte 0
	mov	alua zero
	lad	_main_sloc2_1_0 + 0
	mov	alub mem
	mov	test aluc
;	If comparison is true, jump to next comparison
	gotonz	L_main00181
;	Otherwise, skip all remaining comparisons and go to the end
	goto	L_main00182
;	emit next comparison label L_main00181
L_main00181:
;	next next comparison label is L_main00183
;	compare byte 1
	mov	alua il ,3
	lad	_main_sloc2_1_0 + 1
	mov	alub mem
	mov	test aluc
;	Jump to the end so we can store the result.
	goto	L_main00182
;	emit end of comparison sequence label
L_main00182:
	mov	pic aluc
;	end multibyte equality check
;	src/ifelse.c: 116: pic = 0xff;
;; genAssign
	mov	pic il ,255
;	src/ifelse.c: 120: __endasm;
	halt
;; genLabel
;	src/ifelse.c: 122: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
