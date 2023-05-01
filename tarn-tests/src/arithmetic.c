__sfr __at(7) pic;

int main(int argc, char **argv) {
    volatile int a = 0x1024;
    /* volatile int b = 5; */

    if (a + 5 == (0x1024 + 5)) {
        pic = 1;
    } else {
        pic = 0;
    }

    if (a + 5 != (0x1024 + 5)) {
        pic = 0;
    } else {
        pic = 2;
    }

    if (a + 5 != (0x1024 + 5)) {
        pic = 3;
    }
    if (a + 5 == (0x1024 + 5)) {
        pic = 3;
    }
    pic = 4;

    /* if (a + b == (0x1024 + 5)) { */
    /*     pic = 1; */
    /* } else { */
    /*     pic = 0; */
    /* } */
}
