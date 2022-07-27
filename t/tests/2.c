#define int char

int multiply_or_divide(int which, int a, int b) {
    switch(which) {
    case 0:
        return a * b;
    case 1:
        return a / b;
    }

    if (a) {
        a = 4;
    } else {
        a = b;
    }

    return a;
}

int main (int argc, char **argv) {
    return 0;
}
