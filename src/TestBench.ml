(* ---------------- Test Specification for parser ---------------- *)
type parserResult = Accept
				  | Reject

let string_of_parser_result result = 
	match result with
	| Accept  -> "Accept"
	| Reject  -> "Reject"

type parserTestCase = (string * parserResult) list


let parserTestCases = [
("", Accept); ("a", Reject); ("a;", Accept); ("_acc;", Accept); ("aBc;", Accept); ("Aaa;", Reject);
("a = 0;", Accept); ("a = -4;", Accept); ("0abc;", Reject); ("a = 0.123;", Accept); ("a = 10.33.22;", Reject); ("a = 'c';", Accept); ("a = 'cc';", Reject);
("a = \"abc\";", Accept); ("a = \"abc;", Reject); ("a = true;", Accept); ("a = false;", Accept); ("a = truu", Reject); ("a = 5", Reject); ("_a = ;", Reject); ("_a = 33 'c';", Reject); 
("a = 3 + 5;", Accept); ("a = 3 + 4 + 5;", Accept); ("a = 3 + 4 + 'c';", Accept); ("a = 3 + -;", Reject); ("a = 3 - 2;", Accept); ("a = 3 - -;", Reject); ("a = 3 * 2;", Accept); 
("a = 3 * /;", Reject); ("a = 3 / 4;", Accept); ("a = 3 / *;", Reject); ("a = 3 == 3;", Accept); ("a = 3 == +;", Reject); ("a = 3 != 3;", Accept); ("a = 3 != +;", Reject);
("a = 3 > 2;", Accept); ("a = 3 > +;", Reject); ("a = 3 >= 2;", Accept); ("a = 3 >= -;", Reject); ("a = 3 < 2;", Accept); ("a = 3 < *;", Reject); ("a = 3 <= 2;", Accept); ("a = 3 <= +;", Reject);
("a = true && false;", Accept); ("a = true && +;", Reject); ("a = false || false;", Accept); ("a = false || -;", Reject); ("a = <<;", Accept); ("a = <;", Reject); ("a = >> 3;", Accept); ("a = >> ;", Reject);
("a = 3 - 3 + 2 > 5 == 6 * 7 / 2 >= 2 <= 4 < 1;", Accept); ("a = 3 - 3 > 2 > <=;", Reject); ("a = (a + n);", Accept); ("a = (a + b;", Reject);
("a = (a + (b - 2) > 3);", Accept); ("a = a + b = 2;", Accept); ("a = (b = v);", Accept); ("a = b = 1", Reject); ("a = (a + b = c + 4 + g = 4);", Reject);
("2 = b;", Reject); ("a = 3 + <<;", Accept); ("a = >> <<;", Accept); ("a = >> b;", Accept); ("a = >> 3;", Accept); ("a = f(a,b);", Accept); ("a = f(a,);", Reject);

("main() {}", Accept); ("main(a,b) {}", Reject); ("main() {a + b;}", Accept); ("function(a, b, c, d) { return a + b + b; }", Accept); ("f (a , b {}", Reject); ("f (a, {}", Reject);

("main() {if (a == b) { b = 3;}}", Accept); ("main() {if (a == b) { b = 3; } else { a = 5; }}", Accept);
("main() {if (a == b) { if (b == 3) { 2 + 3; } } else { if (a == v) { e = 4; } else { e == 5; } }}", Accept);
("main() {if (a == b;) {} else {}}", Reject); ("main() {if (a == b {} else {}}", Reject); 
("main() {if {}}", Reject); ("main() {if ()}", Reject); 
("main() {while (a == b) { b = 3 - 1; }}", Accept); ("main() {while (true) {}}", Accept); ("main() {while ()}", Reject); ("main() {while {}}", Reject); ("main() {while (a {}}", Reject);
("main() {for (i = 0; i < 40; i = i + 1) { >> i; }}", Accept); ("main() {for (i;i;i) { a = <<; }}", Accept); ("main() {for () {}}", Reject); ("main() {for (i;i;i)}", Reject);

("a = 3; b = 5; main() {while (a <= 1) { for (i = 1; i <= a; i = i + 1) { if (b > 1) { a = b; } else { a = b - 1; } b = b - 1; } a = a - 1; }}", Accept);
("main() {if (a == b { b = 5; c = 6; } else { while (5 == 4) { for (i = 1; i < 4; i = i + 1) { b = a + c + 6; a = 3 < 5 >= 2; } } }}", Reject);
("a = 3;\nb = 5;\ndouble(x) {\n return x + x; \n}\nmain() {\n a = <<;\n >> double(a);\n}", Accept);
("a = 5;\nb = 3;\nplus10(x) {\n i = 0;\n while(i < 10) {\n  x = x + 1;\n }\n return x;\n}\nmain() {\n for(i = 0; i<10; i=i+1) {\n  c = <<;\n  if (c > a) { >> plus10(c + b); }\n }\n}", Accept)
]

let parse_with_error lexbuf = 
	try Parser.program Lexer.read lexbuf; assert false with 
	| Lexer.SyntaxError _  	-> Reject
	| Parser.Error 			-> Reject
	| _ 					-> Accept

let parse content = 
content
|> Lexing.from_string
|> parse_with_error

(* --------------------------------------------------------------- *)

(* ---------------------- Running Test Bench --------------------- *)
let rec string_failed_list ls = 
	match ls with
	| [] -> ""
	| (n :: []) -> string_of_int n
	| (n :: ns) -> string_of_int n ^ ", " ^ string_failed_list ns

let rec runTest testFunction string_of_result testCases n passedNum failedList =
	match testCases with
	| [] -> print_string ("\nOverall: " ^ string_of_int passedNum ^ "/" ^ string_of_int (n - 1) ^ " passed.");
			if passedNum - n + 1 != 0 
			then print_string ("\nPlease check on case " ^ string_failed_list failedList ^ ".\n")
			else print_string "\n"
	| ((s, r) :: ts) -> let result = testFunction s in 
						if r == result 
						then (print_string ("Case " ^ string_of_int n ^ " | input :\n");
							  print_string (s ^ "\n");
							  print_string (" expected: " ^ string_of_result r ^ " | actual: " ^ string_of_result result ^ " | result: passed.\n");
							  runTest testFunction string_of_result ts (n+1) (passedNum+1) failedList)
						else (print_string ("Case " ^ (string_of_int n ^ " | input :\n"));
							  print_string (s ^ "\n");
							  print_string (" expected: " ^ string_of_result r ^ " | actual: " ^ string_of_result result ^ "\nresult: failed.\n");
							  runTest testFunction string_of_result ts (n+1) (passedNum) (n :: failedList))

(* --------------------------------------------------------------- *)

let testParser testCases = print_string "Start testing the Parser...\n"; runTest parse string_of_parser_result testCases 1 0 []; print_string "Done.\n"

let _ = testParser parserTestCases