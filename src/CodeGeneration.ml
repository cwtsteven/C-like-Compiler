open SyntaxTree

exception UnboundVarError of string
exception NotYetDeveloped

let lbl_counter = ref (-2)

let rec var_lookup v v_tables : type_ * var * int =
	match v_tables with
	| [] -> raise (UnboundVarError ("Unbound variable " ^ v ^ "\n"))
	| (v_table :: vs) 	->	if Hashtbl.mem !v_table v then Hashtbl.find !v_table v else var_lookup v vs

let rec generate_nullary_op op v_tables : type_ * string = 
	match op with
	| Prompt 	-> 	raise NotYetDeveloped
and generate_unary_op (op, e) v_tables : type_ * string =
	let (t, e') = generate_expr e v_tables in
	match op with 
	| Print		-> 	(Void, 
					(match t with
					| Int 		->	e' ^ "\tlea int.str(%rip), %rdi\n" ^ "\tpop %rsi\n" ^ "\tcall _printf\n"
					| Real 		-> 	raise NotYetDeveloped
					| Char 		-> 	e' ^ "\tlea char.str(%rip), %rdi\n" ^ "\tpop %rsi\n" ^ "\tcall _printf\n"
					| String 	-> 	raise NotYetDeveloped
					| Bool 		-> 	lbl_counter := !lbl_counter + 2;
									e' ^ "\tpop %r8\n" ^ "\tcmp $1, %r8\n" ^ "\tjne L" ^ 
									string_of_int !lbl_counter ^ "\n" ^ "\tlea true.str(%rip), %rdi\n" ^ "\tjmp L" ^ string_of_int (!lbl_counter + 1) ^ "\n" ^ "L" ^ string_of_int !lbl_counter ^ ": \n" ^ "\tlea false.str(%rip), %rdi\n" ^ "L" ^ string_of_int (!lbl_counter + 1) ^ ": \n" ^ "\tcall _printf\n"
					| _ 		->	raise NotYetDeveloped
					))
	| Neg 		->	(match t with
					| Int 		-> 	(Int, e' ^ "\tnegl (%rsp)\n")
					| Real 		->	raise NotYetDeveloped
					| _ 		->	raise NotYetDeveloped
					)
	| Not 		->	(match t with
					| Bool 		->	(Bool, e' ^ "\tnot (%rsp)\n")
					| _ 		->	raise NotYetDeveloped
					)

and generate_binary_op (op, e1, e2) v_tables : type_ * string = 
	let (t1, e1') = generate_expr e1 v_tables 
	and (t2, e2') = generate_expr e2 v_tables in
	(match op with
	| Add 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tadd %r8, %rax\n" ^ "\tpush %rax\\\n")
					| (Real, Real)		->	raise NotYetDeveloped
					| (Real, Int) 		->	raise NotYetDeveloped
					| (Int, Real) 		-> 	raise NotYetDeveloped
					| (String, String)	->	raise NotYetDeveloped
					| _ 				->	raise NotYetDeveloped
					)
	| Sub 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tsub %r8, %rax\n" ^ "\tpush %rax\n")
					| (Real, Real)		->	raise NotYetDeveloped
					| (Real, Int) 		->	raise NotYetDeveloped
					| (Int, Real) 		-> 	raise NotYetDeveloped
					| _ 				->	raise NotYetDeveloped
					)
	| Mul 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\timul %r8, %rax\n" ^ "\tpush %rax\n")
					| (Real, Real)		->	raise NotYetDeveloped
					| (Real, Int) 		->	raise NotYetDeveloped
					| (Int, Real) 		-> 	raise NotYetDeveloped
					| _ 				->	raise NotYetDeveloped
					)
	| Div 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcqto\n" ^ "\tidiv %r8\n" ^ "\tpush %rax\n")
					| (Real, Real)		->	raise NotYetDeveloped
					| (Real, Int) 		->	raise NotYetDeveloped
					| (Int, Real) 		-> 	raise NotYetDeveloped
					| _ 				->	raise NotYetDeveloped
					)
	| Eq 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsete %al\n" ^ "\tpush %rax\n"
					| (Real, Real)
					| (Real, Int)
					| (Int, Real)		-> 	raise NotYetDeveloped
					| (Char, Char)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsete %al\n" ^ "\tpush %rax\n"
					| (String, String)	-> 	raise NotYetDeveloped
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsete %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Neq 		->	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetne %al\n" ^ "\tpush %rax\n"
					| (Real, Real)
					| (Real, Int)
					| (Int, Real)		-> 	raise NotYetDeveloped
					| (Char, Char)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetne %al\n" ^ "\tpush %rax\n"
					| (String, String)	-> 	raise NotYetDeveloped
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetne %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Gt 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetg %al\n" ^ "\tpush %rax\n"
					| (Real, Real)
					| (Real, Int)
					| (Int, Real)		-> 	raise NotYetDeveloped
					| (Char, Char)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetg %al\n" ^ "\tpush %rax\n"
					| (String, String)	-> 	raise NotYetDeveloped
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetg %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Geq		->	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetge %al\n" ^ "\tpush %rax\n"
					| (Real, Real)
					| (Real, Int)
					| (Int, Real)		-> 	raise NotYetDeveloped
					| (Char, Char)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetge %al\n" ^ "\tpush %rax\n"
					| (String, String)	-> 	raise NotYetDeveloped
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetge %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Lt 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetl %al\n" ^ "\tpush %rax\n"
					| (Real, Real)
					| (Real, Int)
					| (Int, Real)		-> 	raise NotYetDeveloped
					| (Char, Char)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetl %al\n" ^ "\tpush %rax\n"
					| (String, String)	-> 	raise NotYetDeveloped
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetl %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Leq 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetle %al\n" ^ "\tpush %rax\n"
					| (Real, Real)
					| (Real, Int)
					| (Int, Real)		-> 	raise NotYetDeveloped
					| (Char, Char)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetle %al\n" ^ "\tpush %rax\n"
					| (String, String)	-> 	raise NotYetDeveloped
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\txor %rax, %rax\n" ^ "\tsetle %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| And 		->	(match (t1, t2) with
					| (Bool, Bool) 		->	(Bool, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tand %r8, %rax\n" ^ "\tpush %rax\n")
					| _ 				-> 	raise NotYetDeveloped
					)
	| Or 		-> 	(match (t1, t2) with
					| (Bool, Bool) 		->	(Bool, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tor %r8, %rax\n" ^ "\tpush %rax\n")
					| _ 				-> 	raise NotYetDeveloped
					)
	)

and generate_expr expr v_tables : type_ * string = 
	match expr with
	| Var v 				-> 	let (t, var, offset) = var_lookup v v_tables in
								if offset = -1 then (t, "\tmovabsq (" ^ var ^ "), %rax\n" ^ "\tpush %rax\n")
								else raise NotYetDeveloped
	| Int i 				-> 	(Int, "\tpush $" ^ Int32.to_string i ^ "\n")
	| Real r 				-> 	raise NotYetDeveloped
	| Char c 				-> 	(Char, "\tpush $'" ^ Char.escaped c ^ "'\n")
	| String s 				-> 	raise NotYetDeveloped
	| Bool b 				-> 	(Bool, "\tpush " ^ (if b then "$1" else "$0") ^ "\n")
	| NullaryOp op			-> 	generate_nullary_op op v_tables
	| UnaryOp (op, e) 		-> 	generate_unary_op (op, e) v_tables
	| BinaryOp (op, e1, e2)	->	generate_binary_op (op, e1, e2) v_tables
	| Assign (v, e)			->	let (t', e') = generate_expr e v_tables
								and (t, var, offset) = var_lookup v v_tables in
								if offset = -1 then 
								(match t' with
								| Int 		->	(t', e' ^ "\tpop %rax\n" ^ "\tmovabsq %rax, (" ^ v ^ ")\n")
								| Real		->	raise NotYetDeveloped
								| Char 		->	(t', e' ^ "\tpop %rax\n" ^ "\tmovabsq %rax, (" ^ v ^ ")\n")
								| String 	->	raise NotYetDeveloped
								| Bool		->	(t', e' ^ "\tpop %rax\n" ^ "\tmovabsq %rax, (" ^ v ^ ")\n")
								| _ 		->	raise NotYetDeveloped
								)
								else raise NotYetDeveloped
	| FunCall (v, ps) 		->	raise NotYetDeveloped

let rec generate_block block v_tables : string = 
	let v_table : ((var, (type_ * var * int)) Hashtbl.t) ref = ref (Hashtbl.create 10) in
	let v_tables = v_table :: v_tables 
	and block_array = Array.of_list block
	and result = ref "" in
	for i = 0 to (Array.length block_array) - 1 do 
		result := !result ^ 
		(match block_array.(i) with
		| Expr e 					-> 	snd (generate_expr e v_tables)
		| Return e  				-> 	raise NotYetDeveloped
		| Local s 					-> 	raise NotYetDeveloped
		| If_Then_Else (e, b1, b2)	-> 	let (t, e') = generate_expr e v_tables in
										lbl_counter := !lbl_counter + 2;
										e' ^ 
										(match t with
										| Bool	->	"\tpop %r8\n" ^ "\tcmp $1, %r8\n" ^ "\tjne L" ^ string_of_int !lbl_counter ^ "\n" ^ generate_block b1 v_tables ^ "\tjmp L" ^ string_of_int (!lbl_counter + 1) ^ "\n" ^ "L" ^ string_of_int !lbl_counter ^ ": \n" ^ generate_block b2 v_tables ^ "L" ^ string_of_int (!lbl_counter + 1) ^ ": \n"
										| _ 	-> 	raise NotYetDeveloped
										)
		| While (e, b)				-> 	raise NotYetDeveloped
		| For (e1, e2, e3, b)		-> 	raise NotYetDeveloped
		| Block b 					-> 	generate_block b v_tables
		)
	done;
	!result

let generate_program program v_tables : string = 
	let v_table : ((var, (type_ * var * int)) Hashtbl.t) ref = ref (Hashtbl.create 10) in
	let v_tables = v_table :: v_tables 
	and program_array = Array.of_list program
	and result = ref "" in
	for i = 0 to (Array.length program_array) - 1 do 
		result := !result ^ 
		(match program_array.(i) with
		| Global (Declare (t, v)) 			->	Hashtbl.add !v_table v (t, v, -1);
												v ^ ": " ^ 
												(match t with
												| Void 		->	raise NotYetDeveloped
												| Int 		->	"\t.long"
												| Real 		->	"\t.double"
												| Char 		-> 	"\t.byte"
												| Bool 		-> 	"\t.byte"
												| String 	-> 	"\t.string"
												) ^ "\n"
		| Global (DeclareAssign (t, v, e))	-> 	Hashtbl.add !v_table v (t, v, -1);
												v ^ ": " ^ 
												(match (t, e) with
												| (Int, Int i)			->	"\t.long " ^ Int32.to_string i
												| (Real, Real r) 		->	"\t.double " ^ string_of_float r
												| (Char, Char c) 		-> 	"\t.byte '" ^ Char.escaped c ^ "'"
												| (Bool, Bool b)		-> 	"\t.byte " ^ (if b then "1" else "0")
												| (String, String s)	-> 	"\t.string \"" ^ s ^ "\""
												| _ 					-> 	raise NotYetDeveloped
												) ^ "\n"
		| Function (t, v, ps, b) 			-> 	raise NotYetDeveloped
		| Main b 							-> 	"\t.section __TEXT,__text,regular,pure_instructions\n" ^ "\t.globl _main" ^ "\n_main:\n" ^ "\tpush $0\n" ^ generate_block b v_tables ^ "\tmov $0, %rdi\n\tcall _exit"
		)
	done;
	!result

let rec sort_program global func iterate : program =
	match iterate with
	| [] -> global @ func
	| ((Global s) :: xs) 	-> 	sort_program (global @ [(Global s)]) func xs
	| (x :: xs) 			-> 	sort_program global (func @ [x]) xs

let static_data : string = 
	"\t.data\n"

let prefix : string = 
	"\t.section __TEXT,__cstring,cstring_literals\n" ^ 
	"int.str:\n" ^ 
	"\t.string \"%d\\0\"\n" ^ 
	"char.str:\n" ^ 
	"\t.string \"%c\\0\"\n" ^ 
	"true.str:\n" ^
	"\t.string \"true\"\n" ^
	"false.str:\n" ^
	"\t.string \"false\"\n"

let generate program : string = 
	let v_tables : (((var, (type_ * var * int)) Hashtbl.t) ref) list = [] in
	prefix ^ "\n" ^
	static_data ^
	generate_program (sort_program [] [] program) v_tables ^ 
	"\n"