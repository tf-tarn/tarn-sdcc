__sfr __at(7) pic;
char *vvv;
int main (int argc, char **argv) {
    const char *msg = "foo";

    pic = msg[(char)0];
    pic = ' ';
    pic = msg[(char)1];
    pic = '\n';

    vvv = msg;

    pic = vvv[(char)0];
    pic = ' ';
    pic = vvv[(char)1];
    pic = '\n';

    while (1);

    return 0;
}
