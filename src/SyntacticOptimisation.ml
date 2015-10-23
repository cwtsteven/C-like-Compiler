open SyntaxTree

let f_table : (var, bool) Hashtbl.t = Hashtbl.create 10
let f_table_fun : (var, (type_ * var * (type_ * var) list * block)) Hashtbl.t = Hashtbl.create 10

let push_params_to_fun (es, ps) v_table = 
	match (es, ps) with
	| ([], [])   -> ()
	| (x :: xs, (t, y) :: ys) -> Hashtbl.add v_table y (Some x)
	| _ 		 -> ()

let rec find_return block =
	match block with
	| [] -> None
	| ((Return e) :: xs) -> (Some e)
	| (x :: xs) 		 -> find_return xs

let rec evaluate_function (v, es) (t, v, ps, b) : expr =
	let v_table : (var, expr option) Hashtbl.t = Hashtbl.create 10 in
	let can_progress = ref true in 
	push_params_to_fun (es, ps) v_table;
	let b' = optimise_block b v_table can_progress in
	let e' = find_return b' in
	match e' with
	| None 		-> FunCall (v, es)
	| Some e 	-> e


and optimise_nullary_op op can_progress : expr =
	match op with
	| Prompt 	-> can_progress := false; NullaryOp Prompt

and optimise_unary_op (op, e) v_table can_progress : expr = 
	match op with
	| Print 	-> let e' = optimise_expr e v_table can_progress in 
					can_progress := false;
					UnaryOp(Print, e')
	| Neg		-> let e' = optimise_expr e v_table can_progress in
				   (match e' with
					| Int i 	-> Int (Int32.neg i)
					| Real r 	-> Real (0.0 -. r)
					| x 		-> UnaryOp (Neg, x))
	| Not 		-> let e' = optimise_expr e v_table can_progress in
				   (match e' with
					| Bool x 	-> Bool (not x)
					| x 		-> UnaryOp (Not, x))
and optimise_binary_op (op, e1, e2) v_table can_progress : expr =
	match op with
	| Add    -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.add i1 i2)
					| (Real r, Int i)		 -> Real (r +. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i +. r)
					| (Real r1, Real r2) 	 -> Real (r1 +. r2)
					| (String s1, String s2) -> String (s1 ^ s2)
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Sub	 ->	let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.sub i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 -. r2)
					| (Real r, Int i)		 -> Real (r -. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i -. r)
					| _                      -> BinaryOp (Sub, e1', e2')
				)
	| Mul  	 -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.mul i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 *. r2)
					| (Real r, Int i)		 -> Real (r *. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i *. r)
					| _                      -> BinaryOp (Mul, e1', e2')
				)
	| Div 	 -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.div i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 /. r2)
					| (Real r, Int i)		 -> Real (r /. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i /. r)
					| _                      -> BinaryOp (Div, e1', e2')
				)
	| Eq     -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 = i2)
					| (Real r1, Real r2)	 -> Bool (r1 = r2)
					| (Real r, Int i)		 -> Bool (r = Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i = r)
					| (Char c1, Char c2)	 -> Bool (c1 = c2)
					| (String s1, String s2) -> Bool (s1 = s2) 
					| (Bool b1, Bool b2)     -> Bool (b1 = b2) 
					| _                      -> BinaryOp (Eq, e1', e2')
				)
	| Neq	 -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (not (i1 = i2))
					| (Real r1, Real r2)	 -> Bool (not (r1 = r2))
					| (Real r, Int i)		 -> Bool (not (r = Int32.to_float i))
					| (Int i, Real r)        -> Bool (not (Int32.to_float i = r))
					| (Char c1, Char c2)	 -> Bool (not (c1 = c2))
					| (String s1, String s2) -> Bool (not (s1 = s2))
					| (Bool b1, Bool b2)     -> Bool (not (b1 = b2))
					| _                      -> BinaryOp (Neq, e1', e2')
				)
	| Gt  	 -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 > i2)
					| (Real r1, Real r2)	 -> Bool (r1 > r2)
					| (Real r, Int i)		 -> Bool (r > Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i > r)
					| (Char c1, Char c2)	 -> Bool (c1 > c2)
					| (String s1, String s2) -> Bool (s1 > s2) 
					| _                      -> BinaryOp (Gt, e1', e2')
				)
	| Geq 	 -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 >= i2)
					| (Real r1, Real r2)	 -> Bool (r1 >= r2)
					| (Real r, Int i)		 -> Bool (r >= Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i >= r)
					| (Char c1, Char c2)	 -> Bool (c1 >= c2)
					| (String s1, String s2) -> Bool (s1 >= s2) 
					| _                      -> BinaryOp (Geq, e1', e2')
				)
	| Lt     -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 < i2)
					| (Real r1, Real r2)	 -> Bool (r1 < r2)
					| (Real r, Int i)		 -> Bool (r < Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i < r)
					| (Char c1, Char c2)	 -> Bool (c1 < c2)
					| (String s1, String s2) -> Bool (s1 < s2) 
					| _                      -> BinaryOp (Lt, e1', e2')
				)
	| Leq 	 -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 <= i2)
					| (Real r1, Real r2)	 -> Bool (r1 <= r2)
					| (Real r, Int i)		 -> Bool (r <= Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i <= r)
					| (Char c1, Char c2)	 -> Bool (c1 <= c2)
					| (String s1, String s2) -> Bool (s1 <= s2) 
					| _                      -> BinaryOp (Leq, e1', e2')
				)
	| And 	 -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Bool b1, Bool b2)     -> Bool (b1 && b2)
					| _                      -> BinaryOp (And, e1', e2')
				)
	| Or 	 -> let (e1', e2') = (optimise_expr e1 v_table can_progress, optimise_expr e2 v_table can_progress) in 
				(match (e1', e2') with
					| (Bool b1, Bool b2)     -> Bool (b1 || b2)
					| _                      -> BinaryOp (Or, e1', e2')
				)
