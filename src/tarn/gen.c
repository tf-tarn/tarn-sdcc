/*-------------------------------------------------------------------------
  gen.c - code generator for Padauk.

  Copyright (C) 2018-2021, Philipp Klaus Krause pkk@spth.de

  This program is free software; you can redistribute it and/or modify it
  under the terms of the GNU General Public License as published by the
  Free Software Foundation; either version 2, or (at your option) any
  later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
-------------------------------------------------------------------------*/

#include "ralloc.h"
#include "gen.h"

//#define labelKey2num(X) (X)

/* Use the D macro for basic (unobtrusive) debugging messages */
#define D(x) do if (options.verboseAsm) { x; } while (0)
#define D2(x) /*do { x; } while (0)*/

static bool regalloc_dry_run;
static unsigned int regalloc_dry_run_cost_words;
static float regalloc_dry_run_cost_cycles;
static unsigned int regalloc_dry_run_cycle_scale = 1;

static struct
{
  short debugLine;
  struct
    {
      int pushed;
      int size;
      int param_offset;
    } stack;
  bool saved;

  /* Track content of p */
  struct
   {
     AOP_TYPE type;
     const char *base;
     int offset;
   } p;
}
G;

////////////////////////////////////////////////////////////////////////////////

typedef struct {
    char num;
    const char *name;
} tarn_reg_list_entry_t;

#define TARN_SRC_REG_COUNT 16

const tarn_reg_list_entry_t tarn_src_registers[TARN_SRC_REG_COUNT] = {
    { 0,  "nop" },
    { 1,  "p0" },
    { 2,  "intl" },
    { 3,  "inth" },
    { 4,  "do_reti" },
    { 5,  "x" },
    { 6,  "stack" },
    { 7,  "pic" },
    { 8,  "il" },
    { 9,  "jnz" },
    { 10, "mem" },
    { 11, "r" },
    { 12, "jump" },
    { 13, "zero" },
    { 14, "one" },
    { 15, "aluc" }
};

#define ALUS_AND   0
#define ALUS_XOR   2
#define ALUS_PLUS  4
#define ALUS_LT    9
#define ALUS_EQ    10
#define ALUS_GT    11
#define ALUS_MINUS 16

const char *alu_operations[] = {
    "and",
    "?",
    "xor",
    "?",

    "plus",
    "?",
    "?",
    "?",

    "?",
    "less-than",
    "equal-to",
    "greater-than",

    "?",
    "?",
    "?",
    "?",
    "minus",

};

////////////////////////////////////////////////////////////////////////////////

typedef struct {
    const char *name;
    int offset;
} remat_result_t;

/*-----------------------------------------------------------------*/
/* aopForRemat - rematerializes an object                          */
/*-----------------------------------------------------------------*/
static remat_result_t* resolve_remat (symbol *sym)
{
    static remat_result_t result;

    iCode *ic = sym->rematiCode;
    int val = 0;

    wassert_bt (ic);

    for (;;) {
        if (ic->op == '+') {
            if (isOperandLiteral (IC_RIGHT (ic))) {
                val += (int) operandLitValue (IC_RIGHT (ic));
                ic = OP_SYMBOL (IC_LEFT (ic))->rematiCode;
            } else {
                val += (int) operandLitValue (IC_LEFT (ic));
                ic = OP_SYMBOL (IC_RIGHT (ic))->rematiCode;
            }
        } else if (ic->op == '-') {
            val -= (int) operandLitValue (IC_RIGHT (ic));
            ic = OP_SYMBOL (IC_LEFT (ic))->rematiCode;
        } else if (ic->op == CAST) {
            ic = OP_SYMBOL (IC_RIGHT (ic))->rematiCode;
        } else if (ic->op == ADDRESS_OF) {
            val += (int) operandLitValue (IC_RIGHT (ic));
            break;
        } else
            wassert_bt (0);
    }

    result.name = OP_SYMBOL (IC_LEFT (ic))->rname;
    result.offset = val;
    return &result;

    /* if (OP_SYMBOL (IC_LEFT (ic))->onStack) { */
    /*     aop = newAsmop (AOP_STL); */
    /*     aop->aopu.stk_off = OP_SYMBOL (IC_LEFT (ic))->stack + (OP_SYMBOL (IC_LEFT (ic))->stack < 0 ? G.stack.param_offset : 0) + val; */
    /* } else { */
    /*     aop = newAsmop (AOP_IMMD); */
    /*     aop->aopu.immd = OP_SYMBOL (IC_LEFT (ic))->rname; */
    /*     aop->aopu.immd_off = val; */
    /*     aop->aopu.code = IN_CODESPACE (SPEC_OCLS (OP_SYMBOL (IC_LEFT (ic))->etype)); */
    /* } */

    /* aop->size = getSize (sym->type); */

    /* return aop; */
}

int label_num(symbol *label) {
    if (label) {
        return labelKey2num(label->key);
    }
    return 999;
}

symbol *new_label(const char *s) {
    if (regalloc_dry_run) {
        return NULL;
    }
    return newiTempLabel(s);
}

static bool
regDead (int idx, const iCode *ic)
{
  wassert (idx == R_IDX || idx == X_IDX);

  return (!bitVectBitValue (ic->rSurv, idx));
}

/*---------------------------------------------------------------------*/
/* emit2                                                               */
/*---------------------------------------------------------------------*/
static void emit2 (const char *inst, const char *fmt, ...)
{
  if (!regalloc_dry_run)
    {
      va_list ap;

      va_start (ap, fmt);
      va_emitcode (inst, fmt, ap);
      va_end (ap);
    }
}



static void tarn_emit_label(symbol *label) {
    if (!label) {
        return;
    }
    emitLabel(label);
    /* emit2("", "L_%d:", label_num(label)); */
    if (!regalloc_dry_run) {
        genLine.lineCurr->isLabel = 1;
    }
}

/* static void tarn_emit_label_n(int label) { */
/*     // emitLabel(label + offset); */
/*     emit2("", "%d:", label); */
/*     if (!regalloc_dry_run) { */
/*         genLine.lineCurr->isLabel = 1; */
/*     } */
/* } */

static void tarn_emit_label_f(const char *format, symbol *label) {
    if (!label) {
        return;
    }
    emitLabel(label);
    /* emit2("", format, label_num(label)); */
    //genLine.lineCurr->isLabel = 1;
}

static void
cost(unsigned int words)
{
  /* regalloc_dry_run_cost_words += words; */
  /* regalloc_dry_run_cost_cycles += cycles * regalloc_dry_run_cycle_scale; */
  regalloc_dry_run_cost_words += words;
  regalloc_dry_run_cost_cycles += words * regalloc_dry_run_cycle_scale;
}

static int is_mem(operand *op) {
    if (op->type == SYMBOL) {
        if (OP_SYMBOL(op)->remat) {
            return 0;
        }
        if (op->isParm) {
            return 1;
        }
        if (OP_SYMBOL(op)->isspilt) {
            return 1;
        }
        if (IN_REGSP (SPEC_OCLS (OP_SYMBOL(op)->etype))) {
            return 0;
        } else if (OP_SYMBOL(op)->regs[0]) {
            return 0;
        }
        if (OP_SYMBOL(op)->islocal) {
            return 1;
        }

        return 1;
    }

    return 0;
}

static int is_reg(operand *op) {
    if (op->type == SYMBOL) {
        if (OP_SYMBOL(op)->isspilt) {
            return 0;
        }
        if (IN_REGSP (SPEC_OCLS (OP_SYMBOL(op)->etype))) {
            return 1;
        } else if (OP_SYMBOL(op)->regs[0]) {
            return 1;
        }
        if (op->isParm) {
            return 0;
        }
        if (OP_SYMBOL(op)->islocal) {
            return 0;
        }
    }

    return 0;

}

