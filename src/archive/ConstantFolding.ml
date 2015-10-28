open SyntaxTree

let rec optimise_unary_op (op, e) : expr = 
	match op with
	| Neg   ->	let e' = optimise_expr e in
				(match e' with
					| Int i  ->	Int (Int32.neg i)
					| Real r -> Real (0.0 -. r)
					| _      ->	UnaryOp (Neg, e')
				)
	| Print -> UnaryOp (Print , optimise_expr e)
	| Not   -> 	let e' = optimise_expr e in
				(match e' with
					| Bool x -> Bool (not x)
					| _      -> UnaryOp (Not, e')
				)
and optimise_binary_op (op, e1, e2) : expr = 
	match op with
	| Add    -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.add i1 i2)
					| (Real r, Int i)		 -> Real (r +. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i +. r)
					| (Real r1, Real r2) 	 -> Real (r1 +. r2)
					| (String s1, String s2) -> String (s1 ^ s2)
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Sub	 ->	let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.sub i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 -. r2)
					| (Real r, Int i)		 -> Real (r -. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i -. r)
					| _                      -> BinaryOp (Sub, e1', e2')
				)
	| Mul  	 -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.mul i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 *. r2)
					| (Real r, Int i)		 -> Real (r *. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i *. r)
					| _                      -> BinaryOp (Mul, e1', e2')
				)
	| Div 	 -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.div i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 /. r2)
					| (Real r, Int i)		 -> Real (r /. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i /. r)
					| _                      -> BinaryOp (Div, e1', e2')
				)
	| Eq     -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
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
	| Neq	 -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
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
	| Gt  	 -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 > i2)
					| (Real r1, Real r2)	 -> Bool (r1 > r2)
					| (Real r, Int i)		 -> Bool (r > Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i > r)
					| (Char c1, Char c2)	 -> Bool (c1 > c2)
					| (String s1, String s2) -> Bool (s1 > s2) 
					| _                      -> BinaryOp (Gt, e1', e2')
				)
	| Geq 	 -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 >= i2)
					| (Real r1, Real r2)	 -> Bool (r1 >= r2)
					| (Real r, Int i)		 -> Bool (r >= Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i >= r)
					| (Char c1, Char c2)	 -> Bool (c1 >= c2)
					| (String s1, String s2) -> Bool (s1 >= s2) 
					| _                      -> BinaryOp (Geq, e1', e2')
				)
	| Lt     -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 < i2)
					| (Real r1, Real r2)	 -> Bool (r1 < r2)
					| (Real r, Int i)		 -> Bool (r < Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i < r)
					| (Char c1, Char c2)	 -> Bool (c1 < c2)
					| (String s1, String s2) -> Bool (s1 < s2) 
					| _                      -> BinaryOp (Lt, e1', e2')
				)
	| Leq 	 -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Bool (i1 <= i2)
					| (Real r1, Real r2)	 -> Bool (r1 <= r2)
					| (Real r, Int i)		 -> Bool (r <= Int32.to_float i)
					| (Int i, Real r)        -> Bool (Int32.to_float i <= r)
					| (Char c1, Char c2)	 -> Bool (c1 <= c2)
					| (String s1, String s2) -> Bool (s1 <= s2) 
					| _                      -> BinaryOp (Leq, e1', e2')
				)
	| And 	 -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Bool b1, Bool b2)     -> Bool (b1 && b2)
					| _                      -> BinaryOp (And, e1', e2')
				)
	| Or 	 -> let (e1', e2') = (optimise_expr e1, optimise_expr e2) in 
				(match (e1', e2') with
					| (Bool b1, Bool b2)     -> Bool (b1 || b2)
					| _                      -> BinaryOp (Or, e1', e2')
				)
and optimise_expr_list es : expr list = 
	match es with
	| [] -> []
	| (x :: xs) -> optimise_expr x :: optimise_expr_list xs
and optimise_expr expr : expr = 
	match expr with
	| UnaryOp (op, e)       -> optimise_unary_op (op, e)
	| BinaryOp (op, e1, e2) -> optimise_binary_op (op, e1, e2)
	| FunCall (v, es)		-> FunCall (v, optimise_expr_list es)
	| Assign (v, e) 		-> Assign (v, optimise_expr e)
	| x -> x

let optimise_declare_stmnt declare_stmnt : declare_stmnt = 
	match declare_stmnt with
	| Declare (t, v)     	  -> Declare (t, v)
	| DeclareAssign (t, v, e) -> DeclareAssign (t, v, optimise_expr e)

let rec optimise_stmnt stmnt : stmnt = 
	match stmnt with
	| Expr e                   -> Expr (optimise_expr e)
	| Return e                 -> Return (optimise_expr e)
	| Local s                  -> Local (optimise_declare_stmnt s)
	| If_Then_Else (e, b1, b2) ->	let e' = optimise_expr e in
									(match e' with
										| Bool true  -> Block (optimise_block b1)
										| Bool false -> Block (optimise_block b2)
										| _          -> If_Then_Else (e', optimise_block b1, optimise_block b2)
									)
	| While (e, b)             -> 	let e' = optimise_expr e in 
									(match e' with
									| Bool false -> Block []
									| _ 		 -> While (e', optimise_block b))
	| For (e1, e2, e3, b)      -> For (optimise_expr e1, optimise_expr e2, optimise_expr e3, optimise_block b)
	| Block b 				   -> Block (optimise_block b)
and optimise_block block : block = 
	match block with
	| []        -> []
	| (x :: xs) -> optimise_stmnt x :: optimise_block xs

let optimise_top_level top_level : top_level = 
	match top_level with
	| Global s            	 -> Global (optimise_declare_stmnt s)
	| Function (t, v, ps, b) -> Function (t, v, ps, optimise_block b)
	| Main b              	 -> Main (optimise_block b)

let rec optimise program : program = 
	match program with
	| []        -> []
	| (x :: xs) -> optimise_top_level x :: optimise xs