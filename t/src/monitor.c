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


char parse_hex_digit(char c) {
    if (c >= '0' && c <= '9') {
        return c - '0';
    }
    if (c >= 'a' && c <= 'f') {
        return (c - 'a') + 10;
    }
    if (c >= 'A' && c <= 'F') {
        return (c - 'A') + 10;
    }
    return 0xff;
}


char to_upper_nibble(char digit) {
    static char a[16] = { 0x00, 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x80, 0x90, 0xa0, 0xb0, 0xc0, 0xd0, 0xe0, 0xf0 };

    if (digit < 0 || digit > 0xf) {
        return 0;
    }

    return a[digit];

    // TODO: implement genJumpTab so that this works
    /* switch(digit) { */
    /* case 0x00: return 0x00; */
    /* case 0x01: return 0x10; */
    /* case 0x02: return 0x20; */
    /* case 0x03: return 0x30; */
    /* case 0x04: return 0x40; */
    /* case 0x05: return 0x50; */
    /* case 0x06: return 0x60; */
    /* case 0x07: return 0x70; */
    /* case 0x08: return 0x80; */
    /* case 0x09: return 0x90; */
    /* case 0x0a: return 0xa0; */
    /* case 0x0b: return 0xb0; */
    /* case 0x0c: return 0xc0; */
    /* case 0x0d: return 0xd0; */
    /* case 0x0e: return 0xe0; */
    /* case 0x0f: return 0xf0; */
    /* default: */
    /*     return 0xff; */
    /* } */
}

char read_mem_adh;

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
            return;
        }
        if (linebuf[1] != ' ') {
            print(msg_bad_command);
            return;
        }
        {
            /* char adh = 0; */
            char digit = parse_hex_digit(linebuf[2]);
            if (digit == 0xff) {
                print(msg_bad_number);
                break;
            }
            char val = to_upper_nibble(digit);
            digit = parse_hex_digit(linebuf[3]);
            if (digit == 0xff) {
                print(msg_bad_number);
                break;
            }
            val += digit;

            read_mem_adh = val;

            /* unsigned char i = 0; */
            /* do { */
            /*     pic = 0x0e; */
            /*     pic = *((char*)(4000+i)); */
            /*     pic = 0x0f; */
            /*     ++i; */
            /*     if (i & 0xf) { */
            /*         pic = ' '; */
            /*     } else { */
            /*         pic = '\n'; */
            /*     } */
            /* } while (i > 0); */

////////////////////////////////////////////////////////////////////////////////

#include "read_mem_display_loop.asm"

////////////////////////////////////////////////////////////////////////////////

            /* print("Number parsed!\n"); */
            /* print("val="); */
            /* pic = 0x0e; */
            /* pic = val; */
            /* pic = 0x0f; */
            /* pic = '\n'; */
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
            pic = '\n';
            execute_command();
            inputlen = 0;
            pic = '>';
            pic = ' ';
        } else {
            if (inputlen >= LINEBUFLEN) {
                pic = '\n';
                pic = 'F';
                pic = 'U';
                pic = 'L';
                pic = 'L';
                pic = '\n';
                pic = '>';
                pic = ' ';
                inputlen = 0;
            } else {
                pic = byte;
                linebuf[inputlen] = byte;
                inputlen += 1;
            }
        }
    }

    return byte;
}
