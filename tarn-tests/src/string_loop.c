__sfr __at(7) pic;
int main (int argc, char **argv) {
    const char *msg = "Executed!\n";
    for (char i = 0; msg[i]; ++i) {
        pic = msg[i];
    }

    __asm
        halt
    __endasm;

    return 0;
}
