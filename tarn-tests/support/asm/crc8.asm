;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"crc8.c"
	
.include "/home/tarn/projects/mygcc/testfiles/tarnos/src/macros.s"
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
	.section data,"w"
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
;	src/crc8.c: 5: uint8_t crc8_one(uint8_t crc)
;; genLabel
;	-----------------------------------------
;	 function crc8_one
;	-----------------------------------------
	_crc8_one:
;	src/crc8.c: 8: for (uint8_t i = 0; i < 8; i++)
;; genAssign
	mov	r zero
;; genLabel
L_crc8_one00106:
;; genCmp
	mov	alus il ,9	; less-than 
	mov	alua r
	mov	alub il ,8
	mov	test aluc
;; genIfx
	gotonz	L_crc8_one00123
	goto	L_crc8_one00104
L_crc8_one00123:
;	src/crc8.c: 10: if (crc & 0x80)
;; genAssign
	lad	_crc8_one_PARM_1
	mov	x mem
;; genALUOp
;;	ALU and (0)
;;	ALU operand size 2 1 1
	mov	alus il ,0	; and 
	mov	alua x
	mov	alub il ,128
;; ALU op has ifx!
	mov	alua aluc
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
;; genIfx
	gotonz	L_crc8_one00102
;	src/crc8.c: 12: crc = (crc << 1) ^ POLYNOMIAL;
;; genLeftShift
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub x
	mov	x aluc
;; genALUOp
;;	ALU xor (2)
;;	ALU operand size 1 1 1
	mov	alus il ,2	; xor 
	mov	alua x
	mov	alub il ,7
	lad	_crc8_one_PARM_1
	mov	mem aluc
;; genGoto
	goto	L_crc8_one00107
;; genLabel
L_crc8_one00102:
;	src/crc8.c: 16: crc <<= 1;
;; genLeftShift
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub x
	lad	_crc8_one_PARM_1
	mov	mem aluc
;; genLabel
L_crc8_one00107:
;	src/crc8.c: 8: for (uint8_t i = 0; i < 8; i++)
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alus il ,4	; plus 
	mov	alua r
	mov	alub il ,1
	mov	r aluc
;; genGoto
	goto	L_crc8_one00106
;; genLabel
L_crc8_one00104:
;	src/crc8.c: 20: return crc;
	mov	jmpl stack
	mov	jmph stack
	lad	_crc8_one_PARM_1
	mov	stack mem
	jump
;; genLabel
;	src/crc8.c: 21: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/crc8.c: 23: uint8_t crc8(const uint8_t *data, uint8_t len)
;; genLabel
;	-----------------------------------------
;	 function crc8
;	-----------------------------------------
	_crc8:
;	src/crc8.c: 25: uint8_t crc = 0; /* start with 0 so first uint8_t can be 'xored' in */
;; genAssign
	mov	r zero
;	src/crc8.c: 27: for (uint8_t i = 0; i < len; ++i) {
;; genAssign
	mov	x zero
;; genLabel
L_crc800103:
;; genCmp
	mov	alus il ,9	; less-than 
	mov	alua x
	lad	_crc8_PARM_2
	mov	alub mem
	mov	test aluc
;; genIfx
	gotonz	L_crc800118
	goto	L_crc800101
L_crc800118:
;	src/crc8.c: 28: crc ^= data[i]; /* XOR-in the next input uint8_t */
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	load_stack_from_ptr	_crc8_PARM_1
	mov	stack x
	add_8s_16s
	lad	_crc8_sloc0_1_0
	mov	mem x
	lad	_crc8_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _crc8_sloc0_1_0
; implement me (gen.c:801)
	load_address_from_ptr	_crc8_sloc0_1_0
	lad	_crc8_sloc1_1_0
	mov	mem mem
;; genALUOp
;;	ALU xor (2)
;;	ALU operand size 1 1 1
	mov	alus il ,2	; xor 
	mov	alua r
;	load_reg: spilt
	lad	_crc8_sloc1_1_0
	mov	alub mem
	lad	_crc8_one_PARM_1
	mov	mem aluc
;	src/crc8.c: 29: crc = crc8_one(crc);
;; genCall
	mov	stack x
	mov	stack il ,hi8(L_crc800119)
	mov	stack il ,lo8(L_crc800119)
	goto	_crc8_one
L_crc800119:
	mov	r stack
	mov	x stack
;; genAssign
;	genAssign: registers r, r same; skipping assignment
;	src/crc8.c: 27: for (uint8_t i = 0; i < len; ++i) {
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub il ,1
	mov	x aluc
;; genGoto
	goto	L_crc800103
;; genLabel
L_crc800101:
;	src/crc8.c: 32: return crc;
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;; genLabel
;	src/crc8.c: 33: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/crc8.c: 35: uint8_t main(uint8_t argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/crc8.c: 36: return crc8(argv[0], 200);
;; genAssign
; implement me (gen.c:1496)
;; genPointerGet
;; genPointerGet: operand size 2, 2, 1
	lad	_crc8_PARM_1
	mov	mem r
	lad	_crc8_PARM_1 + 1
	mov	mem x
;; genAssign
	lad	_crc8_PARM_2
	mov	mem il ,200
;; genCall
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	_crc8
L_main00103:
	mov	r stack
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;; genLabel
;	src/crc8.c: 37: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr,"a"
	.section cabs