__sfr __at(7) pic;

#define MEMSPACE_BUF

static int
__div(int num, int denom)
{
  int q = 0;
  while (num >= denom)
    {
      q++;
      num -= denom;
    }
  return q;
}

static int
__mod (int num, int denom)
{
  while (num >= denom)
    {
      num -= denom;
    }
  return num;
}

void
__prints (const char *s)
{
  char c;

  while ('\0' != (c = *s))
    {
        pic = c;
      ++s;
    }
}

int main(int argc, char **argv) {
    __prints("foobar");

    __asm
        halt
        __endasm;

    return 0;
}
