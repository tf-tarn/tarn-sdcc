__sfr __at(7) pic;
char val1;
char val2;
int val3;
int main (int argc, char **argv) {
    val1 = pic;
    val2 = pic;
    val3 = (val1 << 8) + val2;

    return val1;
}
