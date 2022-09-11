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
#define D2(x) do { x; } while (0)

#define PICODE(foo, bar) /* piCode(foo, bar) */
/* #define DEBUG_GEN_FUNC(str, ic) { fprintf(stderr, "genCpl          = "); piCode (ic, stderr); } */
#define DEBUG_GEN_FUNC(str, ic) { emit2(";; " str, ""); }
/* #define DEBUG_GEN_FUNC(str, ic) */

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

#define TARN_SRC_REG_COUNT   16
#define TARN_SRC_REG_MAX_IDX 15

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
#define ALUS_NOT   3
#define ALUS_PLUS  4
#define ALUS_LT    9
#define ALUS_EQ    10
#define ALUS_GT    11
#define ALUS_MINUS 16

const char *alu_operations[] = {
    "and",
    "?",
    "xor",
    "not",

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

static void
cost(unsigned int words)
{
  /* regalloc_dry_run_cost_words += words; */
  /* regalloc_dry_run_cost_cycles += cycles * regalloc_dry_run_cycle_scale; */
  regalloc_dry_run_cost_words += words;
  regalloc_dry_run_cost_cycles += words * regalloc_dry_run_cycle_scale;
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

////////////////////////////////////////////////////////////////////////////////

static struct asmop asmop_r;
static struct asmop asmop_x;
static struct asmop asmop_rx;
static struct asmop asmop_xr;
static struct asmop asmop_adhl;
static struct asmop asmop_zero;
static struct asmop asmop_one;
static struct asmop asmop_two;
static struct asmop asmop_mone;
static struct asmop asmop_alua;
static struct asmop asmop_alub;
static struct asmop asmop_aluc;
static struct asmop asmop_mem;
static struct asmop asmop_stack;

static struct asmop *const ASMOP_R = &asmop_r;
static struct asmop *const ASMOP_X = &asmop_x;
static struct asmop *const ASMOP_RX = &asmop_rx;
static struct asmop *const ASMOP_XR = &asmop_xr;
static struct asmop *const ASMOP_ADHL = &asmop_adhl;
static struct asmop *const ASMOP_ZERO = &asmop_zero;
static struct asmop *const ASMOP_ONE = &asmop_one;
static struct asmop *const ASMOP_TWO = &asmop_two;
static struct asmop *const ASMOP_MONE = &asmop_mone;
static struct asmop *const ASMOP_ALUA = &asmop_alua;
static struct asmop *const ASMOP_ALUB = &asmop_alub;
static struct asmop *const ASMOP_ALUC = &asmop_aluc;
static struct asmop *const ASMOP_MEM = &asmop_mem;
static struct asmop *const ASMOP_STACK = &asmop_stack;

void
tarn_init_asmops (void)
{
  asmop_r.type = AOP_REG;
  asmop_r.size = 1;
  asmop_r.aopu.bytes[0].in_reg = true;
  asmop_r.aopu.bytes[0].byteu.reg = tarn_regs + R_IDX;

  asmop_x.type = AOP_REG;
  asmop_x.size = 1;
  asmop_x.aopu.bytes[0].in_reg = true;
  asmop_x.aopu.bytes[0].byteu.reg = tarn_regs + X_IDX;

  asmop_alua.type = AOP_REG;
  asmop_alua.size = 1;
  asmop_alua.aopu.bytes[0].in_reg = true;
  asmop_alua.aopu.bytes[0].byteu.reg = tarn_regs + ALUA_IDX;

  asmop_alub.type = AOP_REG;
  asmop_alub.size = 1;
  asmop_alub.aopu.bytes[0].in_reg = true;
  asmop_alub.aopu.bytes[0].byteu.reg = tarn_regs + ALUB_IDX;

  asmop_aluc.type = AOP_REG;
  asmop_aluc.size = 1;
  asmop_aluc.aopu.bytes[0].in_reg = true;
  asmop_aluc.aopu.bytes[0].byteu.reg = tarn_regs + ALUC_IDX;

  asmop_mem.type = AOP_REG;
  asmop_mem.size = 1;
  asmop_mem.aopu.bytes[0].in_reg = true;
  asmop_mem.aopu.bytes[0].byteu.reg = tarn_regs + MEM_IDX;

  asmop_stack.type = AOP_REG;
  asmop_stack.size = 1;
  asmop_stack.aopu.bytes[0].in_reg = true;
  asmop_stack.aopu.bytes[0].byteu.reg = tarn_regs + STACK_IDX;

  asmop_rx.type = AOP_REG;
  asmop_rx.size = 2;
  asmop_rx.aopu.bytes[0].in_reg = true;
  asmop_rx.aopu.bytes[0].byteu.reg = tarn_regs + R_IDX;
  asmop_rx.aopu.bytes[1].in_reg = true;
  asmop_rx.aopu.bytes[1].byteu.reg = tarn_regs + X_IDX;

  asmop_xr.type = AOP_REG;
  asmop_xr.size = 2;
  asmop_xr.aopu.bytes[0].in_reg = true;
  asmop_xr.aopu.bytes[0].byteu.reg = tarn_regs + X_IDX;
  asmop_xr.aopu.bytes[1].in_reg = true;
  asmop_xr.aopu.bytes[1].byteu.reg = tarn_regs + R_IDX;

  asmop_adhl.type = AOP_REG;
  asmop_adhl.size = 2;
  asmop_adhl.aopu.bytes[0].in_reg = true;
  asmop_adhl.aopu.bytes[0].byteu.reg = tarn_regs + ADH_IDX;
  asmop_adhl.aopu.bytes[1].in_reg = true;
  asmop_adhl.aopu.bytes[1].byteu.reg = tarn_regs + ADL_IDX;

  asmop_zero.type = AOP_LIT;
  asmop_zero.size = 1;
  asmop_zero.aopu.aop_lit = constVal ("0");

  asmop_one.type = AOP_LIT;
  asmop_one.size = 1;
  asmop_one.aopu.aop_lit = constVal ("1");
  
  asmop_two.type = AOP_LIT;
  asmop_two.size = 1;
  asmop_two.aopu.aop_lit = constVal ("2");
  
  asmop_mone.type = AOP_LIT;
  asmop_mone.size = 8; // Maximum size for asmop.
  asmop_mone.aopu.aop_lit = constVal ("-1");
}


/*-----------------------------------------------------------------*/
/* newAsmop - creates a new asmOp                                  */
/*-----------------------------------------------------------------*/
static asmop *
newAsmop (short type)
{
  asmop *aop;

  aop = Safe_calloc (1, sizeof (asmop));
  aop->type = type;
  aop->regalloc_dry_run = regalloc_dry_run;

  return (aop);
}

/*-----------------------------------------------------------------*/
/* freeAsmop - free up the asmop given to an operand               */
/*----------------------------------------------------------------*/
static void
freeAsmop (operand *op)
{
  asmop *aop;

  wassert_bt (op);

  aop = op->aop;

  if (!aop)
    return;

  Safe_free (aop);

  op->aop = 0;
  if (IS_SYMOP (op) && SPIL_LOC (op))
    SPIL_LOC (op)->aop = 0;
}

/*-----------------------------------------------------------------*/
/* aopForSym - for a true symbol                                   */
/*-----------------------------------------------------------------*/
static asmop *aopForSym (symbol *sym, bool is_spilled)
{
  asmop *aop;

  wassert_bt (regalloc_dry_run || sym);
  wassert_bt (regalloc_dry_run || sym->etype);

  // Unlike some other backends we really free asmops; to avoid a double-free, we need to support multiple asmops for the same symbol.

  if (sym && IS_FUNC (sym->type))
    {
      aop = newAsmop (AOP_IMMD);
      aop->aopu.immd = sym->rname;
      aop->aopu.immd_off = 0;
      aop->aopu.code = IN_CODESPACE (SPEC_OCLS (sym->etype));
      aop->aopu.func = true;
      aop->size = getSize (sym->type);
    }
  /* Assign depending on the storage class */
  else if (sym && is_spilled)
    {
      aop = newAsmop (AOP_SPILL);
      aop->size = getSize (sym->type);
      aop->aopu.immd = sym->rname;
      aop->aopu.immd_off = 0;
    }
  else if (sym && sym->onStack || sym && sym->iaccess)
    {
      aop = newAsmop (AOP_SPILL);
      aop->size = getSize (sym->type);
      int base = sym->stack + (sym->stack < 0 ? G.stack.param_offset : 0);
      for (int offset = 0; offset < aop->size; offset++)
        aop->aopu.bytes[offset].byteu.stk = base + offset;
    }
  /* sfr */
  else if (sym && IN_REGSP (SPEC_OCLS (sym->etype)))
    {
      wassertl (getSize (sym->type) == 1, "Unimplemented support for wide (> 8 bit) I/O register");

      aop = newAsmop (AOP_SFR);
      /* aop->aopu.aop_dir = sym->rname; */
      /* aop->size = getSize (sym->type); */
      aop->size = 1;

      if (sym->etype->select.s._addr < 0
          || sym->etype->select.s._addr > TARN_SRC_REG_MAX_IDX) {
          wassertl (0, "Invalid special register!");
      }
      aop->aopu.aop_dir = (char *)tarn_src_registers[sym->etype->select.s._addr].name;
    }
  else
    {
      aop = newAsmop (sym && IN_CODESPACE (SPEC_OCLS (sym->etype)) ? AOP_CODE : AOP_DIR);
      if (sym)
        {
          aop->aopu.aop_dir = sym->rname;
          aop->size = getSize (sym->type);
        }
    }

  return (aop);
}

/*-----------------------------------------------------------------*/
/* aopForRemat - rematerializes an object                          */
/*-----------------------------------------------------------------*/
static asmop *
aopForRemat (symbol *sym)
{
  iCode *ic = sym->rematiCode;
  asmop *aop;
  int val = 0;

  wassert_bt (ic);

  for (;;)
    {
      if (ic->op == '+')
        {
          if (isOperandLiteral (IC_RIGHT (ic)))
            {
              val += (int) operandLitValue (IC_RIGHT (ic));
              ic = OP_SYMBOL (IC_LEFT (ic))->rematiCode;
            }
          else
            {
              val += (int) operandLitValue (IC_LEFT (ic));
              ic = OP_SYMBOL (IC_RIGHT (ic))->rematiCode;
            }
        }
      else if (ic->op == '-')
        {
          val -= (int) operandLitValue (IC_RIGHT (ic));
          ic = OP_SYMBOL (IC_LEFT (ic))->rematiCode;
        }
      else if (ic->op == CAST)
        {
          ic = OP_SYMBOL (IC_RIGHT (ic))->rematiCode;
        }
      else if (ic->op == ADDRESS_OF)
        {
          val += (int) operandLitValue (IC_RIGHT (ic));
          break;
        }
      else
        wassert_bt (0);
    }

  if (OP_SYMBOL (IC_LEFT (ic))->onStack)
    {
      aop = newAsmop (AOP_STL);
      aop->aopu.stk_off = OP_SYMBOL (IC_LEFT (ic))->stack + (OP_SYMBOL (IC_LEFT (ic))->stack < 0 ? G.stack.param_offset : 0) + val;
    }
  else
    {
      aop = newAsmop (AOP_IMMD);
      aop->aopu.immd = OP_SYMBOL (IC_LEFT (ic))->rname;
      aop->aopu.immd_off = val;
      aop->aopu.code = IN_CODESPACE (SPEC_OCLS (OP_SYMBOL (IC_LEFT (ic))->etype));
    }

  aop->size = getSize (sym->type);

  return aop;
}


/*-----------------------------------------------------------------*/
/* aopOp - allocates an asmop for an operand  :                    */
/*-----------------------------------------------------------------*/
static void aopOp(operand *op)
{
    wassert_bt (op);

    if (op->aop && op->aop->regalloc_dry_run != regalloc_dry_run) {
        // free it, make a new one.
        freeAsmop (op);
        op->aop = NULL;
    }

    /* if already has an asmop */
    if (op->aop)
        return;

    /* if this a literal */
    if (IS_OP_LITERAL (op)) {
        asmop *aop = newAsmop (AOP_LIT);
        aop->aopu.aop_lit = OP_VALUE (op);
        aop->size = getSize (operandType (op));
        op->aop = aop;
        return;
    }

    symbol *sym = OP_SYMBOL (op);

    /* if this is a true symbol */
    if (IS_TRUE_SYMOP (op)) {
        op->aop = aopForSym(sym, false);
        return;
    }

    /* Rematerialize symbols where all bytes are spilt. */
    if (sym->remat && (sym->isspilt || regalloc_dry_run)) {
        bool completely_spilt = TRUE;
        for (int i = 0; i < getSize (sym->type); i++) {
            if (sym->regs[i]) {
                completely_spilt = FALSE;
            }
        }
        if (completely_spilt) {
            op->aop = aopForRemat (sym);
            return;
        }
    }

    if (sym->isspilt) {
        if (!regalloc_dry_run) {
            printf("\033[0;31mWARNING:\033[0m spilled variable %8s %8s %8s\n",
                   sym->name ? sym->name : "()",
                   sym->rname ? sym->rname : "()",
                   sym->usl.spillLoc->rname ? sym->usl.spillLoc->rname : "()");
        }
    }

    /* if the type is a conditional */
    if (sym->regType == REG_CND) {
        asmop *aop = newAsmop (AOP_CND);
        op->aop = aop;
        sym->aop = sym->aop;
        return;
    }

    /* None of the above, which only leaves temporaries. */
    if ((sym->isspilt || sym->nRegs == 0)
        && sym->usl.spillLoc
        && !(regalloc_dry_run && (options.stackAuto || reentrant))) {
        sym->aop = op->aop = aopForSym(sym->usl.spillLoc, sym->isspilt);
        op->aop->size = getSize (sym->type);
        return;
    }

    /* None of the above, which only leaves temporaries. */
    { 
        bool completely_in_regs = true;
        bool completely_spilt = true;
        asmop *aop = newAsmop (AOP_REGDIR);

        aop->size = getSize (operandType (op));
        op->aop = aop;

        for (int i = 0; i < aop->size; i++) {
            aop->aopu.bytes[i].in_reg = !!sym->regs[i];
            if (sym->regs[i]) {
                completely_spilt = false;
                aop->aopu.bytes[i].byteu.reg = sym->regs[i];
                //aop->regs[sym->regs[i]->rIdx] = i;
            // } else if (sym->isspilt && sym->usl.spillLoc || sym->nRegs && regalloc_dry_run) {
            } else if ((sym->isspilt && sym->usl.spillLoc) || (sym->nRegs && regalloc_dry_run)) {
                completely_in_regs = false;

                if (!regalloc_dry_run) {
                    /*aop->aopu.bytes[i].byteu.stk = (long int)(sym->usl.spillLoc->stack) + aop->size - i;

                      if (sym->usl.spillLoc->stack + aop->size - (int)(i) <= -G.stack.pushed)
                      {
                      fprintf (stderr, "%s %d %d %d %d at ic %d\n", sym->name, (int)(sym->usl.spillLoc->stack), (int)(aop->size), (int)(i), (int)(G.stack.pushed), ic->key);
                      wassertl_bt (0, "Invalid stack offset.");
                      }*/
                } else {
                    static long int old_base = -10;
                    static const symbol *old_sym = 0;
                    if (sym != old_sym)
                        {
                            old_base -= aop->size;
                            if (old_base < -100)
                                old_base = -10;
                            old_sym = sym;
                        }

                    // aop->aopu.bytes[i].byteu.stk = old_base + aop->size - i;
                }
            } else {
                aop->type = AOP_DUMMY;
                return;
            }

            if (!completely_in_regs && (!currFunc || GcurMemmap == statsg)) {
                if (!regalloc_dry_run)
                    wassertl_bt (0, "Stack asmop outside of function.");
                cost (180);
            }
        }


        if (completely_in_regs)
            aop->type = AOP_REG;
        else if (completely_spilt && !(options.stackAuto || reentrant)) {
                aop->type = AOP_DIR;
                /* aop->aopu.immd = sym->rname; */
                if (regalloc_dry_run) {
                    aop->aopu.immd = sym->rname;
                } else {
                    aop->aopu.immd = sym->usl.spillLoc->rname;
                }
            }
        else if (completely_spilt) {
            aop->type = AOP_SPILL;
        } else
            wassertl (0, "Unsupported partially spilt aop");
    }
}

/*-----------------------------------------------------------------*/
/* aopSame - are two asmops in the same location?                  */
/*-----------------------------------------------------------------*/
static bool
aopSame (const asmop *aop1, int offset1, const asmop *aop2, int offset2, int size)
{
  for(; size; size--, offset1++, offset2++)
    {
      if (aop1->type == AOP_REG && aop2->type == AOP_REG && // Same register
        aop1->aopu.bytes[offset1].in_reg && aop2->aopu.bytes[offset2].in_reg &&
        aop1->aopu.bytes[offset1].byteu.reg == aop2->aopu.bytes[offset2].byteu.reg)
        continue;

      if (aop1->type == AOP_LIT && aop2->type == AOP_LIT &&
        byteOfVal (aop1->aopu.aop_lit, offset1) == byteOfVal (aop2->aopu.aop_lit, offset2))
        continue;

      if (aop1->type == AOP_DIR && aop2->type == AOP_DIR && aop1->aopu.immd_off + offset1 == aop2->aopu.immd_off + offset2 &&
        !strcmp(aop1->aopu.aop_dir, aop2->aopu.aop_dir))
        return (true);

      if (aop1->type == AOP_SPILL && aop2->type == AOP_SPILL && aop1->aopu.bytes[offset1].byteu.stk == aop2->aopu.bytes[offset2].byteu.stk)
        return (true);

      if (aop1->type == AOP_SFR && aop2->type == AOP_SFR && offset1 == offset2 &&
        aop1->aopu.aop_dir && aop2->aopu.aop_dir && !strcmp(aop1->aopu.aop_dir, aop2->aopu.aop_dir))
        return (true);

      return (false);
    }

  return (true);
}

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
    if (!regalloc_dry_run) {
        if (!label) {
            wassert_bt (label);
        }
    }
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

void emit_asmop(const char *label, asmop *aop) {
    static char buf[256];
    
/* typedef struct asmop */
/* { */
/*   AOP_TYPE type; */
/*   short size; */
/*   union */
/*   { */
/*     value *aop_lit; */
/*     struct */
/*       { */
/*         char *immd; */
/*         int immd_off; */
/*         bool code; /\* in code space *\/ */
/*         bool func; /\* function address *\/ */
/*       }; */
/*     char *aop_dir; */
/*     int stk_off; */
/*     asmop_byte bytes[8]; */
/*   } aopu; */
/* } */
/* asmop; */

#define EMIT_NAME(NAME) emit2(";", "%s operand " #NAME, label);
#define AOP_CASE(NAME) case NAME: EMIT_NAME(NAME); break;
    if (aop) {
        switch (aop->type) {
            AOP_CASE(AOP_CND);
            AOP_CASE(AOP_CODE);
            AOP_CASE(AOP_DIR);
            AOP_CASE(AOP_DUMMY);
            AOP_CASE(AOP_IMMD);
            AOP_CASE(AOP_INVALID);
            AOP_CASE(AOP_LIT);
            AOP_CASE(AOP_REG);
            AOP_CASE(AOP_REGDIR);
            AOP_CASE(AOP_SFR);
            AOP_CASE(AOP_SPILL);
            AOP_CASE(AOP_STL);
        }
        emit2(";", "  size = %d", aop->size);
        switch (aop->type) {
        case AOP_LIT:
            *buf = 0;
            for (int i = 0; i < aop->size; ++i) {
                sprintf(buf + strlen(buf), "%02x ", byteOfVal(aop->aopu.aop_lit, i));
            }
            emit2(";", "  value = %s", buf);
            break;
        case AOP_DIR:
            emit2(";", "  location = %s (direct)", aop->aopu.aop_dir);
            break;
        case AOP_IMMD:
            emit2(";", "  location = %s+%d (immediate)", aop->aopu.immd, aop->aopu.immd_off);
            break;
        case AOP_SPILL:
            emit2(";", "  location = %s+%d (immediate)", aop->aopu.immd, aop->aopu.immd_off);
            break;
        case AOP_CND:
        case AOP_CODE:
        case AOP_DUMMY:
        case AOP_INVALID:
        case AOP_REG:
        case AOP_REGDIR:
        case AOP_SFR:
            break;
        case AOP_STL:
            emit2(";", "  other");
            break;
        }
    } else {
        emit2(";", "%s operand NULL", label);
    }

}

/*---------------------------------------------------------------------*/
/* emit "mov <dreg> <sreg>"                                            */
/*---------------------------------------------------------------------*/
static void emit_mov(const char *dreg, const char *sreg) {
    emit2("mov", "%s %s", dreg, sreg);
    cost(1);
}

/*---------------------------------------------------------------------*/
/* emit "mov <dreg> il ,<literal>"                                     */
/*---------------------------------------------------------------------*/
static void emit_mov_lit(const char *dreg, int literal) {
    emit2("mov", "%s il ,%d", dreg, literal);
    cost(1);
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

static void emit_macro_load_address_from_ptr(const char *addr) {
    emit2("load_address_from_ptr", "%s", addr);
    cost(8);
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
                        if (OP_SYMBOL(op)->etype->select.s._addr < 0
                            || OP_SYMBOL(op)->etype->select.s._addr > TARN_SRC_REG_MAX_IDX) {
                            wassertl (0, "Invalid special register!");
                        }
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
                        if (OP_SYMBOL(op)->etype->select.s._addr < 0
                            || OP_SYMBOL(op)->etype->select.s._addr > TARN_SRC_REG_MAX_IDX) {
                            wassertl (0, "Invalid special register!");
                        }
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

const char *sprint_regs(operand *op) {
    static char buf[256];
    *buf = 0;
    if (is_reg(op)) {
        int offset = 0;
        if (OP_SYMBOL(op)->nRegs) {
            for (int i = 0; i < OP_SYMBOL(op)->nRegs; ++i) {
                snprintf(buf + offset, 256 - offset, "%s,", op_get_register_name_i(op, i));
            }
        } else {
            return op_get_register_name(op);
        }
        offset = strlen(buf);
    }
    /* if (!*buf) { */
    /*     strcpy(buf, "none"); */
    /* } */
    return buf;
}

void print_op_diagnostics(const char *tag, operand *op) {
    static char buf[256];
    static char buf2[256];
    if (IS_SYMOP(op)) {
        size_t padlen = strlen(tag) + 2;
        snprintf(buf, 256, "%s: reg? mem? remat? spilt? nregs regs label", tag);
        emit2(";", "%s", buf);
        {
            size_t i = 0;
            for (; i < padlen; ++i) {
                buf[i] = ' ';
            }
            buf[i] = 0;
        }
        const char *mem_label;
        if (OP_SYMBOL(op)->remat) {
            remat_result_t *result = resolve_remat(OP_SYMBOL(op));
            sprintf(buf2, "%s+%d", result->name, result->offset);
            mem_label = buf2;
        } else {
            mem_label = op_get_mem_label(op);
        }
        sprintf(buf + padlen, "%-4s %-4s %-6s %-6s %-5d %-4s %-5s",
                 is_reg(op) ? "yes" : "",
                 is_mem(op) ? "yes" : "",
                 OP_SYMBOL(op)->remat ? "yes" : "",
                 OP_SYMBOL(op)->isspilt ? "yes" : "",
                 OP_SYMBOL(op)->nRegs,
                 sprint_regs(op),
                 mem_label ? mem_label : "");
        emit2(";", "%s", buf);
    } else {
        emit2("", "; implement me (%s:%d) (print)", __FILE__, __LINE__);
    }
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

#define AOP_IS_DIRECT(aop)    (aop->type == AOP_DIR)
#define AOP_IS_IMMEDIATE(aop) (aop->type == AOP_IMMD)
#define AOP_IS_LIT(aop)       (aop->type == AOP_LIT)
#define AOP_IS_SFR(aop)       (aop->type == AOP_SFR)
#define AOP_IS_REG(aop)       (aop->type == AOP_REG)
#define AOP_IS_CND(aop)       (aop->type == AOP_CND)
#define AOP_IS_SPILL(aop)       (aop->type == AOP_SPILL)


void aop_move_byte(asmop *a1, asmop *a2, int index);

bool aop_move(asmop *a1, asmop *a2) {
    #define AOP_MOVE_DEBUG { emit2("", "; aop_move debug (%s:%d)", __FILE__, __LINE__); emit_asmop("dest", a1); emit_asmop("src ", a2); }

    if (AOP_IS_SPILL(a1)) {
        if (a2->size == 1) {
            if (AOP_IS_REG(a2)) {
                load_address_16o(a1->aopu.immd, a1->aopu.immd_off);
                AOP_MOVE_DEBUG;
                aop_move(ASMOP_MEM, a2);
            } else {
                AOP_MOVE_DEBUG;
            }
        } else {
            for (int i = 0; i < a2->size; ++i) {
                load_address_16o(a1->aopu.immd, a1->aopu.immd_off + i);
                aop_move_byte(ASMOP_MEM, a2, a2->size - i - 1);
            }
        }
    } else if (AOP_IS_DIRECT(a1)) {
        if (AOP_IS_LIT(a2)) {
            if (a1->size == 1) {
                load_address_16(a1->aopu.aop_dir);
                if (byteOfVal(a2->aopu.aop_lit, 0) == 0) {
                    emit_mov("mem", "zero");
                } else {
                    emit_mov_lit("mem", byteOfVal(a2->aopu.aop_lit, 0));
                }
            } else {
                for (int i = 0; i < a2->size; ++i) {
                    load_address_16o(a1->aopu.aop_dir, i);
                    emit_mov_lit("mem", byteOfVal(a2->aopu.aop_lit, i));
                }
            }
        } else if (AOP_IS_IMMEDIATE(a2)) {
            if (a1->size == 2) {
                load_address_16(a1->aopu.aop_dir);
                emit2("mov", "mem il ,hi8(%s + %d) ; hi", a2->aopu.immd, a2->aopu.immd_off);
                load_address_16o(a1->aopu.aop_dir, 1);
                emit2("mov", "mem il ,lo8(%s + %d) ; lo", a2->aopu.immd, a2->aopu.immd_off);
                cost(2);
            } else {
                AOP_MOVE_DEBUG;
                cost(3);
            }
        } else if (AOP_IS_DIRECT(a2)) {
            if (a1->size == 2) {
                load_address_16(a2->aopu.aop_dir);
                emit2("mov", "stack mem ; hi");
                load_address_16o(a2->aopu.aop_dir, 1);
                emit2("mov", "stack mem ; lo");
                load_address_16o(a1->aopu.aop_dir, 1);
                emit2("mov", "mem stack ; lo");
                load_address_16(a1->aopu.aop_dir);
                emit2("mov", "mem stack ; hi");
                cost(4);
            } else if (a1->size == 1) {
                load_address_16(a2->aopu.aop_dir);
                emit2("mov", "stack mem");
                load_address_16(a1->aopu.aop_dir);
                emit2("mov", "mem stack");
                cost(2);
            } else {
                cost(10);
                AOP_MOVE_DEBUG;
            }
        } else if (AOP_IS_REG(a2)) {
            if (a1->size == 1) {
                load_address_16(a1->aopu.aop_dir);
                emit_mov("mem", a2->aopu.bytes[0].byteu.reg->name);
            } else {
                for (int i = 0; i < a1->size; ++i) {
                    load_address_16o(a1->aopu.aop_dir, (a1->size - 1) - i);
                    emit_mov("mem", a2->aopu.bytes[i].byteu.reg->name);
                }
            }
        } else if (AOP_IS_SFR(a2)) {
            load_address_16(a1->aopu.aop_dir);
            emit_mov("mem", a2->aopu.aop_dir);
        } else {
            AOP_MOVE_DEBUG;
        }            
    } else if (AOP_IS_SFR(a1)) {
        if (a1->size == 1) {
            if (AOP_IS_LIT(a2)) {
                if (a2->size == 1) {
                    emit2("mov", "%s il ,%d", a1->aopu.aop_dir, byteOfVal(a2->aopu.aop_lit, 0));
                    cost(1);
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_DIRECT(a2)) {
                if (a2->size == 2) {
                    // means it must be spilled ?
                    // gotta be a better way to do this...
                    emit_macro_load_address_from_ptr(a2->aopu.aop_dir);
                    aop_move(a1, ASMOP_MEM);
                } else if (a2->size == 1) {
                    load_address_16(a2->aopu.aop_dir);
                    emit_mov(a1->aopu.aop_dir, "mem");
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_REG(a2)) {
                emit_mov(a1->aopu.aop_dir, a2->aopu.bytes[0].byteu.reg->name);
            } else if (AOP_IS_SPILL(a2)) {
                load_address_16o(a2->aopu.immd, a2->aopu.immd_off);
                emit_mov(a1->aopu.aop_dir, "mem");
            } else {
                AOP_MOVE_DEBUG;
            }
        } else {
            AOP_MOVE_DEBUG;
        }
    } else if (AOP_IS_REG(a1)) {
        if (a1->size == 1) {
            if (AOP_IS_DIRECT(a2)) {
                if (a2->size == 2) {
                    // means it must be spilled ?
                    // gotta be a better way to do this...
                    emit_macro_load_address_from_ptr(a2->aopu.aop_dir);
                    aop_move(a1, ASMOP_MEM);
                } else if (a2->size == 1) {
                    load_address_16(a2->aopu.aop_dir);
                    // aop->aopu.bytes[i].byteu.reg = sym->regs[i];
                    emit_mov(a1->aopu.bytes[0].byteu.reg->name, "mem");
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_REG(a2)) {
                if (strcmp(a1->aopu.bytes[0].byteu.reg->name, a2->aopu.bytes[0].byteu.reg->name)) {
                    emit_mov(a1->aopu.bytes[0].byteu.reg->name, a2->aopu.bytes[0].byteu.reg->name);
                } else {
                    emit2(";", "Not moving register %s to itself...", a2->aopu.bytes[0].byteu.reg->name);
                    return false;
                    // AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_LIT(a2)) {
                if (a1 == ASMOP_STACK) {
                    for (int i = 0; i < a2->size; ++i) {
                        emit2("mov", "stack il ,%d", byteOfVal(a2->aopu.aop_lit, i));
                        cost(1);
                    }
                } else if (a2->size == 1) {
                    int val = byteOfVal(a2->aopu.aop_lit, 0);
                    if (val) {
                        emit_mov_lit(a1->aopu.bytes[0].byteu.reg->name, val);
                    } else {
                        emit_mov(a1->aopu.bytes[0].byteu.reg->name, "zero");
                    }
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_SFR(a2)) {
                emit_mov(a1->aopu.bytes[0].byteu.reg->name, a2->aopu.aop_dir);
            } else if (a1 == ASMOP_STACK) {
                // Special case: push all to stack.
                // Push low bytes first.
                for (int i = a2->size - 1; i >= 0; --i) {
                    aop_move_byte(a1, a2, i);
                }
            } else if (AOP_IS_SPILL(a2) && a2->size == 1) {
                load_address_16(a2->aopu.immd);
                aop_move(a1, ASMOP_MEM);
            } else {
                AOP_MOVE_DEBUG;
            }
        } else if (AOP_IS_REG(a2)) {
            if (aopSame(a1, 0, a2, 0, a1->size)) {
                emit2(";", "no need to move registers to themselves");
                return false;
            } else {
                AOP_MOVE_DEBUG;
            }
        } else {
            if (AOP_IS_DIRECT(a2)) {
                for (int i = 0; i < a2->size; ++i) {
                    load_address_16o(a2->aopu.aop_dir, i);
                    emit_mov(a1->aopu.bytes[i].byteu.reg->name, "mem");
                }
            } else if (AOP_IS_SPILL(a2)) {
                if (a1 == ASMOP_ADHL && a1->size == 2) {
                    emit_macro_load_address_from_ptr(a2->aopu.immd);
                    cost(8);
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_LIT(a2)) {
                if (a1->size == a2->size) {
                    for (int i = 0; i < a2->size; ++i) {
                        emit_mov_lit(a1->aopu.bytes[i].byteu.reg->name, byteOfVal(a2->aopu.aop_lit, i));
                    }
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else {
                AOP_MOVE_DEBUG;
            }
        }
    } else {
        AOP_MOVE_DEBUG;
    }

    return true;
#undef AOP_MOVE_DEBUG
}

void aop_move_byte(asmop *a1, asmop *a2, int index) {
    #define AOP_MOVE_DEBUG { emit2("", "; aop_move_byte debug (%s:%d)", __FILE__, __LINE__); emit_asmop("dest", a1); emit_asmop("src ", a2); }
    if (AOP_IS_DIRECT(a1)) {
        if (AOP_IS_LIT(a2)) {
            if (a1->size == 1) {
                load_address_16(a1->aopu.aop_dir);
                if (byteOfVal(a2->aopu.aop_lit, index) == 0) {
                    emit_mov("mem", "zero");
                } else {
                    emit2("mov", "mem il ,%d", byteOfVal(a2->aopu.aop_lit, index));
                    cost(1);
                }
            } else {
                AOP_MOVE_DEBUG;
                cost(3);
            }
        } else if (AOP_IS_IMMEDIATE(a2)) {
            if (a1->size == 1) {
                if (index == 0) {
                    load_address_16(a1->aopu.aop_dir);
                    emit2("mov", "mem il ,lo8(%s + %d) ; lo", a2->aopu.immd, a2->aopu.immd_off);
                } else if (index == 1) {
                    load_address_16(a1->aopu.aop_dir);
                    emit2("mov", "mem il ,hi8(%s + %d) ; hi", a2->aopu.immd, a2->aopu.immd_off);
                } else {
                    AOP_MOVE_DEBUG;
                    cost(3);
                }
            } else {
                AOP_MOVE_DEBUG;
                cost(3);
            }
        } else if (AOP_IS_DIRECT(a2)) {
            if (a1->size == 1) {
                load_address_16(a2->aopu.aop_dir);
                emit2("mov", "stack mem");
                load_address_16(a1->aopu.aop_dir);
                emit2("mov", "mem stack");
                cost(2);
            } else {
                cost(10);
                AOP_MOVE_DEBUG;
            }
        } else if (AOP_IS_REG(a2)) {
            if (a1->size == 1) {
                load_address_16(a1->aopu.aop_dir);
                emit_mov("mem", a2->aopu.bytes[0].byteu.reg->name);
            } else {
                cost(10);
                AOP_MOVE_DEBUG;
            }
        } else if (AOP_IS_SFR(a2)) {
            load_address_16(a1->aopu.aop_dir);
            emit_mov("mem", a2->aopu.aop_dir);
        } else {
            AOP_MOVE_DEBUG;
        }            
    } else if (AOP_IS_SFR(a1)) {
        if (a1->size == 1) {
            if (AOP_IS_LIT(a2)) {
                if (a1->size == 1) {
                    emit2("mov", "%s il ,%d", a1->aopu.aop_dir, byteOfVal(a2->aopu.aop_lit, index));
                    cost(1);
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_DIRECT(a2)) {
                if (a2->size == 1) {
                    load_address_16(a2->aopu.aop_dir);
                    emit_mov(a1->aopu.aop_dir, "mem");
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_REG(a2)) {
                emit_mov(a1->aopu.aop_dir, a2->aopu.bytes[0].byteu.reg->name);
            } else {
                AOP_MOVE_DEBUG;
            }
        } else {
            AOP_MOVE_DEBUG;
        }
    } else if (AOP_IS_REG(a1)) {
        if (a1->size == 1) {
            if (AOP_IS_DIRECT(a2)) {
                if (a2->size == 2) {
                    if (index == 0) {
                        load_address_16(a2->aopu.aop_dir);
                        cost(8);
                        aop_move(a1, ASMOP_MEM);
                    } else if (index == 1) {
                        load_address_16o(a2->aopu.aop_dir, 1);
                        aop_move(a1, ASMOP_MEM);
                    } else {
                        AOP_MOVE_DEBUG;
                    }
                } else if (a2->size == 1) {
                    load_address_16(a2->aopu.aop_dir);
                    // aop->aopu.bytes[i].byteu.reg = sym->regs[i];
                    emit_mov(a1->aopu.bytes[0].byteu.reg->name, "mem");
                } else if (a2->size == 4) {
                    load_address_16o(a2->aopu.aop_dir, index);
                    emit_mov(a1->aopu.bytes[0].byteu.reg->name, "mem");
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_REG(a2)) {
                if (strcmp(a1->aopu.bytes[0].byteu.reg->name, a2->aopu.bytes[index].byteu.reg->name)) {
                    emit_mov(a1->aopu.bytes[0].byteu.reg->name, a2->aopu.bytes[index].byteu.reg->name);
                } else {
                    AOP_MOVE_DEBUG;
                }
            } else if (AOP_IS_LIT(a2)) {
                int val = byteOfVal(a2->aopu.aop_lit, index);
                if (val) {
                    emit_mov_lit(a1->aopu.bytes[0].byteu.reg->name, val);
                } else {
                    emit_mov(a1->aopu.bytes[0].byteu.reg->name, "zero");
                }
            } else if (AOP_IS_SFR(a2)) {
                emit_mov(a1->aopu.bytes[0].byteu.reg->name, a2->aopu.aop_dir);
            } else if (AOP_IS_IMMEDIATE(a2)) {
                load_address_16o(a2->aopu.immd, a2->aopu.immd_off + index);
                aop_move(a1, ASMOP_MEM);
            } else {
                AOP_MOVE_DEBUG;
            }
        } else if (AOP_IS_REG(a2)) {
            if (aopSame(a1, 0, a2, 0, a1->size)) {
                emit2(";", "no need to move registers to themselves");
            } else {
                AOP_MOVE_DEBUG;
            }
        } else {
            if (AOP_IS_DIRECT(a2)) {
                load_address_16o(a2->aopu.aop_dir, index);
                emit_mov(a1->aopu.bytes[0].byteu.reg->name, "mem");
            } else {
                AOP_MOVE_DEBUG;
            }
        }
    } else {
        AOP_MOVE_DEBUG;
    }
}


/*-----------------------------------------------------------------------*/
/* gen*                                                                  */
/*-----------------------------------------------------------------------*/

static void genCpl         (iCode *ic)                   { if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genCpl", ic);             } emit2(";; genCpl         ", ""); }
static void genGetByte     (iCode *ic)                   { if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genGetByte      = ", ic); } emit2(";; genGetByte     ", ""); }
static void genIpush       (iCode *ic)                   { if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genIpush        = ", ic); } emit2(";; genIpush       ", ""); }
static void genJumpTab     (iCode *ic)                   { if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genJumpTab      = ", ic); } emit2(";; genJumpTab     ", ""); }
static void genMult        (iCode *ic)                   { if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genMult         = ", ic); } emit2(";; genMult        ", ""); }
static void genNot         (iCode *ic)                   { if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genNot          = ", ic); } emit2(";; genNot         ", ""); }
static void genOr          (iCode *ic)                   { if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genOr           = ", ic); } emit2(";; genOr          ", ""); }
static void genRightShift  (iCode *ic)                   { if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genRightShift   = ", ic); } emit2(";; genRightShift  ", ""); }
static void genSwap        (iCode *ic)                   { if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genSwap         = ", ic); } emit2(";; genSwap        ", ""); }

void load_reg(const char *reg, operand *op) {
    if (!reg) {
        if (!regalloc_dry_run) {
            emit2("", ";; load_reg: reg is null");
        }
        return;
    }

    if (IS_OP_LITERAL (op)) {
        if (byteOfVal(OP_VALUE(op), 0) == 0) {
            emit_mov(reg, "zero");
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
                cost(2);
                emit_mov(reg, "mem");
            } else {
                emit2("", ";; load_reg remat + 0");
                load_address_16(result->name);
                emit_mov(reg, "mem");
            }
        } else if (OP_SYMBOL(op)->isspilt) {
            emit2(";", "load_reg: spilt");
            load_address_16(OP_SYMBOL(op)->usl.spillLoc->rname);
            emit_mov(reg, "mem");
        } else if (is_mem(op)) {
            if (!strcmp(reg, "mem")) {
                load_reg("stack", op);
                emit_mov("mem", "stack");
            } else {
                const char *label = op_get_mem_label(op);
                load_address_16(label);
                emit_mov(reg, "mem");
            }
        } else if (is_reg(op)) {
            const char *source_reg = op_get_register_name(op);
            emit_mov(reg, source_reg);
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
            emit_mov(dest_reg, reg);
        } else if (is_mem(op)) {
            load_address_16(op_get_mem_label(op));
            emit_mov("mem", reg);
        } else if (op->isParm) {
            load_address_16(OP_SYMBOL(op)->rname);
            emit_mov("mem", reg);
        } else if (OP_SYMBOL(op)->regType == REG_CND) {
            emit_mov("test", reg);
        } else if (OP_SYMBOL(op)->isspilt) {
            emit2(";", "read_reg: spilt");
            load_address_16(OP_SYMBOL(op)->usl.spillLoc->rname);
            emit_mov("mem", reg);
        } else if (OP_SYMBOL(op)->nRegs == 1) {
            /* emit2("; ", "symbol is in reg %s", OP_SYMBOL(op)->regs[0]->name); */
            if (!regalloc_dry_run) {
                emit_mov(OP_SYMBOL(op)->regs[0]->name, reg);
            } else {
                emit_mov("fake", reg);
            }
            cost(1);
        } else {
            emit_mov(OP_SYMBOL(op)->rname, reg);
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
  if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genDummyRead", ic); }

  operand *op;

  if ((op = IC_LEFT (ic)) && IS_SYMOP (op))
    ;
  else if ((op = IC_RIGHT (ic)) && IS_SYMOP (op))
    ;
  else
    return;

  if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genDummyRead    = ", ic); } emit2(";; genDummyRead   ", "");

  if (!is_reg(op) || strcmp("pic", op_get_register_name(op))) {
      load_reg("nop", op);
  } else {
      emit2(";", "dummy read omitted for pic register");
  }
}
/*-----------------------------------------------------------------*/
/* genAddrOf - generates code for address of                       */
/*-----------------------------------------------------------------*/
static void genAddrOf (iCode *ic) {
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genAddrOf", ic); }

    operand *result = IC_RESULT (ic);
    operand *left = IC_LEFT (ic);
    operand *right = IC_RIGHT (ic);

    emit2("", ";; genAddrOf: operand size %d, %d, %d", operandSize(result), operandSize(left), operandSize(right));

    

    if (is_mem(left)) {
        if (IS_OP_LITERAL(right)) {
            if (is_reg(result)) {
                if (operandSize(result) == 1) {
                    emit2("mov", "%s il ,%s + %d", op_get_register_name(result), op_get_mem_label(left), ulFromVal (OP_VALUE (right)));
                    cost(1);
                } else if (operandSize(result) == 2) {
                    emit2("mov", "%s il ,lo8(%s + %d)", op_get_register_name_i(result, 0), op_get_mem_label(left), ulFromVal (OP_VALUE (right)));
                    emit2("mov", "%s il ,hi8(%s + %d)", op_get_register_name_i(result, 1), op_get_mem_label(left), ulFromVal (OP_VALUE (right)));
                    cost(2);
                } else {
                    emit2(";; genAddrOf", "result is too big; size=%d", operandSize(result));
                }
            } else if (is_mem(result)) {
                if (operandSize(result) == 1) {
                    load_address_16(op_get_mem_label(result));
                    emit2("mov", "mem il ,%s + %d", op_get_mem_label(left), ulFromVal (OP_VALUE (right)));
                    cost(1);
                } else if (operandSize(result) == 2) {
                    load_address_16(op_get_mem_label(result));
                    emit2("mov", "mem il ,hi8(%s + %d)", op_get_mem_label(left), ulFromVal (OP_VALUE (right)));
                    load_address_16o(op_get_mem_label(result), 1);
                    emit2("mov", "mem il ,lo8(%s + %d)", op_get_mem_label(left), ulFromVal (OP_VALUE (right)));
                    cost(2);
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
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
/* i.e. result = *(left + right);                                  */
/*-----------------------------------------------------------------*/
static void genPointerGet(iCode *ic) {
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genPointerGet", ic); }

    operand *left = IC_LEFT (ic);
    operand *right = IC_RIGHT (ic);
    operand *result = IC_RESULT (ic);
    int size_left = operandSize(left);
    int size_result = operandSize(result);


    wassertl (right, "GET_VALUE_AT_ADDRESS without right operand");
    wassertl (IS_OP_LITERAL (right), "GET_VALUE_AT_ADDRESS with non-literal right operand");

    emit2("", ";; genPointerGet: operand size %d, %d, %d",
          operandSize(result),
          operandSize(left),
          operandSize(right)
          );

    if (IS_OP_LITERAL(right)) {
        int val = operandLitValue(right);
        if (size_result == 1) {
            if (size_left == 2) {
                if (IS_SYMOP(left)) {
                    if (OP_SYMBOL(left)->remat) {
                        remat_result_t *remat_result = resolve_remat(OP_SYMBOL(left));
                        D2(printf("has remat: %s + %d\n", remat_result->name, remat_result->offset));
                        emit2("mov", "adh il ,hi8(%s + %d)", remat_result->name, remat_result->offset);
                        emit2("mov", "adl il ,lo8(%s + %d)", remat_result->name, remat_result->offset);
                        cost(2);
                        if (is_mem(result)) {
                            emit2("mov", "stack mem");
                            cost(1);
                            read_reg("stack", result);
                        } else {
                            read_reg("mem", result);
                        }
                    } else if (OP_SYMBOL(left)->isspilt) {
                        if (!val) {
                            if (!regalloc_dry_run) {
                                print_op_diagnostics("left", left);
                            }
                            aopOp(result);
                            aopOp(left);
                            aop_move(ASMOP_ADHL, left->aop);
                            // put this in aop_move somehow?
                            if (AOP_IS_SPILL(result->aop)
                                || AOP_IS_DIRECT(result->aop)
                                || AOP_IS_IMMEDIATE(result->aop)) {
                                aop_move(ASMOP_STACK, ASMOP_MEM);
                                load_address_16(result->aop->aopu.immd);
                                aop_move(ASMOP_MEM, ASMOP_STACK);
                            } else {
                                aop_move(result->aop, ASMOP_MEM);
                            }
                            /* aop_move(result->aop, left->aop); */

                            /* emit2("", "; implement me (%s:%d) BROKEN", __FILE__, __LINE__); */
                            /* emit2("load_address_from_ptr", "%s", op_get_mem_label(left)); */
                            /* cost(8); */
                            /* if (is_mem(result)) { */
                            /*     emit_mov("stack", "mem"); */
                            /*     read_reg("stack", result); */
                            /* } else { */
                            /*     read_reg("mem", result); */
                            /* } */
                        } else {
                            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                        }
                    } else if (is_mem(left)) {
                        emit2("mov", "adh il ,hi8(%s + %d)", op_get_mem_label(left), val);
                        emit2("mov", "adl il ,lo8(%s + %d)", op_get_mem_label(left), val);
                        cost(2);
                        read_reg("mem", result);
                    } else if (is_reg(left)) {
                        if (!val) {
                            /* emit2("lad", "%s",     op_get_mem_label(result)); */
                            /* emit2("mov", "mem %s", op_get_register_name_i(left, 0)); */
                            /* emit2("lad", "%s + 1", op_get_mem_label(result)); */
                            /* emit2("mov", "mem %s", op_get_register_name_i(left, 1)); */
                            aopOp(result);
                            aopOp(left);
                            aop_move(result->aop, left->aop);
                        } else {
                            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                        }
                    } else {
                        emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    }
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }                    
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else if (size_result == 2) {
            if (size_left == 2) {
                if (IS_SYMOP(left)) {
                    if (OP_SYMBOL(left)->remat) {
                        remat_result_t *remat_result = resolve_remat(OP_SYMBOL(left));
                        D2(printf("has remat: %s + %d\n", remat_result->name, remat_result->offset));
                        emit2("mov", "adh il ,hi8(%s + %d)", remat_result->name, remat_result->offset);
                        emit2("mov", "adl il ,lo8(%s + %d)", remat_result->name, remat_result->offset);
                        cost(2);
                        if (is_mem(result)) {
                            emit2("mov", "stack mem");
                            cost(1);
                            read_reg("stack", result);
                        } else {
                            read_reg("mem", result);
                        }
                    } else {
                        if (!val) {
                            if (OP_SYMBOL(left)->isspilt) {
                                if (!regalloc_dry_run) {
                                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                                    print_op_diagnostics("left", left);
                                }
                                /* emit2("load_address_from_ptr", "%s", op_get_mem_label(left)); */
                                /* emit_mov("stack", "mem"); */
                                /* emit2("load_address_from_ptr", "%s + 1", op_get_mem_label(left)); */
                                /* emit_mov("stack", "mem"); */

                            } else if (is_mem(left)) {
                                emit_macro_load_address_from_ptr(op_get_mem_label(left));
                                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                                read_reg("mem", result);
                            } else if (is_reg(left)) {
                                if (is_mem(result)) {
                                    emit2("lad", "%s",     op_get_mem_label(result));
                                    emit2("mov", "mem %s", op_get_register_name_i(left, 0));
                                    emit2("lad", "%s + 1", op_get_mem_label(result));
                                    emit2("mov", "mem %s", op_get_register_name_i(left, 1));
                                    cost(6);
                                } else {
                                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                                }
                            } else {
                                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                            }
                        } else {
                            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                        }
                    }
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }
    } else {
        emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
    }

    return;

    if (size_result == 1 && size_left == 1) {
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
    } else if (size_result == 2 && size_left == 2) {
        if (IS_OP_LITERAL(right)) {
            int val = operandLitValue(right);
            if (OP_SYMBOL(left)->remat) {
                remat_result_t *remat_result = resolve_remat(OP_SYMBOL(left));
                D2(printf("has remat: %s + %d\n", remat_result->name, remat_result->offset));
                emit2("mov", "adh il ,hi8(%s + %d)", remat_result->name, remat_result->offset);
                emit2("mov", "adl il ,lo8(%s + %d)", remat_result->name, remat_result->offset);
                cost(2);
                if (is_mem(result)) {
                    emit_mov("stack", "mem");
                    read_reg("stack", result);
                } else {
                    read_reg("mem", result);
                }
            } else {
                if (!val) {
                    if (OP_SYMBOL(left)->isspilt) {
                        emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                        emit_macro_load_address_from_ptr(op_get_mem_label(left));
                        read_reg("mem", result);
                    } else if (is_mem(left)) {
                        emit_macro_load_address_from_ptr(op_get_mem_label(left));
                        emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);

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
                        cost(6);
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
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genPointerSet", ic); }

    operand *left = IC_LEFT (ic);
    operand *right = IC_RIGHT (ic);
    int size_left = operandSize(left);
    int size_right = operandSize(right);

    emit2("", ";; genPointerSet: operand size %d, %d", size_left, operandSize(right));

    if (size_left == 1) {
        if (IS_OP_LITERAL(right)) {
            emit2(";; genPointerSet: literal right not implemented(1)", "");
        } else if (is_mem(right)) {
            if (is_reg(left)) {
                load_reg("stack", right);
                emit2("mov", "adh zero");
                emit2("mov", "adl %s", op_get_register_name(left));
                emit2("mov", "mem stack");
                cost(3);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else if (is_reg(right)) {
            if (is_reg(left)) {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            emit2(";; genPointerSet: non-memory right not implemented(1)", "");
        }
    } else if (size_left == 2) {
        if (IS_OP_LITERAL(right)) {
            int val = operandLitValue(right);
            // TODO optimize when val is zero
            if (IS_SYMOP(left)) {
                if (OP_SYMBOL(left)->remat) {
                    remat_result_t *result = resolve_remat(OP_SYMBOL(left));
                    D2(printf("has remat: %s + %d\n", result->name, result->offset));
                    emit2("mov", "adh il ,hi8(%s + %d)", result->name, result->offset);
                    emit2("mov", "adl il ,lo8(%s + %d)", result->name, result->offset);
                    emit2("mov", "mem il ,%d", val);
                    cost(3);
                } else if (OP_SYMBOL(left)->isspilt) {
                    // two-byte value is spilled...
                    print_op_diagnostics("left", left);
                    emit_macro_load_address_from_ptr(op_get_mem_label(left));
                    load_reg("mem", right);
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
                    aopOp(left);
                    aopOp(right);
                    aop_move(ASMOP_ADHL, left->aop);
                    aop_move(ASMOP_MEM, right->aop);
                    /* if (!regalloc_dry_run) { */
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    /* } */
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
        } else if (OP_SYMBOL(right)->isspilt) {
            if (size_right == 1) {
                if (OP_SYMBOL(left)->remat) {
                    load_address_16(op_get_mem_label(right));
                    emit_mov("stack", "mem");

                    remat_result_t *result = resolve_remat(OP_SYMBOL(left));

                    // TODO replace with emit_macro_... call
                    emit2("", "load_address_from_ptr %s+%d", result->name, result->offset);
                    cost(8);

                    emit_mov("mem", "stack");

                    emit2("", "; implement me (%s:%d) (BROKEN)", __FILE__, __LINE__);
                    print_op_diagnostics("right", right);
                    print_op_diagnostics("left ", left);
                } else {
                    emit2("", "; implement me (%s:%d) (BROKEN)", __FILE__, __LINE__);
                    print_op_diagnostics("right", right);
                    print_op_diagnostics("left ", left);
                }
            } else {
                emit2("", "; implement me (%s:%d) (BROKEN)", __FILE__, __LINE__);
                print_op_diagnostics("right", right);
                print_op_diagnostics("left ", left);
            }                
        } else if (is_mem(right)) {
            if (OP_SYMBOL(left)->remat) {
                emit2("", "; implement me (%s:%d) (BROKEN)", __FILE__, __LINE__);
                print_op_diagnostics("right", right);
                print_op_diagnostics("left ", left);
            } else if (is_reg(left)) {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                load_reg("stack", right);
                emit2("mov", "adh zero");
                emit2("mov", "adl %s", op_get_register_name(left));
                emit2("mov", "mem stack");
                cost(3);
            } else if (is_mem(left)) {
                // left has the address to write to
                // right is the value to write
                // first load the value
                load_address_16(op_get_mem_label(right));
                emit2("mov", "stack mem");
                cost(1);
                // now write it
                emit2("load_address_from_ptr", "%s", op_get_mem_label(left));
                cost(8);
                emit2("mov", "mem stack");
                cost(1);
            } else {
                print_op_diagnostics("left", left);
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            if (is_reg(left)) {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            } else if (OP_SYMBOL(left)->remat) {
                emit2("", "; implement me (%s:%d) (BROKEN)", __FILE__, __LINE__);
                remat_result_t *result = resolve_remat(OP_SYMBOL(left));
                D2(printf("has remat: %s + %d\n", result->name, result->offset));
                emit2("mov", "adh il ,hi8(%s + %d)", result->name, result->offset);
                emit2("mov", "adl il ,lo8(%s + %d)", result->name, result->offset);
                /* emit2("mov", "mem il ,%d", val); */
                cost(3);
            } else if (OP_SYMBOL(left)->isspilt) {
                // left has the address to write to
                // right is the value to write
                print_op_diagnostics("left", left);
                emit2("load_address_from_ptr", "%s", op_get_mem_label(left));
                cost(8);
                load_reg("mem", right);
            } else if (is_mem(left)) {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
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
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genCall", ic); }

    sym_link *dtype = operandType (IC_LEFT (ic));
    sym_link *etype = getSpec (dtype);
    sym_link *ftype = IS_FUNCPTR (dtype) ? dtype->next : dtype;
    /* bool tailjump = false; */

    operand *left = IC_LEFT (ic);
    operand *result = IC_RESULT (ic);

    const bool bigreturn = (getSize (ftype->next) > 1) || IS_STRUCT (ftype->next);
    const bool returns_value =
        IS_TRUE_SYMOP (result)
        || (IS_ITEMP (result)
            && (OP_SYMBOL (result)->nRegs
                || OP_SYMBOL (result)->spildir));


    if (ic->op == PCALL) {
        emit2("; What is a PCALL?", "");
    } else {
        bool pushed_r = false;
        bool pushed_x = false;

        if (!regDead (R_IDX, ic)) {
            emit_mov("stack", "r");
            pushed_r = true;
        }
        if (!regDead (X_IDX, ic)) {
            emit_mov("stack", "x");
            pushed_x = true;
        }

        symbol *label = new_label(NULL);
        emit2("mov", "stack il ,hi8(!tlabel)", label_num(label));
        emit2("mov", "stack il ,lo8(!tlabel)", label_num(label));
        cost(2);

        if (IS_LITERAL (etype)) {
            emit_jump_to_number(ulFromVal (OP_VALUE (left)), 0);
        } else {
            const char *name;
            if (OP_SYMBOL (left)->rname[0]) {
                name = OP_SYMBOL (left)->rname;
            } else {
                name = OP_SYMBOL (left)->name;
            }
            emit_jump_to_symbol(name, 0);
        }

        tarn_emit_label(label);

        if (returns_value) {
            if (bigreturn) {
                if (IS_SYMOP(result)) {
                    if (OP_SYMBOL(result)->isspilt) {
                        // pop it largest-byte first (???)
                        for (int i = 0; i < OP_SYMBOL(result)->nRegs; ++i) {
                            load_address_16o(op_get_mem_label(result), i);
                            emit_mov("mem", "stack");
                        }
                    } else if (is_reg(result)) {
                        print_op_diagnostics("result", result);
                        // pop it largest-byte first
                        for (int i = 0; i < OP_SYMBOL(result)->nRegs; ++i) {
                            emit_mov(op_get_register_name_i(result, i), "stack");
                        }
                    }
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    return;
                }
            } else {
                read_reg("stack", result);
            }
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

        emit2("mov", "jmpl stack");
        emit2("mov", "jmph stack");
        cost(2);

        aopOp(left);

        if (operandSize(left) == 1) {
            load_reg("stack", left);
        } else if (operandSize(left) == 2) {
            if (IS_SYMOP(left)) {
                if (OP_SYMBOL(left)->remat) {
                    remat_result_t *result = resolve_remat(OP_SYMBOL(left));
                    D2(printf("has remat: %s + %d\n", result->name, result->offset));
                    emit2("mov", "stack il ,lo8(%s + %d)", result->name, result->offset);
                    emit2("mov", "stack il ,hi8(%s + %d)", result->name, result->offset);
                    cost(2);
                } else if (is_reg(left)) {
                    // push LOWEST byte first because we pop HIGHEST byte first later
                    for (int i = OP_SYMBOL(left)->nRegs - 1; i >= 0; --i) {
                        emit_mov("stack", op_get_register_name_i(left, i));
                    }
                } else if (is_mem(left)) {
                    emit2("mov", "stack il ,lo8(%s)", op_get_mem_label(left));
                    emit2("mov", "stack il ,hi8(%s)", op_get_mem_label(left));
                    cost(2);
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
            } else if (IS_OP_LITERAL(left)) {
                aop_move(ASMOP_STACK, left->aop);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                emit_asmop("left", left->aop);
            }
        }

        emit2("jump", "");
        cost(1);
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
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genEndFunction", ic); }

    // TODO don't generate for a function that has a return value...

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
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genAssign", ic); }

    operand *result = IC_RESULT (ic);
    operand *right = IC_RIGHT (ic);

    aopOp(result);
    aopOp(right);

    aop_move(result->aop, right->aop);

    int size_result = operandSize(result);
    int size_right = operandSize(right);

    if (size_result == 1 && size_right == 1) {
        if (IS_SYMOP (result)) {
            if (IS_SYMOP (right)) {
                if (is_mem(right)) {
                    if (is_mem(result)) {
                    } else {
                        /* const char *result_reg = op_get_register_name(result); */
                        /* load_reg(result_reg, right); */
                    }
                } else {
                    if (is_mem(result)) {
                        /* const char *result_reg = op_get_mem_label(result); */
                        /* const char *right_reg = op_get_register_name(right); */
                        /* load_address_16(result_reg); */
                        /* emit2("mov", "mem %s", right_reg); */
                        /* cost(1); */
                    } else {
                        const char *result_reg = op_get_register_name(result);
                        const char *right_reg = op_get_register_name(right);
                        if (result_reg && right_reg && !strcmp(result_reg, right_reg)) {
                            emit2(";", "genAssign: registers %s, %s same; skipping assignment", result_reg, right_reg);
                        }
                    }
                }
            } else if (IS_OP_LITERAL (right)) {
                if (is_mem(result)) {
                    /* load_address_16(op_get_mem_label(result)); */
                    /* if (byteOfVal(OP_VALUE(right), 0) == 0) { */
                    /*     emit_mov("mem", "zero"); */
                    /* } else { */
                    /*     emit2("mov", "mem il ,%d", byteOfVal(OP_VALUE(right), 0)); */
                    /*     cost(1); */
                    /* } */
                }



            } else {
                emit2("; genAssign: can't handle right", "");
            }
        } else {
            emit2("; genAssign: can't handle non-symbol result", "");
        }
    } else if (size_result == 2 && size_right == 2) {
        if (is_mem(result)) {
            if (IS_SYMOP (right)) {
                if (OP_SYMBOL(right)->remat) {
                    /* remat_result_t *remat_result = resolve_remat(OP_SYMBOL(right)); */
                    /* emit2(";", "remat: %s + %d", remat_result->name, remat_result->offset); */
                    /* /\* load_address_16o(remat_result->name, remat_result->offset); *\/ */
                    /* /\* emit2("mov", "stack mem ; hi"); *\/ */
                    /* /\* load_address_16o(remat_result->name, remat_result->offset + 1); *\/ */
                    /* /\* emit2("mov", "stack mem ; lo"); *\/ */

                    /* load_address_16(op_get_mem_label(result)); */
                    /* emit2("mov", "mem il ,hi8(%s + %d) ; hi", remat_result->name, remat_result->offset); */
                    /* load_address_16o(op_get_mem_label(result), 1); */
                    /* emit2("mov", "mem il ,lo8(%s + %d) ; lo", remat_result->name, remat_result->offset); */
                    /* cost(2); */
                } else if (OP_SYMBOL(right)->isspilt) {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    emit2("load_address_from_ptr", "%s", OP_SYMBOL(right)->usl.spillLoc->rname);
                    cost(8);
                    emit2("mov", "stack mem");
                    cost(1);
                    emit2("load_address_from_ptr", "%s + 1", OP_SYMBOL(right)->usl.spillLoc->rname);
                    cost(8);
                    emit2("mov", "stack mem");
                    cost(1);
                } else if (is_mem(right)) {
                } else if (is_reg(right)) {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    load_address_16(op_get_mem_label(result));
                    emit2("mov", "mem %s ; hi", op_get_register_name_i(right, 1));
                    load_address_16o(op_get_mem_label(result), 1);
                    emit2("mov", "mem %s ; lo", op_get_register_name_i(right, 0));
                    cost(2);
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
            } else if (IS_OP_LITERAL(right)) {
                print_op_diagnostics("right", right);
                load_address_16(op_get_mem_label(result));
                emit2("mov", "mem il, %d ; hi", byteOfVal(OP_VALUE(right), 1));
                load_address_16o(op_get_mem_label(result), 1);
                emit2("mov", "mem il, %d ; lo", byteOfVal(OP_VALUE(right), 0));
                cost(2);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else if (is_reg(result)) {
            if (IS_SYMOP (right)) {
                if (OP_SYMBOL(right)->remat) {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                } else if (OP_SYMBOL(right)->isspilt) {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    load_address_16(op_get_mem_label(right));
                    /* emit2("load_address_from_ptr", "%s", OP_SYMBOL(right)->usl.spillLoc->rname); */
                    emit2("mov", "%s mem", op_get_register_name_i(result, 1));
                    /* emit2("load_address_from_ptr", "%s + 1", OP_SYMBOL(right)->usl.spillLoc->rname); */
                    load_address_16o(op_get_mem_label(right), 1);
                    emit2("mov", "%s mem", op_get_register_name_i(result, 0));
                    cost(2+8+8);
                } else if (is_mem(right)) {
                } else if (is_reg(right)) {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                } else if (IS_OP_LITERAL(right)) {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
            }
        } else {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }
    }
}

static void genCast(iCode *ic) {
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genCast", ic); }

    operand *result = IC_RESULT (ic);
    operand *right = IC_RIGHT (ic);

    int size_result = operandSize(result);
    int size_right = operandSize(right);

    if (size_result == 2 && size_right == 1) {
        if (is_mem(result)) {
            // store zero in high byte
            load_address_16(op_get_mem_label(result));
            emit_mov("mem", "zero");
        } else if (is_reg(result)) {
            // store zero in high byte
            emit_mov(op_get_register_name_i(result, 1), "zero");
        } else {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }
        if (is_mem(right)) {
            if (is_mem(result)) {
                // store right in low byte
                load_address_16(op_get_mem_label(right));
                emit_mov("stack", "mem");
                load_address_16o(op_get_mem_label(result), 1);
                emit_mov("mem", "stack");
            } else if (is_reg(result)) {
                load_address_16(op_get_mem_label(right));
                emit_mov(op_get_register_name_i(result, 0), "mem");
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else if (is_reg(right)) {
            if (is_mem(result)) {
                // store right in low byte
                load_address_16o(op_get_mem_label(result), 1);
                load_reg("mem", right);
            } else if (is_reg(result)) {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }
    } else if (size_result == 1 && size_right == 2) {
        if (is_mem(right)) {
            if (is_mem(result)) {
                // store only low byte
                load_address_16o(op_get_mem_label(right), 1);
                emit_mov("stack", "mem");
                load_address_16(op_get_mem_label(result));
                emit_mov("mem", "stack");
            } else if (is_reg(result)) {
                // store only low byte
                load_address_16o(op_get_mem_label(right), 1);
                read_reg("mem", result);
                cost(1);
            } else {
                print_op_diagnostics("right", right);
                print_op_diagnostics("result", result);
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else if (is_reg(right)) {
            if (is_mem(result)) {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            } else if (is_reg(result)) {
                const char *result_reg = op_get_register_name(result);
                const char *right_reg = op_get_register_name(right);
                if (result_reg && right_reg && strcmp(result_reg, right_reg)) {
                    // only mov if diff regs
                    emit_mov(op_get_register_name(result), op_get_register_name(right));
                } else {
                    emit2("", "; no need to copy a register to itself");
                }
            } else {
                print_op_diagnostics("right", right);
                print_op_diagnostics("result", result);
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }
    } else if (size_result == 2 && size_right == 2) {
        genAssign(ic);
    } else {
        if (size_result == size_right) {
            if (is_mem(right)) {
                if (is_mem(result)) {
                    for (int i = 0; i < size_result; ++i) {
                        load_address_16o(op_get_mem_label(right), i);
                        emit_mov("stack", "mem");
                        load_address_16o(op_get_mem_label(result), i);
                        emit_mov("mem", "stack");
                    }
                } else if (is_reg(result)) {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                } else {
                    emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                }
            } else if (is_reg(right)) {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            emit2("", "; size %d, %d", size_result, size_right);
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }
    }

}


static void genIfx_core(symbol *t, symbol *f, int invert) {
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
        // We jump to f if the condition is FALSE, so we make a new
        // label and jump OVER the jnz instruction if the condition is
        // TRUE.
        symbol *label = NULL;
        if (!regalloc_dry_run) {
            label = new_label(NULL);
            emit_jump_to_label(label, 1);
        }
        emit_jump_to_label(f, 0);
        if (!regalloc_dry_run) {
            tarn_emit_label(label);
        }
        return;
    }

    emit2("; genIfx: op is unknown", "");

}

static void genIfx_impl(iCode *ic, int invert) {
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genIfx", ic); }

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

    if (invert) {
        t = IC_FALSE(ic);
        f = IC_TRUE(ic);
    } else {
        t = IC_TRUE(ic);
        f = IC_FALSE(ic);
    }

    genIfx_core(t, f, invert);
}

/*-----------------------------------------------------------------*/
/* genIfx - generate code for Ifx statement                        */
/*-----------------------------------------------------------------*/
static void genIfx (iCode *ic)
{
    genIfx_impl(ic, 0);
}

void aop_alu(int op, asmop *left, asmop *right, asmop *result, iCode *ifx) {
#define MOVE_AOP_DEBUG { emit2("", "; implement me (%s:%d)", __FILE__, __LINE__); emit_asmop("left ", left); emit_asmop("right", right); emit_asmop("result", result); }

    int size_left = left->size;
    int size_right = right ? right->size : 0;

    wassertl(size_right > 0 || op == ALUS_NOT, "Binary ALU operation with NULL right!");

    if (size_left == 1 && size_right < 2) {
        if (op == ALUS_MINUS) {
            if (AOP_IS_LIT(right)) {
                op = ALUS_PLUS;
                aop_move(ASMOP_ALUA, left);
                // In general, it doesn't matter when alus is
                // set.. except when reading from aluc into alua or
                // alub...
                emit2("mov", "alus il ,%d\t; %s ", op, alu_operations[op]);
                emit2("mov", "alub il ,%d", -byteOfVal(right->aopu.aop_lit, 0));
                cost(2);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            cost(1);
            aop_move(ASMOP_ALUA, left);
            emit2("mov", "alus il ,%d\t; %s ", op, alu_operations[op]);
            if (right) {
                aop_move(ASMOP_ALUB, right);
            }
        }
        if (!ifx) {
            if (result != ASMOP_ALUC) {
                aop_move(result, ASMOP_ALUC);
            }
        }
    } else if (size_left > 1 && size_right == 0) {
        // unary multi-byte
        if (!ifx) {
            if (result != ASMOP_ALUC) {
                aop_move(result, ASMOP_ALUC);
            }
        }
    } else if (size_left > 1 && size_right == 1) {
        if (AOP_IS_LIT(right)) {
            for (int i = 0; i < size_left; ++i) {
                aop_move_byte(ASMOP_STACK, left, i);
            }
            emit2("add_16s_8", "%d", byteOfVal(right->aopu.aop_lit, 0));
            cost(15);
            if (aop_move(result, ASMOP_RX)) {
                emit2("restore_rx", "");
                cost(6);
            }
        } else if (AOP_IS_REG(right)) {
            for (int i = 0; i < size_left; ++i) {
                aop_move_byte(ASMOP_STACK, left, i);
            }
            aop_move(ASMOP_STACK, right);
            emit2("add_8s_16s", "");
            cost(15);
            if (aop_move(result, ASMOP_RX)) {
                emit2("restore_rx", "");
                cost(6);
            }
        } else {
            if (AOP_IS_IMMEDIATE(right)) {
                MOVE_AOP_DEBUG;
            } if (AOP_IS_IMMEDIATE(left)) {
                aop_move(ASMOP_STACK, right);
                emit2("add_8s_16", "%s", left->aopu.aop_dir);
                cost(15);
                if (aop_move(result, ASMOP_RX)) {
                    emit2("restore_rx", "");
                    cost(6);
                }
            } else if (AOP_IS_DIRECT(right)) {
                MOVE_AOP_DEBUG;
            } else {
                // here
                MOVE_AOP_DEBUG;
            }
        }
    } else {
        MOVE_AOP_DEBUG;
    }
}


static void genUminus(iCode *ic) {
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genUminus", ic); }

    operand *result = IC_RESULT (ic);
    operand *left = IC_LEFT (ic);

    aopOp(result);
    aopOp(left);

    if (left->aop->size == 1) {
        aop_alu(ALUS_NOT, left->aop, NULL, ASMOP_ALUC, NULL);
        aop_alu(ALUS_PLUS, ASMOP_ALUC, ASMOP_ONE, result->aop, NULL);
    } else {
        /* int size_left = left->aop->size; */
        int size_result = result->aop->size;
        emit_mov_lit("alus", ALUS_NOT);
        for (int i = 0; i < size_result; ++i) {
            load_address_16o(left->aop->aopu.aop_dir, i);
            emit_mov("alua", "mem");
            emit_mov("stack", "aluc");
        }
        if (left->aop->size == 2) {
            emit2("add_16s_8", "%d", 1);
            cost(15);
            aop_move(result->aop, ASMOP_RX);
            if (!aopSame(result->aop, 0, ASMOP_RX, 0, left->aop->size)) {
                emit2("restore_rx", "");
                cost(6);
            }
        } else {
            emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
        }
        
        /* if (AOP_IS_DIRECT(left)) { */
        /*     emit2("mov", "alus il ,%d\t; %s ", ALUS_NOT, alu_operations[ALUS_NOT]); */
        /*     for (int i = 0; i < size_left; ++i) { */
        /*         load_address_16o(left->aopu.aop_dir, i); */
        /*         emit_mov("stack", "mem"); */
        /*     } */
        /*     MOVE_AOP_DEBUG; */
        /*     /\* aop_move(ASMOP_ALUA, left); *\/ */
        /* } else { */
        /*     MOVE_AOP_DEBUG; */
        /* } */

    }

}



static void genALUOp_impl(int op, operand *left, operand *right, operand *result, iCode *ifx) {
    emit2(";;", "ALU %s (%d)", alu_operations[op], op);

    bool result_is_cond = OP_SYMBOL(result)->regType == REG_CND;
    int size_result = operandSize(result);
    int size_left = operandSize(left);
    int size_right = operandSize(right);
    emit2(";;", "ALU operand size %d %d %d", size_result, size_left, size_right);

    aopOp(result);
    aopOp(left);
    aopOp(right);
    aop_alu(op, left->aop, right->aop, result->aop, ifx);

    if ((size_result == 1 || result_is_cond) && size_left == 1 && size_right == 1) {
        if (op == ALUS_MINUS) {
            /* if (IS_OP_LITERAL(right)) { */
            /*     op = ALUS_PLUS; */
            /*     emit2("mov", "alus il ,%d\t; %s ", op, alu_operations[op]); */
            /*     load_reg("alua", left); */
            /*     emit2("mov", "alub il ,%d", -byteOfVal(OP_VALUE(right), 0)); */
            /* } else { */
            /*     emit2("", "; implement me (%s:%d)", __FILE__, __LINE__); */
            /* } */
        } else {
            /* emit2("mov", "alus il ,%d\t; %s ", op, alu_operations[op]); */
            /* cost(1); */

            /* load_reg("alua", left); */
            /* load_reg("alub", right); */
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
            /* read_reg("aluc", result); */
        }
    } else if (size_result == 2 && size_left == 2 && size_right == 1) {
        
        if (op == ALUS_PLUS) {
            /* if (is_reg(right)) { */
            /*     if (OP_SYMBOL(left)->remat) { */
            /*         remat_result_t *result = resolve_remat(OP_SYMBOL(left)); */
            /*         emit2("mov", "stack %s", op_get_register_name(right)); */
            /*         emit2("add_8s_16", "%s ; 1", result->name); */
            /*         cost(3+15); */
            /*     } else if (OP_SYMBOL(left)->isspilt) { */
            /*         emit2("mov", "stack il ,hi8(%s)", OP_SYMBOL(left)->usl.spillLoc->rname); */
            /*         emit2("mov", "stack il ,lo8(%s)", OP_SYMBOL(left)->usl.spillLoc->rname); */
            /*         load_address_16(op_get_mem_label(right)); */
            /*         emit2("mov", "stack mem"); */
            /*         emit2("add_8s_16s", ""); */
            /*         cost(3+15); */
            /*     } else if (is_mem(left)) { */
            /*         emit2("load_stack_from_ptr", "%s", op_get_mem_label(left)); */
            /*         emit2("mov", "stack %s", op_get_register_name(right)); */
            /*         emit2("add_8s_16s", ""); */
            /*         cost(1+6+15); */
            /*     } else { */
            /*         emit2("", "; implement me (%s:%d)", __FILE__, __LINE__); */
            /*     } */
            /* } else if (is_mem(right)) { */
            /*     if (OP_SYMBOL(left)->remat) { */
            /*         remat_result_t *result = resolve_remat(OP_SYMBOL(left)); */
            /*         /\* emit2("load_stack_from_ptr", "%s + %d", result->name, result->offset); *\/ */
            /*         emit2("mov", "stack il ,hi8(%s + %d)", result->name, result->offset); */
            /*         emit2("mov", "stack il ,lo8(%s + %d)", result->name, result->offset); */
            /*         load_address_16(op_get_mem_label(right)); */
            /*         emit2("mov", "stack mem"); */
            /*         emit2("add_8s_16s", ""); */
            /*         cost(3+15); */
            /*     } else if (OP_SYMBOL(left)->isspilt) { */
            /*         emit2("load_stack_from_ptr", "%s", OP_SYMBOL(left)->usl.spillLoc->rname); */
            /*         /\* emit2("mov", "stack il ,hi8(%s)", OP_SYMBOL(left)->usl.spillLoc->rname); *\/ */
            /*         /\* emit2("mov", "stack il ,lo8(%s)", OP_SYMBOL(left)->usl.spillLoc->rname); *\/ */
            /*         load_address_16(op_get_mem_label(right)); */
            /*         emit2("mov", "stack mem"); */
            /*         emit2("add_8s_16s", ""); */
            /*         cost(6+1+15); */
            /*     } else if (is_mem(left)) { */
            /*         emit2("load_stack_from_ptr", "%s", OP_SYMBOL(left)->rname); */
            /*         /\* emit2("mov", "stack il ,hi8(%s)", OP_SYMBOL(left)->rname); *\/ */
            /*         /\* emit2("mov", "stack il ,lo8(%s)", OP_SYMBOL(left)->rname); *\/ */
            /*         load_address_16(op_get_mem_label(right)); */
            /*         emit_mov("stack", "mem"); */
            /*         emit2("add_8s_16s", ""); */
            /*         cost(3+15); */
            /*     } else if (is_reg(left)) { */
            /*         emit_mov("stack", op_get_register_name_i(left, 1)); */
            /*         emit_mov("stack", op_get_register_name_i(left, 0)); */
            /*         load_address_16(op_get_mem_label(right)); */
            /*         emit_mov("stack", "mem"); */
            /*         emit2("add_8s_16s", ""); */
            /*     } else { */
            /*         emit2("", "; implement me (%s:%d)", __FILE__, __LINE__); */
            /*     } */
            /* } else if (IS_OP_LITERAL(right)) { */
            /*     int right_val = byteOfVal(OP_VALUE(right), 0); */
            /*     if (op == ALUS_MINUS && IS_OP_LITERAL(right)) { */
            /*         op = ALUS_PLUS; */
            /*         right_val = -right_val; */
            /*     } */
            /*     if (OP_SYMBOL(left)->remat) { */
            /*         emit2("", "; implement me (%s:%d)", __FILE__, __LINE__); */
            /*     } else if (OP_SYMBOL(left)->isspilt) { */
            /*         load_address_16(op_get_mem_label(left)); */
            /*         emit2("mov", "stack mem"); */
            /*         load_address_16o(op_get_mem_label(left), 1); */
            /*         emit2("mov", "stack mem"); */
            /*         emit2("add_16s_16l", "%d", 0xff & right_val); */
            /*         cost(2+14); */
            /*     } else if (is_mem(left)) { */
            /*         load_address_16(op_get_mem_label(left)); */
            /*         emit2("mov", "stack mem"); */
            /*         load_address_16o(op_get_mem_label(left), 1); */
            /*         emit2("mov", "stack mem"); */
            /*         emit2("add_16s_16l", "%d", 0xff & right_val); */
            /*         cost(2+14); */
            /*     } else { */
            /*         emit2("", "; implement me (%s:%d)", __FILE__, __LINE__); */
            /*     } */
            /* } else { */
            /*     emit2("", "; implement me (%s:%d)", __FILE__, __LINE__); */
            /* } */
            // cost?

            /* if (op_get_register_name_i(result, 0) */
            /*     && op_get_register_name_i(result, 1) */
            /*     && !strcmp(op_get_register_name_i(result, 0), "r") */
            /*     && !strcmp(op_get_register_name_i(result, 1), "x")) { */
            /*     emit2(";", "result is already in r x"); */
            /* } else { */
            /*     if (is_mem(result)) { */
            /*         emit2("lad", "%s",     op_get_mem_label(result)); */
            /*         emit2("mov", "mem x"); */
            /*         emit2("lad", "%s + 1", op_get_mem_label(result)); */
            /*         emit2("mov", "mem r"); */
            /*         cost(6); */
            /*     } else { */
            /*         emit2("", "; implement me (%s:%d)", __FILE__, __LINE__); */
            /*         cost(1000); */
            /*     } */

            /*     emit2("restore_rx", ""); */
            /*     cost(6); */
            /* } */
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
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genALUOp", ic); }

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

    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genLeftShift", ic); }

    if (IS_OP_LITERAL(right)) {
        if (byteOfVal(OP_VALUE(right), 0) == 1) {
            // one bit, multiply by two, ie. add self to self.
            genALUOp_impl(ALUS_PLUS, left, left, result, NULL);
        } else if (byteOfVal(OP_VALUE(right), 0) == 8) {
            // special case! just move low byte(s) up.
            int size_result = operandSize(result);
            int size_left = operandSize(left);

            if (size_result == 1 && size_left == 2) {
                // uh, well, low byte of 8-bit shifted value is zero.
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            } else  if (size_result == 2 && size_left == 2) {
                if (is_mem(result)) {
                    // zero to low
                    load_address_16o(op_get_mem_label(result), 1);
                    emit_mov("mem", "zero");
                }
                // just copy low to high and zero to low
                if (is_mem(left)) {
                    if (is_mem(result)) {
                        // low to high
                        load_address_16o(op_get_mem_label(left), 1);
                        emit_mov("stack", "mem");
                        load_address_16(op_get_mem_label(result));
                        emit_mov("mem", "stack");
                    } else if (is_reg(result)) {
                        // zero to low
                        emit_mov(op_get_register_name_i(result, 0), "mem");
                        // low to high
                        load_address_16o(op_get_mem_label(left), 1);
                        emit_mov(op_get_register_name_i(result, 1), "mem");
                    } else {
                        emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                        /* const char *result_reg = op_get_register_name(result); */
                        /* load_reg(result_reg, left); */
                    }
                } else if (is_reg(left)) {
                    if (is_mem(result)) {
                        // low to high
                        load_address_16(op_get_mem_label(result));
                        emit_mov("mem", op_get_register_name_i(left, 0));
                    } else if (is_reg(result)) {
                        emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    } else {
                        emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
                    }
                }
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }
        } else {
            wassertl(0, "Left shift by other than 1 or 8 not implemented.");
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
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genGoto", ic); }
    emit_jump_to_label (IC_LABEL (ic), 0);
}


static void genCmpEQorNE   (iCode *ic, iCode *ifx)       {
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genCmpEQorNE", ic); }

    D2(emit2("\t;; test equality", ""));
    emit2("mov", "alus il ,%d\t; %s ", ALUS_EQ, alu_operations[ALUS_EQ]);
    cost(1);

    operand *left = IC_LEFT(ic);
    operand *right = IC_RIGHT(ic);
    operand *result = IC_RESULT(ic);

    aopOp(left);
    aopOp(right);
    aopOp(result);

    if (left->aop->size == 1 && right->aop->size == 1 && result->aop->size == 1) {
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
                emit_mov("alua", "mem");
            } else if (IS_OP_LITERAL(left)) {
                load_reg("alua", left);
            } else {
                emit2("", "; implement me (%s:%d)", __FILE__, __LINE__);
            }

            if (is_reg(right)) {
                load_reg("alub", right);
            } else if (is_mem(right)) {
                load_address_16(op_get_mem_label(right));
                emit_mov("alub", "mem");
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

    } else {
        symbol *result_is_eq_maybe = new_label(NULL);
        symbol *result_is_ne = new_label(NULL);
        symbol *result_is_eq;

        if (ifx) {
            emit2(";", "has ifx");
            result_is_eq = IC_TRUE(ifx);
            /* genIfx(ifx); */
        } else {
            emit2(";", "no ifx");
            result_is_eq = new_label(NULL);
            result_is_ne = result_is_eq;
        }

        if (left->aop->size == right->aop->size) {
            for (int i = 0; i < left->aop->size; ++i) {
                /* aop_alu(ALUS_NOT, left->aop, NULL, ASMOP_ALUC, NULL); */
                aop_move_byte(ASMOP_ALUA, right->aop, right->aop->size - i - 1);
                aop_move_byte(ASMOP_ALUB, left->aop, left->aop->size - i - 1);
                emit_mov("test", "aluc");
                if (i < left->aop->size - 1) {
                    emit_jump_to_label(result_is_eq_maybe, 1);
                } else {
                    emit_jump_to_label(result_is_eq, 1);
                }
                emit_jump_to_label(result_is_ne, 0);

                if (i < left->aop->size - 1) {
                    tarn_emit_label(result_is_eq_maybe);
                    result_is_eq_maybe = new_label(NULL);
                }
            }
            tarn_emit_label(result_is_ne);
        } else {
            emit2("", "; implement me (%s:%d) (%d, %d, %d)",
                  __FILE__, __LINE__, left->aop->size, right->aop->size, result->aop->size);
        }
    }
}

static void genCmp   (iCode *ic, iCode *ifx)       {
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genCmp", ic); }

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
        emit_mov("test", "aluc");
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
    if (!regalloc_dry_run) { DEBUG_GEN_FUNC("genLabel", ic); }

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
