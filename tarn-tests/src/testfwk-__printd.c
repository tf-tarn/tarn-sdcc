__sfr __at(7) pic;

#define MEMSPACE_BUF

static int
__div(int num, int denom)
{
    int q = 0;
    while (num >= denom) {
        q++;
        num -= denom;
    }
    return q;
}

static int
__mod (int num, int denom)
{
    while (num >= denom) {
        num -= denom;
    }
    return num;
}

void
__prints (const char *s)
{
    char c;

    while ('\0' != (c = *s)) {
        pic = c;
        ++s;
    }
}

void
__printd (int n)
{
    if (0 == n) {
        pic = '0';
    } else {
        static char MEMSPACE_BUF buf[6];
        char MEMSPACE_BUF *p = &buf[sizeof (buf) - 1];
        char neg = 0;

        buf[sizeof(buf) - 1] = '\0';

        if (0 > n) {
            n = -n;
            neg = 1;
        }

        while (0 != n) {
            /* --p; */
            *--p = '0' + __mod (n, 10);
            n = __div (n, 10);
        }

        if (neg)
            pic = '-';

        __prints(p);
    }
}

_putchar(char c) {
    pic = c;
}

void __ok (__code const char *szCond, __code const char *szFile, int line)
{
  __prints("--- OK: \"");
  __prints(szCond);
  __prints(" at ");
  __prints(szFile);
  _putchar(':');
  __printd(line);
  _putchar('\n');
}

int main(int argc, char **argv) {
    __printd(0);
    __printd(99);
    __printd(1123);
    __printd(45678);
    __printd(9012);

    __ok("condition", "<filename>", 99);

    __asm
        halt
        __endasm;

    return 0;
}
