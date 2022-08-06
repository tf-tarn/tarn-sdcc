__sfr __at(7) pic;

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

char main(char argc, char **argv) {
    char c = 0;

    c = parse_hex_digit('0');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('1');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('2');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('3');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('4');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('5');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('6');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('7');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('8');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('9');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('a');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('b');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('c');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('d');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('e');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('f');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('x');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit(' ');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';
    c = parse_hex_digit('/');
    pic = 0x0e; pic = c; pic = 0x0f; pic = '\n';

    while(1);
}