const char *op_get_register_name(operand *op) {
    if (is_reg(op)) {
        if (op->type == SYMBOL) {
            if (!op->isParm) {
                if (!OP_SYMBOL(op)->isspilt) {
                    if (OP_SYMBOL(op)->regs[0]) {
                        if (!regalloc_dry_run) {
                            return OP_SYMBOL(op)->regs[0]->name;
                        }
                    } else if (IN_REGSP (SPEC_OCLS (OP_SYMBOL(op)->etype))) {
                        return tarn_src_registers[OP_SYMBOL(op)->etype->select.s._addr].name;
                    } else {
                        return OP_SYMBOL(op)->rname;
                    }
                }
            }
        }
    }
    return NULL;
}

const char *op_get_register_name_i(operand *op, int i) {
    if (is_reg(op)) {
        if (op->type == SYMBOL) {
            if (!op->isParm) {
                if (!OP_SYMBOL(op)->isspilt) {
                    if (IN_REGSP (SPEC_OCLS (OP_SYMBOL(op)->etype))) {
                        return tarn_src_registers[OP_SYMBOL(op)->etype->select.s._addr].name;
                    } else if (OP_SYMBOL(op)->regs[i]) {
                        if (!regalloc_dry_run) {
                            return OP_SYMBOL(op)->regs[i]->name;
                        }
                    } else {
                        return OP_SYMBOL(op)->rname;
                    }
                }
            }
        }
    }
    return NULL;
}

const char *op_get_mem_label(operand *op) {
    if (is_mem(op)) {
        if (op->type == SYMBOL) {
            if (OP_SYMBOL(op)->isspilt) {
                return OP_SYMBOL(op)->usl.spillLoc->rname;
            } else {
                return OP_SYMBOL(op)->rname;
            }
        }
    }
    return NULL;
}

/*---------------------------------------------------------------------*/
/* tarn_emitDebuggerSymbol - associate the current code location       */
/*   with a debugger symbol                                            */
/*---------------------------------------------------------------------*/
void tarn_emitDebuggerSymbol (const char *debugSym)
{
  G.debugLine = 1;
  emit2 ("", ";; debug symbol: %s ==.", debugSym);
  G.debugLine = 0;
}

/*-----------------------------------------------------------------*/
/* resultRemat - result is to be rematerialized                    */
/*-----------------------------------------------------------------*/
static bool resultRemat (const iCode *ic)
{
  if (SKIP_IC (ic) || ic->op == IFX)
    return 0;

  if (IC_RESULT (ic) && IS_ITEMP (IC_RESULT (ic)))
    {
      const symbol *sym = OP_SYMBOL_CONST (IC_RESULT (ic));

      if (!sym->remat)
        return(false);

      bool completely_spilt = TRUE;
      for (unsigned int i = 0; i < getSize (sym->type); i++)
        if (sym->regs[i])
          completely_spilt = FALSE;

      if (completely_spilt)
        return(true);
    }

  return (false);
}


void load_address_16(const char *sym_name) {
#if 0
    emit2("mov", "adh hi8(%s)", sym_name);
    emit2("mov", "adl lo8(%s)", sym_name);
#else
    emit2("lad", "%s", sym_name);
#endif
    cost(2);
}

void load_address_16o(const char *sym_name, int offset) {
#if 0
    emit2("mov", "adh hi8(%s + %d)", sym_name, offset);
    emit2("mov", "adl lo8(%s + %d)", sym_name, offset);
#else
    emit2("lad", "%s + %d", sym_name, offset);
#endif
    cost(2);
}


/*-----------------------------------------------------------------------*/
/* gen*                                                                  */
/*-----------------------------------------------------------------------*/

