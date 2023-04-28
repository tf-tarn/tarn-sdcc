__sfr __at(7) pic;
char val1;
int val3;
int main (int argc, char **argv) {
    val1 = pic;
    val3 = 0;
    val3 = val1 << 8;

    pic = *(0 + (char*)(&val3));
    pic = *(1 + (char*)(&val3));

    __asm
        halt
    __endasm;

    return val1;
}
