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

    __asm
        halt
    __endasm;

}
