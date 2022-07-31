;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"crc8one.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_crc8_one
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_crc8_one_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section .data,"w"
_crc8_one_PARM_1:
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
	.section .text,"ax"
;	t/tests/crc8one.c: 5: uint8_t crc8_one(uint8_t crc)
;	-----------------------------------------
;	 function crc8_one
;	-----------------------------------------
	_crc8_one:
;	t/tests/crc8one.c: 8: for (uint8_t i = 0; i < 8; i++)
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
;	t/tests/crc8one.c: 10: if (crc & 0x80)
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
;	t/tests/crc8one.c: 12: crc = (crc << 1) ^ POLYNOMIAL;
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
;	t/tests/crc8one.c: 16: crc <<= 1;
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub x
	lad	_crc8_one_PARM_1
	mov	mem aluc
	L_7:
;	t/tests/crc8one.c: 8: for (uint8_t i = 0; i < 8; i++)
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua r
	mov	alub il ,1
	mov	r aluc
	;; goto
	goto	L_6
	L_4:
;	t/tests/crc8one.c: 20: return crc;
	;; return
	mov	jmpl stack
	mov	jmph stack
	lad	_crc8_one_PARM_1
	mov	stack mem
	jump
;	t/tests/crc8one.c: 21: }
;; genEndFunction 
;	t/tests/crc8one.c: 23: uint8_t main(uint8_t argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/crc8one.c: 24: return crc8_one(5);
	;; assign
	lad	_crc8_one_PARM_1
	mov	mem il ,5
	;; call function
	mov	stack il ,hi8(L_ret_6)
	mov	stack il ,lo8(L_ret_6)
	goto	_crc8_one
	L_ret_6:
	mov	r stack
	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/crc8one.c: 25: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section initr
	.section cabs
