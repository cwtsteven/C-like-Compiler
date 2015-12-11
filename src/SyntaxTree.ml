type var = string

type type_	 = Void
			 | Int
			 | Real
			 | Char
			 | String
			 | Bool

type nullary_op = Prompt

type unary_op = Print
			  | Neg
			  | Not

type binary_op = Add 
			   | Sub
			   | Mul
			   | Div
			   | Mod
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
		  | Assign of var * expr
		  | FunCall of var * expr list

type declare_stmnt = Declare of type_ * var
			 	   | DeclareAssign of type_ * var * expr

type stmnt = Expr of expr
		   | Return of expr
		   | Local of declare_stmnt
		   | If_Then_Else of expr * block * block
		   | While of var * expr * block
   		   | DoWhile of var * expr * block
		   | For of var * declare_stmnt * expr * expr * block
		   | Block of stmnt list
		   | Break of string
		   | Continue of string
and block = stmnt list

type top_level = Global of declare_stmnt
			   | Function of type_ * var * (type_ * var) list * block
			   | Main of block

type program = top_level list

(* printing the tree, so tedious *)

let string_of_nullary_op op = match op with
	| Prompt -> "Prompt"

let string_of_unary_op op = match op with
	| Neg	-> "Neg"
	| Print -> "Print"
	| Not 	-> "Not"

let string_of_binary_op op = match op with
	| Add 	 ->  "Add"
	| Sub 	 ->  "Sub"
	| Mul 	 ->  "Mul"
	| Div 	 ->  "Div"
	| Mod  	 ->  "Mod"
	| Eq 	 ->  "Eq"
	| Neq	 ->  "Neq"
	| Gt	 ->  "Gt"
	| Geq	 ->  "Geq"
	| Lt 	 ->  "Lt"
	| Leq	 ->  "Leq"
	| And 	 ->  "And"
	| Or 	 ->  "Or"

let string_of_type (type_ : type_) = 
	match type_ with
	| Void -> "void"
	| Int -> "int"
	| Real -> "real"
	| Char -> "char"
	| String -> "string"
	| Bool -> "bool"

let rec string_of_expr_list ls = 
	match ls with
	| [] 		-> ""
	| (x :: []) -> string_of_expr x
	| (x :: xs) -> string_of_expr x ^ " " ^ string_of_expr_list xs
and string_of_expr expr = 
	"(" ^ 
	begin
	match expr with
	| Var v 				-> "Var " ^ v
	| Int i 				-> "Int " ^ Int32.to_string i
	| Real r 				-> "Real " ^ string_of_float r
	| Char c 				-> "Char '" ^ Char.escaped c ^ "'"
	| String s 				-> "String \"" ^ s ^ "\""
	| Bool b				-> "Bool " ^ if b then "true" else "false"
	| NullaryOp op 		 	-> string_of_nullary_op op
	| UnaryOp (op, e) 		-> string_of_unary_op op ^ " " ^ string_of_expr e
	| BinaryOp (op, e1, e2) -> string_of_binary_op op ^ " " ^ string_of_expr e1 ^ " " ^ string_of_expr e2
	| Assign (v, e)			-> "Assign " ^ v ^ " " ^ string_of_expr e
	| FunCall (v, ls) 		-> "FunCall " ^ v ^ " [" ^ string_of_expr_list ls ^ "] " 
	end ^ 
	")"

let string_of_declare_stmnt declare_stmnt = match declare_stmnt with
	| Declare (t, v) 		  -> "Declare (" ^ string_of_type t ^ " \"" ^ v ^ "\")"
	| DeclareAssign (t, v, e) -> "DeclareAssign (" ^ string_of_type t ^ " \"" ^ v ^ "\") " ^ string_of_expr e

let rec string_of_stmnt stmnt = 
	begin
	match stmnt with
	| Expr e 					-> string_of_expr e
	| Return e 					-> "Return " ^ string_of_expr e
	| Local s 			   		-> "Local (" ^ string_of_declare_stmnt s ^ ")"
	| If_Then_Else (e, b1, b2) 	-> "If_Then_Else " ^ string_of_expr e ^ " [" ^string_of_block b1 ^ "] {" ^ string_of_block b2 ^ "}"
	| While (s, e, b)			-> "While " ^ string_of_expr e ^  " {" ^string_of_block b ^ "}"
	| DoWhile (s, e, b)			-> "Do " ^ string_of_block b ^ " While " ^ string_of_expr e
	| For (s, e1, e2, e3, b)	-> "For " ^ string_of_declare_stmnt e1 ^ " " ^ string_of_expr e2 ^ " " ^ string_of_expr e3 ^ " {" ^ string_of_block b ^ "}"
	| Break s					-> "Break " ^ s
	| Continue s				-> "Continue " ^ s 
	| Block b 					-> "Block " ^ string_of_block b
	end
	^ "; "
and string_of_block block = 
	begin
	match block with
	| [] -> ""
	| (s :: b) -> string_of_stmnt s ^ string_of_block b
	end

let rec string_of_var_list ls = 
	match ls with
	| [] 		-> ""
	| ((t, v) :: []) -> string_of_type t ^ " " ^ v ^ ""
	| ((t, v) :: xs) -> string_of_type t ^ " " ^ v ^ " " ^ string_of_var_list xs

let string_of_top_level declare = match declare with
	| Global s 				   -> "Global (" ^ string_of_declare_stmnt s ^ ")"
	| Function (t, v, ps, b)   -> "Function (" ^ string_of_type t ^ ", " ^ v ^ ") [" ^ string_of_var_list ps ^ "] {" ^ string_of_block b ^ "}"
	| Main b 			   	   -> "Main {" ^ string_of_block b ^ "}"

let rec string_of_program program = match program with
	| [] -> ""
	| (x :: xs) -> string_of_top_level x ^ "\n\n" ^ string_of_program xs