static void genCpl         (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genCpl          = "); piCode (ic, stderr); } emit2(";; genCpl         ", ""); }
static void genGetByte     (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genGetByte      = "); piCode (ic, stderr); } emit2(";; genGetByte     ", ""); }
static void genIpush       (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genIpush        = "); piCode (ic, stderr); } emit2(";; genIpush       ", ""); }
static void genJumpTab     (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genJumpTab      = "); piCode (ic, stderr); } emit2(";; genJumpTab     ", ""); }
static void genMult        (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genMult         = "); piCode (ic, stderr); } emit2(";; genMult        ", ""); }
static void genNot         (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genNot          = "); piCode (ic, stderr); } emit2(";; genNot         ", ""); }
static void genOr          (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genOr           = "); piCode (ic, stderr); } emit2(";; genOr          ", ""); }
static void genRightShift  (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genRightShift   = "); piCode (ic, stderr); } emit2(";; genRightShift  ", ""); }
static void genSwap        (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genSwap         = "); piCode (ic, stderr); } emit2(";; genSwap        ", ""); }
static void genUminus      (iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genUminus       = "); piCode (ic, stderr); } emit2(";; genUminus      ", ""); }



void load_reg(const char *reg, operand *op) {
    if (!reg) {
        if (!regalloc_dry_run) {
            emit2("", ";; load_reg: reg is null");
        }
        return;
    }

    if (IS_OP_LITERAL (op)) {
        if (byteOfVal(OP_VALUE(op), 0) == 0) {
            emit2("mov", "%s zero", reg);
            cost(1);
        } else {
            emit2("mov", "%s il ,%d", reg, byteOfVal(OP_VALUE(op), 0));
            cost(1);
        }
        return;
    }

    if (op->type == SYMBOL) {
        if (OP_SYMBOL(op)->remat) {
            remat_result_t *result = resolve_remat(OP_SYMBOL(op));
            D2(printf("has remat: %s + %d\n", result->name, result->offset));

            if (result->offset) {
                emit2("", ";; load_reg remat + N");
                emit2("mov", "adh il ,hi8(%s + %d)", result->name, result->offset);
                emit2("mov", "adl il ,lo8(%s + %d)", result->name, result->offset);
                emit2("mov", "%s mem", reg);
            } else {
                emit2("", ";; load_reg remat + 0");
                load_address_16(result->name);
                emit2("mov", "%s mem", reg);
                cost(1);
            }
        } else if (is_mem(op)) {
            if (!strcmp(reg, "mem")) {
                load_reg("stack", op);
                emit2("mov", "mem stack");
            } else {
                const char *label = op_get_mem_label(op);
                load_address_16(label);
                emit2("mov", "%s mem", reg);
                cost(1);
            }
        } else if (is_reg(op)) {
            const char *source_reg = op_get_register_name(op);
            emit2("mov", "%s %s", reg, source_reg);
            cost(1);
        } else {
            emit2("", ";; load_reg bad op(1)");
        }

        return;
    } else {
        emit2("", ";; load_reg bad op(2)");
    }

    emit2("; load_reg: op not suppoted", "");
}

void read_reg(const char *reg, operand *op) {
    if (IS_OP_LITERAL (op)) {
        emit2("; error:", "can't assign literal = %s", reg);
        return;
    }

    if (op->type == SYMBOL) {
        if (is_reg(op)) {
            const char *dest_reg = op_get_register_name(op);
            emit2("mov", "%s %s", dest_reg, reg);
            cost(1);
        } else if (is_mem(op)) {
            load_address_16(op_get_mem_label(op));
            emit2("mov", "mem %s", reg);
            cost(1);
        } else if (op->isParm) {
            load_address_16(OP_SYMBOL(op)->rname);
            emit2("mov", "mem %s", reg);
            cost(1);
        } else if (OP_SYMBOL(op)->regType == REG_CND) {
            emit2("mov", "test %s", reg);
            cost(1);
        } else if (OP_SYMBOL(op)->isspilt) {
            emit2(";", "read_reg: spilt");
            load_address_16(OP_SYMBOL(op)->usl.spillLoc->rname);
            emit2("mov", "mem %s", reg);
            cost(1);
        } else if (OP_SYMBOL(op)->nRegs == 1) {
            /* emit2("; ", "symbol is in reg %s", OP_SYMBOL(op)->regs[0]->name); */
            if (!regalloc_dry_run) {
                emit2("mov", "%s %s", OP_SYMBOL(op)->regs[0]->name, reg);
            }
            cost(1);
        } else {
            emit2("mov", "%s %s", OP_SYMBOL(op)->rname, reg);
            cost(1);
        }

        return;
    }

    emit2("; read_reg: op not suppoted", "");
}

static void emit_jump_to_label(symbol *target, int nz)
{
    const char *instruction;
    if (nz) {
        instruction = "gotonz";
    } else {
        instruction = "goto";
    }
    if (!regalloc_dry_run) {
        emit2(instruction, "!tlabel", label_num(target));
    }
    cost(1);
}


static void emit_jump_to_symbol(const char *name, int nz)
{
    const char *instruction;
    if (nz) {
        instruction = "gotonz";
    } else {
        instruction = "goto";
    }
    emit2(instruction, "%s", name);
    cost(1);
}

static void emit_jump_to_number(int address, int nz)
{
    const char *instruction;
    if (nz) {
        instruction = "gotonz";
    } else {
        instruction = "goto";
    }
    emit2(instruction, "%d", address);
    cost(1);
}

const char *to_string_op(unsigned int op) {
#define N_CASE(V) case V: return #V
    switch (op) {
        N_CASE(ARRAYINIT);
        N_CASE(BITWISEAND);
        N_CASE(CALL);
        N_CASE(CAST);
        N_CASE(CRITICAL);
        N_CASE(ENDCRITICAL);
        N_CASE(ENDFUNCTION);
        N_CASE(EQ_OP);
        N_CASE(FUNCTION);
        N_CASE(GET_VALUE_AT_ADDRESS);
        N_CASE(GE_OP);
        N_CASE(GOTO);
        N_CASE(INLINEASM);
        N_CASE(IPOP);
        N_CASE(IPUSH);
        N_CASE(JUMPTABLE);
        N_CASE(LABEL);
        N_CASE(LE_OP);
        N_CASE(NE_OP);
        N_CASE(PCALL);
        N_CASE(RECEIVE);
        N_CASE(SEND);

    case '%': return "'%'";
    case '*': return "'*'";
    case '+': return "'+'";
    case '-': return "'-'";
    case '/': return "'/'";
    case '<': return "'<'";
    case '=': return "'='";
    case '>': return "'>'";
    case '^': return "'^'";
    case '|': return "'|'";

    }


    return "(unknown)";


}

void print_ic_intelligibly(const iCode *ic) {
    /* printf("intelligible IC:\n\t%s (%d)\n", to_string_op(ic->op), ic->op); */
}

/*-----------------------------------------------------------------*/
/* genDummyRead - generate code for dummy read of volatiles        */
/*-----------------------------------------------------------------*/
static void genDummyRead (const iCode *ic)
{
  operand *op;

  if ((op = IC_LEFT (ic)) && IS_SYMOP (op))
    ;
  else if ((op = IC_RIGHT (ic)) && IS_SYMOP (op))
    ;
  else
    return;

  if (!regalloc_dry_run) { fprintf(stderr, "genDummyRead    = "); piCode (ic, stderr); } emit2(";; genDummyRead   ", "");

  if (strcmp("pic", op_get_register_name(op))) {
      load_reg("stack", op);
      emit2("mov", "nop stack");
  } else {
      emit2(";", "dummy read omitted for pic register");
  }
}
/*-----------------------------------------------------------------*/
/* genAddrOf - generates code for address of                       */
/*-----------------------------------------------------------------*/
static void genAddrOf (iCode *ic) {
    if (!regalloc_dry_run) { fprintf(stderr, "genAddrOf       = "); piCode (ic, stderr); }

    operand *result = IC_RESULT (ic);
    operand *left = IC_LEFT (ic);
    operand *right = IC_RIGHT (ic);

    emit2("", ";; genAddrOf: operand size %d, %d, %d", operandSize(result), operandSize(left), operandSize(right));

    if (is_mem(left)) {
        if (IS_OP_LITERAL(right)) {
            if (operandSize(result) == 1) {
                emit2("mov", "%s il ,%s + %d", op_get_register_name(result), op_get_mem_label(left), ulFromVal (OP_VALUE (right)));
            } else if (operandSize(result) == 2) {
                emit2("mov", "%s il ,lo8(%s + %d)", op_get_register_name_i(result, 0), op_get_mem_label(left), ulFromVal (OP_VALUE (right)));
                emit2("mov", "%s il ,hi8(%s + %d)", op_get_register_name_i(result, 1), op_get_mem_label(left), ulFromVal (OP_VALUE (right)));
            } else {
                emit2(";; genAddrOf", "result is too big; size=%d", operandSize(result));
            }
        } else {
            emit2(";; genAddrOf: non-literal right not handled", "");
        }
    } else {
        emit2(";; genAddrOf: non-memory left not handled", "");
    }
}

/*-----------------------------------------------------------------*/
/* genPointerGet - generate code for pointer get                   */
/*-----------------------------------------------------------------*/
static void genPointerGet(iCode *ic) {
    if (!regalloc_dry_run) { fprintf(stderr, "genPointerGet   = "); piCode (ic, stderr); }

    operand *left = IC_LEFT (ic);
    operand *right = IC_RIGHT (ic);
    operand *result = IC_RESULT (ic);
    int size_left = operandSize(left);

    wassertl (right, "GET_VALUE_AT_ADDRESS without right operand");
    wassertl (IS_OP_LITERAL (right), "GET_VALUE_AT_ADDRESS with non-literal right operand");

    emit2("", ";; genPointerGet: operand size %d, %d, %d",
          operandSize(left),
          operandSize(right),
          operandSize(result)
          );

    if (size_left == 1) {
        if (IS_OP_LITERAL(right)) {
            emit2(";; genPointerGet: literal right not implemented(1)", "");
        } else if (is_mem(right)) {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            /* load_reg("stack", right); */
            /* emit2("mov", "adh zero"); */
            /* emit2("mov", "adl %s", op_get_register_name(left)); */
            /* emit2("mov", "mem stack"); */
        } else {
            emit2(";; genPointerGet: non-memory right not implemented(1)", "");
        }
    } else if (size_left == 2) {
        if (IS_OP_LITERAL(right)) {
            int val = operandLitValue(right);
            if (OP_SYMBOL(left)->remat) {
                remat_result_t *remat_result = resolve_remat(OP_SYMBOL(left));
                D2(printf("has remat: %s + %d\n", remat_result->name, remat_result->offset));
                emit2("mov", "adh il ,hi8(%s + %d)", remat_result->name, remat_result->offset);
                emit2("mov", "adl il ,lo8(%s + %d)", remat_result->name, remat_result->offset);
                if (is_mem(result)) {
                    emit2("mov", "stack mem");
                    read_reg("stack", result);
                } else {
                    read_reg("mem", result);
                }
            } else {
                if (!val) {
                    if (OP_SYMBOL(left)->isspilt) {
                        emit2("load_address_from_ptr", "%s", op_get_mem_label(left));
                        read_reg("mem", result);
                    } else if (is_mem(left)) {
                        emit2("load_address_from_ptr", "%s", op_get_mem_label(left));

                        /* { // read 2 to stack */
                        /*     load_address_16o(op_get_mem_label(left), 0); */
                        /*     emit2("mov", "stack mem"); */
                        /*     load_address_16o(op_get_mem_label(left), 1); */
                        /*     emit2("mov", "stack mem"); */
                        /*     cost(2); */
                        /* } */
                        /* emit2("mov", "adl stack"); */
                        /* emit2("mov", "adh stack"); */
                        /* emit2("mov", "stack mem"); */
                        /* cost(3); */

                        /* { // read 2 to stack */
                        /*     load_address_16o(op_get_mem_label(left), 0); */
                        /*     emit2("mov", "stack mem"); */
                        /*     load_address_16o(op_get_mem_label(left), 1); */
                        /*     emit2("mov", "stack mem"); */
                        /*     cost(2); */
                        /* } */

                        /* emit2("add_16s_8", "%d", 1); */

                        /* emit2("mov", "adl stack"); */
                        /* emit2("mov", "adh stack"); */
                        /* emit2("mov", "stack mem"); */

                        /* emit2("mov", "adl stack"); */
                        /* emit2("mov", "adh stack"); */

                        /* cost(5); */


                        read_reg("mem", result);

                    } else if (is_reg(left)) {
                        emit2("lad", "%s",     op_get_mem_label(result));
                        emit2("mov", "mem %s", op_get_register_name_i(left, 0));
                        emit2("lad", "%s + 1", op_get_mem_label(result));
                        emit2("mov", "mem %s", op_get_register_name_i(left, 1));
                    } else {
                        emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    }
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
            }
            /* printf("remat stuff\n"); */
            /* printf("remat left = %p\n", OP_SYMBOL(left)->rematiCode); */
            /* piCode(OP_SYMBOL(left)->rematiCode, stdout); */
            /* printf("remat result left = %p\n", OP_SYMBOL(IC_RESULT(OP_SYMBOL(left)->rematiCode))->rematiCode); */
            /* piCode(OP_SYMBOL(IC_RESULT(OP_SYMBOL(left)->rematiCode))->rematiCode, stdout); */
            /* printf("remat left left = %p\n", OP_SYMBOL(IC_LEFT(OP_SYMBOL(left)->rematiCode))->rematiCode); */
            /* piCode(OP_SYMBOL(IC_LEFT(OP_SYMBOL(left)->rematiCode))->rematiCode, stdout); */
            /* printf("end remat stuff\n"); */

        } else if (is_mem(right)) {
            /* load_reg("stack", right); */
            /* emit2("mov", "adh zero"); */
            /* emit2("mov", "adl %s", op_get_register_name(left)); */
            /* emit2("mov", "mem stack"); */
            emit2(";; todo 4", "");
        } else {
            emit2(";; genPointerGet: non-memory right not implemented(2)", "");
        }
    } else {
        emit2(";; genPointerGet: left too big", "");
    }
}

/*-----------------------------------------------------------------*/
/* genPointerSet - stores the value into a pointer location        */
/*-----------------------------------------------------------------*/
static void genPointerSet(iCode *ic) {
    if (!regalloc_dry_run) { fprintf(stderr, "genPointerSet   = "); piCode (ic, stderr); }
    operand *left = IC_LEFT (ic);
    operand *right = IC_RIGHT (ic);
    int size_left = operandSize(left);

    emit2("", ";; genPointerSet: operand size %d, %d", operandSize(left), operandSize(right));

    if (size_left == 1) {
        if (IS_OP_LITERAL(right)) {
            emit2(";; genPointerSet: literal right not implemented(1)", "");
        } else if (is_mem(right)) {
            if (is_reg(left)) {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                load_reg("stack", right);
                emit2("mov", "adh zero");
                emit2("mov", "adl %s", op_get_register_name(left));
                emit2("mov", "mem stack");
                cost(3);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            emit2(";; genPointerSet: non-memory right not implemented(1)", "");
        }
    } else if (size_left == 2) {
        if (IS_OP_LITERAL(right)) {
            int val = operandLitValue(right);
            if (IS_SYMOP(left)) {
                if (OP_SYMBOL(left)->remat) {
                    if (IS_PTR(operandType(left))) {
                        emit2(";", "left is pointer: %d", __LINE__);
                    }
                    remat_result_t *result = resolve_remat(OP_SYMBOL(left));
                    D2(printf("has remat: %s + %d\n", result->name, result->offset));
                    emit2("mov", "adh il ,hi8(%s + %d)", result->name, result->offset);
                    emit2("mov", "adl il ,lo8(%s + %d)", result->name, result->offset);
                    emit2("mov", "mem il ,%d", val);
                    cost(3);
                } else if (OP_SYMBOL(left)->isspilt) {
                    // two-byte value is spilled...
                    if (IS_PTR(operandType(left))) {
                        emit2(";", "left is pointer: %d", __LINE__);
                    }
                    emit2("", "load_address_from_ptr %s", op_get_mem_label(left));
                    load_reg("mem", right);
                    cost(3);
                } else if (is_mem(left)) {
                    emit2("mov", "adh il ,hi8(%s + %d)", op_get_mem_label(left), byteOfVal(OP_VALUE(right), 0));
                    emit2("mov", "adl il ,lo8(%s + %d)", op_get_mem_label(left), byteOfVal(OP_VALUE(right), 0));
                    emit2("mov", "mem il ,%d", val);
                    cost(3);
                    /* if (is_mem(left)) { */
                    /*     emit2("", "; is mem"); */
                    /* } */
                    /* if (is_reg(left)) { */
                    /*     emit2("", "; is reg"); */
                    /* } */
                    /* if (OP_SYMBOL(left)->remat) { */
                    /*     emit2("", "; is remat"); */
                    /*     remat_result_t *result = resolve_remat(OP_SYMBOL(left)); */
                    /*     D2(emit2("", "has remat: %s + %d\n", result->name, result->offset)); */
                    /* } */

                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
                /* printf("remat stuff\n"); */
                /* printf("remat left = %p\n", OP_SYMBOL(left)->rematiCode); */
                /* piCode(OP_SYMBOL(left)->rematiCode, stdout); */
                /* printf("remat result left = %p\n", OP_SYMBOL(IC_RESULT(OP_SYMBOL(left)->rematiCode))->rematiCode); */
                /* piCode(OP_SYMBOL(IC_RESULT(OP_SYMBOL(left)->rematiCode))->rematiCode, stdout); */
                /* printf("remat left left = %p\n", OP_SYMBOL(IC_LEFT(OP_SYMBOL(left)->rematiCode))->rematiCode); */
                /* piCode(OP_SYMBOL(IC_LEFT(OP_SYMBOL(left)->rematiCode))->rematiCode, stdout); */
                /* printf("end remat stuff\n"); */
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else if (is_mem(right)) {
            if (is_reg(left)) {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                load_reg("stack", right);
                emit2("mov", "adh zero");
                emit2("mov", "adl %s", op_get_register_name(left));
                emit2("mov", "mem stack");
                cost(3);
            } else if (is_mem(left)) {
                if (!regalloc_dry_run) {
                    if (OP_SYMBOL(left)->isspilt) {
                        emit2(";", "left is spilt: %d", __LINE__);
                    }
                    if (IS_PTR(operandType(left))) {
                        emit2(";", "left is pointer: %d", __LINE__);
                    }
                    if (IS_TRUE_SYMOP(left)) {
                        emit2(";", "left is true symop: %d", __LINE__);
                    }
                    if (OP_SYMBOL(left)->remat) {
                        emit2(";", "left is remat: %d", __LINE__);
                    }
                    if (OP_SYMBOL(left)->usl.spillLoc) {
                        emit2(";", "left has spill location: %d", __LINE__);
                    }
                }
                // left has the address to write to
                // right is the value to write
                // first load the value
                load_address_16(op_get_mem_label(right));
                emit2("mov", "stack mem");
                // now write it
                emit2("load_address_from_ptr", "%s", op_get_mem_label(left));
                emit2("mov", "mem stack");
                cost(2);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            emit2(";; genPointerSet: non-memory right not implemented(2)", "");
        }
    } else {
        emit2(";; genPointerSet: left too big", "");
    }
}

/*-----------------------------------------------------------------*/
/* genCall - generates a call statement                            */
/*-----------------------------------------------------------------*/
static void
genCall (const iCode *ic)
{
  sym_link *dtype = operandType (IC_LEFT (ic));
  sym_link *etype = getSpec (dtype);
  sym_link *ftype = IS_FUNCPTR (dtype) ? dtype->next : dtype;
  /* bool tailjump = false; */

  /* operand *left = IC_LEFT (ic); */
  operand *result = IC_RESULT (ic);

  const bool bigreturn = (getSize (ftype->next) > 2) || IS_STRUCT (ftype->next);
  const bool returns_value =
      IS_TRUE_SYMOP (result)
      || (IS_ITEMP (result)
          && (OP_SYMBOL (result)->nRegs
              || OP_SYMBOL (result)->spildir));


  D2(emit2("", "\t;; call function"));

  if (bigreturn) {
      emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
      return;
  }

  if (ic->op == PCALL) {
      emit2("; What is a PCALL?", "");
  } else {
      bool pushed_r = false;
      bool pushed_x = false;

      if (!regDead (R_IDX, ic)) {
          emit2("mov", "stack r");
          pushed_r = true;
      }
      if (!regDead (X_IDX, ic)) {
          emit2("mov", "stack x");
          pushed_x = true;
      }

      symbol *label = new_label(NULL);
      emit2("mov", "stack il ,hi8(!tlabel)", label_num(label));
      emit2("mov", "stack il ,lo8(!tlabel)", label_num(label));

      if (IS_LITERAL (etype)) {
          emit_jump_to_number(ulFromVal (OP_VALUE (IC_LEFT (ic))), 0);
      } else {
          const char *name;
          if (OP_SYMBOL (IC_LEFT (ic))->rname[0]) {
              name = OP_SYMBOL (IC_LEFT (ic))->rname;
          } else {
              name = OP_SYMBOL (IC_LEFT (ic))->name;
          }
          emit_jump_to_symbol(name, 0);
      }

      tarn_emit_label(label);

      if (returns_value) {
          read_reg("stack", result);
      } else {
          emit2("\t; function returns nothing", "");
      }
      if (pushed_x) {
          if (!regDead (X_IDX, ic)) {
              emit2("mov", "x stack");
          } else  {
              emit2("mov", "nop stack");
          }
          cost(1);
      }
      if (pushed_r) {
          if (!regDead (R_IDX, ic)) {
              emit2("mov", "r stack");
          } else  {
              emit2("mov", "nop stack");
          }
          cost(1);
      }
  }

}


/*-----------------------------------------------------------------*/
/* genReturn - generate code for return statement                  */
/* Is called iff a function DOES return a value.                   */
/*-----------------------------------------------------------------*/
static void
genReturn (iCode *ic)
{
    operand *left = IC_LEFT (ic);

    if (left) {
        D2(emit2("\t;; return", ""));
        piCode(ic, stderr);

        emit2("mov", "jmpl stack");
        emit2("mov", "jmph stack");

        if (left) {
            load_reg("stack", left);
        }

        emit2("jump", "");
        cost(3);
    }

    /* if (!(ic->next && ic->next->op == LABEL && IC_LABEL (ic->next) == returnLabel)) { */
    /* } */

  /* if (!(ic->next && ic->next->op == LABEL && IC_LABEL (ic->next) == returnLabel)) */
  /*   if (!currFunc->stack && !IFFUNC_ISISR (currFunc->type)) */
  /*   { */
  /*     emit2 ("ret", ""); */
  /*     cost (2, 1); */
  /*   } */
  /*   else */
  /*     emitJP(returnLabel, 1.0f); */

}

/*-----------------------------------------------------------------*/
/* genEndFunction - generates epilogue for functions               */
/* Is called iff a function DOESN'T return a value.                */
/*-----------------------------------------------------------------*/
static void genEndFunction (iCode *ic)                   {
    if (!regalloc_dry_run) { fprintf(stderr, "genEndFunction  = "); piCode (ic, stderr); }

    // TODO don't generate for a function that has a return value...

    emit2(";; genEndFunction ", "");

    emit2("mov", "jmpl stack");
    emit2("mov", "jmph stack");
    emit2("jump", "");
    cost(3);
}

/*-----------------------------------------------------------------*/
/* genFunction - generated code for function entry                 */
/*-----------------------------------------------------------------*/
static void
genFunction (iCode *ic)
{
  const symbol *sym = OP_SYMBOL_CONST (IC_LEFT (ic));

  /* create the function header */
  emit2 (";", "-----------------------------------------");
  emit2 (";", " function %s", sym->name);
  emit2 (";", "-----------------------------------------");

  D (emit2 (";", tarn_assignment_optimal ? "Register assignment is optimal." : "Register assignment might be sub-optimal."));

  emit2 ("", "%s:", sym->rname);
}


/*-----------------------------------------------------------------*/
/* genAssign - generate code for assignment                        */
/*-----------------------------------------------------------------*/
static void
genAssign (iCode *ic)
{
  if (!regalloc_dry_run) {
      fprintf(stderr, "genAssign       = "); piCode (ic, stderr);
  }
  D2(emit2("\t;; assign", ""));

  operand *result = IC_RESULT (ic);
  operand *right = IC_RIGHT (ic);

  int size_result = operandSize(result);
  int size_right = operandSize(right);

  if (size_result == 1 && size_right == 1) {
      if (IS_SYMOP (result)) {
          if (IS_SYMOP (right)) {
              if (is_mem(right)) {
                  if (is_mem(result)) {
                      // buffer in stack so we can change addresses
                      load_reg("stack", right);
                      read_reg("stack", result);
                  } else {
                      const char *result_reg = op_get_register_name(result);
                      load_reg(result_reg, right);
                  }
              } else {
                  if (is_mem(result)) {
                      const char *result_reg = op_get_mem_label(result);
                      const char *right_reg = op_get_register_name(right);
                      load_address_16(result_reg);
                      emit2("mov", "mem %s", right_reg);
                      cost(1);
                  } else {
                      const char *result_reg = op_get_register_name(result);
                      const char *right_reg = op_get_register_name(right);
                      if (result_reg && right_reg && !strcmp(result_reg, right_reg)) {
                          emit2(";", "genAssign: registers %s, %s same; skipping assignment", result_reg, right_reg);
                      } else {
                          emit2("mov", "%s %s ; here", result_reg, right_reg);
                          cost(1);
                      }
                  }
              }
          } else if (IS_OP_LITERAL (right)) {
              if (is_mem(result)) {
                  load_address_16(op_get_mem_label(result));
                  if (byteOfVal(OP_VALUE(right), 0) == 0) {
                      emit2("mov", "mem zero");
                      cost(1);
                  } else {
                      emit2("mov", "mem il ,%d", byteOfVal(OP_VALUE(right), 0));
                      cost(1);
                  }
              } else {
                  if (byteOfVal(OP_VALUE(right), 0) == 0) {
                      emit2("mov", "%s zero", op_get_register_name(result));
                  } else {
                      emit2("mov", "%s il, %d",
                            op_get_register_name(result),
                            byteOfVal(OP_VALUE(right), 0));
                  }
                  cost(1);
              }



          } else {
              emit2("; genAssign: can't handle right", "");
          }
      } else {
          emit2("; genAssign: can't handle non-symbol result", "");
      }
  } else if (size_result == 2 && size_right == 2) {
      if (is_mem(result)) {
          if (is_mem(right)) {
              /* load_address_16(result_reg); */
              /* emit2("mov", "mem %s", right_reg); */

              emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
          } else if (is_reg(right)) {
              load_address_16(op_get_mem_label(result));
              emit2("mov", "mem %s ; hi", op_get_register_name_i(right, 1));
              load_address_16o(op_get_mem_label(result), 1);
              emit2("mov", "mem %s ; lo", op_get_register_name_i(right, 0));
              cost(2);
          } else if (IS_OP_LITERAL(right)) {
              emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
          } else if (OP_SYMBOL(right)->remat) {
              remat_result_t *remat_result = resolve_remat(OP_SYMBOL(right));
              emit2(";", "remat: %s + %d", remat_result->name, remat_result->offset);
              /* load_address_16o(remat_result->name, remat_result->offset); */
              /* emit2("mov", "stack mem ; hi"); */
              /* load_address_16o(remat_result->name, remat_result->offset + 1); */
              /* emit2("mov", "stack mem ; lo"); */

              load_address_16(op_get_mem_label(result));
              emit2("mov", "mem il ,hi8(%s + %d) ; hi", remat_result->name, remat_result->offset);
              load_address_16o(op_get_mem_label(result), 1);
              emit2("mov", "mem il ,lo8(%s + %d) ; lo", remat_result->name, remat_result->offset);
              cost(4);
          } else if (OP_SYMBOL(right)->isspilt) {
              emit2("load_address_from_ptr", "%s", OP_SYMBOL(right)->usl.spillLoc->rname);
              emit2("mov", "stack mem");
              emit2("load_address_from_ptr", "%s + 1", OP_SYMBOL(right)->usl.spillLoc->rname);
              emit2("mov", "stack mem");
              emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
              cost(2);
          } else {
              emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
          }
      } else if (is_reg(result)) {
          emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
          load_address_16(op_get_mem_label(right));
          emit2("mov", "%s mem ; hi", op_get_register_name_i(result, 1));
          load_address_16o(op_get_mem_label(right), 1);
          emit2("mov", "%s mem ; lo", op_get_register_name_i(result, 0));
          cost(2);
      } else {
          emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
      }
  } else {
      emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
  }
}

static void genCast(iCode *ic) {
    if (!regalloc_dry_run) { fprintf(stderr, "genCast         = "); piCode (ic, stderr); }
    emit2(";; genCast        ", "");

    genAssign(ic);
}


static void genIfx_impl(iCode *ic, int invert) {
    if (!regalloc_dry_run) { fprintf(stderr, "genIfx          = "); piCode (ic, stderr); }

    operand *const cond = IC_COND (ic);
    symbol *t;
    symbol *f;

    D2(emit2("\t;; If x", ""));

    if (IS_OP_LITERAL (cond)) {
        emit2("; genIfx: op is literal", "");
        return;
    }

    if (IS_SYMOP (cond)) {
        if (OP_SYMBOL(cond)->regType == REG_CND)  {
            // don't need to do anything; has already been loaded.
        } else {
            // Check if it equals zero and invert.
            load_reg("alua", cond);
            emit2("mov", "alus il ,%d\t; %s ", ALUS_EQ, alu_operations[ALUS_EQ]);
            emit2("mov", "alub zero");
            emit2("mov", "test aluc");
            cost(4);
            invert = 1 - invert;
        }
    }


    /* Description of IFX:

       Conditional jump. If true label is present then jump to true
       label if condition is true else jump to false label if
       condition is false

       if (IC_COND) goto IC_TRUE;
       Or
       If (!IC_COND) goto IC_FALSE;
    */

    if (invert) {
        t = IC_FALSE(ic);
        f = IC_TRUE(ic);
    } else {
        t = IC_TRUE(ic);
        f = IC_FALSE(ic);
    }

    if (t) {
        emit_jump_to_label(t, 1);
        return;
    }

    if (f) {
        // We jump to f if the condition is FALSE, so we make a new
        // label and jump OVER the jnz instruction if the condition is
        // TRUE.
        symbol *label = new_label(NULL);
        emit_jump_to_label(label, 1);
        emit_jump_to_label(f, 0);
        tarn_emit_label(label);
        return;
    }

    emit2("; genIfx: op is unknown", "");
}

/*-----------------------------------------------------------------*/
/* genIfx - generate code for Ifx statement                        */
/*-----------------------------------------------------------------*/
static void genIfx (iCode *ic)
{
    genIfx_impl(ic, 0);
}

static void genALUOp_impl(int op, operand *left, operand *right, operand *result, iCode *ifx) {
    emit2(";;", "ALU %s (%d)", alu_operations[op], op);

    bool result_is_cond = OP_SYMBOL(result)->regType == REG_CND;
    int size_result = operandSize(result);
    int size_left = operandSize(left);
    int size_right = operandSize(right);


    if ((size_result == 1 || result_is_cond) && size_left == 1 && size_right == 1) {
        if (op == ALUS_MINUS) {
            if (IS_OP_LITERAL(right)) {
                op = ALUS_PLUS;
                emit2("mov", "alus il ,%d\t; %s ", op, alu_operations[op]);
                load_reg("alua", left);
                emit2("mov", "alub il ,%d", -byteOfVal(OP_VALUE(right), 0));
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            emit2("mov", "alus il ,%d\t; %s ", op, alu_operations[op]);
            cost(1);

            load_reg("alua", left);
            load_reg("alub", right);
        }

        if (ifx) {
            // TODO: optimize?

            // We can only cast to boolean by checking equality against
            // zero, and then negating the condition of the ifx
            // (equivalently, inverting its jumps).
            emit2("", ";; ALU op has ifx!", op);
            emit2("mov", "alua aluc");
            emit2("mov", "alus il ,%d\t; %s ", ALUS_EQ, alu_operations[ALUS_EQ]);
            emit2("mov", "alub zero");
            emit2("mov", "test aluc");
            cost(4);

            genIfx_impl(ifx, 1);
        } else {
            read_reg("aluc", result);
        }
    } else if (size_result == 2 && size_left == 2 && size_right == 1) {
        if (op == ALUS_PLUS) {
            if (is_reg(right)) {
                if (OP_SYMBOL(left)->remat) {
                    remat_result_t *result = resolve_remat(OP_SYMBOL(left));
                    D2(emit2(";", "remat: %s + %d", result->name, result->offset));
                    piCode(OP_SYMBOL(left)->rematiCode, stdout);
                    emit2("mov", "stack %s", op_get_register_name(right));
                    emit2("add_8s_16", "%s ; 1", result->name);
                } else if (OP_SYMBOL(left)->isspilt) {
                    D2(emit2(";", "left is spilt"));
                    emit2("mov", "stack il ,hi8(%s)", OP_SYMBOL(left)->usl.spillLoc->rname);
                    emit2("mov", "stack il ,lo8(%s)", OP_SYMBOL(left)->usl.spillLoc->rname);
                    load_address_16(op_get_mem_label(right));
                    emit2("mov", "stack mem");
                    emit2("add_8s_16s", "");
                    cost(3);
                } else if (is_mem(left)) {
                    emit2("load_stack_from_ptr", "%s", op_get_mem_label(left));
                    /* load_address_16(op_get_mem_label(left)); */
                    /* emit2("mov", "stack mem"); */
                    /* load_address_16(op_get_mem_label(left)); */
                    /* emit2("mov", "stack mem"); */
                    /* emit2("mov", "adl stack"); */
                    /* emit2("mov", "adh stack"); */
                    /* emit2("mov", "stack mem"); */

                    /* load_address_16o(op_get_mem_label(left), 1); */
                    /* emit2("mov", "stack mem"); */
                    /* load_address_16o(op_get_mem_label(left), 1); */
                    /* emit2("mov", "stack mem"); */
                    /* emit2("mov", "adl stack"); */
                    /* emit2("mov", "adh stack"); */
                    /* emit2("mov", "stack mem"); */


                    emit2("mov", "stack %s", op_get_register_name(right));
                    emit2("add_8s_16s", "");
                    cost(1);
                } else {
                    emit2("", "; I AM BROKEN (%s:%d)", __FILE__, __LINE__);
                    /* emit2("add_8s_2x8r", "%s %s %s ; 3", */
                    /*       op_get_register_name(right), */
                    /*       op_get_register_name_i(left, 0), */
                    /*       op_get_register_name_i(left, 1)); */
                }
            } else if (is_mem(right)) {
                if (OP_SYMBOL(left)->remat) {
                    remat_result_t *result = resolve_remat(OP_SYMBOL(left));
                    D2(emit2("", "\t; remat: %s + %d", result->name, result->offset));
                    emit2("mov", "stack il ,hi8(%s + %d)", result->name, result->offset);
                    emit2("mov", "stack il ,lo8(%s + %d)", result->name, result->offset);
                    load_address_16(op_get_mem_label(right));
                    emit2("mov", "stack mem");
                    emit2("add_8s_16s", "");
                    cost(3);
                } else if (OP_SYMBOL(left)->isspilt) {
                    emit2("mov", "stack il ,hi8(%s)", OP_SYMBOL(left)->usl.spillLoc->rname);
                    emit2("mov", "stack il ,lo8(%s)", OP_SYMBOL(left)->usl.spillLoc->rname);
                    load_address_16(op_get_mem_label(right));
                    emit2("mov", "stack mem");
                    emit2("add_8s_16s", "");
                    cost(3);
                } else if (is_mem(left)) {
                    if (!regalloc_dry_run) {
                        emit2("mov", "stack il ,hi8(%s)", OP_SYMBOL(left)->rname);
                        emit2("mov", "stack il ,lo8(%s)", OP_SYMBOL(left)->rname);
                        load_address_16(op_get_mem_label(right));
                        emit2("mov", "stack mem");
                        emit2("add_8s_16s", "");
                        cost(3);
                    }
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
            } else if (IS_OP_LITERAL(right)) {
                if (OP_SYMBOL(left)->remat) {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                } else if (OP_SYMBOL(left)->isspilt) {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                } else if (is_mem(left)) {
                    load_address_16(op_get_mem_label(left));
                    emit2("mov", "stack mem");
                    load_address_16o(op_get_mem_label(left), 1);
                    emit2("mov", "stack mem");
                    emit2("add_16s_16l", "%lu", ulFromVal (OP_VALUE(right)));
                    cost(2);
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
            // cost?

            if (op_get_register_name_i(result, 0)
                && op_get_register_name_i(result, 1)
                && !strcmp(op_get_register_name_i(result, 0), "r")
                && !strcmp(op_get_register_name_i(result, 1), "x")) {
                emit2(";", "result is already in r x");
            } else {
                if (!regalloc_dry_run) {
                    if (IS_TRUE_SYMOP(result)) {
                        emit2(";", "result is true symop: %d", __LINE__);
                    }
                    if (IS_PTR(operandType(result))) {
                        emit2(";", "result is pointer");
                    }
                    if (OP_SYMBOL(result)->usl.spillLoc) {
                        emit2(";", "result has spill location: %d", __LINE__);
                    }
                }
                /* if (OP_SYMBOL(result)->isspilt) { */
                /*     emit2(";", "result is spilt: %d", __LINE__); */
                /*     emit2("load_address_from_ptr", "%s", OP_SYMBOL(result)->usl.spillLoc->rname); */
                /*     emit2("mov", "mem x"); */
                /*     emit2("load_address_from_ptr", "%s + 1", OP_SYMBOL(result)->usl.spillLoc->rname); */
                /*     emit2("mov", "mem r"); */
                /* } else */
                    if (is_mem(result)) {
                    emit2("lad", "%s",     op_get_mem_label(result));
                    emit2("mov", "mem x");
                    emit2("lad", "%s + 1", op_get_mem_label(result));
                    emit2("mov", "mem r");
                    cost(6);
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    cost(1000);
                }
                /* emit2("mov", "stack r"); */
                /* emit2("mov", "stack x"); */
                /* emit2("mov", "%s stack", op_get_register_name_i(result, 1)); */
                /* emit2("mov", "%s stack", op_get_register_name_i(result, 0)); */
                /* cost(4); */

                emit2("restore_rx", "");
                cost(6);
            }
        } else {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }
    } else {
        if (!regalloc_dry_run) {
            emit2("", "; implement me (%s:%d) (%d, %d, %d, %s)", __FILE__, __LINE__,
                  size_result, size_left, size_right, op_get_mem_label(result));

        }
    }

}

static void genALUOp(int op, iCode *ic, iCode *ifx)
{
    if (!regalloc_dry_run) { piCode(ic, stdout); }

    operand *result = IC_RESULT (ic);
    operand *left = IC_LEFT (ic);
    operand *right = IC_RIGHT (ic);

    genALUOp_impl(op, left, right, result, ifx);
}


/*-----------------------------------------------------------------*/
/* genAnd - code for and                                           */
/*-----------------------------------------------------------------*/
static void genAnd   (iCode *ic, iCode *ifx) { genALUOp(ALUS_AND,   ic, ifx ); }
static void genPlus  (iCode *ic)             { genALUOp(ALUS_PLUS,  ic, NULL); }
static void genXor   (iCode *ic)             { genALUOp(ALUS_XOR,   ic, NULL); }
static void genMinus (iCode *ic, iCode *ifx) { genALUOp(ALUS_MINUS, ic, ifx); }

/*-----------------------------------------------------------------*/
/* genLeftShift - generates code for right shifting                */
/*-----------------------------------------------------------------*/
static void
genLeftShift (const iCode *ic)
{
  operand *result = IC_RESULT (ic);
  operand *left = IC_LEFT (ic);
  operand *right = IC_RIGHT (ic);

  if (IS_OP_LITERAL(right)) {
      if (byteOfVal(OP_VALUE(right), 0) == 1) {
          // one bit, multiply by two, ie. add self to self.
          genALUOp_impl(ALUS_PLUS, left, left, result, NULL);
      } else {
          wassertl(0, "Left shift by more than one not implemented.");
      }
  } else {
      wassertl(0, "Left shift by non-literal not implemented.");
  }
}



/*-----------------------------------------------------------------*/
/* genGoto - generates a jump                                      */
/*-----------------------------------------------------------------*/
static void
genGoto (const iCode *ic)
{
    D2(emit2("\t;; goto", ""));
    emit_jump_to_label (IC_LABEL (ic), 0);
}


static void genCmpEQorNE   (iCode *ic, iCode *ifx)       {
    if (!regalloc_dry_run) { fprintf(stderr, "genCmpEQorNE    = "); piCode (ic, stderr); }

    D2(emit2("\t;; test equality", ""));
    emit2("mov", "alus il ,%d\t; %s ", ALUS_EQ, alu_operations[ALUS_EQ]);
    cost(1);

    operand *left = IC_LEFT(ic);
    operand *right = IC_RIGHT(ic);
    operand *result = IC_RESULT(ic);

    if (IS_SYMOP(result) && OP_SYMBOL(result)->regType == REG_CND) {
        load_reg("alua", left);
        load_reg("alub", right);
        emit2("mov", "test aluc");
        cost(1);
    } else {
        if (is_reg(left)) {
            load_reg("alua", left);
        } else if (is_mem(left)) {
            load_address_16(op_get_mem_label(left));
            emit2("mov", "alua mem");
        } else if (IS_OP_LITERAL(left)) {
            load_reg("alua", left);
        } else {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }

        if (is_reg(right)) {
            load_reg("alub", right);
        } else if (is_mem(right)) {
            load_address_16(op_get_mem_label(right));
            emit2("mov", "alub mem");
        } else if (IS_OP_LITERAL(right)) {
            load_reg("alua", right);
        } else {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }

        read_reg("aluc", result);
        cost(1);
    }

    if (ifx) {
        genIfx(ifx);
    } else {
        emit2(";", "no ifx");
    }
}

static void genCmp   (iCode *ic, iCode *ifx)       {
    if (!regalloc_dry_run) { fprintf(stderr, "genCmpEQorNE    = "); piCode (ic, stderr); }

    D2(emit2("\t;; compare", ""));
    if (ic->op == '>') {
        emit2("mov", "alus il ,%d\t; %s ", ALUS_GT, alu_operations[ALUS_GT]);
        cost(1);
    } else {
        emit2("mov", "alus il ,%d\t; %s ", ALUS_LT, alu_operations[ALUS_LT]);
        cost(1);
    }

    if (OP_SYMBOL(IC_RESULT(ic))->regType == REG_CND) {
        load_reg("alua", IC_LEFT(ic));
        load_reg("alub", IC_RIGHT(ic));
        /* read_reg("aluc", IC_RESULT(ic)); */
        emit2("mov", "test aluc");
        cost(1);
    } else {
        emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
    }

    if (ifx) {
        genIfx(ifx);
    }
}


/*-----------------------------------------------------------------*/
/* genLabel - generates a label                                    */
/*-----------------------------------------------------------------*/
static void genLabel (const iCode *ic)
{
    D2(emit2 (";; genLabel", ""));
    /* printf("genLabel: "); */
    /* piCode(ic, stdout); */

    /* special case never generate */
    if (IC_LABEL (ic) == entryLabel)
        return;

    /* special case never generate ??? */
    /* if (IC_LABEL (ic) == returnLabel) */
    /*     return; */

    if (options.debug /*&& !regalloc_dry_run*/)
        debugFile->writeLabel (IC_LABEL (ic), ic);

    tarn_emit_label(IC_LABEL(ic));

    // G.p.type = AOP_INVALID;
}



/*-----------------------------------------------------------------------*/
/* genTarniCode - generate code for PADAUK for a single iCode instruction */
/*-----------------------------------------------------------------------*/
static void
genTarniCode (iCode *ic)
{
  genLine.lineElement.ic = ic;

  if (resultRemat (ic))
    {
      if (!regalloc_dry_run)
        D (emit2 ("; skipping iCode since result will be rematerialized", ""));
      return;
    }

  if (ic->generated)
    {
      //if (!regalloc_dry_run)
        D (emit2 ("; skipping generated iCode", ""));
      return;
    }

  switch (ic->op)
    {
    case '!':
      genNot (ic);
      break;

    case '~':
      genCpl (ic);
      break;

    case UNARYMINUS:
      genUminus (ic);
      break;

    case IPUSH:
      genIpush (ic);
      break;

    case IPOP:
      wassertl (0, "Unimplemented iCode");
      break;

    case CALL:
    case PCALL:
      genCall (ic);
      break;

    case FUNCTION:
      genFunction (ic);
      break;

    case ENDFUNCTION:
      genEndFunction (ic);
      break;

   case RETURN:
      genReturn (ic);
      break;

    case LABEL:
      genLabel (ic);
      break;

    case GOTO:
      genGoto (ic);
      break;

    case '+':
      genPlus (ic);
      break;

    case '-':
      genMinus (ic, ic->next && ic->next->op == IFX ? ic->next : 0);
      break;

    case '*':
      genMult (ic);
      break;

    case '/':
    case '%':
      wassertl (0, "Unimplemented iCode");
      break;

    case '>':
    case '<':
      genCmp (ic, ifxForOp (IC_RESULT (ic), ic));
      break;

    case LE_OP:
    case GE_OP:
      wassertl (0, "Unimplemented iCode");
      break;

    case NE_OP:
    case EQ_OP:
      genCmpEQorNE (ic, ifxForOp (IC_RESULT (ic), ic));
      break;

    case AND_OP:
    case OR_OP:
      wassertl (0, "Unimplemented iCode");
      break;

    case '^':
      genXor (ic);
      break;

    case '|':
      genOr (ic);
      break;

    case BITWISEAND:
      genAnd (ic, ifxForOp (IC_RESULT (ic), ic));
      break;

    case INLINEASM:
      genInline (ic);
      break;

    case RRC:
    case RLC:
      wassertl (0, "Unimplemented iCode");
      break;

    case GETABIT:
      wassertl (0, "Unimplemented iCode");
      break;

    case GETBYTE:
      genGetByte (ic);
      break;

    case GETWORD:
      wassertl (0, "Unimplemented iCode");
      break;

    case SWAP:
      genSwap (ic);
      break;

    case LEFT_OP:
      genLeftShift (ic);
      break;

    case RIGHT_OP:
      genRightShift (ic);
      break;

    case GET_VALUE_AT_ADDRESS:
      genPointerGet (ic);
      break;

    case SET_VALUE_AT_ADDRESS:
      genPointerSet (ic);
      break;

    case '=':
      wassert (!POINTER_SET (ic));
      genAssign (ic);
      break;

    case IFX:
      genIfx (ic);
      break;

    case ADDRESS_OF:
      genAddrOf (ic);
      break;

    case JUMPTABLE:
      genJumpTab (ic);
      break;

    case CAST:
      genCast (ic);
      break;

    case RECEIVE:
    case SEND:
      wassertl (0, "Unimplemented iCode");
      break;

    case DUMMY_READ_VOLATILE:
      genDummyRead (ic);
      break;

    case CRITICAL:
      wassertl (0, "Unimplemented iCode: Critical section");
      break;

    case ENDCRITICAL:
      wassertl (0, "Unimplemented iCode: Critical section");
      break;

    default:
      fprintf (stderr, "iCode op %d:\n", ic->op);
      wassertl (0, "Unknown iCode");
    }
}

float dryTarniCode (iCode *ic)
{
  regalloc_dry_run = true;
  regalloc_dry_run_cost_words = 0;
  regalloc_dry_run_cost_cycles = 0;

  initGenLineElement ();

  genTarniCode (ic);

  G.p.type = AOP_INVALID;

  destroy_line_list ();

  wassert (regalloc_dry_run);

  const unsigned int word_cost_weight = 2 << (optimize.codeSize * 3 + !optimize.codeSpeed * 3);

  return (regalloc_dry_run_cost_words * word_cost_weight + regalloc_dry_run_cost_cycles * ic->count);
}


/*---------------------------------------------------------------------*/
/* genTarnCode - generate code for Padauk for a block of instructions   */
/*---------------------------------------------------------------------*/
void
genTarnCode (iCode *lic)
{
  int clevel = 0;
  int cblock = 0;
  int cln = 0;
  regalloc_dry_run = false;

  /* if debug information required */
  if (options.debug && currFunc && !regalloc_dry_run)
    debugFile->writeFunction (currFunc, lic);

  if (options.debug && !regalloc_dry_run)
    debugFile->writeFrameAddress (NULL, NULL, 0); /* have no idea where frame is now */

  for (iCode *ic = lic; ic; ic = ic->next) {
      initGenLineElement ();

      genLine.lineElement.ic = ic;

      if (ic->level != clevel || ic->block != cblock)
          {
              if (options.debug)
                  debugFile->writeScope (ic);
              clevel = ic->level;
              cblock = ic->block;
          }

      if (ic->lineno && cln != ic->lineno)
          {
              if (options.debug)
                  debugFile->writeCLine (ic);

              if (!options.noCcodeInAsm)
                  emit2 (";", "%s: %d: %s", ic->filename, ic->lineno, printCLine (ic->filename, ic->lineno));
              cln = ic->lineno;
          }

      regalloc_dry_run_cost_words = 0;
      regalloc_dry_run_cost_cycles = 0;

      if (options.iCodeInAsm)
          {
              const char *iLine = printILine (ic);
              emit2 ("; ic:", "%d: %s", ic->key, iLine);
              dbuf_free (iLine);
          }

      genTarniCode(ic);

#if 0
      D2(emit2 (";", "Cost for generated ic %d : (%d, %f)", label_num(ic), regalloc_dry_run_cost_words, regalloc_dry_run_cost_cycles));
#endif
  }

  if (options.debug)
    debugFile->writeFrameAddress (NULL, NULL, 0); /* have no idea where frame is now */

  /* now we are ready to call the
     peephole optimizer */
  if (!options.nopeep)
    peepHole (&genLine.lineHead);

  /* now do the actual printing */
  printLine (genLine.lineHead, codeOutBuf);

  G.p.type = AOP_INVALID;

  /* destroy the line list */
  destroy_line_list ();
}
