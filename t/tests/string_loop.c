int main (int argc, char **argv) {
    __sfr __at(7) pic;
    const char *msg = "Executed!\n";
    for (char i = 0; msg[i]; ++i) {
        pic = msg[i];
    }
    return 0;
}
