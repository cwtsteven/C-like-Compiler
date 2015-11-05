open SyntaxTree
open TestHelper

let valid_testcases = [
("tc101", [Global(Declare (Int, "a")); Main[]]) ; 
("tc102", [Global(Declare (String, "_acc")); Main[]]) ; 
("tc103", [Global(Declare (Char, "aBc")); Main[]]) ; 
("tc104", [Global(DeclareAssign (Int, "a", Int (to32 0))); Main[]]) ; 
("tc105", [Global(DeclareAssign (Int, "a", UnaryOp(Neg , (Int(to32 4))))); Main[]]) ; 
("tc106", [Global(DeclareAssign(Real, "a", (Real 0.123))); Main[]]) ; 
("tc107", [Global(DeclareAssign(Char, "a", Char 'c')); Main[]]) ; 
("tc108", [Global(DeclareAssign(String, "a", String "Hello World!")); Main[]]) ;
("tc109", [Global(DeclareAssign(Bool, "a", Bool true)); Main[]]) ; 
("tc110", [Global(DeclareAssign(Int, "a", BinaryOp(Add, Int (to32 3) , Int (to32 5)))); Main[]]) ; 
("tc111", [Global(DeclareAssign(Int, "a", BinaryOp(Add, BinaryOp(Add, Int (to32 3), Int (to32 4)), Int (to32 5)))); Main[]]) ; 
("tc112", [Main[]]) ; 
("tc113", [Main[Local(DeclareAssign(Int, "a", (Int (to32 3)))); Local(DeclareAssign(Int, "b", BinaryOp(Add, Var "a", Int (to32 3))))]]) ; 
("tc114", [Main[If_Then_Else(BinaryOp(Eq, Int (to32 1), Int (to32 1)), [Local(DeclareAssign(Int, "a", Int (to32 2)))], [])]]) ; 
("tc115", [Main[Local(DeclareAssign(Int, "a", Int (to32 1))); Local(DeclareAssign(Int, "b", Int (to32 2))); Local(Declare(Int, "x")); Local(Declare(Int, "y")); If_Then_Else(BinaryOp(Eq, Var "a", Var "b"), [Expr(Assign("x", Var "y"))], [Expr(UnaryOp(Print, Var "a"))])]]) ; 
("tc116", [Global(DeclareAssign(Int, "a", Int (to32 1))); Main[While((BinaryOp(Leq, Var "a", Int (to32 2))), [Expr(UnaryOp(Print, Var "a")); Expr(Assign("a", BinaryOp(Add, Var "a", Int (to32 1))))])]]) ; 
("tc117", [Main[For(DeclareAssign(Int, "i", Int (to32 2)), BinaryOp(Leq, Var "i", Int (to32 3)), Assign("i", BinaryOp(Add, Var "i", Int (to32 1))), [Expr(UnaryOp(Print, Var "i"))])]]) ;
("tc118", [Global(DeclareAssign(Int, "a", Int (to32 5))); Function (Int, "double", [(Int, "x")], [Return (BinaryOp(Add, Var "x", Var "x"))]); Main[Local(DeclareAssign(Int, "b", NullaryOp(Prompt))); While(BinaryOp(Leq, Var "b", Var "a"), [Expr(Assign("a", BinaryOp(Add, Var "a", Int (to32 1)))) ; If_Then_Else(BinaryOp(Leq, Var "b", Var "a"), [Expr(UnaryOp(Print, Var "a"))], [Expr(UnaryOp(Print, Var "b"))]) ]) ] ]); 
("tc119", [Main[Expr(UnaryOp(Print, BinaryOp(Add, Int (to32 1), Int (to32 2))))]]) ;
("tc120", [Function(Int, "plus1", [(Int, "n")], [Local(DeclareAssign(Int, "m", Int (to32 1))); Return(BinaryOp(Add, Var "n", Var "m"))]); Main[Local(DeclareAssign(Int, "a", Int (to32 2))); Local(DeclareAssign(Int, "b", FunCall("plus1", [Var "a"]))); Expr(UnaryOp(Print, Var "b"))]])
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
("tc118", "ParserError")
]

let parse = Compiler.parse

let rec test_valid_cases testcases = 
	match testcases with
	| [] -> ()
	| ((filename, expected) :: xs) -> let content = ref "" in
									  read_file ("testing/valid/" ^ filename) content;
									  print_string ("case " ^ filename ^ ": ");
									  let result = parse !content in
									  (if result = expected 
									  then print_string "\tpassed"
									  else print_string "\t\tfailed.");
									  print_string "\n";
									  test_valid_cases xs

let rec test_invalid_cases testcases = 
	match testcases with
	| [] -> ()
	| ((filename, expected) :: xs) -> let content = ref "" in
									  read_file ("testing/invalid/" ^ filename) content;
									  print_string ("case " ^ filename ^ ": ");
									  (try parse !content; () with
									  | ErrorHandling.SyntaxError _ -> if compare expected "SyntaxError" == 0 then print_string "\tpassed." else print_string "\t\tfailed."
									  | ErrorHandling.ParserError _ -> if compare expected "ParserError" == 0 then print_string "\tpassed." else print_string "\t\tfailed.");
									  print_string "\n";
									  test_invalid_cases xs

let test = 
	print_string "\n------- Parser Test -------\n";
	print_string "Testing valid programs...\n";
	test_valid_cases valid_testcases;
	print_string "Testing invalid programs...\n";
	test_invalid_cases invalid_testcases;
	print_string "Done.\n"