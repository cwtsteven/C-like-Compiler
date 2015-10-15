type var = string

type nullary_op = Prompt

type unary_op = Print
			  | Neg
			  | Not

type binary_op = Assign
			   | Add 
			   | Sub
			   | Mul
			   | Div
			   | Eq
			   | Neq
			   | Gt
			   | Geq
			   | Lt
			   | Leq
			   | And 
			   | Or 

type expr = Var of var 
		  | Int of int32
		  | Real of float
		  | Char of char 
		  | String of string
		  | Bool of bool
		  | NullaryOp of nullary_op
		  | UnaryOp of unary_op * expr
		  | BinaryOp of binary_op * expr * expr
		  | FunCall of var * expr list
		  (*| Assign of var * expr*)

type stmnt = Expr of expr
		   | Return of expr
		   | If_Then_Else of expr * block * block
		   | While of expr * block
		   | For of expr * expr * expr * block
and block = stmnt list

type declare = Declare of var
			 | DeclareAssign of var * expr
			 | Function of var * var list * block
			 | Main of block

type program = declare list

(* printing the tree, so tedious *)

let printNullaryOp op = match op with
	| Prompt -> print_string "Prompt"

let printUnaryOp op = match op with
	| Neg	-> print_string "Neg"
	| Print -> print_string "Print"
	| Not 	-> print_string "Not"

let printBinaryOp op = match op with
	| Assign -> print_string "Assign"
	| Add 	-> print_string "Add"
	| Sub 	-> print_string "Sub"
	| Mul 	-> print_string "Mul"
	| Div 	-> print_string "Div"
	| Eq 	-> print_string "Eq"
	| Neq	-> print_string "Neq"
	| Gt	-> print_string "Gt"
	| Geq	-> print_string "Geq"
	| Lt 	-> print_string "Lt"
	| Leq	-> print_string "Leq"
	| And 	-> print_string "And"
	| Or 	-> print_string "Or"

let rec printExprList ls = 
	match ls with
	| [] 		-> ()
	| (x :: []) -> printExpr x; printExprList []
	| (x :: xs) -> printExpr x; print_string " "; printExprList xs
and printExpr expr = 
	print_string "(";
	begin
	match expr with
	| Var v 				-> print_string "Var "; print_string v
	| Int i 				-> print_string ("Int " ^ Int32.to_string i)
	| Real r 				-> print_string "Real "; print_float r
	| Char c 				-> print_string "Char '"; print_char c; print_string "'"
	| String s 				-> print_string "String \""; print_string s; print_char '"'
	| Bool b				-> print_string "Bool "; if b then print_string "true" else print_string "false"
	| NullaryOp op 		 	-> printNullaryOp op
	| UnaryOp (op, e) 		-> printUnaryOp op; print_string " "; printExpr e
	| BinaryOp (op, e1, e2) -> printBinaryOp op; print_string " "; printExpr e1; print_string " "; printExpr e2
	| FunCall (v, ls) 		-> print_string ("FunCall " ^ v); print_string " ["; printExprList ls; print_string "] " 
	(*| Assign (v, e)			-> print_string ("Assign (Var " ^ v ^ ") "); printExpr e*)
	end;
	print_string ")"


let rec printStmnt stmnt = 
	begin
	match stmnt with
	| Expr e 					-> printExpr e
	| Return e 					-> print_string "Return "; printExpr e
	| If_Then_Else (e, b1, b2) 	-> print_string "If_Then_Else "; printExpr e; print_string " ["; printBlock b1; print_string "] {"; printBlock b2; print_string "}"; 
	| While (e, b)				-> print_string "While "; printExpr e; print_string " {"; printBlock b; print_string "}"; 
	| For (e1, e2, e3, b)		-> print_string "For "; printExpr e1; print_string " "; printExpr e2; print_string " "; printExpr e3; print_string " {"; printBlock b; print_string "}"; 
	end;
	print_string "; "
and printBlock block = 
	begin
	match block with
	| [] -> ()
	| (s :: b) -> printStmnt s; printBlock b
	end

let rec printVarList ls = 
	match ls with
	| [] 		-> ()
	| (x :: []) -> print_string x; printExprList []
	| (x :: xs) -> print_string x; print_string " "; printVarList xs

let printDeclare declare = match declare with
	| Declare v 		   -> print_string "Declare (Var "; print_string v; print_string ") "
	| DeclareAssign (v, e) -> print_string "DeclareAssign (Var "; print_string v; print_string ") "; printExpr e
	| Function (v, ps, b)  -> print_string "Function (Var "; print_string v; print_string ") ["; printVarList ps; print_string "] {"; printBlock b; print_string "}"
	| Main b 			   -> print_string "Main "; print_string "{"; printBlock b; print_string "}"

let rec printProgram program = match program with
	| [] -> ()
	| (x :: xs) -> printDeclare x; print_string "\n\n"; printProgram xs