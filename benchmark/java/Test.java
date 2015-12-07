public class Test {
	
	public static int fibonacci(int n) {
		if (n <= 1) 
			return n;
		else 
			return fibonacci(n - 1) + fibonacci(n - 2);
	}

	public static int factorial(int n) {
		if (n <= 1)
			return 1;
		else 
			return n * factorial(n - 1);
	}

	public static void main(String[] args) {
		int limit = 100;
		lbl:
		for (int i = 0; i < limit; i++) {
			lbl2:
			for (int j = 0; j < limit; j++) {
				for (int k = 0; k < limit; k++) {
					if (k > 50)
						continue lbl2;
					System.out.print("" + (fibonacci(i) + factorial(i)));
					if (i == 25)
						break lbl;
				}
			}
		}
	}

}