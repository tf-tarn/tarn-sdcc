;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"string_loop.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
.section .text
ljmp _main
jump
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_main_PARM_2
	.globl	_main_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section .data,"w"
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd
;--------------------------------------------------------
; overlayable items in ram
;--------------------------------------------------------
	.area	_overlay
_main_sloc0_1_0:
	.ds	2
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
;	t/tests/string_loop.c: 1: int main (int argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/string_loop.c: 3: const char *msg = "Executed!\n";
;	t/tests/string_loop.c: 4: for (char i = 0; msg[i]; ++i) {
	;; assign
	mov	r zero
	L_3:
;;	ALU plus (4)
	mov	stack r
	add_8s_16	___str_0 ; 1
	lad	_main_sloc0_1_0
	mov	mem x
	lad	_main_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerGet: operand size 2, 1, 1
; line 648
	lad	_main_sloc0_1_0 + 0
	mov	stack mem
	lad	_main_sloc0_1_0 + 1
	mov	stack mem
	mov	adl stack
	mov	adh stack
	mov	stack mem
	mov	x stack
	;; If x
	mov	alua x
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_1
;	t/tests/string_loop.c: 5: pic = msg[i];
	;; assign
	mov	pic x ; here
;	t/tests/string_loop.c: 4: for (char i = 0; msg[i]; ++i) {
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua r
	mov	alub il ,1
	mov	r aluc
	;; goto
	goto	L_3
	L_1:
;	t/tests/string_loop.c: 7: return 0;
	;; return
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;	t/tests/string_loop.c: 8: }
;; genEndFunction 
	.section .text,"ax"
	.section const
	.section const
___str_0:
	.ascii	"Executed!"
	.byte 0x0A
	.byte 0x00
	.section .text,"ax"
	.section initr
	.section cabs
