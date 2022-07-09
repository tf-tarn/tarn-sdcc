#include "ralloc.h"
#include "gen.h"
#include "dbuf_string.h"

/** Transform weird SDCC handling of writes via pointers
    into something more sensible. */
static void
transformPointerSet (eBBlock **ebbs, int count)
{
  /* for all blocks */
  for (int i = 0; i < count; i++)
    {
      iCode *ic;

      /* for all instructions do */
      for (ic = ebbs[i]->sch; ic; ic = ic->next)
        if (POINTER_SET (ic))
          {
            IC_LEFT (ic) = IC_RESULT (ic);
            IC_RESULT (ic) = 0;
            ic->op = SET_VALUE_AT_ADDRESS;
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

  transformPointerSet (ebbs, count);

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
