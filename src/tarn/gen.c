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

/* Use the D macro for basic (unobtrusive) debugging messages */
#define D(x) do if (options.verboseAsm) { x; } while (0)
#define D2(x) do { x; } while (0)

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

/*---------------------------------------------------------------------*/
/* tarn_emitDebuggerSymbol - associate the current code location        */
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


/*-----------------------------------------------------------------------*/
/* gen*                                                                  */
/*-----------------------------------------------------------------------*/

static void genAddrOf      (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genAddrOf       = "); piCode (ic, stderr); } emit2(";; genAddrOf      ", ""); }
/* static void genAnd         (const iCode *ic, iCode *ifx)       { if (!regalloc_dry_run) { fprintf(stderr, "genAnd          = "); piCode (ic, stderr); } emit2(";; genAnd         ", ""); } */
/* static void genAssign      (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genAssign       = "); piCode (ic, stderr); } emit2(";; genAssign      ", ""); } */
/* static void genCall        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genCall         = "); piCode (ic, stderr); } emit2(";; genCall        ", ""); } */
static void genCast        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genCast         = "); piCode (ic, stderr); } emit2(";; genCast        ", ""); }
/* static void genCmp         (const iCode *ic, iCode *ifx)       { if (!regalloc_dry_run) { fprintf(stderr, "genCmp          = "); piCode (ic, stderr); } emit2(";; genCmp         ", ""); } */
/* static void genCmpEQorNE   (const iCode *ic, iCode *ifx)       { if (!regalloc_dry_run) { fprintf(stderr, "genCmpEQorNE    = "); piCode (ic, stderr); } emit2(";; genCmpEQorNE   ", ""); } */
static void genCpl         (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genCpl          = "); piCode (ic, stderr); } emit2(";; genCpl         ", ""); }
static void genDummyRead   (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genDummyRead    = "); piCode (ic, stderr); } emit2(";; genDummyRead   ", ""); }
static void genEndFunction (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genEndFunction  = "); piCode (ic, stderr); } emit2(";; genEndFunction ", ""); }
/* static void genFunction    (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genFunction     = "); piCode (ic, stderr); } emit2(";; genFunction    ", ""); } */
static void genGetByte     (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genGetByte      = "); piCode (ic, stderr); } emit2(";; genGetByte     ", ""); }
/* static void genGoto        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genGoto         = "); piCode (ic, stderr); } emit2(";; genGoto        ", ""); } */
/* static void genIfx         (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genIfx          = "); piCode (ic, stderr); } emit2(";; genIfx         ", ""); } */
static void genIpush       (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genIpush        = "); piCode (ic, stderr); } emit2(";; genIpush       ", ""); }
static void genJumpTab     (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genJumpTab      = "); piCode (ic, stderr); } emit2(";; genJumpTab     ", ""); }
/* static void genLabel       (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genLabel        = "); piCode (ic, stderr); } emit2(";; genLabel       ", ""); } */
/* static void genLeftShift   (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genLeftShift    = "); piCode (ic, stderr); } emit2(";; genLeftShift   ", ""); } */
static void genMinus       (const iCode *ic, const iCode *ifx) { if (!regalloc_dry_run) { fprintf(stderr, "genMinus        = "); piCode (ic, stderr); } emit2(";; genMinus       ", ""); }
static void genMult        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genMult         = "); piCode (ic, stderr); } emit2(";; genMult        ", ""); }
static void genNot         (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genNot          = "); piCode (ic, stderr); } emit2(";; genNot         ", ""); }
static void genOr          (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genOr           = "); piCode (ic, stderr); } emit2(";; genOr          ", ""); }
/* static void genPlus        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genPlus         = "); piCode (ic, stderr); } emit2(";; genPlus        ", ""); } */
static void genPointerGet  (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genPointerGet   = "); piCode (ic, stderr); } emit2(";; genPointerGet  ", ""); }
static void genPointerSet  (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genPointerSet   = "); piCode (ic, stderr); } emit2(";; genPointerSet  ", ""); }
/* static void genReturn      (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genReturn       = "); piCode (ic, stderr); } emit2(";; genReturn      ", ""); } */
static void genRightShift  (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genRightShift   = "); piCode (ic, stderr); } emit2(";; genRightShift  ", ""); }
static void genSwap        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genSwap         = "); piCode (ic, stderr); } emit2(";; genSwap        ", ""); }
static void genUminus      (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genUminus       = "); piCode (ic, stderr); } emit2(";; genUminus      ", ""); }
/* static void genXor         (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genXor          = "); piCode (ic, stderr); } emit2(";; genXor         ", ""); } */

void load_reg(const char *reg, operand *op) {
    if (regalloc_dry_run) {
        return;
    }

    if (IS_OP_LITERAL (op)) {
        emit2("mov", "%s il ,%d", reg, byteOfVal(OP_VALUE(op), 0));
        return;
    }

    if (op->type == SYMBOL) {
        if (op->isParm) {
            // parameters are addresses by default
            // but really we want to pass them on the stack...
            load_address_16(OP_SYMBOL(op)->rname);
            emit2("mov", "%s mem", reg);
        } else {
            // test if has reg...
            if (OP_SYMBOL(op)->isspilt) {
                emit2("mov", "%s %s", reg, OP_SYMBOL(op)->usl.spillLoc->rname);
            } else {
                emit2("mov", "%s %s", reg, OP_SYMBOL(op)->regs[0]->name);
            }
        }
        return;
    } else {
        emit2("", ";; genALUOp %d bad op", op);
    }

    /* if (op->type == SYMBOL) { */
    /*     if (op->isParm) { */
    /*         // parameters are addresses by default */
    /*         // but really we want to pass them on the stack... */
    /*         /\* emit2("; symbol is parameter", ""); *\/ */
    /*         load_address_16(OP_SYMBOL(op)->rname); */
    /*         emit2("mov", "%s mem ,0", reg); */
    /*         return; */
    /*     } */

    /*     emit2("", "; symbol has %d regs", OP_SYMBOL(op)->nRegs); */
    /*     // if (OP_SYMBOL(op)->nRegs) */

    /*     // something else? */
    /*     if (op->isaddr) { */
    /*         emit2("; symbol is addr", ""); */
    /*     } */
    /*     if (op->isPtr) { */
    /*         emit2("; symbol is pointer", ""); */
    /*     } */
    /*     emit2("mov", "%s %s ,0", reg, OP_SYMBOL(op)->rname); */
    /*     return; */
    /* } */

    emit2("; load_reg: op not suppoted", "");
}

void read_reg(const char *reg, operand *op) {
    if (regalloc_dry_run) {
        return;
    }

    if (IS_OP_LITERAL (op)) {
        emit2("; error:", "can't assign literal = %s", reg);
        return;
    }

    if (op->type == SYMBOL) {
        if (OP_SYMBOL(op)->nRegs == 1) {
            /* emit2("; ", "symbol is in reg %s", OP_SYMBOL(op)->regs[0]->name); */
            emit2("mov", "%s %s ,0", OP_SYMBOL(op)->regs[0]->name, reg);
            return;
        }

        emit2("mov", "%s %s ,0", OP_SYMBOL(op)->rname, reg);
        return;
    }

    emit2("; read_reg: op not suppoted", "");
}

static void emit_jump_to_label(const symbol *target, int nz)
{
    if (!regalloc_dry_run) {
        const char *instruction;
        if (nz) {
            instruction = "gotonz";
        } else {
            instruction = "goto";
        }
        emit2(instruction, "L_%05d", labelKey2num(target->key));
    }
}

static void emit_jump_to_symbol(const char *name, int nz)
{
    if (!regalloc_dry_run) {
        const char *instruction;
        if (nz) {
            instruction = "gotonz";
        } else {
            instruction = "goto";
        }
        emit2(instruction, "%s", name);
    }
}

static void emit_jump_to_number(int address, int nz)
{
    if (!regalloc_dry_run) {
        const char *instruction;
        if (nz) {
            instruction = "gotonz";
        } else {
            instruction = "goto";
        }
        emit2(instruction, "%d", address);
    }
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
    printf("intelligible IC:\n\t%s (%d)\n", to_string_op(ic->op), ic->op);
}
/*     typedef struct iCode */
/* { */
/*   unsigned int op;              /\* operation defined *\/ */
/*   int key;                      /\* running key for this iCode *\/ */
/*   int seq;                      /\* sequence number within routine *\/ */
/*   int seqPoint;                 /\* sequence point *\/ */
/*   short depth;                  /\* loop depth of this iCode *\/ */
/*   long level;                   /\* scope level *\/ */
/*   short block;                  /\* sequential block number *\/ */
/*   unsigned nosupdate:1;         /\* don't update spillocation with this *\/ */
/*   unsigned generated:1;         /\* code generated for this one *\/ */
/*   unsigned parmPush:1;          /\* parameter push Vs spill push *\/ */
/*   unsigned supportRtn:1;        /\* will cause a call to a support routine *\/ */
/*   unsigned regsSaved:1;         /\* registers have been saved *\/ */
/*   unsigned bankSaved:1;         /\* register bank has been saved *\/ */
/*   unsigned builtinSEND:1;       /\* SEND for parameter of builtin function *\/ */
/*   bool localEscapeAlive:1;      /\* At this iCode, a local variable, a pointer to which has escaped (e.g. by having been stored in a global variable, cast to integer, passed to function) might be alive. *\/ */
/*   bool parmEscapeAlive:1;       /\* At this iCode, a stack parameter, a pointer to which has escaped (e.g. by having been stored in a global variable, cast to integer, passed to function) might be alive. *\/ */
/*   unsigned inlined:1;           /\* from an inlined function *\/ */

/*   struct iCode *next;           /\* next in chain *\/ */
/*   struct iCode *prev;           /\* previous in chain *\/ */
/*   set *movedFrom;               /\* if this iCode gets moved to another block *\/ */
/*   bitVect *rlive;               /\* ranges that are live at this point *\/ */
/*   int defKey;                   /\* key for the operand being defined  *\/ */
/*   bitVect *uses;                /\* vector of key of used symbols      *\/ */
/*   bitVect *rUsed;               /\* registers used by this instruction *\/ */
/*   bitVect *rMask;               /\* registers in use during this instruction *\/ */
/*   bitVect *rSurv;               /\* registers that survive this instruction (i.e. they are in use, it is not their last use and they are not in the return) *\/ */
/*   union */
/*   { */
/*     struct */
/*     { */
/*       operand *left;            /\* left if any   *\/ */
/*       operand *right;           /\* right if any  *\/ */
/*       operand *result;          /\* result of this op *\/ */
/*     } */
/*     lrr; */

/*     struct */
/*     { */
/*       operand *condition;       /\* if this is a conditional *\/ */
/*       symbol *trueLabel;        /\* true for conditional     *\/ */
/*       symbol *falseLabel;       /\* false for conditional    *\/ */
/*     } */
/*     cnd; */

/*     struct */
/*     { */
/*       operand *condition;       /\* condition for the jump *\/ */
/*       set *labels;              /\* ordered set of labels  *\/ */
/*     } */
/*     jmpTab; */

/*   } */
/*   ulrrcnd; */

/*   symbol *label;                /\* for a goto statement     *\/ */

/*   const char *inlineAsm;        /\* pointer to inline assembler code *\/ */
/*   literalList *arrayInitList;   /\* point to array initializer list. *\/ */

/*   int lineno;                   /\* file & lineno for debug information *\/ */
/*   char *filename; */

/*   int parmBytes;                /\* if call/pcall, count of parameter bytes */
/*                                    on stack *\/ */
/*   int argreg;                   /\* argument regno for SEND/RECEIVE *\/ */
/*   int eBBlockNum;               /\* belongs to which eBBlock *\/ */
/*   char riu;                     /\* after ralloc, the registers in use *\/ */
/*   float count;                  /\* An execution count or probability *\/ */
/*   float pcount;                 /\* For propagation of count *\/ */

/*   struct ast *tree;             /\* ast node for this iCode (if not NULL) *\/ */
/* } */
/* iCode; */


void load_address_16(const char *sym_name) {
#if 0
    emit2("mov", "adh hi8(%s)", sym_name);
    emit2("mov", "adl lo8(%s)", sym_name);
#else
    emit2("lad", "%s", sym_name);
#endif
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

  operand *left = IC_LEFT (ic);

  /* const bool bigreturn = (getSize (ftype->next) > 2) || IS_STRUCT (ftype->next); */
  /* const bool SomethingReturned = (IS_ITEMP (IC_RESULT (ic)) && */
  /*                      (OP_SYMBOL (IC_RESULT (ic))->nRegs || OP_SYMBOL (IC_RESULT (ic))->spildir)) */
  /*                      || IS_TRUE_SYMOP (IC_RESULT (ic)); */

  /* D (emit2 ("; genCall", "")); */

  /* aopOp (left, ic); */
  /* if (SomethingReturned && !bigreturn) */
  /*   aopOp (IC_RESULT (ic), ic); */

  /* if (bigreturn) */
  /*   { */
  /*     wassertl (IC_RESULT (ic), "Unused return value in call to function returning large type."); */

  /*     const symbol *rsym = OP_SYMBOL_CONST (IC_RESULT (ic)); */
  /*     if (rsym->usl.spillLoc) */
  /*       rsym = rsym->usl.spillLoc; */

  /*     if (rsym->onStack || rsym->isspilt && regalloc_dry_run && (options.stackAuto || reentrant)) */
  /*       { */
  /*         emit2 ("mov.io", "a, sp"); */
  /*         emit2 ("add", "a, #0x%02x", (rsym->stack + (rsym->stack < 0 ? G.stack.param_offset : 0) - G.stack.pushed) & 0xff); */
  /*       } */
  /*     else */
  /*       { */
  /*         emit2 ("mov", "a, #%s", rsym->rname); */
  /*         cost (1, 1); */
  /*       } */
  /*     pushAF (); */
  /*   } */

  /* bool jump = !ic->parmBytes && IFFUNC_ISNORETURN (ftype); */


  emit2(";; genCall", "");
  if (ic->op == PCALL) {
      emit2("; What is a PCALL?", "");
  } else {
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
  }

}


/*-----------------------------------------------------------------*/
/* genReturn - generate code for return statement                  */
/*-----------------------------------------------------------------*/
static void
genReturn (const iCode *ic)
{
    if (regalloc_dry_run) {
        return;
    }

    print_ic_intelligibly(ic);

    operand *left = IC_LEFT (ic);

    emit2("\n\t;; genReturn", "");
    piCode(ic, stderr);

    emit2("mov", "jmpl stack");
    emit2("mov", "jmph stack");

    load_reg("stack", left);

    emit2("jump", "");
}


/*-----------------------------------------------------------------*/
/* genFunction - generated code for function entry                 */
/*-----------------------------------------------------------------*/
static void
genFunction (iCode *ic)
{
  const symbol *sym = OP_SYMBOL_CONST (IC_LEFT (ic));
  sym_link *ftype = operandType (IC_LEFT (ic));

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
genAssign (const iCode *ic)
{
  operand *result, *right;

  if (!regalloc_dry_run) { fprintf(stderr, "genAssign       = "); piCode (ic, stderr); } emit2("\n\t;; genAssign      ", "");

  result = IC_RESULT (ic);
  right = IC_RIGHT (ic);


  if (IS_SYMOP (result)) {
      if (IS_SYMOP (right)) {
          load_address_16(OP_SYMBOL(right)->rname);
          emit2("mov", "stack mem ,0");
          load_address_16(OP_SYMBOL(result)->rname);
          emit2("mov", "mem stack ,0");
      } else if (IS_OP_LITERAL (right)) {
          load_address_16(OP_SYMBOL(result)->rname);
          emit2("mov", "mem il ,%d", byteOfVal(OP_VALUE(right), 0));
      } else {
          emit2("; genAssign: can't handle right", "");
      }
  } else {
      emit2("; genAssign: can't handle non-symbol result", "");
  }
}


static void genALUOp_impl(int op, const operand *left, const operand *right, iCode *ifx) {
    emit2("", ";; genALUOp %d", op);
    emit2("mov", "alus il ,%d", op);

    load_reg("alua", left);
    load_reg("alub", right);


    /* if (IS_OP_LITERAL(left)) { */
    /*     emit2("mov", "alua il ,%d", byteOfVal(OP_VALUE(left), 0)); */
    /*     if (IS_OP_LITERAL(right)) { */
    /*         emit2("mov", "alub il ,%d", byteOfVal(OP_VALUE(right), 0)); */
    /*     } else { */
    /*         emit2("", ";; genALUOp %d bad right", op); */
    /*     } */
    /* } else if (left->type == SYMBOL) { */
    /*     if (left->isParm) { */
    /*         // parameters are addresses by default */
    /*         // but really we want to pass them on the stack... */
    /*         load_address_16(OP_SYMBOL(left)->rname); */
    /*         emit2("mov", "alua mem", byteOfVal(OP_VALUE(left), 0)); */
    /*     } else { */
    /*         // test if has reg... */
    /*         if (OP_SYMBOL(left)->isspilt) { */
    /*             emit2("mov", "alua %s", OP_SYMBOL(left)->usl.spillLoc->rname); */
    /*         } else { */
    /*             emit2("mov", "alua %s", OP_SYMBOL(left)->regs[0]->name); */
    /*         } */
    /*     } */

    /*     if (IS_OP_LITERAL(right)) { */
    /*         emit2("mov", "alub il ,%d", byteOfVal(OP_VALUE(right), 0)); */
    /*     } else if (right->type == SYMBOL) { */
    /*         if (right->isParm) { */
    /*             // parameters are addresses by default */
    /*             // but really we want to pass them on the stack... */
    /*             load_address_16(OP_SYMBOL(right)->rname); */
    /*             emit2("mov", "alub mem", byteOfVal(OP_VALUE(right), 0)); */
    /*         } else { */
    /*             // test if has reg... */
    /*             if (OP_SYMBOL(right)->isspilt) { */
    /*                 emit2("mov", "alub %s", OP_SYMBOL(right)->usl.spillLoc->rname); */
    /*             } else { */
    /*                 emit2("mov", "alub %s", OP_SYMBOL(right)->regs[0]->name); */
    /*             } */
    /*         } */
    /*     } else */
    /*         emit2("", ";; genALUOp %d bad right", op); */
    /* } else { */
    /*     emit2("", ";; genALUOp %d bad left", op); */
    /* } */
}

static void genALUOp(int op, const iCode *ic, iCode *ifx)
{
    if (regalloc_dry_run) {
        return;
    }

    operand *result = IC_RESULT (ic);
    operand *left = IC_LEFT (ic);
    operand *right = IC_RIGHT (ic);

    genALUOp_impl(op, left, right, ifx);
}

#define ALUS_AND  0
#define ALUS_XOR  2
#define ALUS_PLUS 4
#define ALUS_EQ   10
/*-----------------------------------------------------------------*/
/* genAnd - code for and                                           */
/*-----------------------------------------------------------------*/
static void genAnd  (const iCode *ic, iCode *ifx) { genALUOp(ALUS_AND,  ic, ifx ); }
static void genPlus (const iCode *ic)             { genALUOp(ALUS_PLUS, ic, NULL); }
static void genXor  (const iCode *ic)             { genALUOp(ALUS_XOR,  ic, NULL); }

/*-----------------------------------------------------------------*/
/* genLeftShift - generates code for right shifting                */
/*-----------------------------------------------------------------*/
static void
genLeftShift (const iCode *ic)
{
  operand *result = IC_RESULT (ic);
  operand *left = IC_LEFT (ic);
  operand *right = IC_RIGHT (ic);

  if (regalloc_dry_run) {
      return;
  }

  if (IS_OP_LITERAL(right)) {
      if (byteOfVal(OP_VALUE(right), 0) == 1) {
          // one bit, multiply by two, ie. add self to self.
          genALUOp_impl(ALUS_PLUS, left, left, NULL);
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
    D2(emit2("\n\t;; genGoto", ""));
    emit_jump_to_label (IC_LABEL (ic), 0);
}

/*-----------------------------------------------------------------*/
/* genIfx - generate code for Ifx statement                        */
/*-----------------------------------------------------------------*/
static void genIfx (const iCode *ic)
{
    if (regalloc_dry_run) {
        return;
    }


    operand *const cond = IC_COND (ic);
    operand *const t = IC_TRUE (ic);
    operand *const f = IC_FALSE (ic);

    emit2("\n\t;; genIfx", "");

    if (IS_OP_LITERAL (cond)) {
        emit2("; genIfx: op is literal", "");
        return;
    }

    if (IS_SYMOP (cond)) {
        /* emit2("; genIfx: op is symbol", ""); */
        /* emit2("; symbol is", "%s", OP_SYMBOL(cond)->rname); */
        if (OP_SYMBOL(cond)->nRegs == 1) {
            /* emit2("; ", "symbol is in reg %s", OP_SYMBOL(cond)->regs[0]->name); */
            if (OP_SYMBOL(cond)->regType != REG_CND && !OP_SYMBOL(cond)->regs[0]) {
                emit2(";; ERROR: sanity. conditional in ifx is not conditional?", "");
            }
            // no need to copy test to itself
            // shouldn't really happen
            if (OP_SYMBOL(cond)->regs[0] &&  OP_SYMBOL(cond)->regs[0]->rIdx != TEST_IDX) {
                emit2("mov", "test %s ,0", OP_SYMBOL(cond)->regs[0]->name);
            }
        } else {
            emit2("mov", "test %s ,0", OP_SYMBOL(cond)->rname);
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

    if (t) {
        emit_jump_to_label(t, 1);
        return;
    }

    if (f) {
        emit2("", "; TODO: REVERSE THIS!");
        emit_jump_to_label(f, 1);
        return;
    }

    emit2("; genIfx: op is unknown", "");
}

static void genCmpEQorNE   (const iCode *ic, iCode *ifx)       {
    if (!regalloc_dry_run) { fprintf(stderr, "genCmpEQorNE    = "); piCode (ic, stderr); }

    emit2("\n\t;; genCmpEQorNE", "");
    emit2("", ";; TODO: set alus!");

    if (OP_SYMBOL(IC_RESULT(ic))->regType == REG_CND) {
        load_reg("alua", IC_LEFT(ic));
        load_reg("alub", IC_RIGHT(ic));
        /* read_reg("aluc", IC_RESULT(ic)); */
        emit2("mov", "test aluc ,0");
    } else {
        emit2(";; TODO: genCmpEQorNE non-conditional case", "");
    }

    if (ifx) {
        genIfx(ifx);
    }
}

static void genCmp   (const iCode *ic, iCode *ifx)       {
    if (!regalloc_dry_run) { fprintf(stderr, "genCmpEQorNE    = "); piCode (ic, stderr); }

    emit2("\n\t;; genCmp", "");
    emit2("", ";; TODO: set alus!");

    if (OP_SYMBOL(IC_RESULT(ic))->regType == REG_CND) {
        load_reg("alua", IC_LEFT(ic));
        load_reg("alub", IC_RIGHT(ic));
        /* read_reg("aluc", IC_RESULT(ic)); */
        emit2("mov", "test aluc ,0");
    } else {
        emit2(";; TODO: genCmp non-conditional case", "");
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
    // emit2 ("; genLabel", "");

    /* special case never generate */
    if (IC_LABEL (ic) == entryLabel)
        return;

    if (options.debug /*&& !regalloc_dry_run*/)
        debugFile->writeLabel (IC_LABEL (ic), ic);

    printf("Hello, there should be a label here.\n");

    emit2("", "\rL_%d:", (IC_LABEL(ic)->key + 100));

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

  for (iCode *ic = lic; ic; ic = ic->next)
    {
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
      D (emit2 (";", "Cost for generated ic %d : (%d, %f)", ic->key, regalloc_dry_run_cost_words, regalloc_dry_run_cost_cycles));
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
