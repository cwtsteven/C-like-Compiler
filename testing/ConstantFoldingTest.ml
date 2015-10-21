open SyntaxTree
open Parser
open Lexer
open TestHelper

let parse content = 
content
|> Lexing.from_string
|> Parser.program Lexer.read
|> ConstantFolding.constant_folding

let to32 = Int32.of_int

let valid_testcases = [
("tc201", [Global(DeclareAssign("a", Int (to32 8)))]) ;
("tc202", [Global(DeclareAssign("a", Bool true))]) ; 
("tc203", [Global(DeclareAssign("a", String "I am so excited!"))]) ; 
("tc204", [Global(DeclareAssign("a", Bool false))]) ; 
("tc205", [Global(DeclareAssign("a", Real 6.2))]) ; 
("tc206", [Main[Local(DeclareAssign("a", Int (to32 5))); If_Then_Else(Bool true, [Expr(UnaryOp(Print, Var "a"))], [])]])
]
	

let rec test_valid_cases testcases = 
	match testcases with
	| [] -> ()
	| ((filename, expected) :: xs) -> let content = ref "" in
									  read_file ("testing/valid/" ^ filename) content;
									  print_string ("case " ^ filename ^ ": ");
									  let result = parse !content in
									  (if result = expected 
									  then print_string "passed"
									  else print_string "failed.");
									  print_string "\n";
									  test_valid_cases xs

let test = 
	print_string "Testing the Parser (with opimization)...\n";
	print_string "Testing valid programs...\n";
	test_valid_cases valid_testcases;
	print_string "Done.\n";