char var = 0;
void g() {
    var = 1;
}
char main (char argc, char **argv) {
    g();
    return var;
}
