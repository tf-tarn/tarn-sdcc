__data __at(0x8000) char array[4];
unsigned char index = 1;
char main (char argc, char **argv) {
    array[index] = 5;
    return 0;
}
