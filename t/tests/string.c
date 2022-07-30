char main (char argc, char **argv) {
    __sfr __at(7) pic;
    const char *s = "foobar";
    pic = s[0];
    pic = s[1];
    return 0;
}
