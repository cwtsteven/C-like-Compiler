open SyntaxTree
open TestHelper

let parse content = 
content
|> Lexing.from_string
|> Parser.program Lexer.read

let valid_testcases = [
("tc101", [Global(Declare (Int, "a"))]) ; 
("tc102", [Global(Declare (String, "_acc"))]) ; 
("tc103", [Global(Declare (Char, "aBc"))]) ; 
("tc104", [Global(DeclareAssign (Int, "a", Int (to32 0)))]) ; 
("tc105", [Global(DeclareAssign (Int, "a", UnaryOp(Neg , (Int(to32 4)))))]) ; 
("tc106", [Global(DeclareAssign(Real, "a", (Real 0.123)))]) ; 
("tc107", [Global(DeclareAssign(Char, "a", Char 'c'))]) ; 
("tc108", [Global(DeclareAssign(String, "a", String "Hello World!"))]) ;
("tc109", [Global(DeclareAssign(Bool, "a", Bool true))]) ; 
("tc110", [Global(DeclareAssign(Int, "a", BinaryOp(Add, Int (to32 3) , Int (to32 5))))]) ; 
("tc111", [Global(DeclareAssign(Int, "a", BinaryOp(Add, BinaryOp(Add, Int (to32 3), Int (to32 4)), Int (to32 5))))]) ; 
("tc112", [Global(DeclareAssign(String, "a", NullaryOp Prompt))]) ; 
("tc113", [Global(DeclareAssign(Int, "a", FunCall ("f", [Var "x"; Var "y"])))]) ; 
("tc114", [Main[]]) ; 
("tc115", [Main[Expr(Assign("a", BinaryOp(Add, Var "a", Int (to32 3))))]]) ; 
("tc116", [Main[If_Then_Else(BinaryOp(Eq, Var "a", Var "b"), [Expr(Assign("x", Var "y"))], [])]]) ; 
("tc117", [Main[If_Then_Else(BinaryOp(Eq, Var "a", Var "b"), [Expr(Assign("x", Var "y"))], [Expr(UnaryOp(Print, Var "a"))])]]) ; 
("tc118", [Main[While(Bool true, [Expr(Assign("x", BinaryOp(Add, Var "x", Int (to32 1))))])]]) ; 
("tc119", [Main[For(Assign("i", Int (to32 2)), BinaryOp(Leq, Var "i", Int (to32 3)), Assign("i", BinaryOp(Add, Var "i", Int (to32 1))), [Expr(UnaryOp(Print, Var "i"))])]]) ;
("tc120", [Global(DeclareAssign(Int, "a", Int (to32 5))); Function (Int, "double", [(Int, "x")], [Return (BinaryOp(Add, Var "x", Var "x"))]); Main[Local(DeclareAssign(Int, "b", NullaryOp(Prompt))); While(BinaryOp(Leq, Var "b", Var "a"), [Expr(Assign("a", BinaryOp(Add, Var "a", Int (to32 1)))) ; If_Then_Else(BinaryOp(Leq, Var "b", Var "a"), [Expr(UnaryOp(Print, Var "a"))], [Expr(UnaryOp(Print, Var "b"))]) ]) ] ]); 
]

let invalid_testcases = [
("tc101", "ParserError") ; 
("tc102", "SyntaxError") ; 
("tc103", "ParserError") ;
("tc104", "SyntaxError") ;
("tc104", "SyntaxError") ;
("tc105", "SyntaxError") ;
("tc106", "SyntaxError") ;
("tc107", "ParserError") ;
("tc108", "ParserError") ;
("tc109", "ParserError") ;
("tc110", "ParserError") ;
("tc111", "ParserError") ;
("tc112", "ParserError") ;
("tc113", "ParserError") ;
("tc114", "ParserError") ;
("tc115", "ParserError") ;
("tc116", "ParserError") ;
("tc117", "ParserError") ;
("tc118", "ParserError") ;
("tc119", "ParserError") ;
("tc120", "ParserError")
]

let rec test_valid_cases testcases = 
	match testcases with
	| [] -> ()
	| ((filename, expected) :: xs) -> let content = ref "" in
									  read_file ("testing/valid/" ^ filename) content;
									  print_string ("case " ^ filename ^ ": ");
									  let result = parse !content in
									  (*
									  assert (result = expected); 
									  print_string "passed.";
									  *)
									  (if result = expected 
									  then print_string "passed"
									  else print_string "failed.");
									  print_string "\n";
									  test_valid_cases xs

let rec test_invalid_cases testcases = 
	match testcases with
	| [] -> ()
	| ((filename, expected) :: xs) -> let content = ref "" in
									  read_file ("testing/invalid/" ^ filename) content;
									  print_string ("case " ^ filename ^ ": ");
									  (try parse !content; print_string "impossible" with
									  | Lexer.SyntaxError _ -> if compare expected "SyntaxError" == 0 then print_string "passed." else print_string "failed."
									  | Parser.Error  		-> if compare expected "ParserError" == 0 then print_string "passed." else print_string "failed.");
									  print_string "\n";
									  test_invalid_cases xs

let test = 
	print_string "\n------- Parser Test -------\n";
	print_string "Testing valid programs...\n";
	test_valid_cases valid_testcases;
	print_string "Testing invalid programs...\n";
	test_invalid_cases invalid_testcases;
	print_string "Done.\n"