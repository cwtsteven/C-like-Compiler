#include <stdio.h>

int fibonacci(int n) {
	if (n <= 1)
		return n;
	else
		return n + fibonacci(n - 1) + fibonacci(n - 2);
}

int factorial(int n) {
	if (n <= 1)
		return 1;
	else
		return n * factorial(n - 1);
}

int main() {
	int i = 1;
	int limit = 25;
	while (i <= limit) {
		int j = 1;
		while (j <= limit) {
			int k = 1;
			while (k <= limit) {
				if (i <= j + k)
					printf("%d", fibonacci(i) + factorial(i));
				k++;
			}
			j++;
		}
		i++;
	}
	return 0;
}