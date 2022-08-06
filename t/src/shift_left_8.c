__sfr __at(7) pic;
int val1;
int val2;
char val3;
int main (int argc, char **argv) {
    val1 = pic;
    val2 = pic;
    val3 = (val1 << 8) + val2;

    return val1;
}
