__sfr __at(7) pic;
int main (int argc, char **argv) {
    const char *msg = "Executed!\n";
    for (char i = 0; msg[i]; ++i) {
        pic = msg[i];
    }

    while(1);

    return 0;
}
