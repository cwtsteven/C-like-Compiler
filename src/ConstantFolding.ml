open SyntaxTree

let rec constant_folding_unary_op (op, e) = 
	match op with
	| Neg   ->	let e' = constant_folding_expr e in
				(match e' with
					| Int i  ->	Int (Int32.neg i)
					| Real r -> Real (0.0 -. r)
					| _      ->	UnaryOp (Neg, e')
				)
	| Print -> UnaryOp (Print , constant_folding_expr e)
	| Not   -> 	let e' = constant_folding_expr e in
				(match e' with
					| Bool x -> Bool (not x)
					| _      -> UnaryOp (Not, e')
				)
and constant_folding_binary_op (op, e1, e2) = 
	match op with
	| Assign -> BinaryOp (Assign, constant_folding_expr e1, constant_folding_expr e2)
	| Add    -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.add i1 i2)
					| (Real r, Int i)		 -> Real (r +. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i +. r)
					| (Real r1, Real r2) 	 -> Real (r1 +. r2)
					| (String s1, String s2) -> String (s1 ^ s2)
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Sub	 ->	let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.sub i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 -. r2)
					| (Real r, Int i)		 -> Real (r -. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i -. r)
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Mul  	 -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.mul i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 *. r2)
					| (Real r, Int i)		 -> Real (r *. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i *. r)
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Div 	 -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> Int (Int32.div i1 i2)
					| (Real r1, Real r2)	 -> Real (r1 /. r2)
					| (Real r, Int i)		 -> Real (r /. Int32.to_float i)
					| (Int i, Real r)        -> Real (Int32.to_float i /. r)
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Eq     -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> if i1 = i2 then Bool true else Bool false
					| (Real r1, Real r2)	 -> if r1 = r2 then Bool true else Bool false
					| (Char c1, Char c2)	 -> if c1 = c2 then Bool true else Bool false
					| (String s1, String s2) -> if s1 = s2 then Bool true else Bool false
					| (Bool b1, Bool b2)     -> if b1 = b2 then Bool true else Bool false
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Neq	 -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> if i1 != i2 then Bool true else Bool false
					| (Real r1, Real r2)	 -> if r1 != r2 then Bool true else Bool false
					| (Char c1, Char c2)	 -> if c1 != c2 then Bool true else Bool false
					| (String s1, String s2) -> if s1 != s2 then Bool true else Bool false
					| (Bool b1, Bool b2)     -> if b1 != b2 then Bool true else Bool false
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Gt  	 -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> if i1 > i2 then Bool true else Bool false
					| (Real r1, Real r2)	 -> if r1 > r2 then Bool true else Bool false
					| (Char c1, Char c2)	 -> if c1 > c2 then Bool true else Bool false
					| (String s1, String s2) -> if s1 > s2 then Bool true else Bool false
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Geq 	 -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> if i1 >= i2 then Bool true else Bool false
					| (Real r1, Real r2)	 -> if r1 >= r2 then Bool true else Bool false
					| (Char c1, Char c2)	 -> if c1 >= c2 then Bool true else Bool false
					| (String s1, String s2) -> if s1 >= s2 then Bool true else Bool false
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Lt     -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> if i1 < i2 then Bool true else Bool false
					| (Real r1, Real r2)	 -> if r1 < r2 then Bool true else Bool false
					| (Char c1, Char c2)	 -> if c1 < c2 then Bool true else Bool false
					| (String s1, String s2) -> if s1 < s2 then Bool true else Bool false
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Leq 	 -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Int i1, Int i2)       -> if i1 <= i2 then Bool true else Bool false
					| (Real r1, Real r2)	 -> if r1 <= r2 then Bool true else Bool false
					| (Char c1, Char c2)	 -> if c1 <= c2 then Bool true else Bool false
					| (String s1, String s2) -> if s1 <= s2 then Bool true else Bool false
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| And 	 -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Bool b1, Bool b2)     -> if b1 && b2 then Bool true else Bool false
					| _                      -> BinaryOp (Add, e1', e2')
				)
	| Or 	 -> let (e1', e2') = (constant_folding_expr e1, constant_folding_expr e2) in 
				(match (e1', e2') with
					| (Bool b1, Bool b2)     -> if b1 || b2 then Bool true else Bool false
					| _                      -> BinaryOp (Add, e1', e2')
				)
and constant_folding_expr_list es = 
	match es with
	| [] -> []
	| (x :: xs) -> constant_folding_expr x :: constant_folding_expr_list xs
and constant_folding_expr expr = 
	match expr with
	| UnaryOp (op, e)       -> constant_folding_unary_op (op, e)
	| BinaryOp (op, e1, e2) -> constant_folding_binary_op (op, e1, e2)
	| FunCall (v, es)		-> FunCall (v, constant_folding_expr_list es)
	| x -> x

let constant_folding_declare_stmnt declare_stmnt = 
	match declare_stmnt with
	| Declare v      	   -> Declare v
	| DeclareAssign (v, e) -> DeclareAssign (v, constant_folding_expr e)

let rec constant_folding_stmnt stmnt = 
	match stmnt with
	| Expr e                   -> Expr (constant_folding_expr e)
	| Return e                 -> Return (constant_folding_expr e)
	| If_Then_Else (e, b1, b2) ->	let e' = constant_folding_expr e in
									(match e' with
										| Bool true  -> If_Then_Else (Bool true, constant_folding_block b1, [])
										| Bool false -> If_Then_Else (Bool false, [], constant_folding_block b2)
										| _          -> If_Then_Else (e', constant_folding_block b1, constant_folding_block b2)
									)
	| While (e, b)             -> While (constant_folding_expr e, constant_folding_block b)
	| For (e1, e2, e3, b)      -> For (constant_folding_expr e1, constant_folding_expr e2, constant_folding_expr e3, constant_folding_block b)
	| Local s                  -> Local (constant_folding_declare_stmnt s)
and constant_folding_block block = 
	match block with
	| []        -> []
	| (x :: xs) -> constant_folding_stmnt x :: constant_folding_block xs

let constant_folding_declare declare = 
	match declare with
	| Global s            -> Global (constant_folding_declare_stmnt s)
	| Function (v, ps, b) -> Function (v, ps, constant_folding_block b)
	| Main b              -> Main (constant_folding_block b)

let rec constant_folding program = 
	match program with
	| []        -> []
	| (x :: xs) -> constant_folding_declare x :: constant_folding xs