open SyntaxTree

(* whether the function is pure function or not *)
let f_table : (var, bool) Hashtbl.t = Hashtbl.create 10

(* store the block of an function that is pure *)
let f_table_fun : (var, (type_ * (type_ * var) list * block)) Hashtbl.t = Hashtbl.create 10

let rec var_lookup v v_tables : expr option =
	match v_tables with
	| [] -> None
	| (v_table :: vs) 	->	if Hashtbl.mem v_table v then Hashtbl.find v_table v else var_lookup v vs

(* evaulating pure functions *)
let rec push_params_to_fun (es, ps) v_table = 
	match (es, ps) with
	| ([], [])  				-> ()
	| (x :: xs, (t, y) :: ys) 	-> Hashtbl.add v_table y (Some x); push_params_to_fun (xs, ys) v_table
	| _ 		 				-> ()

let rec find_return block =
	match block with
	| [] -> None
	| ((Return e) :: xs) -> (Some e)
	| (x :: xs) 		 -> find_return xs

let rec evaluate_function (v, es) (t, ps, b) v_tables : expr =
	let v_table : (var, expr option) Hashtbl.t = Hashtbl.create 10 in
	let v_tables = v_table :: v_tables in
	let () = push_params_to_fun (es, ps) v_table in
	let b' = optimise_block b v_tables (ref true) false in
	let e' = find_return b' in
	match e' with
	| None 		-> FunCall (v, es)
	| Some e 	-> e

(* optimisation procedures *)
and optimise_nullary_op op isPure : expr =
	match op with
	| Prompt 	-> isPure := false; NullaryOp Prompt

and optimise_unary_op (op, e) v_tables isPure isLoop : expr = 
	let e' = optimise_expr e v_tables isPure isLoop in 
	match op with
	| Print 	-> 	isPure := false;
					UnaryOp(Print, e')
	| Neg		-> 	(match e' with
					| Int i 	-> Int (Int32.neg i)
					| Real r 	-> Real (0.0 -. r)
					| x 		-> UnaryOp (Neg, x))
	| Not 		-> 	(match e' with
					| Bool x 	-> Bool (not x)
					| x 		-> UnaryOp (Not, x))
and optimise_binary_op (op, e1, e2) v_tables isPure isLoop : expr = 
	let (e1', e2') = (optimise_expr e1 v_tables isPure isLoop, optimise_expr e2 v_tables isPure isLoop) in 
	match op with
	| Add    -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.add i1 i2)
					| (Real r, Int i)		 -> Real (r +. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i +. r)
					| (Real r1, Real r2) 	 -> Real (r1 +. r2)
					| (String s1, String s2) -> String (s1 ^ s2)
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Sub	 ->	(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.sub i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 -. r2)
					| (Real r, Int i)		 -> Real (r -. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i -. r)
					| _                      -> BinaryOp (Sub, e1', e2')
				)
	| Mul  	 -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.mul i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 *. r2)
					| (Real r, Int i)		 -> Real (r *. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i *. r)
					| _                      -> BinaryOp (Mul, e1', e2')
				)
	| Div 	 -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.div i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 /. r2)
					| (Real r, Int i)		 -> Real (r /. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i /. r)
					| _                      -> BinaryOp (Div, e1', e2')
				)
	| Mod 	 -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.rem i1 i2)
					| _                      -> BinaryOp (Mod, e1', e2')
				)				
	| Eq     -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 = i2)
					| (Real r1, Real r2)	 -> Bool (r1 = r2)
					| (Real r, Int i)		 -> Bool (r = Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i = r)
					| (Char c1, Char c2)	 -> Bool (c1 = c2)
					| (String s1, String s2) -> Bool (s1 = s2) 
					| (Bool b1, Bool b2)     -> Bool (b1 = b2) 
					| _                      -> BinaryOp (Eq, e1', e2')
				)
	| Neq	 -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (not (i1 = i2))
					| (Real r1, Real r2)	 -> Bool (not (r1 = r2))
					| (Real r, Int i)		 -> Bool (not (r = Int32.to_float i))
					| (Int i, Real r)        -> Bool (not (Int32.to_float i = r))
					| (Char c1, Char c2)	 -> Bool (not (c1 = c2))
					| (String s1, String s2) -> Bool (not (s1 = s2))
					| (Bool b1, Bool b2)     -> Bool (not (b1 = b2))
					| _                      -> BinaryOp (Neq, e1', e2')
				)
	| Gt  	 -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 > i2)
					| (Real r1, Real r2)	 -> Bool (r1 > r2)
					| (Real r, Int i)		 -> Bool (r > Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i > r)
					| (Char c1, Char c2)	 -> Bool (c1 > c2)
					| (String s1, String s2) -> Bool (s1 > s2) 
					| _                      -> BinaryOp (Gt, e1', e2')
				)
	| Geq 	 -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 >= i2)
					| (Real r1, Real r2)	 -> Bool (r1 >= r2)
					| (Real r, Int i)		 -> Bool (r >= Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i >= r)
					| (Char c1, Char c2)	 -> Bool (c1 >= c2)
					| (String s1, String s2) -> Bool (s1 >= s2) 
					| _                      -> BinaryOp (Geq, e1', e2')
				)
	| Lt     -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 < i2)
					| (Real r1, Real r2)	 -> Bool (r1 < r2)
					| (Real r, Int i)		 -> Bool (r < Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i < r)
					| (Char c1, Char c2)	 -> Bool (c1 < c2)
					| (String s1, String s2) -> Bool (s1 < s2) 
					| _                      -> BinaryOp (Lt, e1', e2')
				)
	| Leq 	 -> (match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 <= i2)
					| (Real r1, Real r2)	 -> Bool (r1 <= r2)
					| (Real r, Int i)		 -> Bool (r <= Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i <= r)
					| (Char c1, Char c2)	 -> Bool (c1 <= c2)
					| (String s1, String s2) -> Bool (s1 <= s2) 
					| _                      -> BinaryOp (Leq, e1', e2')
				)
	| And 	 -> (match (e1', e2') with
					| (Bool b1, Bool b2)     -> Bool (b1 && b2)
					| _                      -> BinaryOp (And, e1', e2')
				)
	| Or 	 -> (match (e1', e2') with
					| (Bool b1, Bool b2)     -> Bool (b1 || b2)
					| _                      -> BinaryOp (Or, e1', e2')
				)
