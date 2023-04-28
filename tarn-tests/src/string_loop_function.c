__sfr __at(7) pic;

void print(const char *s) {
    for (char i = 0; s[i]; ++i) {
        pic = s[i];
    }
    return;
}

char var;

char main (char argc, char **argv) {
    const char *msg = "Hello, world!\n";
    const char *msg_too_short = "Too short.\n";
    const char *msg_bad_command = "Huh!?\n";
    const char *msg_bad_number = "Bad number.\n";

    if (argc) {
        var = 1;
    } else {
        var = 1;
    }

    switch (var) {
    case 0:
        print(msg_too_short);
        break;
    case 1:
        print(msg);
        break;
    case 2:
        print(msg_too_short);
        break;
    }

    __asm
        halt
    __endasm;

    return 0;
}
