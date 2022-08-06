typedef unsigned char uint8_t;

uint8_t main (uint8_t argc, char **argv) {
    __sfr __at(7) pic;
    volatile uint8_t byte;

    while (1) {
        byte = pic;
        if (byte != 0xff) {
            pic = byte;
        }
    }
}
