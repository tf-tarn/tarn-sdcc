char array[5];
unsigned char index = 0;
char main (char argc, char **argv) {
    __sfr __at(7) pic;
    pic = array[0];
    pic = array[1];
    pic = array[2];
    pic = array[3];
    pic = array[4];

    array[index++] = '5';
    array[index++] = '4';
    array[index++] = '3';
    array[index++] = '2';
    array[index++] = '1';

    pic = array[0];
    pic = array[1];
    pic = array[2];
    pic = array[3];
    pic = array[4];

    pic = index;

    while (1);

    return 0;
}
