;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"not_equal.c"
	
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
;	src/not-equal.c: 3: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/not-equal.c: 4: volatile unsigned char a = 1;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,1
;	src/not-equal.c: 5: volatile unsigned int n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;	src/not-equal.c: 7: pic = '1';
;; genAssign
	mov	pic il ,49
;	src/not-equal.c: 8: while (a != 0) {
;; genLabel
L_main00101:
;; genIfx
	lad	_main_a_65536_2
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00103
;	src/not-equal.c: 9: pic = '2';
;; genAssign
	mov	pic il ,50
;	src/not-equal.c: 10: a = 0;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,0
;; genGoto
	goto	L_main00101
;; genLabel
L_main00103:
;	src/not-equal.c: 13: pic = '3';
;; genAssign
	mov	pic il ,51
;	src/not-equal.c: 14: while (a == 0) {
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
;	src/not-equal.c: 15: pic = '4';
;; genAssign
	mov	pic il ,52
;	src/not-equal.c: 16: a = 1;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,1
;; genGoto
	goto	L_main00104
;; genLabel
L_main00106:
;	src/not-equal.c: 19: pic = '5';
;; genAssign
	mov	pic il ,53
;	src/not-equal.c: 20: while (n != 0) {
;; genLabel
L_main00107:
;; genIfx
;	begin multibyte (2) comparison
	lad	_main_n_65536_2
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,10	; equal-to 
	gotonz	L_main00237
	mov	test aluc
	goto	L_main00238
L_main00237:
	lad	_main_n_65536_2 + 1
	mov	alua mem
	mov	alub zero
	mov	test aluc
L_main00238:
	gotonz	L_main00109
;	src/not-equal.c: 21: pic = '6';
;; genAssign
	mov	pic il ,54
;	src/not-equal.c: 22: n = 0;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,0
;; genGoto
	goto	L_main00107
;; genLabel
L_main00109:
;	src/not-equal.c: 25: pic = '7';
;; genAssign
	mov	pic il ,55
;	src/not-equal.c: 26: while (n == 0) {
;; genLabel
L_main00110:
;; genIfx
;	begin multibyte (2) comparison
	lad	_main_n_65536_2
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,10	; equal-to 
	gotonz	L_main00240
	mov	test aluc
	goto	L_main00241
L_main00240:
	lad	_main_n_65536_2 + 1
	mov	alua mem
	mov	alub zero
	mov	test aluc
L_main00241:
	gotonz	L_main00239
	goto	L_main00112
L_main00239:
;	src/not-equal.c: 27: pic = '8';
;; genAssign
	mov	pic il ,56
;	src/not-equal.c: 28: n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;; genGoto
	goto	L_main00110
;; genLabel
L_main00112:
;	src/not-equal.c: 30: pic = '9';
;; genAssign
	mov	pic il ,57
;	src/not-equal.c: 32: while (n < 2) {
;; genLabel
L_main00113:
;; genCmp
;	begin multibyte (2) comparison
	lad	_main_n_65536_2
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
;	src/not-equal.c: 33: pic = 0x40;
;; genAssign
	mov	pic il ,64
;	src/not-equal.c: 34: ++n;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_main_n_65536_2
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
;	src/not-equal.c: 37: pic = 0x41;
;; genAssign
	mov	pic il ,65
;	src/not-equal.c: 38: while (n > 1) {
;; genLabel
L_main00116:
;; genCmp
;	begin multibyte (2) comparison
	lad	_main_n_65536_2
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
;	src/not-equal.c: 39: pic = 0x42;
;; genAssign
	mov	pic il ,66
;	src/not-equal.c: 40: --n;
;; genALUOp
;;	ALU minus (16)
;;	ALU operand size 2 2 1
	lad	_main_n_65536_2
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
;	src/not-equal.c: 45: a = 0;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,0
;	src/not-equal.c: 47: pic = 0x50;
;; genAssign
	mov	pic il ,80
;	src/not-equal.c: 48: while (a != 0) {
;; genLabel
L_main00119:
;; genIfx
	lad	_main_a_65536_2
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00121
;	src/not-equal.c: 49: pic = 0x51;
;; genAssign
	mov	pic il ,81
;	src/not-equal.c: 50: a = 0;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,0
;; genGoto
	goto	L_main00119
;; genLabel
L_main00121:
;	src/not-equal.c: 53: a = 1;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,1
;	src/not-equal.c: 55: pic = 0x52;
;; genAssign
	mov	pic il ,82
;	src/not-equal.c: 56: while (a == 0) {
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
;	src/not-equal.c: 57: pic = 0x53;
;; genAssign
	mov	pic il ,83
;	src/not-equal.c: 58: a = 1;
;; genAssign
	lad	_main_a_65536_2 + 0
	mov	mem il ,1
;; genGoto
	goto	L_main00122
;; genLabel
L_main00124:
;	src/not-equal.c: 61: n = 0;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,0
;	src/not-equal.c: 63: pic = 0x54;
;; genAssign
	mov	pic il ,84
;	src/not-equal.c: 64: while (n != 0) {
;; genLabel
L_main00125:
;; genIfx
;	begin multibyte (2) comparison
	lad	_main_n_65536_2
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,10	; equal-to 
	gotonz	L_main00250
	mov	test aluc
	goto	L_main00251
L_main00250:
	lad	_main_n_65536_2 + 1
	mov	alua mem
	mov	alub zero
	mov	test aluc
L_main00251:
	gotonz	L_main00127
;	src/not-equal.c: 65: pic = 0x55;
;; genAssign
	mov	pic il ,85
;	src/not-equal.c: 66: n = 0;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,0
;; genGoto
	goto	L_main00125
;; genLabel
L_main00127:
;	src/not-equal.c: 69: n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;	src/not-equal.c: 71: pic = 0x56;
;; genAssign
	mov	pic il ,86
;	src/not-equal.c: 72: while (n == 0) {
;; genLabel
L_main00128:
;; genIfx
;	begin multibyte (2) comparison
	lad	_main_n_65536_2
	mov	alua mem
	mov	alub zero
	mov	alus il ,10	; equal-to 
	mov	test aluc
	mov	alus il ,10	; equal-to 
	gotonz	L_main00253
	mov	test aluc
	goto	L_main00254
L_main00253:
	lad	_main_n_65536_2 + 1
	mov	alua mem
	mov	alub zero
	mov	test aluc
L_main00254:
	gotonz	L_main00252
	goto	L_main00130
L_main00252:
;	src/not-equal.c: 73: pic = 0x57;
;; genAssign
	mov	pic il ,87
;	src/not-equal.c: 74: n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;; genGoto
	goto	L_main00128
;; genLabel
L_main00130:
;	src/not-equal.c: 77: n = 2;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,2
;	src/not-equal.c: 79: pic = 0x58;
;; genAssign
	mov	pic il ,88
;	src/not-equal.c: 80: while (n < 2) {
;; genLabel
L_main00131:
;; genCmp
;	begin multibyte (2) comparison
	lad	_main_n_65536_2
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
;	src/not-equal.c: 81: pic = 0x59;
;; genAssign
	mov	pic il ,89
;	src/not-equal.c: 82: ++n;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_main_n_65536_2
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
;	src/not-equal.c: 85: n = 1;
;; genAssign
	lad	_main_n_65536_2 + 0
	mov	mem il ,0
	lad	_main_n_65536_2 + 1
	mov	mem il ,1
;	src/not-equal.c: 87: pic = 0x60;
;; genAssign
	mov	pic il ,96
;	src/not-equal.c: 88: while (n > 1) {
;; genLabel
L_main00134:
;; genCmp
;	begin multibyte (2) comparison
	lad	_main_n_65536_2
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
;	src/not-equal.c: 89: pic = 0x61;
;; genAssign
	mov	pic il ,97
;	src/not-equal.c: 90: --n;
;; genALUOp
;;	ALU minus (16)
;;	ALU operand size 2 2 1
	lad	_main_n_65536_2
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
;	src/not-equal.c: 92: pic = 0x62;
;; genAssign
	mov	pic il ,98
;	src/not-equal.c: 102: __endasm;
	halt
;	src/not-equal.c: 104: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/not-equal.c: 105: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
