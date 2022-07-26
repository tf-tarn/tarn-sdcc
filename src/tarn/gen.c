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
/* pdk_emitDebuggerSymbol - associate the current code location        */
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
static void genAnd         (const iCode *ic, iCode *ifx)       { if (!regalloc_dry_run) { fprintf(stderr, "genAnd          = "); piCode (ic, stderr); } emit2(";; genAnd         ", ""); }
/* static void genAssign      (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genAssign       = "); piCode (ic, stderr); } emit2(";; genAssign      ", ""); } */
static void genCall        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genCall         = "); piCode (ic, stderr); } emit2(";; genCall        ", ""); }
static void genCast        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genCast         = "); piCode (ic, stderr); } emit2(";; genCast        ", ""); }
static void genCmp         (const iCode *ic, iCode *ifx)       { if (!regalloc_dry_run) { fprintf(stderr, "genCmp          = "); piCode (ic, stderr); } emit2(";; genCmp         ", ""); }
/* static void genCmpEQorNE   (const iCode *ic, iCode *ifx)       { if (!regalloc_dry_run) { fprintf(stderr, "genCmpEQorNE    = "); piCode (ic, stderr); } emit2(";; genCmpEQorNE   ", ""); } */
static void genCpl         (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genCpl          = "); piCode (ic, stderr); } emit2(";; genCpl         ", ""); }
static void genDummyRead   (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genDummyRead    = "); piCode (ic, stderr); } emit2(";; genDummyRead   ", ""); }
static void genEndFunction (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genEndFunction  = "); piCode (ic, stderr); } emit2(";; genEndFunction ", ""); }
static void genFunction    (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genFunction     = "); piCode (ic, stderr); } emit2(";; genFunction    ", ""); }
static void genGetByte     (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genGetByte      = "); piCode (ic, stderr); } emit2(";; genGetByte     ", ""); }
static void genGoto        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genGoto         = "); piCode (ic, stderr); } emit2(";; genGoto        ", ""); }
/* static void genIfx         (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genIfx          = "); piCode (ic, stderr); } emit2(";; genIfx         ", ""); } */
static void genIpush       (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genIpush        = "); piCode (ic, stderr); } emit2(";; genIpush       ", ""); }
static void genJumpTab     (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genJumpTab      = "); piCode (ic, stderr); } emit2(";; genJumpTab     ", ""); }
/* static void genLabel       (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genLabel        = "); piCode (ic, stderr); } emit2(";; genLabel       ", ""); } */
static void genLeftShift   (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genLeftShift    = "); piCode (ic, stderr); } emit2(";; genLeftShift   ", ""); }
static void genMinus       (const iCode *ic, const iCode *ifx) { if (!regalloc_dry_run) { fprintf(stderr, "genMinus        = "); piCode (ic, stderr); } emit2(";; genMinus       ", ""); }
static void genMult        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genMult         = "); piCode (ic, stderr); } emit2(";; genMult        ", ""); }
static void genNot         (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genNot          = "); piCode (ic, stderr); } emit2(";; genNot         ", ""); }
static void genOr          (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genOr           = "); piCode (ic, stderr); } emit2(";; genOr          ", ""); }
static void genPlus        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genPlus         = "); piCode (ic, stderr); } emit2(";; genPlus        ", ""); }
static void genPointerGet  (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genPointerGet   = "); piCode (ic, stderr); } emit2(";; genPointerGet  ", ""); }
static void genPointerSet  (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genPointerSet   = "); piCode (ic, stderr); } emit2(";; genPointerSet  ", ""); }
static void genReturn      (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genReturn       = "); piCode (ic, stderr); } emit2(";; genReturn      ", ""); }
static void genRightShift  (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genRightShift   = "); piCode (ic, stderr); } emit2(";; genRightShift  ", ""); }
static void genSwap        (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genSwap         = "); piCode (ic, stderr); } emit2(";; genSwap        ", ""); }
static void genUminus      (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genUminus       = "); piCode (ic, stderr); } emit2(";; genUminus      ", ""); }
static void genXor         (const iCode *ic)                   { if (!regalloc_dry_run) { fprintf(stderr, "genXor          = "); piCode (ic, stderr); } emit2(";; genXor         ", ""); }

static void genAssign (const iCode *ic) {
    if (!regalloc_dry_run) { fprintf(stderr, "genAssign       = "); piCode (ic, stderr); } emit2(";; genAssign      ", "");
}


    if (IS_OP_LITERAL (op)) {
        emit2("mov", "%s il ,%d", reg, byteOfVal(OP_VALUE(op), 0));
        return;
    }


/*-----------------------------------------------------------------*/
/* genLabel - generates a label                                    */
/*-----------------------------------------------------------------*/
static void
genLabel (const iCode *ic)
{
    // emit2 ("; genLabel", "");

    /* special case never generate */
    if (IC_LABEL (ic) == entryLabel)
        return;

    if (options.debug /*&& !regalloc_dry_run*/)
        debugFile->writeLabel (IC_LABEL (ic), ic);

    printf("Hello, there should be a label here.\n");

    emit2("", "L_%d:", (IC_LABEL(ic)->key + 100));

    // G.p.type = AOP_INVALID;
}


void write_reg(const char *reg, operand *op) {
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
            /* emit2("; symbol is parameter", ""); */
            emit2("mov", "adh hi8(%s) ,0", OP_SYMBOL(op)->rname);
            emit2("mov", "adl lo8(%s) ,0", OP_SYMBOL(op)->rname);
            emit2("mov", "%s mem ,0", reg);
            return;
        }

        emit2("", "; symbol has %d regs", OP_SYMBOL(op)->nRegs);
        // if (OP_SYMBOL(op)->nRegs)

        // something else?
        if (op->isaddr) {
            emit2("; symbol is addr", "");
        }
        if (op->isPtr) {
            emit2("; symbol is pointer", "");
        }
        emit2("mov", "%s %s ,0", reg, OP_SYMBOL(op)->rname);
        return;
    }

    emit2("; write_reg: op not suppoted", "");
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

static void genCmpEQorNE   (const iCode *ic, iCode *ifx)       {
    emit2(";; genCmpEQorNE", "%p", ifx);
    // TODO set alus too
    write_reg("alua", IC_LEFT(ic));
    write_reg("alub", IC_RIGHT(ic));
    read_reg("aluc", IC_RESULT(ic));
}

static void
emitJP(const symbol *target)
{
  if (!regalloc_dry_run)
    emit2 ("jnz", "L_%05d", labelKey2num (target->key));
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

    emit2(";; genIfx", "%p", ic);

    if (IS_OP_LITERAL (cond)) {
        emit2("; genIfx: op is literal", "");
        return;
    }

    if (IS_SYMOP (cond)) {
        /* emit2("; genIfx: op is symbol", ""); */
        /* emit2("; symbol is", "%s", OP_SYMBOL(cond)->rname); */
        if (OP_SYMBOL(cond)->nRegs == 1) {
            /* emit2("; ", "symbol is in reg %s", OP_SYMBOL(cond)->regs[0]->name); */
            // no need to copy test to itself
            if (OP_SYMBOL(cond)->regs[0]->rIdx != TEST_IDX) {
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
        emitJP(t);
        return;
    }

    if (f) {
        emit2("", "; TODO: REVERSE THIS!");
        emitJP(t);
        return;
    }

    emit2("; genIfx: op is unknown", "");
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
