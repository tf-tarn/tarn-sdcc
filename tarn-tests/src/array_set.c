__sfr __at(7) pic;
__data __at(0x8000) char array[4];
char main (char argc, char **argv) {
    array[3] = 5;
    pic = array[3];
    while(1);
}