and optimise_expr expr v_table can_progress : expr =
	match expr with
	| Var v 				-> 	if !can_progress && Hashtbl.mem v_table v then 
								(match Hashtbl.find v_table v with
								| None		-> 	Var v
								| Some e 	-> 	e)
								else Var v
	| Assign (v, e)			->	let e' = optimise_expr e v_table can_progress in
								can_progress := Hashtbl.mem v_table v;
								Hashtbl.add v_table v (Some e');
								Assign (v, e')
	| NullaryOp op 			->  optimise_nullary_op op can_progress
	| UnaryOp (op, e)		->	optimise_unary_op (op, e) v_table can_progress
	| BinaryOp (op, e1, e2)	->	optimise_binary_op (op, e1, e2) v_table can_progress
	| FunCall (v, ps)		->	let ps' = optimise_expr_list ps v_table can_progress in
								can_progress := !can_progress && Hashtbl.mem f_table v && (not (Hashtbl.find f_table v));
								if (not (Hashtbl.find f_table v)) then evaluate_function (v, ps') (Hashtbl.find f_table_fun v)
								else FunCall (v, ps')
	| x 					-> 	x
and optimise_expr_list ls v_table can_progress : expr list =
	match ls with
	| [] -> []
	| (x :: xs) -> optimise_expr x v_table can_progress :: optimise_expr_list xs v_table can_progress


and optimise_declare_stmnt declare_stmnt v_table can_progress : declare_stmnt = 
	match declare_stmnt with
	| Declare (t, v) 			->	Hashtbl.add v_table v None; Declare (t, v)
	| DeclareAssign (t, v, e)	->	let e' = optimise_expr e v_table can_progress in
									Hashtbl.add v_table v (Some e');
									DeclareAssign (t, v, e')

and optimise_block block v_table can_progress : block = 
	let block_array : stmnt array = Array.make (List.length block) (Expr (Bool true)) in
	for i = 0 to (List.length block) - 1 do 
		let stmnt = List.nth block i in
		block_array.(i) <- (
		match stmnt with
		| Expr e 					-> 	Expr (optimise_expr e v_table can_progress)
		| Return e 					-> 	Return (optimise_expr e v_table can_progress) 
		| Local s 					-> 	Local (optimise_declare_stmnt s v_table can_progress)
		| If_Then_Else (e, b1, b2)	-> 	let v_table' : (var, expr option) Hashtbl.t = Hashtbl.create 10
										and can_progress' = ref true in
										( 	let e' = optimise_expr e v_table can_progress in
											can_progress := false;
											match e' with
											| Bool true 	-> Block (optimise_block b1 v_table' can_progress')
											| Bool false 	-> Block (optimise_block b2 v_table' can_progress')
											| _ 			-> If_Then_Else (e', optimise_block b1 v_table' can_progress', optimise_block b2 v_table' can_progress')
										) 
		| While (e, b) 				-> 	let v_table' : (var, expr option) Hashtbl.t = Hashtbl.create 10
										and can_progress' = ref true in
										(can_progress := false; While (optimise_expr e v_table can_progress, optimise_block b v_table' can_progress'))
		| For (e1, e2, e3, b) 		-> 	let v_table' : (var, expr option) Hashtbl.t = Hashtbl.create 10
										and can_progress' = ref true in
										can_progress := false;
										For (e1, e2, e3, optimise_block b v_table' can_progress')
		| Block b 					-> 	let v_table' : (var, expr option) Hashtbl.t = Hashtbl.create 10
										and can_progress' = ref true in
										can_progress := false; 
										Block (optimise_block b v_table' can_progress')
		)
	done;
	Array.to_list block_array

let push_params ps v_table = 
	match ps with
	| [] -> ()
	| ((t, v) :: xs) -> Hashtbl.add v_table v None

let optimise_function (t, v, ps, b) : top_level = 
	let v_table : (var, expr option) Hashtbl.t = Hashtbl.create 10
	and can_progress = ref true in
	push_params ps v_table;
	let b' = optimise_block b v_table can_progress in
	Hashtbl.add f_table v (not !can_progress);
	if !can_progress then Hashtbl.add f_table_fun v (t, v, ps, b');
	Function (t, v, ps, b')


let optimise program : program = 
	let v_table : (var, expr option) Hashtbl.t = Hashtbl.create 10
	and can_progress = ref true
	and program_array : top_level array = Array.make (List.length program) (Main[]) in
	for i = 0 to (List.length program) - 1 do 
		let declare_stmnt = List.nth program i in
		program_array.(i) <- (
		match declare_stmnt with
		| Global s  				->	Global (optimise_declare_stmnt s v_table can_progress)
		| Function (t, v, ps, b)	->  optimise_function (t, v, ps, b)
		| Main b 					->	let v_table' : (var, expr option) Hashtbl.t = Hashtbl.create 10
										and can_progress' = ref true in 
										Main (optimise_block b v_table' can_progress')
		)
	done;
	Array.to_list program_array