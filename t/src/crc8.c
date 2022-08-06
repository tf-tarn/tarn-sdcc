typedef unsigned char uint8_t;

#define POLYNOMIAL 0x07

uint8_t crc8_one(uint8_t crc)
 {

     for (uint8_t i = 0; i < 8; i++)
     {
         if (crc & 0x80)
         { /* most significant bit set, shift crc register and perform XOR operation, taking not-saved 9th set bit into account */
             crc = (crc << 1) ^ POLYNOMIAL;
         }
         else
         { /* most significant bit not set, go to next bit */
             crc <<= 1;
         }
     }

     return crc;
 }

uint8_t crc8(const uint8_t *data, uint8_t len)
{
    uint8_t crc = 0; /* start with 0 so first uint8_t can be 'xored' in */

    for (uint8_t i = 0; i < len; ++i) {
        crc ^= data[i]; /* XOR-in the next input uint8_t */
        crc = crc8_one(crc);
    }

    return crc;
}

uint8_t main(uint8_t argc, char **argv) {
    return crc8(argv[0], 200);
}
