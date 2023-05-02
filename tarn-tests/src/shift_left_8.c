__sfr __at(7) pic;
char val1;
char val2;
int val3;
int main (int argc, char **argv) {
    val1 = pic; // a
    val2 = pic; // b
    val3 = (val1 << 8) + val2;

    // I mean, it's kind of a useless test, I guess, but that's what
    // shifting means in this case...
    pic = *(0 + (char*)(&val3)); // a
    pic = *(1 + (char*)(&val3)); // b

    __asm
        halt
    __endasm;

    return val1;
}
