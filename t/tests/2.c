#define int char

int multiply_or_divide(int which, int a, int b) {
    switch(which) {
    case 0:
        return a * b;
    case 1:
        return a / b;
    }

    return 0;
}

int main (int argc, char **argv) {
    return 0;
}
