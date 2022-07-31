typedef unsigned char uint8_t;

#define LINEBUFLEN 6

uint8_t inputlen = 0;
char linebuf[LINEBUFLEN];

__sfr __at(7) pic;

void execute_command() {
    const char *msg = "Executed!\n";
    for (char i = 0; msg[i]; ++i) {
        pic = msg[i];
    }
}

#define LINEBUFLEN 6
uint8_t main (uint8_t argc, char **argv) {
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
            pic = 'x';
            execute_command();
            inputlen = 0;
            pic = '>';
            pic = ' ';
        } else {
            if (inputlen >= LINEBUFLEN) {
                pic = 'F';
                pic = 'U';
                pic = 'L';
                pic = 'L';
                pic = '\n';
                pic = '>';
                pic = ' ';
                inputlen = 0;
            } else {
                inputlen += 1;
                linebuf[inputlen] = byte;
            }
        }
    }

    return byte;
}
