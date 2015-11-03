open SyntaxTree

exception UnboundVarError of string
exception TypeError of string
exception NotYetDeveloped

let lbl_counter = ref (-2)

let rec var_lookup v v_tables : type_ * int =
	match v_tables with
	| [] -> raise (UnboundVarError ("Unbound variable " ^ v ^ "\n"))
	| (v_table :: vs) 	->	if Hashtbl.mem !v_table v then Hashtbl.find !v_table v else var_lookup v vs

let rec generate_nullary_op op v_tables : type_ * string = 
	match op with
	| Prompt 	-> 	raise NotYetDeveloped
and generate_unary_op (op, e) v_tables : type_ * string =
	let (t, e') = generate_expr e v_tables in
	match op with 
	| Print		-> 	(Void, (match t with
							| Int 		->	e' ^ "\tlea int.str(%rip), %rdi\n" ^ "\tpop %rsi\n" ^ "\tcall _printf\n"
							| Real 		-> 	raise NotYetDeveloped
							| Char 		-> 	e' ^ "\tlea char.str(%rip), %rdi\n" ^ "\tpop %rsi\n" ^ "\tcall _printf\n"
							| String 	-> 	raise NotYetDeveloped
							| Bool 		-> 	lbl_counter := !lbl_counter + 2;
											e' ^ "\tpop %r8\n" ^ "\tcmp $1, %r8\n" ^ "\tjne L" ^ 
											string_of_int !lbl_counter ^ "\n" ^ "\tlea true.str(%rip), %rdi\n" ^ "\tjmp L" ^ string_of_int (!lbl_counter + 1) ^ "\n" ^ "L" ^ string_of_int !lbl_counter ^ ": \n" ^ "\tlea false.str(%rip), %rdi\n" ^ "L" ^ string_of_int (!lbl_counter + 1) ^ ": \n" ^ "\tcall _printf\n"
							| _ 		->	raise NotYetDeveloped
							)
					)
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
					| (Int, Int)		->	(Int, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tadd %r8, %rax\n" ^ "\tpush %rax\n")
					| _ 				->	raise NotYetDeveloped
					)
	| Sub 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tsub %r8, %rax\n" ^ "\tpush %rax\n")
					| _ 				->	raise NotYetDeveloped
					)
	| Mul 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\timul %r8, %rax\n" ^ "\tpush %rax\n")
					| _ 				->	raise NotYetDeveloped
					)
	| Div 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcqto\n" ^ "\tidiv %r8\n" ^ "\tpush %rax\n")
					| _ 				->	raise NotYetDeveloped
					)
	| Eq 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char) 		
					| (Bool, Bool) 		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\tmov $0, %rax\n" ^ "\tsete %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Neq 		->	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\tmov $0, %rax\n" ^ "\tsetne %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Gt 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\tmov $0, %rax\n" ^ "\tsetg %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Geq		->	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\tmov $0, %rax\n" ^ "\tsetge %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Lt 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\tmov $0, %rax\n" ^ "\tsetl %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Leq 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcmp %r8, %rax\n" ^ "\tmov $0, %rax\n" ^ "\tsetle %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| And 		->	(Bool, 
					(match (t1, t2) with
					| (Bool, Bool) 		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tand %r8, %rax\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Or 		-> 	(Bool, 
					(match (t1, t2) with
					| (Bool, Bool) 		->	e1' ^ e2' ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tor %r8, %rax\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	)


and generate_assign_global ((t : type_), v, e) v_tables : type_ * string =
	let (t', e') = generate_expr e v_tables in
	match (t, t') with
	| (Int, Int) 		
	| (Char, Char) 		
	| (Bool, Bool)		->	(t', e' ^ "\tpop %rax\n" ^ "\tmovabsq %rax, (" ^ v ^ ")\n")
	| _ 				->	raise NotYetDeveloped	

and generate_expr expr v_tables : type_ * string = 
	match expr with
	| Var v 				-> 	let (t, offset) = var_lookup v v_tables in
								if offset = 0 then 
									(t, "\tmovabsq (" ^ v ^ "), %rax\n" ^ "\tpush %rax\n")
								else 
									raise NotYetDeveloped
	| Int i 				-> 	(Int, "\tpush $" ^ Int32.to_string i ^ "\n")
	| Real r 				-> 	raise NotYetDeveloped
	| Char c 				-> 	(Char, "\tpush $'" ^ Char.escaped c ^ "'\n")
	| String s 				-> 	raise NotYetDeveloped
	| Bool b 				-> 	(Bool, "\tpush $" ^ (if b then "1" else "0") ^ "\n")
	| NullaryOp op			-> 	generate_nullary_op op v_tables
	| UnaryOp (op, e) 		-> 	generate_unary_op (op, e) v_tables
	| BinaryOp (op, e1, e2)	->	generate_binary_op (op, e1, e2) v_tables
	| Assign (v, e)			->	let (t, offset) = var_lookup v v_tables in
								if offset = 0 then 
									generate_assign_global (t, v, e) v_tables
								else
									raise NotYetDeveloped
	| FunCall (v, ps) 		->	raise NotYetDeveloped


let rec generate_block block v_tables offset : string = 
	match block with
	| [] 											->	""
	| ((Expr e) :: bs)								-> 	snd (generate_expr e v_tables) ^ generate_block bs v_tables offset
	| ((Return e) :: bs)	 						-> 	raise NotYetDeveloped
	| ((Local s) :: bs)								-> 	raise NotYetDeveloped
	| ((If_Then_Else (e, b1, b2)) :: bs)			-> 	let v_table : ((var, (type_ * int)) Hashtbl.t) ref = ref (Hashtbl.create 10) in
														let v_tables = v_table :: v_tables in
														let (t, e') = generate_expr e v_tables in
														lbl_counter := !lbl_counter + 2;
														e' ^ 
														(match t with
														| Bool	->	"\tpop %r8\n" ^ "\tcmp $1, %r8\n" ^ "\tjne L" ^ string_of_int !lbl_counter ^ "\n" ^ generate_block b1 v_tables offset ^ "\tjmp L" ^ string_of_int (!lbl_counter + 1) ^ "\n" ^ "L" ^ string_of_int !lbl_counter ^ ": \n" ^ generate_block b2 v_tables offset ^ "L" ^ string_of_int (!lbl_counter + 1) ^ ": \n"
														| _ 	-> 	raise NotYetDeveloped
														) ^ generate_block bs v_tables offset
	| ((While (e, b)) :: bs)						-> 	let v_table : ((var, (type_ * int)) Hashtbl.t) ref = ref (Hashtbl.create 10) in
														let v_tables = v_table :: v_tables in
														let (t, e') = generate_expr e v_tables in
														lbl_counter := !lbl_counter + 2;
														"L" ^ string_of_int !lbl_counter ^ ": \n" ^ e' ^
														(match t with
														| Bool 	-> 	"\tpop %r8\n" ^ "\tcmp $1, %r8\n" ^ "\tjne L" ^ string_of_int (!lbl_counter + 1) ^ "\n" ^ generate_block b v_tables offset ^ "\tjmp L" ^ string_of_int !lbl_counter ^ "\n" ^ "L" ^ string_of_int (!lbl_counter + 1) ^ ": \n"
														| _ 	-> raise NotYetDeveloped
														) ^ generate_block bs v_tables offset
	| ((For (e1, e2, e3, b)) :: bs)					-> 	raise NotYetDeveloped
	| ((Block b) :: bs) 							-> 	generate_block b v_tables offset ^ generate_block bs v_tables offset

let function_prefix : string =
	"\tpush %rbp\n" ^
	"\tmov %rsp, %rbp\n"

let function_postfix : string =
	"\tjmp RETURN\n"


let rec generate_func funcs v_tables : string =
	(match funcs with
	| [] 								-> 	""
	| ((Function (t, v, ps, b)) :: fs) 	-> 	raise NotYetDeveloped
	| ((Main b) :: fs) 					->  let v_table : ((var, (type_ * int)) Hashtbl.t) ref = ref (Hashtbl.create 10) in
											let v_tables = v_table :: v_tables in
											"\n\t.globl _main\n" ^ "_main:\n" ^ function_prefix ^ generate_block b v_tables (ref 0) ^ "\tmov $0, %rdi\n\tcall _exit\n" ^ generate_func fs v_tables
	| _ 								->	raise NotYetDeveloped
	)


let rec generate_global globals v_table : string =
	(match globals with
	| [] 											-> 	""
	| ((Global (Declare (t, v))) :: gs) 			->	Hashtbl.add !v_table v (t, 0);
														v ^ ": "
														^ (match t with
														| Void 		->	raise NotYetDeveloped
														| Int 		->	"\t.long"
														| Real 		->	"\t.double"
														| Char 		-> 	"\t.byte"
														| Bool 		-> 	"\t.byte"
														| String 	-> 	"\t.string"
														) ^ "\n" ^ generate_global gs v_table
	| ((Global (DeclareAssign (t, v, e))) :: gs)	-> 	Hashtbl.add !v_table v (t, 0);
														v ^ ": "
														^ (match (t, e) with
														| (Int, Int i)			->	"\t.long " ^ Int32.to_string i
														| (Real, Real r) 		->	"\t.double " ^ string_of_float r
														| (Char, Char c) 		-> 	"\t.byte '" ^ Char.escaped c ^ "'"
														| (Bool, Bool b)		-> 	"\t.byte " ^ (if b then "1" else "0")
														| (String, String s)	-> 	"\t.string \"" ^ s ^ "\""
														| _ 					-> 	raise (TypeError ("Type mismatched for " ^ v))
														) ^ "\n" ^ generate_global gs v_table
	| _ 											->	raise NotYetDeveloped
	)

let rec sort_program global func iterate : program * program =
	match iterate with
	| [] 					-> 	(global, func)
	| ((Global s) :: xs) 	-> 	sort_program (global @ [(Global s)]) func xs
	| (x :: xs) 			-> 	sort_program global (func @ [x]) xs

let prefix : string = 
	"\t.section __TEXT,__cstring,cstring_literals\n" 
	^ "int.str:\n" 
	^ "\t.string \"%d\\0\"\n" 
	^ "char.str:\n" 
	^ "\t.string \"%c\\0\"\n" 
	^ "true.str:\n" 
	^ "\t.string \"true\"\n" 
	^ "false.str:\n" 
	^ "\t.string \"false\"\n" 

let postfix : string =
	"RETURN: \n" 
	^ "\tmov %rbp, %rsp\n" 
	^ "\tpop %rbp\n" 
	^ "\tret\n"

let generate program : string = 
	let v_tables : (((var, (type_ * int)) Hashtbl.t) ref) list = [] in
	let v_table : ((var, (type_ * int)) Hashtbl.t) ref = ref (Hashtbl.create 10) 
	and (global, func) = sort_program [] [] program in
	let v_tables = v_table :: v_tables in
	let global_asm = generate_global global v_table in
	let func_asm = generate_func func v_tables in
	prefix 
	^ "\n"
	^ (if List.length global != 0 then "\t.data\n" else "") 
	^ global_asm 
	^ "\n"
	^ "\t.section __TEXT,__text,regular,pure_instructions\n\n"
	^ func_asm 
	^ "\n" 
	^ postfix 
	^ "\n"