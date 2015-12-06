# 1 Dependencies
In order to compile the project correctly, please make sure you have the following installed.

1. Ocaml, minimum version 4.02.1
2. Menhir, minimum version 20151005

# 2 How to compile
To compile the whole project, execute <code>make</code>.

# 3 How to run
### 3.1 Run the compiler
To run the compiler, execute <code>./Main.native file [-fopoff]</code>. For example: <code>./Main.native main.txt -fopoff</code>. The compiler will generate an assembly file in the same directory. 

1. <code>file</code> is the path of the source code. 
2. <code>-fopoff</code> turns off fron-end optimisation. If this tag does not appear, the compiler will perform front-end optimisation by default.

Another way to run the compiler is to execute <code>./Main.native [-fopoff]</code> without a specified file. This will allow you to type your code in terminal. An assembly file named "test.s" will be created in the same directory.

### 3.2 Run the tests
To run the tests, execute <code>sh testbench.sh</code>.

# 4 Error Reporting
The compiler will inform you where and what exactly happened, for instance, if we have this input program:
<pre><code>int a = ;</code></pre>
we will get
<pre><code>Parse error in Line 1, Column 9. expression was expected but I got this token: ;</code></pre>

# 5 Syntax
This grammar is simulating a C-like imperative programming language. In the top-level, you can declare global variables and functions, below gives you a first taste of a valid program:
<pre><code>int a = 3;

int double(int x) {
  return x + x;
}

main() {
  a = 1;
  int b = <<;
  if (b > a) {
    >> double(b);
  } else {
    >> double(a);
  }
}</code></pre>
The syntax will be described more detailly in the sections below.

### 5.1 Identifiers
An identifier is the name of a variable or function. The name is restricted by the following rules:
- An identifier must begin with a small-case letter (a - z) or an underscore <code>_</code>.
- It can be followed by (a - z) or (A - Z) or (0 - 9) or an underscore.
- An identifier cannot be a predefined keyword
- Example of valid identifier: <code>a</code> <code>_a</code> <code>_a123</code>
- Example if invalid identifier: <code>A</code> <code>A123</code> <code>123A</code>

### 5.2 Primitive Data types
There are five primitive data types. 
- <code>int</code> corresponds to a 32-bit integer
- <code>real</code> corresponds to double precision floating point (double in C)
- <code>char</code> a single character
- <code>string</code> a string (cannot contain <code>"</code>)
- <code>bool</code> either true or false

### 5.3 Declaring variables
You can either just to decalre a variable or at the same time, assign a value to it, for instance: <code>int a;</code> and <code>int a = 1;</code> are valid. 

##### 5.3.1 Global variables
When declaring global variables, be aware that the right hand side of the statement can only be a simple expression (i.e. without function call). For instance: <code>int a = 3 + 5;</code> is valid, but <code>int a = f(2);</code> is invalid.

##### 5.3.2 Local variables
The right hand side can also be any expression including function call. Be aware that the variables declared inside a function is local to the function, for instance, if we decalre a global variable and a local varibale with the same name, the local one is used inside the function.
<pre><code>int a = 1;
main() {
  int a = 1;
  a = a + 1;
}</code></pre>
In the line <code>a = a + 1;</code>, it will not change the global variable <code>a</code>. 

### 5.4 Basic I/O
You can use <code><<</code> as basic input and <code>>></code> as output. <code><<</code> is an expression that will return a string by default, for example, you can assign the return value to a variable <code>a = <<;</code>. <code>>></code> is followed by an expression in which the compiler will evaluate the expression before printing it. For instance: <code>>> 3 + 5;</code> will print 8. 

### 5.5 Operators
An operator is either a nullary/unary/binary operator. Here is the precedence of operators (from low to high)
- <code>>></code> (non-associative)
- <code>=</code> (right-associative)
- <code>&&</code> <code>||</code> <code>!</code>
- <code>==</code> <code>!=</code> <code>></code> <code>>=</code> <code><</code> <code><=</code> 
- <code>+</code> <code>-</code>
- <code>*</code> <code>/</code>

All operators are left-associative unless otherwise specified. For instance, an expression: 
<code>>> 3 + 4 * 5 >= 1;</code> will be evaluated to <code>>> ((3 + (4 * 5)) >= 1)</code>. 

### 5.6 Control
Traditional control flow <code>if</code> <code>if else</code> <code>while</code> and <code>for</code> are supported. 
Here are the rules for each statement:
- <code>if (expr) {statements}</code>
- <code>if (expr) {statements} else {statements}</code>
- <code>while (expr) {statements}</code>
- <code>for(int var = integer;expr;expr) {statements}</code>

##### 5.6.1 Label, Break, Continue
<code>break</code> and <code>continue</code> are also supported. <code>break;</code> will escape from the closest loop and <code>continue;</code> will repeat the closest loop. You can also declare labels in a control loop as follows:
- <code>while lbl: (expr) {statements}</code>
- <code>for lbl: (int var = integer;expr;expr) {statements}</code>
You can also use <code>break lbl;</code> or <code>continue lbl;</code> to escape or repeat the labeled control loop.

### 5.7 Function
Funtion declaration is also allowed in the top-level. Here is an example:
<pre><code>int a = 5;
int double(int x) {
  return 2 * x;
}
</code></pre>
In the above, we defined a function called <code>double</code> which takes a single <code>int</code> parameter <code>x</code> and return an <code>int</code>. 

# 6 Syntactic Optimisation

### 6.1 Constant Folding
Right now, the compiler will do constant folding. For instance, <code>int a = 3 + 6;</code> will be transformed to <code>int a = 9;</code> in the parse tree.

### 6.2 Constant Propagation and Function Inlining
The compiler will also perform constant propagation and function inlining on the parse tree. For instance: 
<pre><code>int a = 1;
int b = a + 1;

int double(int x) {
  return x + x;
}

main() {
  int c = double(a);
}
</code></pre>
will be transformed to
<pre><code>int a = 1;
int b = 2;

int double(int x) {
  return x + x;
}

main() {
  int c = 2;
}
</code></pre>
However, the optimisation within a block of code will be stopped, if we reach a statement that has side effects (ie, printing, prompting, assigning non-local variables), but we will continue on, if any, inner blocks. For instance:
<pre><code>int a = 1;
int c = a + 2;

int f(int x) {
  a = a + 1;
  return 1;
}

main() {
  int d = 1;
  int f = d;
  int e = f(a);
  int g = d;
}
</code></pre>
will be transformed to 
<pre><code>int a = 1;
int c = 3;

int f(int x) {
  a = a + 1;
  return 1;
}

main() {
  int d = 1;
  int f = 1;
  int e = f(a);
  int g = d;
}
</code></pre>

# 7 Code Generation
For now, the compiler can generate codes for

1. int arithmetic and comparison
2. char comparison
3. boolean operations
4. prompting int
5. printing int char and boolean
6. control statement
7. decalring and assigning global and local variables
8. functions and function calls

# 8 Benchmark
##### Compile time
| Language      | Time elasped  |
| ------------- |:-------------:|
| c             | 0.02s         |
| java          | 1.41s         |
| compiler      | 0.01s         |

##### Run time
| Language      | Time elasped  |
| ------------- |:-------------:|
| c             | 0.69s         |
| java          | 0.86s         |
| compiler      | 1.44s         |

In order to run the benchmark script, please execute <code>sh benchmark.sh</code>. The code that was used in benchmarking can also be found inside the <code>benchmark</code> folder. 