and optimise_expr expr v_tables isPure isLoop : expr = 
	let v_table = List.hd v_tables in
	match expr with
	| Var v 				-> 	if Hashtbl.mem v_table v then 
									(match Hashtbl.find v_table v with
									| None		-> 	Var v
									| Some e 	-> 	e
									)
								else (
									if not isLoop && !isPure then (
										let e' = var_lookup v v_tables in
										match e' with
										| None 		-> 	Var v
										| Some e 	-> 	e
									)
									else (
										Var v
									)
								)
	| Assign (v, e)			->	let () = isPure := Hashtbl.mem v_table v in
								let e' = optimise_expr e v_tables isPure isLoop in
								if !isPure then
									Hashtbl.add v_table v (Some e');
								Assign (v, e')
	| NullaryOp op 			->  optimise_nullary_op op isPure
	| UnaryOp (op, e)		->	optimise_unary_op (op, e) v_tables isPure isLoop
	| BinaryOp (op, e1, e2)	->	optimise_binary_op (op, e1, e2) v_tables isPure isLoop
	| FunCall (v, es)		->	let () = isPure := !isPure && Hashtbl.mem f_table v && Hashtbl.find f_table v in
								let es' = optimise_expr_list es v_tables isPure isLoop in
								if Hashtbl.mem f_table v &&  Hashtbl.find f_table v then evaluate_function (v, es') (Hashtbl.find f_table_fun v) v_tables
								else FunCall (v, es')
	| x 					->	x
and optimise_expr_list ls v_tables isPure isLoop : expr list =
	match ls with
	| [] -> []
	| (x :: xs) ->	let e' = optimise_expr x v_tables isPure isLoop in 
					e' :: optimise_expr_list xs v_tables isPure isLoop


and optimise_declare_stmnt declare_stmnt v_tables isPure isLoop : declare_stmnt = 
	let v_table = List.hd v_tables in
	match declare_stmnt with
	| Declare (t, v) 			->	Hashtbl.add v_table v None; Declare (t, v)
	| DeclareAssign (t, v, e)	->	let e' = optimise_expr e v_tables isPure isLoop in
									let () = (if !isPure then Hashtbl.add v_table v (Some e') else Hashtbl.add v_table v (Some (Var v))) in
									DeclareAssign (t, v, e')

and optimise_block' block v_tables isPure isLoop : block = 
	match block with
	| [] 									->	[]
	| (Expr e :: bs) 						-> 	let e' = optimise_expr e v_tables isPure isLoop in
												Expr e' :: optimise_block' bs v_tables isPure isLoop
	| (Return e :: bs) 						-> 	let e' = optimise_expr e v_tables isPure isLoop in
												Return e' :: optimise_block' bs v_tables isPure isLoop
	| (Local s :: bs) 						-> 	let stmnt' = optimise_declare_stmnt s v_tables isPure isLoop in
												Local stmnt' :: optimise_block' bs v_tables isPure isLoop
	| (If_Then_Else (e, b1, b2) :: bs)		-> 	let e' = optimise_expr e v_tables isPure isLoop in
												let temp = ref true in
												let stmnt' = 
												(match e' with
												| Bool true 	-> Block (optimise_block b1 v_tables temp isLoop)
												| Bool false 	-> Block (optimise_block b2 v_tables temp isLoop)
												| _ 			-> If_Then_Else (e', optimise_block b1 v_tables temp isLoop, optimise_block b2 v_tables temp isLoop)
												) in
												let () = isPure := !isPure && !temp in
												stmnt' :: optimise_block' bs v_tables isPure isLoop
	| (While (s, e, b) :: bs) 				-> 	let e' = optimise_expr e v_tables isPure isLoop in
												let stmnt' = 
												(match e' with
												| Bool false 	-> 	Block [] 
												| _ 			->  let temp = ref true in 
																	let b' = optimise_block b v_tables temp true in
																	let () = isPure := !isPure && !temp in
																	While (s, e, b')
												) in
												stmnt' :: optimise_block' bs v_tables isPure isLoop
	| (DoWhile (s, e, b) :: bs) 			->	let bs' = List.append b (While (s, e, b) :: bs) in
												optimise_block' bs' v_tables isPure isLoop
	| (For (s, e1, e2, e3, b) :: bs) 		-> 	let temp = ref true in 
												let b' = optimise_block b v_tables temp true in
												let () = isPure := !isPure && !temp in
												For (s, e1, e2, e3, b') :: optimise_block' bs v_tables isPure isLoop
	| (Break s :: bs)						->	Break s :: optimise_block' bs v_tables isPure isLoop
	| (Continue s :: bs)					-> 	Continue s :: optimise_block' bs v_tables isPure isLoop
	| (Block b :: bs) 						-> 	let b' = optimise_block b v_tables isPure false in
												Block b' :: optimise_block' bs v_tables isPure isLoop
	
and optimise_block block v_tables isPure isLoop : block = 
	let v_table : (var, expr option) Hashtbl.t = Hashtbl.create 10 in
	let v_tables = v_table :: v_tables in
	optimise_block' block v_tables isPure isLoop


let push_params ps v_table = 
	match ps with
	| [] -> ()
	| ((t, v) :: xs) -> Hashtbl.add v_table v None

let optimise_function (t, v, ps, b) v_tables : top_level = 
	let v_table : (var, expr option) Hashtbl.t = Hashtbl.create 10 in
	let v_tables = v_table :: v_tables
	and isPure = ref true in
	let () = push_params ps v_table in
	let b' = optimise_block' b v_tables isPure false in
	Hashtbl.add f_table v (!isPure);
	if !isPure then Hashtbl.add f_table_fun v (t, ps, b');
	Function (t, v, ps, b')


let rec optimise_program program v_tables : program = 
	match program with
	| [] -> []
	| ((Global s) :: ts) 				->	let global' = optimise_declare_stmnt s v_tables (ref true) false in
											Global (global') :: optimise_program ts v_tables
	| ((Function (t, v, ps, b)) :: ts) 	->	let func' = optimise_function (t, v, ps, b) v_tables in
											func' :: optimise_program ts v_tables
	| ((Main b) :: ts) 					->	let b' = optimise_block b v_tables (ref true) false in
											Main b' :: optimise_program ts v_tables


let optimise program : program = 
	let v_tables : ((var, expr option) Hashtbl.t) list = []
	and v_table : (var, expr option) Hashtbl.t = Hashtbl.create 10 in
	let v_tables = v_table :: v_tables in
	optimise_program program v_tables
