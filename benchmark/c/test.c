#include <stdio.h>

int fibonacci(int n) {
    if (n <= 1)
        return n;
    else
        return fibonacci(n - 1) + fibonacci(n - 2);
}

int factorial(int n) {
    if (n <= 1)
        return 1;
    else
        return n * factorial(n - 1);
}

int main() {
    int limit = 100;
    for (int i = 0; i < limit; i++) {
        for (int j = 0; j < limit; j++) {
            for (int k = 0; k < limit; k++) {
                if (k > 50)
                    goto lbl2;
                printf("%d", fibonacci(i) + factorial(i));
                if (i == 25)
                    goto lbl1;
            }
            lbl2: ;
        }
    }
    lbl1:
    return 0;
}