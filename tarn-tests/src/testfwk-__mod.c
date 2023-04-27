__sfr __at(7) pic;

static int
__mod (int num, int denom)
{
  while (num >= denom)
    {
      num -= denom;
    }
  return num;
}

int main(int argc, char **argv) {
    int a = __mod(18, 5);
    
    pic = (a >> 8) & 0xff;
    pic = a & 0xff;

    a = __mod(18, 17);
    pic = (a >> 8) & 0xff;
    pic = a & 0xff;

    a = __mod(0xffff, 0xfffe);
    pic = (a >> 8) & 0xff;
    pic = a & 0xff;

    a = __mod(0x3241, 997);
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
