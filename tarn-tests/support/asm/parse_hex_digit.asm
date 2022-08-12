;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"parse_hex_digit.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_parse_hex_digit
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_parse_hex_digit_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_parse_hex_digit_PARM_1:
	.ds	1
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
_main_sloc0_1_0:
	.ds	1
_main_sloc1_1_0:
	.ds	1
_main_sloc2_1_0:
	.ds	1
_main_sloc3_1_0:
	.ds	1
_main_sloc4_1_0:
	.ds	1
_main_sloc5_1_0:
	.ds	1
_main_sloc6_1_0:
	.ds	1
_main_sloc7_1_0:
	.ds	1
_main_sloc8_1_0:
	.ds	1
_main_sloc9_1_0:
	.ds	1
_main_sloc10_1_0:
	.ds	1
_main_sloc11_1_0:
	.ds	1
_main_sloc12_1_0:
	.ds	1
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
;	src/parse_hex_digit.c: 3: char parse_hex_digit(char c) {
;; genLabel
;	-----------------------------------------
;	 function parse_hex_digit
;	-----------------------------------------
	_parse_hex_digit:
;	src/parse_hex_digit.c: 4: if (c >= '0' && c <= '9') {
;; genCmp
	mov	alus il ,9	; less-than 
	lad	_parse_hex_digit_PARM_1
	mov	alua mem
	mov	alub il ,48
	mov	test aluc
;; genIfx
	gotonz	L_parse_hex_digit00102
;; genCmp
	mov	alus il ,11	; greater-than 
	lad	_parse_hex_digit_PARM_1
	mov	alua mem
	mov	alub il ,57
	mov	test aluc
;; genIfx
	gotonz	L_parse_hex_digit00102
;	src/parse_hex_digit.c: 5: return c - '0';
;; genALUOp
;;	ALU minus (16)
;;	ALU operand size 1 1 1
	lad	_parse_hex_digit_PARM_1
	mov	alua mem
	mov	alus il ,4	; plus 
	mov	alub il ,-48
	mov	r aluc
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;; genLabel
L_parse_hex_digit00102:
;	src/parse_hex_digit.c: 7: if (c >= 'a' && c <= 'f') {
;; genCmp
	mov	alus il ,9	; less-than 
	lad	_parse_hex_digit_PARM_1
	mov	alua mem
	mov	alub il ,97
	mov	test aluc
;; genIfx
	gotonz	L_parse_hex_digit00105
;; genCmp
	mov	alus il ,11	; greater-than 
	lad	_parse_hex_digit_PARM_1
	mov	alua mem
	mov	alub il ,102
	mov	test aluc
;; genIfx
	gotonz	L_parse_hex_digit00105
;	src/parse_hex_digit.c: 8: return (c - 'a') + 10;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	lad	_parse_hex_digit_PARM_1
	mov	alua mem
	mov	alus il ,4	; plus 
	mov	alub il ,169
	mov	r aluc
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;; genLabel
L_parse_hex_digit00105:
;	src/parse_hex_digit.c: 10: if (c >= 'A' && c <= 'F') {
;; genCmp
	mov	alus il ,9	; less-than 
	lad	_parse_hex_digit_PARM_1
	mov	alua mem
	mov	alub il ,65
	mov	test aluc
;; genIfx
	gotonz	L_parse_hex_digit00108
;; genCmp
	mov	alus il ,11	; greater-than 
	lad	_parse_hex_digit_PARM_1
	mov	alua mem
	mov	alub il ,70
	mov	test aluc
;; genIfx
	gotonz	L_parse_hex_digit00108
;	src/parse_hex_digit.c: 11: return (c - 'A') + 10;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	lad	_parse_hex_digit_PARM_1
	mov	alua mem
	mov	alus il ,4	; plus 
	mov	alub il ,201
	mov	r aluc
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;; genLabel
L_parse_hex_digit00108:
;	src/parse_hex_digit.c: 13: return 0xff;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,255
	jump
;; genLabel
;	src/parse_hex_digit.c: 14: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/parse_hex_digit.c: 16: char main(char argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/parse_hex_digit.c: 19: c = parse_hex_digit('0');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,48
;; genCall
	mov	stack il ,hi8(L_main00111)
	mov	stack il ,lo8(L_main00111)
	goto	_parse_hex_digit
L_main00111:
	mov	r stack
;; genAssign
;	genAssign: registers r, r same; skipping assignment
;	src/parse_hex_digit.c: 20: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	mov	pic r
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 21: c = parse_hex_digit('1');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,49
;; genCall
	mov	stack il ,hi8(L_main00112)
	mov	stack il ,lo8(L_main00112)
	goto	_parse_hex_digit
L_main00112:
	mov	r stack
;; genAssign
;	genAssign: registers r, r same; skipping assignment
;	src/parse_hex_digit.c: 22: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	mov	pic r
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 23: c = parse_hex_digit('2');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,50
;; genCall
	mov	stack il ,hi8(L_main00113)
	mov	stack il ,lo8(L_main00113)
	goto	_parse_hex_digit
L_main00113:
	mov	r stack
;; genAssign
;	genAssign: registers r, r same; skipping assignment
;	src/parse_hex_digit.c: 24: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	mov	pic r
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 25: c = parse_hex_digit('3');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,51
;; genCall
	mov	stack il ,hi8(L_main00114)
	mov	stack il ,lo8(L_main00114)
	goto	_parse_hex_digit
L_main00114:
	mov	r stack
;; genAssign
;	genAssign: registers r, r same; skipping assignment
;	src/parse_hex_digit.c: 26: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	mov	pic r
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 27: c = parse_hex_digit('4');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,52
;; genCall
	mov	stack il ,hi8(L_main00115)
	mov	stack il ,lo8(L_main00115)
	goto	_parse_hex_digit
L_main00115:
	mov	r stack
;; genAssign
;	genAssign: registers r, r same; skipping assignment
;	src/parse_hex_digit.c: 28: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	mov	pic r
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 29: c = parse_hex_digit('5');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,53
;; genCall
	mov	stack il ,hi8(L_main00116)
	mov	stack il ,lo8(L_main00116)
	goto	_parse_hex_digit
L_main00116:
	mov	r stack
;; genAssign
;	genAssign: registers r, r same; skipping assignment
;	src/parse_hex_digit.c: 30: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	mov	pic r
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 31: c = parse_hex_digit('6');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,54
;; genCall
	mov	stack il ,hi8(L_main00117)
	mov	stack il ,lo8(L_main00117)
	goto	_parse_hex_digit
L_main00117:
	mov	r stack
;; genAssign
	lad	_main_sloc0_1_0
	mov	mem r
;	src/parse_hex_digit.c: 32: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc0_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 33: c = parse_hex_digit('7');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,55
;; genCall
	mov	stack il ,hi8(L_main00118)
	mov	stack il ,lo8(L_main00118)
	goto	_parse_hex_digit
L_main00118:
	mov	r stack
;; genAssign
	lad	_main_sloc1_1_0
	mov	mem r
;	src/parse_hex_digit.c: 34: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc1_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 35: c = parse_hex_digit('8');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,56
;; genCall
	mov	stack il ,hi8(L_main00119)
	mov	stack il ,lo8(L_main00119)
	goto	_parse_hex_digit
L_main00119:
	mov	r stack
;; genAssign
	lad	_main_sloc2_1_0
	mov	mem r
;	src/parse_hex_digit.c: 36: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc2_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 37: c = parse_hex_digit('9');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,57
;; genCall
	mov	stack il ,hi8(L_main00120)
	mov	stack il ,lo8(L_main00120)
	goto	_parse_hex_digit
L_main00120:
	mov	r stack
;; genAssign
	lad	_main_sloc3_1_0
	mov	mem r
;	src/parse_hex_digit.c: 38: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc3_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 39: c = parse_hex_digit('a');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,97
;; genCall
	mov	stack il ,hi8(L_main00121)
	mov	stack il ,lo8(L_main00121)
	goto	_parse_hex_digit
L_main00121:
	mov	r stack
;; genAssign
	lad	_main_sloc4_1_0
	mov	mem r
;	src/parse_hex_digit.c: 40: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc4_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 41: c = parse_hex_digit('b');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,98
;; genCall
	mov	stack il ,hi8(L_main00122)
	mov	stack il ,lo8(L_main00122)
	goto	_parse_hex_digit
L_main00122:
	mov	r stack
;; genAssign
	lad	_main_sloc5_1_0
	mov	mem r
;	src/parse_hex_digit.c: 42: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc5_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 43: c = parse_hex_digit('c');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,99
;; genCall
	mov	stack il ,hi8(L_main00123)
	mov	stack il ,lo8(L_main00123)
	goto	_parse_hex_digit
L_main00123:
	mov	r stack
;; genAssign
	lad	_main_sloc6_1_0
	mov	mem r
;	src/parse_hex_digit.c: 44: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc6_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 45: c = parse_hex_digit('d');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,100
;; genCall
	mov	stack il ,hi8(L_main00124)
	mov	stack il ,lo8(L_main00124)
	goto	_parse_hex_digit
L_main00124:
	mov	r stack
;; genAssign
	lad	_main_sloc7_1_0
	mov	mem r
;	src/parse_hex_digit.c: 46: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc7_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 47: c = parse_hex_digit('e');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,101
;; genCall
	mov	stack il ,hi8(L_main00125)
	mov	stack il ,lo8(L_main00125)
	goto	_parse_hex_digit
L_main00125:
	mov	r stack
;; genAssign
	lad	_main_sloc8_1_0
	mov	mem r
;	src/parse_hex_digit.c: 48: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc8_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 49: c = parse_hex_digit('f');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,102
;; genCall
	mov	stack il ,hi8(L_main00126)
	mov	stack il ,lo8(L_main00126)
	goto	_parse_hex_digit
L_main00126:
	mov	r stack
;; genAssign
	lad	_main_sloc9_1_0
	mov	mem r
;	src/parse_hex_digit.c: 50: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc9_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 51: c = parse_hex_digit('x');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,120
;; genCall
	mov	stack il ,hi8(L_main00127)
	mov	stack il ,lo8(L_main00127)
	goto	_parse_hex_digit
L_main00127:
	mov	r stack
;; genAssign
	lad	_main_sloc10_1_0
	mov	mem r
;	src/parse_hex_digit.c: 52: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc10_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 53: c = parse_hex_digit(' ');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,32
;; genCall
	mov	stack il ,hi8(L_main00128)
	mov	stack il ,lo8(L_main00128)
	goto	_parse_hex_digit
L_main00128:
	mov	r stack
;; genAssign
	lad	_main_sloc11_1_0
	mov	mem r
;	src/parse_hex_digit.c: 54: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc11_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 55: c = parse_hex_digit('/');
;; genAssign
	lad	_parse_hex_digit_PARM_1
	mov	mem il ,47
;; genCall
	mov	stack il ,hi8(L_main00129)
	mov	stack il ,lo8(L_main00129)
	goto	_parse_hex_digit
L_main00129:
	mov	r stack
;; genAssign
	lad	_main_sloc12_1_0
	mov	mem r
;	src/parse_hex_digit.c: 56: pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
;; genAssign
	mov	pic il ,14
;; genAssign
	lad	_main_sloc12_1_0
	mov	pic mem
;; genAssign
	mov	pic il ,15
;; genAssign
	mov	pic il ,10
;	src/parse_hex_digit.c: 58: while(1);
;; genLabel
L_main00102:
;; genGoto
	goto	L_main00102
;; genLabel
;	src/parse_hex_digit.c: 59: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
