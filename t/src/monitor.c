typedef unsigned char uint8_t;

#define LINEBUFLEN 6

uint8_t inputlen = 0;
char linebuf[LINEBUFLEN];

__sfr __at(7) pic;

void print(const char *s) {
    for (char i = 0; s[i]; ++i) {
        pic = s[i];
    }
    return;
}

/* void print_n(char n) { */

/* } */

void execute_command() {
    const char *msg_too_short = "Too short.\n";
    const char *msg_bad_command = "Huh!?\n";
    const char *msg_bad_number = "Bad number.\n";

    if (inputlen < 1) {
        print("Enter a command, please.\n");
        return;
    }

    switch (linebuf[0]) {
    case 'c':
        print("CRC coming soon.\n");
        break;
    case 'r':
        if (inputlen < 4) {
            print(msg_too_short);
        }
        if (linebuf[1] != ' ') {
            print(msg_bad_command);
        }
        {
            /* char adh = 0; */
            /* char digit = parse_hex_digit(linebuf[2]); */
            /* if (digit == 0xff) { */
            /*     print(msg_bad_number); */
            /*     break; */
            /* } */
            /* adh = to_upper_nibble(digit); */
            /* char digit = parse_hex_digit(linebuf[2]); */
            /* if (digit == 0xff) { */
            /*     print(msg_bad_number); */
            /*     break; */
            /* } */
            /* adh += digit; */
            print("Number parsed! .. (not really)\n");
        }
        break;
    default:
        print(msg_bad_command);
        break;
    }

    return;
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
