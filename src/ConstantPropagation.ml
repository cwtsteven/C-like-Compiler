open SyntaxTree

let f_table : (var, expr) Hashtbl.t = Hashtbl.create 20

let rec contains_fun_call expr : bool = 
	match expr with
	| UnaryOp (op, e)		-> contains_fun_call e
	| BinaryOp (op, e1, e2) -> contains_fun_call e1 || contains_fun_call e2
	| FunCall _				-> true
	| Assign (v, e) 			-> contains_fun_call e
	| _ 					-> false

let declare_stmnt_contains_fun_call declare_stmnt : bool = 
	match declare_stmnt with
	| Declare (t, v)     	  -> false
	| DeclareAssign (t, v, e) -> contains_fun_call e

let stmnt_contains_fun_call stmnt : bool = 
	match stmnt with
	| Expr e 					-> contains_fun_call e
	| Return e 					-> contains_fun_call e
	| If_Then_Else (e, b1, b2)  -> true
	| While (e, b) 				-> true
	| For (e1, e2, e3, b)       -> true
	| Local s  					-> declare_stmnt_contains_fun_call s

let top_level_contains_fun_call top_level : bool = 
	match top_level with
	| Global s 				-> declare_stmnt_contains_fun_call s
	| _ 					-> false


let rec constant_propagation_unary_op (op, e) v_table : expr = 
	match op with
	| Print 	-> UnaryOp(Print, constant_propagation_expr e v_table)
	| Neg		-> let e' = constant_propagation_expr e v_table in
				   (match e' with
					| Int i 	-> Int (Int32.neg i)
					| Real r 	-> Real (0.0 -. r)
					| x 		-> UnaryOp (Neg, x))
	| Not 		-> let e' = constant_propagation_expr e v_table in
				   (match e' with
					| Bool x 	-> Bool (not x)
					| x 		-> UnaryOp (Not, x))
and constant_propagation_binary_op (op, e1, e2) v_table : expr =
	match op with
	| Add    -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.add i1 i2)
					| (Real r, Int i)		 -> Real (r +. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i +. r)
					| (Real r1, Real r2) 	 -> Real (r1 +. r2)
					| (String s1, String s2) -> String (s1 ^ s2)
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Sub	 ->	let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.sub i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 -. r2)
					| (Real r, Int i)		 -> Real (r -. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i -. r)
					| _                      -> BinaryOp (Sub, e1', e2')
				)
	| Mul  	 -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.mul i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 *. r2)
					| (Real r, Int i)		 -> Real (r *. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i *. r)
					| _                      -> BinaryOp (Mul, e1', e2')
				)
	| Div 	 -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.div i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 /. r2)
					| (Real r, Int i)		 -> Real (r /. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i /. r)
					| _                      -> BinaryOp (Div, e1', e2')
				)
	| Eq     -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
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
	| Neq	 -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
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
	| Gt  	 -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 > i2)
					| (Real r1, Real r2)	 -> Bool (r1 > r2)
					| (Real r, Int i)		 -> Bool (r > Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i > r)
					| (Char c1, Char c2)	 -> Bool (c1 > c2)
					| (String s1, String s2) -> Bool (s1 > s2) 
					| _                      -> BinaryOp (Gt, e1', e2')
				)
	| Geq 	 -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 >= i2)
					| (Real r1, Real r2)	 -> Bool (r1 >= r2)
					| (Real r, Int i)		 -> Bool (r >= Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i >= r)
					| (Char c1, Char c2)	 -> Bool (c1 >= c2)
					| (String s1, String s2) -> Bool (s1 >= s2) 
					| _                      -> BinaryOp (Geq, e1', e2')
				)
	| Lt     -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 < i2)
					| (Real r1, Real r2)	 -> Bool (r1 < r2)
					| (Real r, Int i)		 -> Bool (r < Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i < r)
					| (Char c1, Char c2)	 -> Bool (c1 < c2)
					| (String s1, String s2) -> Bool (s1 < s2) 
					| _                      -> BinaryOp (Lt, e1', e2')
				)
	| Leq 	 -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 <= i2)
					| (Real r1, Real r2)	 -> Bool (r1 <= r2)
					| (Real r, Int i)		 -> Bool (r <= Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i <= r)
					| (Char c1, Char c2)	 -> Bool (c1 <= c2)
					| (String s1, String s2) -> Bool (s1 <= s2) 
					| _                      -> BinaryOp (Leq, e1', e2')
				)
	| And 	 -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Bool b1, Bool b2)     -> Bool (b1 && b2)
					| _                      -> BinaryOp (And, e1', e2')
				)
	| Or 	 -> let (e1', e2') = (constant_propagation_expr e1 v_table, constant_propagation_expr e2 v_table) in 
				(match (e1', e2') with
					| (Bool b1, Bool b2)     -> Bool (b1 || b2)
					| _                      -> BinaryOp (Or, e1', e2')
				)
