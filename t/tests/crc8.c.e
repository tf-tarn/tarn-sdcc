assembler was passed: -plosgffw crc8.asm
--BEGIN ASM--
;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"crc8.c"
	
.section text
.org 0
ljmp _main
jump
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_crc8
	.globl	_crc8_one
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_crc8_PARM_2
	.globl	_crc8_PARM_1
	.globl	_crc8_one_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"r"
_crc8_one_PARM_1:
	.ds	1
_crc8_PARM_1:
	.ds	2
_crc8_PARM_2:
	.ds	1
_crc8_sloc0_1_0:
	.ds	2
_crc8_sloc1_1_0:
	.ds	1
_main_PARM_1:
	.ds	1
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd
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
	.section code,"ax"
;	t/tests/crc8.c: 5: uint8_t crc8_one(uint8_t crc)
;	-----------------------------------------
;	 function crc8_one
;	-----------------------------------------
	_crc8_one:
;	t/tests/crc8.c: 8: for (uint8_t i = 0; i < 8; i++)

	;; assign
	mov	r zero
	L_6:

	;; compare
	mov	alus il ,9	; less-than 
	mov	alua r
	mov	alub il ,8
	mov	test aluc

	;; If x
	gotonz	L_26
	goto	L_4
	L_26:
;	t/tests/crc8.c: 10: if (crc & 0x80)

	;; assign
	lad	_crc8_one_PARM_1
	mov	x mem
;;	ALU and (0)
	mov	alus il ,0	; and 
	mov	alua x
	mov	alub il ,128
;; ALU op has ifx!
	mov	alua aluc
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc

	;; If x
	gotonz	L_2
;	t/tests/crc8.c: 12: crc = (crc << 1) ^ POLYNOMIAL;
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub x
	mov	x aluc
;;	ALU xor (2)
	mov	alus il ,2	; xor 
	mov	alua x
	mov	alub il ,7
	lad	_crc8_one_PARM_1
	mov	mem aluc

	;; goto
	goto	L_7
	L_2:
;	t/tests/crc8.c: 16: crc <<= 1;
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub x
	lad	_crc8_one_PARM_1
	mov	mem aluc
	L_7:
;	t/tests/crc8.c: 8: for (uint8_t i = 0; i < 8; i++)
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua r
	mov	alub il ,1
	mov	r aluc

	;; goto
	goto	L_6
	L_4:
;	t/tests/crc8.c: 20: return crc;

	;; return
	mov	jmpl stack
	mov	jmph stack
	lad	_crc8_one_PARM_1
	mov	stack mem
	jump
;	t/tests/crc8.c: 21: }
;; genEndFunction 
;	t/tests/crc8.c: 23: uint8_t crc8(const uint8_t *data, uint8_t len)
;	-----------------------------------------
;	 function crc8
;	-----------------------------------------
	_crc8:
;	t/tests/crc8.c: 25: uint8_t crc = 0; /* start with 0 so first uint8_t can be 'xored' in */

	;; assign
	mov	r zero
;	t/tests/crc8.c: 27: for (uint8_t i = 0; i < len; ++i) {

	;; assign
	mov	x zero
	L_3:

	;; compare
	mov	alus il ,9	; less-than 
	mov	alua x
	lad	_crc8_PARM_2
	mov	alub mem
	mov	test aluc

	;; If x
	gotonz	L_25
	goto	L_1
	L_25:
;	t/tests/crc8.c: 28: crc ^= data[i]; /* XOR-in the next input uint8_t */
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	lad	_crc8_PARM_1
	mov	alua mem
	mov	alub x
	lad	_crc8_sloc0_1_0
	mov	mem aluc
;; genPointerGet  
;;	ALU xor (2)
	mov	alus il ,2	; xor 
	mov	alua r
	lad	_crc8_sloc1_1_0
	mov	alub mem
	lad	_crc8_one_PARM_1
	mov	mem aluc
;	t/tests/crc8.c: 29: crc = crc8_one(crc);
;; call function
	goto	_crc8_one

	;; assign
	mov	r r
;	t/tests/crc8.c: 27: for (uint8_t i = 0; i < len; ++i) {
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub il ,1
	mov	x aluc

	;; goto
	goto	L_3
	L_1:
;	t/tests/crc8.c: 32: return crc;

	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/crc8.c: 33: }
;; genEndFunction 
;	t/tests/crc8.c: 35: uint8_t main(uint8_t argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/crc8.c: 36: return crc8(argv[0], 200);

	;; assign
	lad	_main_PARM_2
	mov	r mem
;; genPointerGet  

	;; assign
	lad	_crc8_PARM_2
	mov	mem il ,200
;; call function
	goto	_crc8

	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/crc8.c: 37: }
;; genEndFunction 
	.section code,"ax"
	.section const
	.section initr
	.section cabs
--END ASM--
