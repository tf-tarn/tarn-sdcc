typedef unsigned char uint8_t;

#define POLYNOMIAL ((uint8_t)0x07)

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

uint8_t main(uint8_t argc, char **argv) {
    return crc8_one(5);
}
