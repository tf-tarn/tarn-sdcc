__sfr __at(7) pic;

void test_char() {
    volatile char a = 0x30;
    volatile char b = 0x20;

    pic = a & b;
    pic = a | b;
    pic = a ^ b;

}

void test_int() {
    volatile int a = 0xee30;
    volatile int b = 0xbb20;

    pic = (a & b) >> 8;
    pic = a & b;
    pic = (a | b) >> 8;
    pic = a | b;
    pic = (a ^ b) >> 8;
    pic = a ^ b;

}

void test_long() {
    volatile long a = 0x0e03ee30;
    volatile long b = 0x020bbb20;

    long r = a & b;
    
    pic = r >> 24;
    pic = r >> 16;
    pic = r >> 8;
    pic = r;

    r = a | b;
    
    pic = r >> 24;
    pic = r >> 16;
    pic = r >> 8;
    pic = r;

    r = a ^ b;

    pic = r >> 24;
    pic = r >> 16;
    pic = r >> 8;
    pic = r;

}

/*
void test_long_long() {
    volatile long long a = 0x0e03ee30020bbb20;
    volatile long long b = 0x020bbb2030ee0303;

    long_long r = a & b;
    
    pic = r >> 56;
    pic = r >> 48;
    pic = r >> 40;
    pic = r >> 32;
    pic = r >> 24;
    pic = r >> 16;
    pic = r >> 8;
    pic = r;

    r = a | b;
    
    pic = r >> 56;
    pic = r >> 48;
    pic = r >> 40;
    pic = r >> 32;
    pic = r >> 24;
    pic = r >> 16;
    pic = r >> 8;
    pic = r;

    r = a ^ b;

    pic = r >> 56;
    pic = r >> 48;
    pic = r >> 40;
    pic = r >> 32;
    pic = r >> 24;
    pic = r >> 16;
    pic = r >> 8;
    pic = r;

}
*/

int main(int argc, char **argv) {

    pic = 0xff;
    test_char();

    test_int();

    test_long();

    pic = 0xff;

    __asm
        halt
    __endasm;
}