and constant_propagation_expr expr v_table : expr = 
	match expr with
	| Var v 	     		-> if Hashtbl.mem v_table v then Hashtbl.find v_table v else Var v
	| UnaryOp (op, e)		-> constant_propagation_unary_op (op, e) v_table
	| BinaryOp (op, e1, e2)	-> constant_propagation_binary_op (op, e1, e2) v_table
	| FunCall (var, ps)     -> FunCall (var, ps)
	| Assign (v, e) 		-> let e' = constant_propagation_expr e v_table in
								Hashtbl.add v_table v e';
								Assign (v, e')
	| x 					-> x

let constant_propagation_declare_stmnt declare_stmnt v_table : declare_stmnt = 
	match declare_stmnt with
	| Declare (t, v) 			-> Declare (t, v)
	| DeclareAssign (t, v, e) 	-> let e' = constant_propagation_expr e v_table in
									Hashtbl.add v_table v e';
									DeclareAssign (t, v, e')

let rec constant_propagation_block block : block = 
	let v_table : (var, expr) Hashtbl.t = Hashtbl.create 10 in
	let hit_fun_call = ref false in
	let stmnt_array = Array.of_list block in
	for i = 0 to (Array.length stmnt_array) - 1 do
		(if not !hit_fun_call then hit_fun_call := stmnt_contains_fun_call stmnt_array.(i));
		(match stmnt_array.(i) with
		| Expr e   					-> if not !hit_fun_call then stmnt_array.(i) <- Expr (constant_propagation_expr e v_table)
		| Return e 					-> if not !hit_fun_call then stmnt_array.(i) <- Return (constant_propagation_expr e v_table) else stmnt_array.(i) <- Return e
		| Local s   				-> if not !hit_fun_call then stmnt_array.(i) <- Local (constant_propagation_declare_stmnt s v_table) else stmnt_array.(i) <- Local s
		| If_Then_Else (e, b1, b2)	-> if not !hit_fun_call
										then let e' = constant_propagation_expr e v_table in
										(match e' with
											| Bool true  -> stmnt_array.(i) <- If_Then_Else (Bool true, constant_propagation_block b1, [])
											| Bool false -> stmnt_array.(i) <- If_Then_Else (Bool true, [], constant_propagation_block b2)
											| _			 -> stmnt_array.(i) <- If_Then_Else (e', constant_propagation_block b1, constant_propagation_block b2)
										)
										else stmnt_array.(i) <- If_Then_Else (e, constant_propagation_block b1, constant_propagation_block b2)
		| While (e , b) 			-> stmnt_array.(i) <- While (e, constant_propagation_block b)
		| For (e1, e2, e3, b)		-> stmnt_array.(i) <- For (e1, e2, e3, constant_propagation_block b)
		)
	done;
	Array.to_list stmnt_array

let constant_propagation program : program = 
	let v_table : (var, expr) Hashtbl.t = Hashtbl.create 10 in
	let hit_fun_call = ref false in 
	let program_array = Array.of_list program in
	for i = 0 to (Array.length program_array) - 1 do
		(if not !hit_fun_call then hit_fun_call := top_level_contains_fun_call program_array.(i));
		(match program_array.(i) with
		| Global s   				-> if not !hit_fun_call then program_array.(i) <- Global (constant_propagation_declare_stmnt s v_table) else program_array.(i) <- Global s
		| Function (t, v, ps, b) 	-> program_array.(i) <- Function (t, v, ps, constant_propagation_block b)
		| Main b 					-> program_array.(i) <- Main (constant_propagation_block b)
		)
	done;
	Array.to_list program_array