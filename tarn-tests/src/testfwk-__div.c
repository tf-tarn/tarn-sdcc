__sfr __at(7) pic;

static int
__div(int num, int denom)
{
  int q = 0;
  while (num >= denom)
    {
      q++;
      num -= denom;
    }
  return q;
}

int main(int argc, char **argv) {
    int a = __div(0x3241, 17);

    pic = (a >> 8) & 0xff;
    pic = a & 0xff;

    /* a = __div(35, 10); */

    /* pic = (a >> 8) & 0xff; */
    /* pic = a & 0xff; */

    __asm
        halt
        __endasm;

    return 0;
}
