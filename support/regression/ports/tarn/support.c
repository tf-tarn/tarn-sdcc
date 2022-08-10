__sfr __at 0x7 pic;

void
_putchar(unsigned char c)
{
  pic = c;
  return;
/*   c; */
/* #ifndef __SDCC_STACK_AUTO */
/*   __asm */
/*     mov a, __putchar_PARM_1+0 */
/*     .db 0x00, 0xff */
/*   __endasm; */
/* #else */
/*   __asm */
/*     mov	a, sp */
/*     add	a, #0xfc */
/*     mov	p, a */
/*     idxm	a, p */
/*     .db 0x00, 0xff */
/*   __endasm; */
/* #endif */
}

void
_initEmu(void)
{
}

void
_exitEmu(void)
{
    __asm
        .byte 0x99
        .byte 0x99
    __endasm;
    // pic = 's';
  return;
  /* __asm */
  /*   stopsys */
  /* __endasm; */
}
