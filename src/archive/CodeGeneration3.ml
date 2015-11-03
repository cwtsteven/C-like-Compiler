open SyntaxTree

exception UnboundVarError of string
exception TypeError of string
exception NotYetDeveloped

let lbl_counter = ref 0

let f_table : (var, (type_ * int)) Hashtbl.t = Hashtbl.create 10

let rec var_lookup v v_tables : type_ * int =
	match v_tables with
	| [] -> raise (UnboundVarError ("Unbound variable " ^ v ^ "\n"))
	| (v_table :: vs) 	->	if Hashtbl.mem v_table v then Hashtbl.find v_table v else var_lookup v vs

let rec generate_nullary_op op v_tables : type_ * string = 
	match op with
	| Prompt 	-> 	raise NotYetDeveloped
and generate_unary_op (op, e) v_tables : type_ * string =
	let (t, e') = generate_expr e v_tables in
	match op with 
	| Print		-> 	(Void, (match t with
							| Int 		->	e' ^ "\tlea int.str(%rip), %rdi\n" ^ (match e with | FunCall _ 	->	"\tmov %rax, %rsi\n" | _ 	-> 	"\tpop %rsi\n") ^ "\tcall _printf\n"
							| Char 		-> 	e' ^ "\tlea char.str(%rip), %rdi\n" ^ (match e with | FunCall _ 	->	"\tmov %rax, %rsi\n" | _ 	-> 	"\tpop %rsi\n")  ^ "\tcall _printf\n"
							| Bool 		-> 	let lbl = !lbl_counter in
											let () = lbl_counter := lbl + 2 in 
											e' ^ (match e with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tcmp $1, %rax\n" ^ "\tjne L" ^ 
											string_of_int lbl ^ "\n" ^ "\tlea true.str(%rip), %rdi\n" ^ "\tjmp L" ^ string_of_int (lbl + 1) ^ "\n" ^ "L" ^ string_of_int lbl ^ ": \n" ^ "\tlea false.str(%rip), %rdi\n" ^ "L" ^ string_of_int (lbl + 1) ^ ": \n" ^ "\tcall _printf\n"
							| _ 		->	raise NotYetDeveloped
							)
					)
	| Neg 		->	(match t with
					| Int 		-> 	(Int, e' ^ (match e with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tnegl (%rsp)\n")
					| _ 		->	raise NotYetDeveloped
					)
	| Not 		->	(match t with
					| Bool 		->	(Bool, e' ^ (match e with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tnot (%rsp)\n")
					| _ 		->	raise NotYetDeveloped
					)

and generate_binary_op (op, e1, e2) v_tables : type_ * string = 
	let (t1, e1') = generate_expr e1 v_tables 
	and (t2, e2') = generate_expr e2 v_tables in
	(match op with
	| Add 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tadd %rax, %r8\n" ^ "\tpush %r8\n")
					| _ 				->	raise NotYetDeveloped
					)
	| Sub 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tsub %rax, %r8\n" ^ "\tpush %r8\n")
					| _ 				->	raise NotYetDeveloped
					)
	| Mul 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\timul %rax, %r8\n" ^ "\tpush %r8\n")
					| _ 				->	raise NotYetDeveloped
					)
	| Div 		-> 	(match (t1, t2) with
					| (Int, Int)		->	(Int, e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ "\tpop %r8\n" ^ "\tpop %rax\n" ^ "\tcqto\n" ^ "\tidiv %r8\n" ^ "\tpush %rax\n")
					| _ 				->	raise NotYetDeveloped
					)
	| Eq 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char) 		
					| (Bool, Bool) 		->	e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tcmp %rax, %r8\n" ^ "\tmov $0, %rax\n" ^ "\tsete %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Neq 		->	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tcmp %rax, %r8\n" ^ "\tmov $0, %rax\n" ^ "\tsetne %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Gt 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tcmp %rax, %r8\n" ^ "\tmov $0, %rax\n" ^ "\tsetg %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Geq		->	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tcmp %rax, %r8\n" ^ "\tmov $0, %rax\n" ^ "\tsetge %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Lt 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tcmp %rax, %r8\n" ^ "\tmov $0, %rax\n" ^ "\tsetl %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| Leq 		-> 	(Bool, 
					(match (t1, t2) with
					| (Int, Int) 		
					| (Char, Char)		
					| (Bool, Bool)		->	e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tcmp %rax, %r8\n" ^ "\tmov $0, %rax\n" ^ "\tsetle %al\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise NotYetDeveloped
					))
	| And 		->	(Bool, 
					(match (t1, t2) with
					| (Bool, Bool) 		->	e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tand %r8, %rax\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise (TypeError ("Type mismatch."))
					))
	| Or 		-> 	(Bool, 
					(match (t1, t2) with
					| (Bool, Bool) 		->	e1' ^ (match e1 with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ e2' ^ (match e2 with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tpop %r8\n" ^ "\tor %r8, %rax\n" ^ "\tpush %rax\n"
					| _ 				-> 	raise (TypeError ("Type mismatch."))
					))
	)

and generate_expr expr v_tables : type_ * string = 
	match expr with
	| Var v 				-> 	let (t, offset) = var_lookup v v_tables in
								if offset = 0 then 
									(t, "\tmovabsq (" ^ v ^ "), %rax\n" ^ "\tpush %rax\n")
								else 
									(t, "\tpush " ^ string_of_int offset ^ "(%rbp)\n")
	| Int i 				-> 	(Int, "\tpush $" ^ Int32.to_string i ^ "\n")
	| Real r 				-> 	raise NotYetDeveloped
	| Char c 				-> 	(Char, "\tpush $'" ^ Char.escaped c ^ "'\n")
	| String s 				-> 	raise NotYetDeveloped
	| Bool b 				-> 	(Bool, "\tpush $" ^ (if b then "1" else "0") ^ "\n")
	| NullaryOp op			-> 	generate_nullary_op op v_tables
	| UnaryOp (op, e) 		-> 	generate_unary_op (op, e) v_tables
	| BinaryOp (op, e1, e2)	->	generate_binary_op (op, e1, e2) v_tables
	| Assign (v, e)			->	let (t, offset) = var_lookup v v_tables 
								and (t', e') = generate_expr e v_tables in
								(t, 
								if offset = 0 then 
									(match (t, t') with
									| (Int, Int) 		
									| (Char, Char) 		
									| (Bool, Bool)		->	e' ^ (match e with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tmovabsq %rax, (" ^ v ^ ")\n"
									| _ 				->	raise NotYetDeveloped
									)
								else
									(match (t, t') with
									| (Int, Int) 		
									| (Char, Char) 		
									| (Bool, Bool)		->	e' ^ (match e with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tmov %rax, " ^ string_of_int offset ^ "(%rbp)\n"
									| _ 				->	raise NotYetDeveloped
									)
								)
	| FunCall (v, ps) 		->	if Hashtbl.mem f_table v then
									let (t, size) = Hashtbl.find f_table v in
									(t, generate_expr_list (List.rev ps) v_tables ^  "\tcall _" ^ v ^ "\n" ^ "\tadd $" ^ string_of_int (size - 8) ^ ", %rsp\n")
								else
									raise (UnboundVarError ("Unbound variable " ^ v ^ "\n"))

and generate_expr_list es v_tables : string =
	match es with
	| [] -> ""
	| (e :: ps) -> 	let (t, e') = generate_expr e v_tables in
				   	e' ^ (match e with | FunCall _ 	->	"\tpush %rax\n" | _ 	-> 	"") ^ generate_expr_list ps v_tables


let rec generate_block' block v_tables offset : string = 
	match block with
	| [] 											->	""
	| ((Expr e) :: bs)								-> 	snd (generate_expr e v_tables) ^ generate_block' bs v_tables offset
	| ((Return e) :: bs)	 						-> 	snd (generate_expr e v_tables) ^ (match e with | FunCall _ 	->	 "" | _ 	->	"\tpop %rax\n") ^ "\tjmp RETURN\n" ^ generate_block' bs v_tables offset
	| ((Local (Declare (t, v))) :: bs)				-> 	let v_table = List.hd v_tables in
														let _offset = 
														(match t with
														| Int 		
														| Char 		
														| Bool 		->	offset := !offset - 8; !offset
														| _ 		-> 	raise NotYetDeveloped
														) in
														let () = Hashtbl.add v_table v (t, _offset) in
														generate_block' bs v_tables offset
	| ((Local (DeclareAssign (t, v, e))) :: bs)		-> 	let v_table = List.hd v_tables 
														and (t', e') = generate_expr e v_tables in
														let _offset = 
														(match (t, t') with
														| (Int, Int)		
														| (Char, Char)
														| (Bool, Bool)		->	offset := !offset - 8; !offset
														| _ 				->	raise NotYetDeveloped
														) in
														let () = Hashtbl.add v_table v (t, _offset) in
														e' ^ (match e with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tmov %rax, " ^ string_of_int _offset ^ "(%rbp)\n"
														^ generate_block' bs v_tables offset
	| ((If_Then_Else (e, b1, b2)) :: bs)			-> 	let (t, e') = generate_expr e v_tables in
														let lbl = !lbl_counter in
														let () = lbl_counter := lbl + 2 in
														let b1' = generate_block b1 v_tables offset in
														let b2' = generate_block b2 v_tables offset in
														e' ^ 
														(match t with
														| Bool	->	(match e with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tcmp $1, %rax\n" ^ "\tjne L" ^ string_of_int lbl ^ "\n" ^ b1' ^ "\tjmp L" ^ string_of_int (lbl + 1) ^ "\n" ^ "L" ^ string_of_int lbl ^ ": \n" ^ b2' ^ "L" ^ string_of_int (lbl + 1) ^ ": \n"
														| _ 	-> 	raise NotYetDeveloped
														) ^ generate_block' bs v_tables offset
	| ((While (e, b)) :: bs)						-> 	let (t, e') = generate_expr e v_tables in
														let lbl = !lbl_counter in
														let () = lbl_counter := lbl + 2 in
														let b' = generate_block b v_tables offset in
														"L" ^ string_of_int lbl ^ ": \n" ^ e' ^
														(match t with
														| Bool 	-> 	(match e with | FunCall _ 	->	"" | _ 	-> 	"\tpop %rax\n") ^ "\tcmp $1, %rax\n" ^ "\tjne L" ^ string_of_int (lbl + 1) ^ "\n" ^ b' ^ "\tjmp L" ^ string_of_int lbl ^ "\n" ^ "L" ^ string_of_int (lbl + 1) ^ ": \n"
														| _ 	-> 	raise NotYetDeveloped
														) ^ generate_block' bs v_tables offset
	| ((For (e1, e2, e3, b)) :: bs)					-> 	raise NotYetDeveloped
	| ((Block b) :: bs) 							-> 	let b' = generate_block b v_tables offset in
														b' ^ generate_block' bs v_tables offset
and generate_block block v_tables offset : string = 
	let v_table : (var, (type_ * int)) Hashtbl.t = Hashtbl.create 10 in
	let v_tables = v_table :: v_tables in
	generate_block' block v_tables offset

let function_prefix : string =
	"\tpush %rbp\n" ^
	"\tmov %rsp, %rbp\n"

let rec generate_params_list (ps : (type_ * var) list) v_table offset =
	match ps with
	| [] -> ()
	| ((t, v) :: vs) -> let () = 
						(match t with
						| Int 		
						| Char 		
						| Bool 		->	offset := !offset + 8;
						| _ 		->	raise NotYetDeveloped
						);
						Hashtbl.add v_table v (t, !offset) in
						generate_params_list vs v_table offset

let generate_function (t, v, ps, b) v_tables : string = 
	let v_table : (var, (type_ * int)) Hashtbl.t = Hashtbl.create 10 in
	let v_tables = v_table :: v_tables 
	and param_offset = ref 8
	and local_offset = ref 0 in
	let () = generate_params_list ps v_table param_offset in
	let () = Hashtbl.add f_table v (t, !param_offset) in
	let b' = generate_block' b v_tables local_offset in
	"_" ^ v ^ ": \n" ^ function_prefix ^ "\tsub $" ^ string_of_int (!local_offset * -1) ^ ", %rsp\n" ^ "\tand $-32, %rsp\n" ^ b' ^ if t = Void then "\tjmp RETURN\n" else ""


let rec generate_func funcs v_tables : string =
	(match funcs with
	| [] 								-> 	""
	| ((Function (t, v, ps, b)) :: fs) 	-> 	let f' = generate_function (t, v, ps, b) v_tables in
											f' ^ "\n"
											^ generate_func fs v_tables
	| ((Main b) :: fs) 					->  let local_offset = ref 0 in
											let b' = generate_block b v_tables local_offset in
											"\t.globl _main\n" ^ "_main:\n" ^ function_prefix ^ "\tsub $" ^ string_of_int (!local_offset * -1) ^ ", %rsp\n" ^ "\tand $-32, %rsp\n" ^ b' ^ "\tmov $0, %rdi\n\tcall _exit\n" ^ "\n"
											^ generate_func fs v_tables
	| _ 								->	raise NotYetDeveloped
	)


let rec generate_global globals v_table : string =
	(match globals with
	| [] 											-> 	""
	| ((Global (Declare (t, v))) :: gs) 			->	Hashtbl.add v_table v (t, 0);
														generate_global gs v_table 
														^ v ^ ": "
														^ (match t with
														| Void 		->	raise NotYetDeveloped
														| Int 		->	"\t.long"
														| Real 		->	raise NotYetDeveloped
														| Char 		-> 	"\t.byte"
														| Bool 		-> 	"\t.byte"
														| String 	-> 	raise NotYetDeveloped
														) ^ "\n"
	| ((Global (DeclareAssign (t, v, e))) :: gs)	-> 	Hashtbl.add v_table v (t, 0);
														generate_global gs v_table
														^ v ^ ": "
														^ (match (t, e) with
														| (Int, Int i)			->	"\t.long " ^ Int32.to_string i
														| (Real, Real r) 		->	raise NotYetDeveloped
														| (Char, Char c) 		-> 	"\t.byte '" ^ Char.escaped c ^ "'"
														| (Bool, Bool b)		-> 	"\t.byte " ^ (if b then "1" else "0")
														| (String, String s)	-> 	raise NotYetDeveloped
														| _ 					-> 	raise (TypeError ("Type mismatch for variable " ^ v ^ "."))
														) ^ "\n"
	| _ 											->	raise NotYetDeveloped
	)

let rec sort_program global func iterate : program * program =
	match iterate with
	| [] 					-> 	(global, func)
	| ((Global s) :: xs) 	-> 	sort_program ((Global s) :: global) func xs
	| (x :: xs) 			-> 	sort_program global (x :: func) xs

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
	let v_tables : ((var, (type_ * int)) Hashtbl.t) list = []
	and v_table : (var, (type_ * int)) Hashtbl.t = Hashtbl.create 10
	and (global, func) = sort_program [] [] program in
	let v_tables = v_table :: v_tables in
	let global_asm = generate_global global v_table in
	let func_asm = generate_func (List.rev func) v_tables in
	prefix 
	^ "\n"
	^ (if List.length global != 0 then "\t.data\n" else "") 
	^ global_asm 
	^ "\n"
	^ "\t.section __TEXT,__text,regular,pure_instructions\n\n"
	^ func_asm 
	^ postfix 
	^ "\n"
