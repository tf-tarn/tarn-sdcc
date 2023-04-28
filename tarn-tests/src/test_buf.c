__sfr __at(7) pic;

int main(int argc, char **argv) {

    static char buf[6];
    char *p = &buf[sizeof (buf) - 1];
    char neg = 0;
    
    buf[sizeof(buf) - 1] = '\0';

    *--p = 'a';
    *--p = 'b';
    *--p = 'c';
    *--p = 'd';
    *--p = 'e';

    for (char i = 0; i < sizeof buf; ++i) {
        pic = buf[i];
    }

    __asm
        halt
        __endasm;
}
