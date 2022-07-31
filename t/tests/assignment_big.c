char *vvv;
char main (char argc, char **argv) {
    const char *msg = "foo";

    vvv = msg;

    return vvv[0];
}
