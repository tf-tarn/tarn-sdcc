__sfr __at(7) pic;

int main(int argc, char **argv) {
    volatile unsigned char a = 1;
    volatile unsigned int n = 1;

    /* pic = '1'; */
    /* while (a != 0) { */
    /*     pic = '2'; */
    /*     a = 0; */
    /* } */
    /* pic = '3'; */
    /* while (a == 0) { */
    /*     pic = '4'; */
    /*     a = 1; */
    /* } */
    /* pic = '5'; */

    pic = '6';
    while (n != 0) {
        pic = '7';
        n = 0;
    }

    n = 0;

    pic = '8';
    while (n == 0) {
        pic = '9';
        n = 1;
    }
    pic = '9' + 1;

    /* pic = '6'; */
    /* pic = '7'; */
    /* pic = '8'; */
    /* pic = '9'; */
    /* pic = '9' + 1; */
    
    __asm
        halt
        __endasm;

    return 0;
}
