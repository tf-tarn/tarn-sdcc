__sfr __at(7) pic;

int litbitint (unsigned int b)
{
  /* register unsigned int b = a; /\* Suggest allocating b to accumulator *\/ */

    
  if (b & 0x0001)
    return(0);
  else if (b & 0x0004)
    return(1);
  else if (b & 0x2010)
    return(2);
  else
    return(3);
}

int main(int argc, char **argv) {
    int x = litbitint (0x0001u);
    int y = litbitint (0x0004);
    int z = litbitint (0x1020u);

    pic = x >> 8;
    pic = x;
    pic = 0xff;
    pic = y >> 8;
    pic = y;
    pic = 0xff;
    pic = z >> 8;
    pic = z;

    pic = 0xff;

    __asm
        halt
    __endasm;

}
