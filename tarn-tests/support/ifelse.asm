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
	.globl	_test_int
	.globl	_test_char
	.globl	_main_PARM_2
	.globl	_main_PARM_1
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
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
_main_a_65536_12:
	.ds	1
_main_n_65536_12:
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
	mov	alus il ,10	; equal-to 
	lad	_test_char_PARM_1 + 0
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
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
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_test_int_PARM_1 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_test_int00121
	goto	L_test_int00122
L_test_int00121:
	mov	alua zero
	lad	_test_int_PARM_1 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_test_int00122
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
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_test_int_PARM_1 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_test_int00124
	goto	L_test_int00125
L_test_int00124:
	mov	alua il ,1
	lad	_test_int_PARM_1 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_test_int00125
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
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_test_int_PARM_1 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_test_int00127
	goto	L_test_int00128
L_test_int00127:
	mov	alua zero
	lad	_test_int_PARM_1 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_test_int00128
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
;	src/ifelse.c: 35: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/ifelse.c: 36: volatile unsigned char a = 1;
;; genAssign
	lad	_main_a_65536_12 + 0
	mov	mem il ,1
;	src/ifelse.c: 37: volatile unsigned int n = 1;
;; genAssign
	lad	_main_n_65536_12 + 0
	mov	mem il ,0
	lad	_main_n_65536_12 + 1
	mov	mem il ,1
;	src/ifelse.c: 39: if (a == 1) {
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	lad	_main_a_65536_12 + 0
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
;; genIfx
	gotonz	L_main00159
	goto	L_main00102
L_main00159:
;	src/ifelse.c: 40: pic = 1;
;; genAssign
	mov	pic il ,1
;; genGoto
	goto	L_main00103
;; genLabel
L_main00102:
;	src/ifelse.c: 42: pic = 0;
;; genAssign
	mov	pic il ,0
;; genLabel
L_main00103:
;	src/ifelse.c: 45: if (a == 0) {
;; genIfx
	lad	_main_a_65536_12
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00160
	goto	L_main00105
L_main00160:
;	src/ifelse.c: 46: pic = 0;
;; genAssign
	mov	pic il ,0
;; genGoto
	goto	L_main00106
;; genLabel
L_main00105:
;	src/ifelse.c: 48: pic = 2;
;; genAssign
	mov	pic il ,2
;; genLabel
L_main00106:
;	src/ifelse.c: 51: if (n == 1) {
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_main_n_65536_12 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_main00161
	goto	L_main00162
L_main00161:
	mov	alua il ,1
	lad	_main_n_65536_12 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_main00162
	goto	L_main00108
;	emit end of comparison sequence label
L_main00162:
;	end multibyte equality check
;	src/ifelse.c: 52: pic = 3;
;; genAssign
	mov	pic il ,3
;; genGoto
	goto	L_main00109
;; genLabel
L_main00108:
;	src/ifelse.c: 54: pic = 0;
;; genAssign
	mov	pic il ,0
;; genLabel
L_main00109:
;	src/ifelse.c: 57: if (n == 0) {
;; genIfx
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_main_n_65536_12 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_main00164
	goto	L_main00165
L_main00164:
	mov	alua zero
	lad	_main_n_65536_12 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_main00165
	goto	L_main00111
;	emit end of comparison sequence label
L_main00165:
;	end multibyte equality check
;	src/ifelse.c: 58: pic = 0;
;; genAssign
	mov	pic il ,0
;; genGoto
	goto	L_main00112
;; genLabel
L_main00111:
;	src/ifelse.c: 60: pic = 4;
;; genAssign
	mov	pic il ,4
;; genLabel
L_main00112:
;	src/ifelse.c: 63: if (a == 0) {
;; genIfx
	lad	_main_a_65536_12
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00167
	goto	L_main00117
L_main00167:
;	src/ifelse.c: 64: pic = 0;
;; genAssign
	mov	pic il ,0
;; genGoto
	goto	L_main00118
;; genLabel
L_main00117:
;	src/ifelse.c: 65: } else if (a == 1) {
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	lad	_main_a_65536_12 + 0
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
;; genIfx
	gotonz	L_main00168
	goto	L_main00114
L_main00168:
;	src/ifelse.c: 66: pic = 5;
;; genAssign
	mov	pic il ,5
;; genGoto
	goto	L_main00118
;; genLabel
L_main00114:
;	src/ifelse.c: 68: pic = 0;
;; genAssign
	mov	pic il ,0
;; genLabel
L_main00118:
;	src/ifelse.c: 71: if (n == 0) {
;; genIfx
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_main_n_65536_12 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_main00169
	goto	L_main00170
L_main00169:
	mov	alua zero
	lad	_main_n_65536_12 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_main00170
	goto	L_main00123
;	emit end of comparison sequence label
L_main00170:
;	end multibyte equality check
;	src/ifelse.c: 72: pic = 0;
;; genAssign
	mov	pic il ,0
;; genGoto
	goto	L_main00124
;; genLabel
L_main00123:
;	src/ifelse.c: 73: } else if (n == 1) {
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_main_n_65536_12 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_main00172
	goto	L_main00173
L_main00172:
	mov	alua il ,1
	lad	_main_n_65536_12 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_main00173
	goto	L_main00120
;	emit end of comparison sequence label
L_main00173:
;	end multibyte equality check
;	src/ifelse.c: 74: pic = 6;
;; genAssign
	mov	pic il ,6
;; genGoto
	goto	L_main00124
;; genLabel
L_main00120:
;	src/ifelse.c: 76: pic = 0;
;; genAssign
	mov	pic il ,0
;; genLabel
L_main00124:
;	src/ifelse.c: 79: pic = test_char(a);
;; genAssign
	lad	_main_a_65536_12
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
;	src/ifelse.c: 80: pic = test_int(a);
;; genCast
	lad	_main_a_65536_12 + 0
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
;	src/ifelse.c: 82: pic = 0xff;
;; genAssign
	mov	pic il ,255
;	src/ifelse.c: 86: __endasm;
	halt
;; genLabel
;	src/ifelse.c: 88: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
