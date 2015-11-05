public class Test {
	
	public static int fibonacci(int n) {
		if (n <= 1) 
			return n;
		else 
			return n + fibonacci(n - 1) + fibonacci(n - 2);
	}

	public static int factorial(int n) {
		if (n <= 1)
			return 1;
		else 
			return n * factorial(n - 1);
	}

	public static void main(String[] args) {
		int i = 1;
		int limit = 25;
		while (i <= limit) {
			int j = 1;
			while (j <= limit) {
				int k = 1;
				while (k <= limit) {
					if (i <= j + k)
						System.out.print("" + (fibonacci(i) + factorial(i)));
					k++;
				}
				j++;
			}
			i++;
		}
	}

}