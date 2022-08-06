char array[5];
unsigned char index = 0;
char main (char argc, char **argv) {
    __sfr __at(7) pic;
    pic = 0x0e;
    pic = array[0];
    pic = 0x0f;
    pic = 0x0e;
    pic = array[1];
    pic = 0x0f;
    pic = 0x0e;
    pic = array[2];
    pic = 0x0f;
    pic = 0x0e;
    pic = array[3];
    pic = 0x0f;
    pic = 0x0e;
    pic = array[4];
    pic = 0x0f;

    pic = '\n';
    array[index++] = 5;
    array[index++] = 4;
    array[index++] = 3;
    array[index++] = 2;
    array[index++] = 1;

    pic = 0x0e;
    pic = array[0];
    pic = 0x0f;
    pic = 0x0e;
    pic = array[1];
    pic = 0x0f;
    pic = 0x0e;
    pic = array[2];
    pic = 0x0f;
    pic = 0x0e;
    pic = array[3];
    pic = 0x0f;
    pic = 0x0e;
    pic = array[4];
    pic = 0x0f;

    pic = '\n';

    pic = 0x0e;
    pic = index;
    pic = 0x0f;

    pic = '\n';

    while (1);

    return 0;
}
