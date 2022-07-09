/*-------------------------------------------------------------------------

  ralloc.h - header file register allocation

                Written By -  Philipp Krause . pkk@spth.de (2018)

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

   In other words, you are welcome to use, share and improve this program.
   You are forbidden to forbid anyone else to use, share and improve
   what you give them.   Help stamp out software-hoarding!
-------------------------------------------------------------------------*/

#ifndef SDCCRALLOC_H
#define SDCCRALLOC_H 1

#include "common.h"

enum
{
  R_IDX = 0, // General purpose register R
  X_IDX,     // General purpose register X
  ALUC_IDX,  // ALU result register ALUC
  TEST_IDX,  // Test register
};

enum
{
  REG_GPR  = 2,
  REG_TEST = 4,
};

/* definition for the registers */
typedef struct reg_info
{
    short type;                   /* can have value
                                   REG_GPR, REG_PTR or REG_CND */
    short rIdx;                   /* index into register table */
    char *name;                   /* name */
    char isFree;
} reg_info;

extern reg_info tarn_regs[];

void tarn_assignRegisters (ebbIndex *);

void tarnSpillThis (symbol *sym);
iCode *tarn_ralloc2_cc(ebbIndex *ebbi);

void tarnRegFix (eBBlock **ebbs, int count);

#endif
