char var = 0;
void g(char a, char b) {
    var = a+b;
}
char main (char argc, char **argv) {
    g(1, 2);
    return var;
}
