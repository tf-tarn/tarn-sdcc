;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"monitor.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
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
	.section .data,"w"
_linebuf:
	.ds	64
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
_main_byte_65536_3:
	.ds	1
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
	.section static
	.section post_static
	.section static
	.section post_static
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.section home,"ax"
	.section home,"ax"
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.section .text,"ax"
;	t/tests/monitor.c: 8: void execute_command() {
;	-----------------------------------------
;	 function execute_command
;	-----------------------------------------
	_execute_command:
;	t/tests/monitor.c: 10: pic = 'O';

	;; assign
	mov	pic il, 79
;	t/tests/monitor.c: 11: pic = 'K';

	;; assign
	mov	pic il, 75
;	t/tests/monitor.c: 12: pic = '\n';

	;; assign
	mov	pic il, 10
;	t/tests/monitor.c: 13: }
;; genEndFunction 
;	t/tests/monitor.c: 16: uint8_t main (uint8_t argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/monitor.c: 21: pic = 'H';

	;; assign
	mov	pic il, 72
;	t/tests/monitor.c: 22: pic = 'e';

	;; assign
	mov	pic il, 101
;	t/tests/monitor.c: 23: pic = 'l';

	;; assign
	mov	pic il, 108
;	t/tests/monitor.c: 24: pic = 'l';

	;; assign
	mov	pic il, 108
;	t/tests/monitor.c: 25: pic = 'o';

	;; assign
	mov	pic il, 111
;	t/tests/monitor.c: 26: pic = '\n';

	;; assign
	mov	pic il, 10
;	t/tests/monitor.c: 27: pic = '>';

	;; assign
	mov	pic il, 62
;	t/tests/monitor.c: 28: pic = ' ';

	;; assign
	mov	pic il, 32
;	t/tests/monitor.c: 30: while (1) {
	L_11:
;	t/tests/monitor.c: 31: byte = pic;

	;; assign
	lad	_main_byte_65536_3
	mov	mem pic
;	t/tests/monitor.c: 33: if (byte == 0xff) {

	;; test equality
	mov	alus il ,10	; equal-to 
	lad	_main_byte_65536_3
	mov	alua mem
	mov	alub il ,255
	mov	test aluc

	;; If x
	gotonz	L_11
;	t/tests/monitor.c: 35: } else if (byte == '\n') {

	;; test equality
	mov	alus il ,10	; equal-to 
	lad	_main_byte_65536_3
	mov	alua mem
	mov	alub il ,10
	mov	test aluc

	;; If x
	gotonz	L_33
	goto	L_5
	L_33:
;	t/tests/monitor.c: 36: execute_command();
	;; call function
	mov	stack hi8(L_ret_34)
	mov	stack lo8(L_ret_34)
	goto	_execute_command
	L_ret_34:
	; function returns nothing

	;; goto
	goto	L_11
	L_5:
;	t/tests/monitor.c: 38: if (inputlen >= LINEBUFLEN) {

	;; compare
	mov	alus il ,9	; less-than 
	lad	_inputlen
	mov	alua mem
	mov	alub il ,64
	mov	test aluc

	;; If x
	gotonz	L_2
;	t/tests/monitor.c: 39: pic = 'F';

	;; assign
	mov	pic il, 70
;	t/tests/monitor.c: 40: pic = 'U';

	;; assign
	mov	pic il, 85
;	t/tests/monitor.c: 41: pic = 'L';

	;; assign
	mov	pic il, 76
;	t/tests/monitor.c: 42: pic = 'L';

	;; assign
	mov	pic il, 76
;	t/tests/monitor.c: 43: pic = '\n';

	;; assign
	mov	pic il, 10
;	t/tests/monitor.c: 44: inputlen = 0;

	;; assign
	lad	_inputlen
	mov	mem zero

	;; goto
	goto	L_11
	L_2:
;	t/tests/monitor.c: 46: inputlen += 1;
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	lad	_inputlen
	mov	alua mem
	mov	alub il ,1
	lad	_inputlen
	mov	mem aluc
;	t/tests/monitor.c: 47: linebuf[inputlen] = byte;
;; genAddrOf: operand size 2, 64, 1
	mov	r il ,lo8(_linebuf + 0)
	mov	x il ,hi8(_linebuf + 0)
;;	ALU plus (4)
	lad	_inputlen
	add_8r_2x8r	mem r x ; 4
;	result is already in r x
;; genPointerSet: operand size 2, 1
	lad	_main_byte_65536_3
	mov	stack mem
	mov	adh zero
	mov	adl r
	mov	mem stack

	;; goto
	goto	L_11
;	t/tests/monitor.c: 52: return byte;
;	t/tests/monitor.c: 53: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section initr
__xinit__inputlen:
	.byte	#0x00	; 0
	.section cabs
t/tests/monitor.c(46:31:42:1:0:9)		_inputlen  = _inputlen  + 0x1 {signed-char literal}
t/tests/monitor.c(47:33:46:1:0:9)		iTemp9 [r x ] = iTemp8 [r x ] + _inputlen 
