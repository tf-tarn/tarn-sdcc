__sfr __at(7) pic;

int main(int argc, char **argv) {
    volatile unsigned char a = 1;
    volatile unsigned int n = 1;

    pic = '1';
    while (a != 0) {
        pic = '2';
        a = 0;
    }

    pic = '3';
    while (a == 0) {
        pic = '4';
        a = 1;
    }

    pic = '5';
    while (n != 0) {
        pic = '6';
        n = 0;
    }

    pic = '7';
    while (n == 0) {
        pic = '8';
        n = 1;
    }
    pic = '9';

    while (n < 2) {
        pic = 0x40;
        ++n;
    }

    pic = 0x41;
    while (n > 1) {
        pic = 0x42;
        --n;
    }

    // again

    a = 0;

    pic = 0x50;
    while (a != 0) {
        pic = 0x51;
        a = 0;
    }

    a = 1;
    
    pic = 0x52;
    while (a == 0) {
        pic = 0x53;
        a = 1;
    }

    n = 0;

    pic = 0x54;
    while (n != 0) {
        pic = 0x55;
        n = 0;
    }

    n = 1;

    pic = 0x56;
    while (n == 0) {
        pic = 0x57;
        n = 1;
    }

    n = 2;

    pic = 0x58;
    while (n < 2) {
        pic = 0x59;
        ++n;
    }

    n = 1;

    pic = 0x60;
    while (n > 1) {
        pic = 0x61;
        --n;
    }
    pic = 0x62;
    
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
