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
This grammar is simulating a C-like imperative programming languages. In the top-level, you can declare global variables and functions, for instance:
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
