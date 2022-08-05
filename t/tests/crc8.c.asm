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
_main_sloc2_1_0:
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
;	t/tests/crc8.c: 5: uint8_t crc8_one(uint8_t crc)
;	-----------------------------------------
;	 function crc8_one
;	-----------------------------------------
	_crc8_one:
;	t/tests/crc8.c: 8: for (uint8_t i = 0; i < 8; i++)
	mov	r zero
L_crc8_one00106:
	mov	alus il ,9	; less-than 
	mov	alua r
	mov	alub il ,8
	mov	test aluc
	gotonz	L_crc8_one00123
	goto	L_crc8_one00104
L_crc8_one00123:
;	t/tests/crc8.c: 10: if (crc & 0x80)
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
	gotonz	L_crc8_one00102
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
	goto	L_crc8_one00107
L_crc8_one00102:
;	t/tests/crc8.c: 16: crc <<= 1;
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub x
	lad	_crc8_one_PARM_1
	mov	mem aluc
L_crc8_one00107:
;	t/tests/crc8.c: 8: for (uint8_t i = 0; i < 8; i++)
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua r
	mov	alub il ,1
	mov	r aluc
	goto	L_crc8_one00106
L_crc8_one00104:
;	t/tests/crc8.c: 20: return crc;
	mov	jmpl stack
	mov	jmph stack
	lad	_crc8_one_PARM_1
	mov	stack mem
	jump
;	t/tests/crc8.c: 21: }
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
;	t/tests/crc8.c: 23: uint8_t crc8(const uint8_t *data, uint8_t len)
;	-----------------------------------------
;	 function crc8
;	-----------------------------------------
	_crc8:
;	t/tests/crc8.c: 25: uint8_t crc = 0; /* start with 0 so first uint8_t can be 'xored' in */
	mov	r zero
;	t/tests/crc8.c: 27: for (uint8_t i = 0; i < len; ++i) {
	mov	x zero
L_crc800103:
	mov	alus il ,9	; less-than 
	mov	alua x
	lad	_crc8_PARM_2
	mov	alub mem
	mov	test aluc
	gotonz	L_crc800118
	goto	L_crc800101
L_crc800118:
;	t/tests/crc8.c: 28: crc ^= data[i]; /* XOR-in the next input uint8_t */
;;	ALU plus (4)
	load_stack_from_ptr	_crc8_PARM_1
	mov	stack x
	add_8s_16s
;	result is pointer
;	result has spill location: 1452
	lad	_crc8_sloc0_1_0
	mov	mem x
	lad	_crc8_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerGet: operand size 2, 1, 1
	load_address_from_ptr	_crc8_sloc0_1_0
	lad	_crc8_sloc1_1_0
	mov	mem mem
;;	ALU xor (2)
	mov	alus il ,2	; xor 
	mov	alua r
	lad	_crc8_sloc1_1_0
	mov	alub mem
	lad	_crc8_one_PARM_1
	mov	mem aluc
;	t/tests/crc8.c: 29: crc = crc8_one(crc);
	mov	stack x
	mov	stack il ,hi8(L_crc800119)
	mov	stack il ,lo8(L_crc800119)
	goto	_crc8_one
L_crc800119:
	mov	r stack
	mov	x stack
;	genAssign: registers r, r same; skipping assignment
;	t/tests/crc8.c: 27: for (uint8_t i = 0; i < len; ++i) {
;;	ALU plus (4)
	mov	alus il ,4	; plus 
	mov	alua x
	mov	alub il ,1
	mov	x aluc
	goto	L_crc800103
L_crc800101:
;	t/tests/crc8.c: 32: return crc;
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/crc8.c: 33: }
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
;	t/tests/crc8.c: 35: uint8_t main(uint8_t argc, char **argv) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	t/tests/crc8.c: 36: return crc8(argv[0], 200);
; implement me (gen.c:1169)
;; genPointerGet: operand size 2, 1, 2
	load_address_from_ptr	_main_sloc2_1_0
	lad	_crc8_PARM_1
	mov	mem mem
	lad	_crc8_PARM_2
	mov	mem il ,200
	mov	stack il ,hi8(L_main00103)
	mov	stack il ,lo8(L_main00103)
	goto	_crc8
L_main00103:
	mov	r stack
	mov	jmpl stack
	mov	jmph stack
	mov	stack r
	jump
;	t/tests/crc8.c: 37: }
;; genEndFunction 
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section initr
	.section cabs
