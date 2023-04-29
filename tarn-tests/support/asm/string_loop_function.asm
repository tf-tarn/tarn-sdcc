;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.file	"string_loop_function.c"
	
.include "/home/tarn/projects/tarnos/asm/src/macros/macros.s"
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl	_main
	.globl	_print
	.globl	_main_PARM_2
	.globl	_main_PARM_1
	.globl	_var
	.globl	_print_PARM_1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.section data,"w"
_print_PARM_1:
	.ds	2
_var:
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
	.area	_overlay
_print_sloc0_1_0:
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
;	src/string_loop_function.c: 3: void print(const char *s) {
;; genLabel
;	-----------------------------------------
;	 function print
;	-----------------------------------------
	_print:
;	src/string_loop_function.c: 4: for (char i = 0; s[i]; ++i) {
;; genAssign
	mov	r zero
;; genLabel
L_print00103:
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 2 2 1
	lad	_print_PARM_1
	mov	stack mem
	lad	_print_PARM_1 + 1
	mov	stack mem
	mov	stack r
	add_8s_16s
	lad	_print_sloc0_1_0 + 0
	mov	mem x
	lad	_print_sloc0_1_0 + 1
	mov	mem r
	restore_rx
;; genPointerGet
;; genPointerGet: operand size 1, 2, 1
;	left: reg? mem? remat? spilt? nregs regs label
;	           yes         yes    2          _print_sloc0_1_0
	load_address_from_ptr	_print_sloc0_1_0
	mov	x mem
;; genIfx
	mov	alua x
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_print00101
;	src/string_loop_function.c: 5: pic = s[i];
;; genAssign
	mov	pic x
;	src/string_loop_function.c: 4: for (char i = 0; s[i]; ++i) {
;; genALUOp
;;	ALU plus (4)
;;	ALU operand size 1 1 1
	mov	alua r
	mov	alus il ,4	; plus 
	mov	alub il ,1
	mov	r aluc
;; genGoto
	goto	L_print00103
;; genLabel
L_print00101:
;	src/string_loop_function.c: 7: return;
;; genLabel
;	src/string_loop_function.c: 8: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
;	src/string_loop_function.c: 12: char main (char argc, char **argv) {
;; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
	_main:
;	src/string_loop_function.c: 13: const char *msg = "Hello, world!\n";
;	src/string_loop_function.c: 14: const char *msg_too_short = "Too short.\n";
;	src/string_loop_function.c: 18: if (argc) {
;; genIfx
	lad	_main_PARM_1
	mov	alua mem
	mov	alus il ,10	; equal-to 
	mov	alub zero
	mov	test aluc
	gotonz	L_main00102
;	src/string_loop_function.c: 19: var = 1;
;; genAssign
	lad	_var + 0
	mov	mem il ,1
;; genGoto
	goto	L_main00103
;; genLabel
L_main00102:
;	src/string_loop_function.c: 21: var = 1;
;; genAssign
	lad	_var + 0
	mov	mem il ,1
;; genLabel
L_main00103:
;	src/string_loop_function.c: 24: switch (var) {
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	lad	_var + 0
	mov	alua mem
	mov	alub zero
	mov	test aluc
;; genIfx
	gotonz	L_main00104
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	lad	_var + 0
	mov	alua mem
	mov	alub il ,1
	mov	test aluc
;; genIfx
	gotonz	L_main00105
;; genCmpEQorNE
	mov	alus il ,10	; equal-to 
	lad	_var + 0
	mov	alua mem
	mov	alub il ,2
	mov	test aluc
;; genIfx
	gotonz	L_main00106
;; genGoto
	goto	L_main00107
;	src/string_loop_function.c: 25: case 0:
;; genLabel
L_main00104:
;	src/string_loop_function.c: 26: print(msg_too_short);
;; genAssign
	lad	_print_PARM_1
	mov	mem il ,hi8(___str_1 + 0) ; hi
	lad	_print_PARM_1 + 1
	mov	mem il ,lo8(___str_1 + 0) ; lo
;; genCall
	mov	stack il ,hi8(L_main00132)
	mov	stack il ,lo8(L_main00132)
	goto	_print
L_main00132:
	; function returns nothing
;	src/string_loop_function.c: 27: break;
;; genGoto
	goto	L_main00107
;	src/string_loop_function.c: 28: case 1:
;; genLabel
L_main00105:
;	src/string_loop_function.c: 29: print(msg);
;; genAssign
	lad	_print_PARM_1
	mov	mem il ,hi8(___str_0 + 0) ; hi
	lad	_print_PARM_1 + 1
	mov	mem il ,lo8(___str_0 + 0) ; lo
;; genCall
	mov	stack il ,hi8(L_main00133)
	mov	stack il ,lo8(L_main00133)
	goto	_print
L_main00133:
	; function returns nothing
;	src/string_loop_function.c: 30: break;
;; genGoto
	goto	L_main00107
;	src/string_loop_function.c: 31: case 2:
;; genLabel
L_main00106:
;	src/string_loop_function.c: 32: print(msg_too_short);
;; genAssign
	lad	_print_PARM_1
	mov	mem il ,hi8(___str_1 + 0) ; hi
	lad	_print_PARM_1 + 1
	mov	mem il ,lo8(___str_1 + 0) ; lo
;; genCall
	mov	stack il ,hi8(L_main00134)
	mov	stack il ,lo8(L_main00134)
	goto	_print
L_main00134:
	; function returns nothing
;	src/string_loop_function.c: 34: }
;; genLabel
L_main00107:
;	src/string_loop_function.c: 38: __endasm;
	halt
;	src/string_loop_function.c: 40: return 0;
	mov	jmpl stack
	mov	jmph stack
	mov	stack zero
	jump
;; genLabel
;	src/string_loop_function.c: 41: }
;; genEndFunction
	mov	jmpl stack
	mov	jmph stack
	jump
	.section code,"ax"
	.section const
	.section const
___str_0:
	.ascii	"Hello, world!"
	.byte 0x0A
	.byte 0x00
	.section code,"ax"
	.section const
___str_1:
	.ascii	"Too short."
	.byte 0x0A
	.byte 0x00
	.section code,"ax"
	.section initr,"a"
	.section cabs
