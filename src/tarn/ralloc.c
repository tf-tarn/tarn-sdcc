#include "ralloc.h"
#include "gen.h"
#include "dbuf_string.h"

const char *find_ic_op_name(int no) {
    extern iCodeTable codeTable[];
    for (int i = 0; ; i++) {
        if (no == codeTable[i].icode) {
            return codeTable[i].printName;
        }
        if (codeTable[i].icode == SWAP) {
            break;
        }
    }

    abort();
    return "<unknown ic op>";
}


reg_info tarn_regs[] =
{
  {REG_GPR,  R_IDX,      "r"},
  {REG_GPR,  X_IDX,      "x"},
  {REG_TEST, ALUC_IDX,   "aluc"},
  {REG_TEST, TEST_IDX,   "test"},
};

void fix_pointer_set(iCode *ic) {
    IC_LEFT (ic) = IC_RESULT (ic);
    IC_RESULT (ic) = 0;
    ic->op = SET_VALUE_AT_ADDRESS;
}


#define IS_ALU_OP(op) (op == '+'                \
        || op == '-'                            \
        || op == '*'                            \
        || op == '/'                            \
        || op == '%'                            \
        || op == '>'                            \
        || op == '<'                            \
        || op == LE_OP                          \
        || op == GE_OP                          \
        || op == EQ_OP                          \
        || op == NE_OP                          \
        || op == AND_OP                         \
        || op == OR_OP                          \
        || op == '^'                            \
        || op == '|'                            \
        || op == BITWISEAND                     \
        || op == LEFT_OP                        \
        || op == RIGHT_OP)


/** Transform weird SDCC handling of writes via pointers
    into something more sensible. */
static void
transformIC (eBBlock **ebbs, int count)
{
    /* for all blocks */
    for (int i = 0; i < count; i++) {
        iCode *ic;
        iCode *prev = NULL;

        /* for all instructions do */
        for (ic = ebbs[i]->sch; ic; ic = ic->next) {
            if (POINTER_SET (ic)) {
                fix_pointer_set(ic);
            }
            if (prev) {
                printf("transform test: %d %d %d\n", IS_ALU_OP(prev->op), ic->op == IFX, IC_RESULT(prev) == IC_COND(ic));
                if (IS_ALU_OP(prev->op)
                    && ic->op == IFX
                    && IC_RESULT(prev) == IC_COND(ic)
                    /* also check lifespan */) {
                    OP_SYMBOL(IC_RESULT(prev))->nRegs = 1;
                    OP_SYMBOL(IC_RESULT(prev))->regs[0] = tarn_regs + TEST_IDX;
                    OP_SYMBOL(IC_COND(ic))->nRegs = 1;
                    OP_SYMBOL(IC_COND(ic))->regs[0] = tarn_regs + TEST_IDX;
                }
            }
            prev = ic;
        }
    }
}


/*-----------------------------------------------------------------*/
/* assignRegisters - assigns registers to each live range as need  */
/*-----------------------------------------------------------------*/
void
tarn_assignRegisters (ebbIndex *ebbi)
{
  eBBlock **ebbs = ebbi->bbOrder;
  int count = ebbi->count;
  iCode *ic;

  transformIC (ebbs, count);

  /* /\* liveranges probably changed by register packing */
  /*    so we compute them again *\/ */
  /* recomputeLiveRanges (ebbs, count, FALSE); */

  if (options.dump_i_code)
    dumpEbbsToFileExt (DUMP_PACK, ebbi);

  ic = tarn_ralloc2_cc(ebbi);

  /* regTypeNum(); */
  /* serialRegMark(ebbs, count); */

  /* if (options.dump_i_code) */
  /*   { */
  /*     dumpEbbsToFileExt (DUMP_RASSGN, ebbi); */
  /*     dumpLiveRanges (DUMP_LRANGE, liveRanges); */
  /*   } */

  genTarnCode (ic);
}
