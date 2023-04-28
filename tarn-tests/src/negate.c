__sfr __at(7) pic;

char main(char argc, char **argv) {
    char x;

    x = pic;
    pic = -x;
    x = pic;
    pic = -x;
    x = pic;
    pic = -x;
    x = pic;
    pic = -x;
    x = pic;
    pic = -x;

    __asm
        halt
    __endasm;
}
