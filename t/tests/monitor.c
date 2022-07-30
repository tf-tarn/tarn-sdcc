typedef unsigned char uint8_t;

#define LINEBUFLEN 64

uint8_t inputlen = 0;
char linebuf[LINEBUFLEN];

void execute_command() {
    __sfr __at(7) pic;
    pic = 'O';
    pic = 'K';
    pic = '\n';
}

#define LINEBUFLEN 64
uint8_t main (uint8_t argc, char **argv) {
    __sfr __at(7) pic;
    volatile uint8_t byte;


    pic = 'H';
    pic = 'e';
    pic = 'l';
    pic = 'l';
    pic = 'o';
    pic = '\n';
    pic = '>';
    pic = ' ';

    while (1) {
        byte = pic;

        if (byte == 0xff) {
            continue;
        } else if (byte == '\n') {
            execute_command();
        } else {
            if (inputlen >= LINEBUFLEN) {
                pic = 'F';
                pic = 'U';
                pic = 'L';
                pic = 'L';
                pic = '\n';
                inputlen = 0;
            } else {
                inputlen += 1;
                linebuf[inputlen] = byte;
            }
        }
    }

    return byte;
}
