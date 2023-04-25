;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"addition_large_2.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_var
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_vvv
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_vvv:
	.ds	2
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section initd,"a"
_var:
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
;	src/addition_large_2.c: 3: int main (int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/addition_large_2.c: 4: const char *msg = "foo";
;	src/addition_large_2.c: 5: vvv = msg + var;
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_var
	mov	stack mem
	add_8s_16	___str_0
	lad	_vvv + 1
	mov	mem r
	lad	_vvv + 0
	mov	mem x
	restore_rx
;	src/addition_large_2.c: 6: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
;	src/addition_large_2.c: 7: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section const
___str_0:
	.ascii	"foo"
	.byte 0x00
	.section code,"ax"
	.section initr,"a"
__xinit__var:
	.byte	#0x01	; 1
	.section cabs
