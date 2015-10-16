# Dependencies
In order to compile the project correctly, please make sure you have the following installed.

1. Ocaml, minimum version 4.02.1
2. Menhir, minimum version 20151005

# How to compile
In order to compile, execute <code>make all</code>.

# How to run
In order to run the parser, execute<code>./Main.native</code>, then enter you code in the console. For now, it will either print the generated parse tree or an error message as its ouptput.

In order to run the test, execute<code>./TestBench.native</code>.

# Syntax
This grammar is simulating a C-like imperative programming languages. In the top-level, you can declare global variables and functions, below gives you a first taste of a valid program:
<pre><code>var a = 3;
double(x) {
  return x + x;
}
main() {
  var a = 1;
  b = <<;
  if (b > a) {
    >> double(b);
  } else {
    >> double(a);
  }
}</code></pre>
The syntax will be described more detailly in the sections below.

## Identifiers
An identifier is the name of a variable or function. The name is restricted by the following rules:
- An identifier must begin with a small-case letter (a - z) or an underscore <code>_</code>.
- It can be followed by (a - z) or (A - Z) or (0 - 9) or an underscore.
- An identifier cannot be a predefined keyword
- Example of valid identifier: <code>a</code> <code>_a</code> <code>_a123</code>
- Example if invalid identifier: <code>A</code> <code>A123</code> <code>123A</code>

## Declaring variables
You can either just to decalre a variable or at the same time, assign a value to it, for instance: <code>var a;</code> and <code>var a = 1;</code>. The right hand side can also be an expression: <code>var a = 3 + 5;</code>. Be aware that the variables declared inside a function is local to the function, for instance, if we decalre a global variable and a local varibale with the same name, the local one is used inside the function.
<pre><code>var a = 1;
main() {
  var a = 1;
  a = a + 1;
}</pre></code>
In the line <code>a = a + 1;</code>, it will not change the global variable <code>a</code>. 

## Basic I/O
You can use <code><<</code> as basic input and <code>>></code> as output. <code><<</code> is an expression that will return a string by default, for example, you can assign the return value to a variable <code>a = <<;</code>. <code>>></code> is followed by an expression in which the compiler will evaluate the expression before printing it. For instance: <code>>> 3 + 5;</code> will print 8. 

## Operators
An operator is either a nullary/unary/binary operator. Here is the precedence iof operators (from low to high)
- <code>>></code> (non-associative)
- <code>=</code> (non-associative)
- <code>&&</code> <code>||</code> <code>!</code>
- <code>==</code> <code>!=</code> <code>></code> <code>>=</code> <code><</code> <code><=</code> 
- <code>+</code> <code>-</code>
- <code>*</code> <code>/</code>

All operators are left-associative unless otherwise specified. For instance, an expression:
<code>>> 3 + 4 * 5 >= 1;</code> will be evaluated to <code>>> ((3 + (4 * 5)) >= 1)</code>. 

## Control statement
Traditional control flow <code>if</code> <code>if else</code> <code>while</code> and <code>for</code> are supported. 
Here are the rules for each statement:
- <code>if (expr) {statements}</code>
- <code>if (expr) {statements} else {statements}</code>
- <code>while (expr) {statements}</code>
- <code>for(expr;expr;expr) {statements}</code>

