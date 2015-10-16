# Compiler Construction

## Dependencies
1. Ocaml, minimum version 4.02.1
2. Menhir, minimum version 20151005

## How to compile
In order to compile, execute <code>make all</code>.

## How to run
In order to run the parser, execute<code>./Main.native</code>, then enter you code in the console. For now, it will either print the generated parse tree or an error message as its ouptput.

In order to run the test, execute<code>./TestBench.native</code>.

## Syntax
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
