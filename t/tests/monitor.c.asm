;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"monitor.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_execute_command
	.globl	_inputlen
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_linebuf
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_linebuf:
	.ds	64
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
_main_byte_65536_3:
	.ds	1
_main_sloc0_1_0:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd
_inputlen:
	.ds	1
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
; interrupt vector
;--------------------------------------------------------
	.section home,"ax"
__interrupt_vect:
;; tarn_genIVT
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.section home
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
;	t/tests/monitor.c: 8: void execute_command() {
;	-----------------------------------------
;	 function execute_command
;	-----------------------------------------
	_execute_command:
;	t/tests/monitor.c: 10: pic = 'O';
	mov	pic il, 79
;	t/tests/monitor.c: 11: pic = 'K';
	mov	pic il, 75
;	t/tests/monitor.c: 12: pic = '\n';
	mov	pic il, 10
;	t/tests/monitor.c: 13: }
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
;	t/tests/monitor.c: 16: uint8_t main (uint8_t argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/monitor.c: 21: pic = 'H';
	mov	pic il, 72
;	t/tests/monitor.c: 22: pic = 'e';
	mov	pic il, 101
;	t/tests/monitor.c: 23: pic = 'l';
	mov	pic il, 108
;	t/tests/monitor.c: 24: pic = 'l';
	mov	pic il, 108
;	t/tests/monitor.c: 25: pic = 'o';
	mov	pic il, 111
;	t/tests/monitor.c: 26: pic = '\n';
	mov	pic il, 10
;	t/tests/monitor.c: 27: pic = '>';
	mov	pic il, 62
;	t/tests/monitor.c: 28: pic = ' ';
	mov	pic il, 32
;	t/tests/monitor.c: 30: while (1) {
L_main00111:
;	t/tests/monitor.c: 31: byte = pic;
	lad	_main_byte_65536_3
	mov	mem pic
;	t/tests/monitor.c: 33: if (byte == 0xff) {
	mov	alus il ,10	; equal-to 
	lad	_main_byte_65536_3
	mov	alua mem
	mov	alub il ,255
	mov	test aluc
	gotonz	L_main00111
;	t/tests/monitor.c: 35: } else if (byte == '\n') {
	mov	alus il ,10	; equal-to 
	lad	_main_byte_65536_3
	mov	alua mem
	mov	alub il ,10
	mov	test aluc
	gotonz	L_main00131
	goto	L_main00105
L_main00131:
;	t/tests/monitor.c: 36: execute_command();
	mov	stack il ,hi8(L_main00132)
	mov	stack il ,lo8(L_main00132)
	goto	_execute_command
L_main00132:
	; function returns nothing
	goto	L_main00111
L_main00105:
;	t/tests/monitor.c: 38: if (inputlen >= LINEBUFLEN) {
	mov	alus il ,9	; less-than 
	lad	_inputlen
	mov	alua mem
	mov	alub il ,64
	mov	test aluc
	gotonz	L_main00102
;	t/tests/monitor.c: 39: pic = 'F';
	mov	pic il, 70
;	t/tests/monitor.c: 40: pic = 'U';
	mov	pic il, 85
;	t/tests/monitor.c: 41: pic = 'L';
	mov	pic il, 76
;	t/tests/monitor.c: 42: pic = 'L';
	mov	pic il, 76
;	t/tests/monitor.c: 43: pic = '\n';
	mov	pic il, 10
;	t/tests/monitor.c: 44: inputlen = 0;
	lad	_inputlen
	mov	mem zero
	goto	L_main00111
L_main00102:
;	t/tests/monitor.c: 46: inputlen += 1;
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	lad	_inputlen
	mov	alua mem
	mov	alub il ,1
	lad	_inputlen
	mov	mem aluc
;	t/tests/monitor.c: 47: linebuf[inputlen] = byte;
;;	ALU plus (4)
	mov	stack il ,hi8(_linebuf + 0)
	mov	stack il ,lo8(_linebuf + 0)
	lad	_inputlen
	mov	stack mem
	add_8s_16s
;	result is pointer
;	result has spill location: 1452
	lad	_main_sloc0_1_0
	mov	mem x
	lad	_main_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerSet: operand size 2, 1
;	left is spilt: 892
;	left is pointer: 895
;	left has spill location: 904
	lad	_main_byte_65536_3
	mov	stack mem
	load_address_from_ptr	_main_sloc0_1_0
	mov	mem stack
	goto	L_main00111
;	t/tests/monitor.c: 52: return byte;
;	t/tests/monitor.c: 53: }
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr
__xinit__inputlen:
	.byte	#0x00	; 0
	.section cabs
