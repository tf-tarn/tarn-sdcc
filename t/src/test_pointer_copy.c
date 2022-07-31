__sfr __at(7) pic;
char *vvv;
int main (int argc, char **argv) {
    const char *msg = "foo";

    /* pic = 0x0e; */
    pic = msg[(char)0];
    /* pic = 0x0f; */
    /* pic = ' '; */
    /* pic = 0x0e; */
    pic = msg[(char)1];
    /* pic = 0x0f; */
    /* pic = '\n'; */

    vvv = msg;

    /* pic = 0x0e; */
    pic = vvv[(char)0];
    /* pic = 0x0f; */
    /* pic = ' '; */
    /* pic = 0x0e; */
    pic = vvv[(char)1];
    /* pic = 0x0f; */
    /* pic = '\n'; */

    while (1);

    return 0;
}
