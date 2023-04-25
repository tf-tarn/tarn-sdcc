static int
__mod (int num, int denom)
{
  while (num >= denom)
    {
      num -= denom;
    }
  return num;
}
