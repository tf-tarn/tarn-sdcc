__sfr __at(7) pic;
char val1;
int val3;
int main (int argc, char **argv) {
    val1 = pic;
    val3 = val1 << 8;

    return val1;
}
