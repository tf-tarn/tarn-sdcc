__sfr __at(7) pic;
char main (char argc, char **argv) {

    char val = pic;

    while (val != '!') {
        switch(val) {
        case 'a':
            pic = '2';
            break;
        case 'e':
            pic = '4';
            break;
        case 'i':
            pic = '6';
            break;
        case 'o':
            pic = '8';
            break;
        case 'u':
            pic = '_';
            break;
        case 0xff:
            break;
        default:
            pic = val;
            val = 0xff;
            break;
        }
        val = pic;
    }
    pic = '.';
    pic = '\n';
    while(1);
}
