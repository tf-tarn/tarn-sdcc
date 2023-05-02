;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"comparison.c"
	
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
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
_main_a_65536_2:
	.ds	1
_main_n_65536_2:
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
;	src/comparison.c: 3: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/comparison.c: 4: volatile unsigned char a = 1;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,1
;	src/comparison.c: 5: volatile unsigned int n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;	src/comparison.c: 7: pic = '1';
;; genAssign
	mov	pic il ,49
;	src/comparison.c: 8: while (a != 0) {
;; genLabel
L_main00101:
;; genIfx
	lad	_main_a_65536_2
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00103
;	src/comparison.c: 9: pic = '2';
;; genAssign
	mov	pic il ,50
;	src/comparison.c: 10: a = 0;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,0
;; genGoto
	goto	L_main00101
;; genLabel
L_main00103:
;	src/comparison.c: 13: pic = '3';
;; genAssign
	mov	pic il ,51
;	src/comparison.c: 14: while (a == 0) {
;; genLabel
L_main00104:
;; genIfx
	lad	_main_a_65536_2
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00235
	goto	L_main00106
L_main00235:
;	src/comparison.c: 15: pic = '4';
;; genAssign
	mov	pic il ,52
;	src/comparison.c: 16: a = 1;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,1
;; genGoto
	goto	L_main00104
;; genLabel
L_main00106:
;	src/comparison.c: 19: pic = '5';
;; genAssign
	mov	pic il ,53
;	src/comparison.c: 20: while (n != 0) {
;; genLabel
L_main00107:
;; genIfx
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_main_n_65536_2 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_main00236
	goto	L_main00237
L_main00236:
	mov	alua zero
	lad	_main_n_65536_2 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_main00109
;	emit end of comparison sequence label
L_main00237:
;	end multibyte equality check
;	src/comparison.c: 21: pic = '6';
;; genAssign
	mov	pic il ,54
;	src/comparison.c: 22: n = 0;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,0
;; genGoto
	goto	L_main00107
;; genLabel
L_main00109:
;	src/comparison.c: 25: pic = '7';
;; genAssign
	mov	pic il ,55
;	src/comparison.c: 26: while (n == 0) {
;; genLabel
L_main00110:
;; genIfx
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_main_n_65536_2 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_main00239
	goto	L_main00240
L_main00239:
	mov	alua zero
	lad	_main_n_65536_2 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_main00240
	goto	L_main00112
;	emit end of comparison sequence label
L_main00240:
;	end multibyte equality check
;	src/comparison.c: 27: pic = '8';
;; genAssign
	mov	pic il ,56
;	src/comparison.c: 28: n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;; genGoto
	goto	L_main00110
;; genLabel
L_main00112:
;	src/comparison.c: 30: pic = '9';
;; genAssign
	mov	pic il ,57
;	src/comparison.c: 32: while (n < 2) {
;; genLabel
L_main00113:
;; genCmp
;	begin multibyte (2) comparison
	lad	_main_n_65536_2 + 0
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,9	; less-than 
	gotonz	L_main00243
	mov	test aluc
	goto	L_main00244
L_main00243:
	lad	_main_n_65536_2 + 1
	mov	alua mem
	mov	alub il ,2
	mov	test aluc
L_main00244:
	gotonz	L_main00242
	goto	L_main00115
L_main00242:
;	src/comparison.c: 33: pic = 0x40;
;; genAssign
	mov	pic il ,64
;	src/comparison.c: 34: ++n;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_main_n_65536_2 + 0
	mov	stack mem
	lad	_main_n_65536_2 + 1
	mov	stack mem
	add_16s_8	1
	lad	_main_n_65536_2 + 1
	mov	mem r
	lad	_main_n_65536_2 + 0
	mov	mem x
	restore_rx
;; genGoto
	goto	L_main00113
;; genLabel
L_main00115:
;	src/comparison.c: 37: pic = 0x41;
;; genAssign
	mov	pic il ,65
;	src/comparison.c: 38: while (n > 1) {
;; genLabel
L_main00116:
;; genCmp
;	begin multibyte (2) comparison
	lad	_main_n_65536_2 + 0
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,11	; greater-than 
	gotonz	L_main00246
	mov	test aluc
	goto	L_main00247
L_main00246:
	lad	_main_n_65536_2 + 1
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
L_main00247:
	gotonz	L_main00245
	goto	L_main00118
L_main00245:
;	src/comparison.c: 39: pic = 0x42;
;; genAssign
	mov	pic il ,66
;	src/comparison.c: 40: --n;
;; genALUOp
;;	ALU minus (16)
;;	ALU operand size 2 2 1
	lad	_main_n_65536_2 + 0
	mov	stack mem
	lad	_main_n_65536_2 + 1
	mov	stack mem
	add_16s_16l	65535
	lad	_main_n_65536_2 + 1
	mov	mem r
	lad	_main_n_65536_2 + 0
	mov	mem x
	restore_rx
;; genGoto
	goto	L_main00116
;; genLabel
L_main00118:
;	src/comparison.c: 45: a = 0;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,0
;	src/comparison.c: 47: pic = 0x50;
;; genAssign
	mov	pic il ,80
;	src/comparison.c: 48: while (a != 0) {
;; genLabel
L_main00119:
;; genIfx
	lad	_main_a_65536_2
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00121
;	src/comparison.c: 49: pic = 0x51;
;; genAssign
	mov	pic il ,81
;	src/comparison.c: 50: a = 0;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,0
;; genGoto
	goto	L_main00119
;; genLabel
L_main00121:
;	src/comparison.c: 53: a = 1;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,1
;	src/comparison.c: 55: pic = 0x52;
;; genAssign
	mov	pic il ,82
;	src/comparison.c: 56: while (a == 0) {
;; genLabel
L_main00122:
;; genIfx
	lad	_main_a_65536_2
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00248
	goto	L_main00124
L_main00248:
;	src/comparison.c: 57: pic = 0x53;
;; genAssign
	mov	pic il ,83
;	src/comparison.c: 58: a = 1;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,1
;; genGoto
	goto	L_main00122
;; genLabel
L_main00124:
;	src/comparison.c: 61: n = 0;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,0
;	src/comparison.c: 63: pic = 0x54;
;; genAssign
	mov	pic il ,84
;	src/comparison.c: 64: while (n != 0) {
;; genLabel
L_main00125:
;; genIfx
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_main_n_65536_2 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_main00249
	goto	L_main00250
L_main00249:
	mov	alua zero
	lad	_main_n_65536_2 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_main00127
;	emit end of comparison sequence label
L_main00250:
;	end multibyte equality check
;	src/comparison.c: 65: pic = 0x55;
;; genAssign
	mov	pic il ,85
;	src/comparison.c: 66: n = 0;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,0
;; genGoto
	goto	L_main00125
;; genLabel
L_main00127:
;	src/comparison.c: 69: n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;	src/comparison.c: 71: pic = 0x56;
;; genAssign
	mov	pic il ,86
;	src/comparison.c: 72: while (n == 0) {
;; genLabel
L_main00128:
;; genIfx
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	lad	_main_n_65536_2 + 0
	mov	alub mem
	mov	test aluc
	gotonz	L_main00252
	goto	L_main00253
L_main00252:
	mov	alua zero
	lad	_main_n_65536_2 + 1
	mov	alub mem
	mov	test aluc
	gotonz	L_main00253
	goto	L_main00130
;	emit end of comparison sequence label
L_main00253:
;	end multibyte equality check
;	src/comparison.c: 73: pic = 0x57;
;; genAssign
	mov	pic il ,87
;	src/comparison.c: 74: n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;; genGoto
	goto	L_main00128
;; genLabel
L_main00130:
;	src/comparison.c: 77: n = 2;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,2
;	src/comparison.c: 79: pic = 0x58;
;; genAssign
	mov	pic il ,88
;	src/comparison.c: 80: while (n < 2) {
;; genLabel
L_main00131:
;; genCmp
;	begin multibyte (2) comparison
	lad	_main_n_65536_2 + 0
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,9	; less-than 
	gotonz	L_main00256
	mov	test aluc
	goto	L_main00257
L_main00256:
	lad	_main_n_65536_2 + 1
	mov	alua mem
	mov	alub il ,2
	mov	test aluc
L_main00257:
	gotonz	L_main00255
	goto	L_main00133
L_main00255:
;	src/comparison.c: 81: pic = 0x59;
;; genAssign
	mov	pic il ,89
;	src/comparison.c: 82: ++n;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_main_n_65536_2 + 0
	mov	stack mem
	lad	_main_n_65536_2 + 1
	mov	stack mem
	add_16s_8	1
	lad	_main_n_65536_2 + 1
	mov	mem r
	lad	_main_n_65536_2 + 0
	mov	mem x
	restore_rx
;; genGoto
	goto	L_main00131
;; genLabel
L_main00133:
;	src/comparison.c: 85: n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;	src/comparison.c: 87: pic = 0x60;
;; genAssign
	mov	pic il ,96
;	src/comparison.c: 88: while (n > 1) {
;; genLabel
L_main00134:
;; genCmp
;	begin multibyte (2) comparison
	lad	_main_n_65536_2 + 0
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,11	; greater-than 
	gotonz	L_main00259
	mov	test aluc
	goto	L_main00260
L_main00259:
	lad	_main_n_65536_2 + 1
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
L_main00260:
	gotonz	L_main00258
	goto	L_main00136
L_main00258:
;	src/comparison.c: 89: pic = 0x61;
;; genAssign
	mov	pic il ,97
;	src/comparison.c: 90: --n;
;; genALUOp
;;	ALU minus (16)
;;	ALU operand size 2 2 1
	lad	_main_n_65536_2 + 0
	mov	stack mem
	lad	_main_n_65536_2 + 1
	mov	stack mem
	add_16s_16l	65535
	lad	_main_n_65536_2 + 1
	mov	mem r
	lad	_main_n_65536_2 + 0
	mov	mem x
	restore_rx
;; genGoto
	goto	L_main00134
;; genLabel
L_main00136:
;	src/comparison.c: 92: pic = 0x62;
;; genAssign
	mov	pic il ,98
;	src/comparison.c: 102: __endasm;
	halt
;	src/comparison.c: 104: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/comparison.c: 105: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
