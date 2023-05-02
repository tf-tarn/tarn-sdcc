__sfr __at(7) pic;

char test_char(char a) {
    if (a == 0) {
        return 0;
    }
    
    if (a == 1) {
        return 7;
    }
    
    if (a == 0) {
        return 0;
    }

    return 0;
}

char test_int(int n) {
    if (n == 0) {
        return 0;
    }
    
    if (n == 1) {
        return 8;
    }
    
    if (n == 0) {
        return 0;
    }

    return 0;
}

int litbitint (unsigned int a)
{
  register unsigned int b = a + 1; /* Suggest allocating b to accumulator */

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
    volatile unsigned char a = 1;
    volatile unsigned int n = 1;

    if (a == 1) {
        pic = 1;
    } else {
        pic = 0;
    }

    if (a == 0) {
        pic = 0;
    } else {
        pic = 2;
    }

    if (n == 1) {
        pic = 3;
    } else {
        pic = 0;
    }

    if (n == 0) {
        pic = 0;
    } else {
        pic = 4;
    }

    if (a == 0) {
        pic = 0;
    } else if (a == 1) {
        pic = 5;
    } else {
        pic = 0;
    }

    if (n == 0) {
        pic = 0;
    } else if (n == 1) {
        pic = 6;
    } else {
        pic = 0;
    }

    pic = test_char(a);
    pic = test_int(a);

    pic = 0xff;

    int x = litbitint (0x0001u - 1);
    int y = litbitint (0x8fe8u - 1);
    int z = litbitint (0x3030u - 1);

    /* pic = x >> 8; */
    /* pic = x; */
    pic = y >> 8;
    pic = y;
    /* pic = z >> 8; */
    /* pic = z; */

    pic = 0xff;

    /* pic = (litbitint (0x0001u - 1) == 0); */
    pic = (litbitint (0x8fe8u - 1) == 3);
    /* pic = (litbitint (0x3030u - 1) == 2); */


    pic = 0xff;

    __asm
        halt
    __endasm;

}
