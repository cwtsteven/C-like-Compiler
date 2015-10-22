open SyntaxTree
open TestHelper

let parse content = 
content
|> Lexing.from_string
|> Parser.program Lexer.read
|> ConstantFolding.constant_folding
|> ConstantPropagation.constant_propagation

let valid_testcases = [
("tc301", [Global(DeclareAssign(Int, "a", Int (to32 5))); Global(DeclareAssign(Int, "b", Int (to32 5)))]) ;
("tc302", [Main[Local(DeclareAssign(Int, "a", Int (to32 3))); Local(DeclareAssign(Int, "b", Int (to32 6)))]]) ;
("tc303", [Main[Local(DeclareAssign(Int, "a", Int (to32 3))); Local(DeclareAssign(Int, "b", Int (to32 2))); Expr(Assign("b", Int (to32 5))); Local(DeclareAssign(Int, "c", Int (to32 5)))]]) ;
("tc304", [Main[Local(DeclareAssign(Int, "a", Int (to32 3))); Local(DeclareAssign(Int, "b", Int (to32 3))); If_Then_Else(BinaryOp(Eq, Var "a", Var "b"), [Local(DeclareAssign(Int, "a", Int(to32 5))); Local(DeclareAssign(Int, "c", Int(to32 5)))], [])]])
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
	print_string "\n------- Constant Propagation Test -------\n";
	test_valid_cases valid_testcases;
	print_string "Done.\n"