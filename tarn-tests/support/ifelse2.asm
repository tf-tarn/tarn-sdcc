;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"ifelse2.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_litbitint
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_litbitint_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_litbitint_PARM_1:
	.ds	2
_main_PARM_1:
	.ds	2
_main_PARM_2:
	.ds	2
_main_sloc0_1_0:
	.ds	2
_main_sloc1_1_0:
	.ds	2
_main_sloc2_1_0:
	.ds	2
_main_sloc3_1_0:
	.ds	2
_main_sloc4_1_0:
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
;	src/ifelse2.c: 3: int litbitint (unsigned int b)
;; genLabel
;	-----------------------------------------
;	 function litbitint
;	-----------------------------------------
	_litbitint:
;	src/ifelse2.c: 8: if (b & 0x0001)
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 2 2 2
;	begin bitwise ALU operation
	mov	alus il ,0	; and 
	lad	_litbitint_PARM_1 + 0
	mov	alua mem
	mov	alub zero
	lad	_litbitint_PARM_1 + 1
	mov	alua mem
	mov	alub il ,1
;	end bitwise ALU operation
;; ALU op has ifx!
	mov	alua aluc
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
;; genIfx
	gotonz	L_litbitint00108
;	src/ifelse2.c: 9: return(0);
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,0
	mov	stack il ,0
	jump
;; genLabel
L_litbitint00108:
;	src/ifelse2.c: 10: else if (b & 0x0004)
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 2 2 2
;	begin bitwise ALU operation
	mov	alus il ,0	; and 
	lad	_litbitint_PARM_1 + 0
	mov	alua mem
	mov	alub zero
	lad	_litbitint_PARM_1 + 1
	mov	alua mem
	mov	alub il ,4
;	end bitwise ALU operation
;; ALU op has ifx!
	mov	alua aluc
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
;; genIfx
	gotonz	L_litbitint00105
;	src/ifelse2.c: 11: return(1);
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,1
	mov	stack il ,0
	jump
;; genLabel
L_litbitint00105:
;	src/ifelse2.c: 12: else if (b & 0x2010)
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 2 2 2
;	begin bitwise ALU operation
	mov	alus il ,0	; and 
	lad	_litbitint_PARM_1 + 1
	mov	alua mem
	mov	alub il ,32
	mov	r aluc
	lad	_litbitint_PARM_1 + 0
	mov	alua mem
	mov	alub il ,16
	mov	x aluc
;	end bitwise ALU operation
;; genIfx
	mov	alus il ,10	; equal-to 
;	begin multibyte (2) equality check
	mov	alua zero
	mov	alub x
	mov	test aluc
	gotonz	L_litbitint00124
	goto	L_litbitint00125
L_litbitint00124:
	mov	alua zero
	mov	alub r
	mov	test aluc
	gotonz	L_litbitint00102
;	emit end of comparison sequence label
L_litbitint00125:
;	end multibyte equality check
;	src/ifelse2.c: 13: return(2);
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,2
	mov	stack il ,0
	jump
;; genLabel
L_litbitint00102:
;	src/ifelse2.c: 15: return(3);
	mov	jmpl stack
	mov	jmph stack
	mov	stack il ,3
	mov	stack il ,0
	jump
;; genLabel
;	src/ifelse2.c: 16: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/ifelse2.c: 18: int main(int argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/ifelse2.c: 19: int x = litbitint (0x0001u);
;; genAssign
	lad	_litbitint_PARM_1 + 0
	mov	mem il ,0
	lad	_litbitint_PARM_1 + 1
	mov	mem il ,1
;; genCall
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	_litbitint
L_main00103:
	lad	_main_sloc0_1_0 + 0
	mov	mem stack
	lad	_main_sloc0_1_0 + 1
	mov	mem stack
;; genAssign
	lad	_main_sloc0_1_0 + 0
	mov	stack mem
	lad	_main_sloc1_1_0 + 0
	mov	mem stack
	lad	_main_sloc0_1_0 + 1
	mov	stack mem
	lad	_main_sloc1_1_0 + 1
	mov	mem stack
;	src/ifelse2.c: 20: int y = litbitint (0x0004);
;; genAssign
	lad	_litbitint_PARM_1 + 0
	mov	mem il ,0
	lad	_litbitint_PARM_1 + 1
	mov	mem il ,4
;; genCall
	mov	stack il ,hi8(L_main00104)
	mov	stack il ,lo8(L_main00104)
	goto	_litbitint
L_main00104:
	lad	_main_sloc2_1_0 + 0
	mov	mem stack
	lad	_main_sloc2_1_0 + 1
	mov	mem stack
;; genAssign
	lad	_main_sloc2_1_0 + 0
	mov	stack mem
	lad	_main_sloc3_1_0 + 0
	mov	mem stack
	lad	_main_sloc2_1_0 + 1
	mov	stack mem
	lad	_main_sloc3_1_0 + 1
	mov	mem stack
;	src/ifelse2.c: 21: int z = litbitint (0x1020u);
;; genAssign
	lad	_litbitint_PARM_1 + 0
	mov	mem il ,16
	lad	_litbitint_PARM_1 + 1
	mov	mem il ,32
;; genCall
	mov	stack il ,hi8(L_main00105)
	mov	stack il ,lo8(L_main00105)
	goto	_litbitint
L_main00105:
	lad	_main_sloc4_1_0 + 0
	mov	mem stack
	lad	_main_sloc4_1_0 + 1
	mov	mem stack
;; genAssign
	lad	_main_sloc4_1_0 + 0
	mov	x mem
	lad	_main_sloc4_1_0 + 1
	mov	r mem
;	src/ifelse2.c: 23: pic = x >> 8;
;; genGetByte      = 
;	offset = 1, 0
	lad	_main_sloc1_1_0 + 0
	mov	pic mem
;	src/ifelse2.c: 24: pic = x;
;; genCast
	lad	_main_sloc1_1_0 + 1
	mov	pic mem
;	src/ifelse2.c: 25: pic = 0xff;
;; genAssign
	mov	pic il ,255
;	src/ifelse2.c: 26: pic = y >> 8;
;; genGetByte      = 
;	offset = 1, 0
	lad	_main_sloc3_1_0 + 0
	mov	pic mem
;	src/ifelse2.c: 27: pic = y;
;; genCast
	lad	_main_sloc3_1_0 + 1
	mov	pic mem
;	src/ifelse2.c: 28: pic = 0xff;
;; genAssign
	mov	pic il ,255
;	src/ifelse2.c: 29: pic = z >> 8;
;; genGetByte      = 
;	offset = 1, 0
	mov	pic x
;	src/ifelse2.c: 30: pic = z;
;; genCast
	mov	pic r
;	src/ifelse2.c: 32: pic = 0xff;
;; genAssign
	mov	pic il ,255
;	src/ifelse2.c: 36: __endasm;
	halt
;; genLabel
;	src/ifelse2.c: 38: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs
