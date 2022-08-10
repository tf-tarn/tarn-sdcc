;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"string_loop.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
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
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd,"a"
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
;	src/string_loop.c: 2: int main (int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/string_loop.c: 3: const char *msg = "Executed!\n";
;	src/string_loop.c: 4: for (char i = 0; msg[i]; ++i) {
;; genAssign
	mov	r zero
;; genLabel
L_main00106:
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	mov	stack r
	add_8s_16	___str_0 ; 1
	lad	_main_sloc0_1_0
	mov	mem x
	lad	_main_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _main_sloc0_1_0
; implement me (gen.c:801)
	load_address_from_ptr	_main_sloc0_1_0
	mov	x mem
;; genIfx
	mov	alua x
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00103
;	src/string_loop.c: 5: pic = msg[i];
;; genAssign
	mov	pic x ; here
;	src/string_loop.c: 4: for (char i = 0; msg[i]; ++i) {
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alus il ,4	; plus 
	mov	alua r
	mov	alub il ,1
	mov	r aluc
;; genGoto
	goto	L_main00106
;	src/string_loop.c: 8: while(1);
;; genLabel
L_main00103:
;; genGoto
	goto	L_main00103
;	src/string_loop.c: 10: return 0;
;; genLabel
;	src/string_loop.c: 11: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section const
___str_0:
	.ascii	"Executed!"
	.byte 0x0A
	.byte 0x00
	.section code,"ax"
	.section initr,"a"
	.section cabs
