__sfr __at(7) pic;

const char table[2] = {
  1, 2
};
const char(*table_ptr)[2] = &table;

char main() {
    pic = table[1];
    pic = (*table_ptr)[1];
    pic = *table_ptr[1];
}
