%{
	open SyntaxTree
%}

%token <int32> INT
%token <float> REAL
%token <char> CHAR
%token <string> STRING
%token <bool> BOOL

%token <string> IDENTIFIER
%token VAR
%token ASSIGN
%token AND OR NOT
%token ADD SUB MUL DIV
%token EQ NEQ GT GEQ LT LEQ
%token PROMPT PRINT
%token IF ELSE
%token WHILE
%token FOR
%token MAIN RETURN

%token COMMA
%token SEMICOLON
%token L_BRACKET R_BRACKET
%token L_CBRACKET R_CBRACKET

%token EOF

%nonassoc PRINT
%nonassoc ASSIGN
%left AND OR NOT
%left EQ NEQ GT GEQ LT LEQ 
%left ADD SUB
%left MUL DIV

%type <SyntaxTree.expr> data
%type <SyntaxTree.nullary_op> nullary_op
%type <SyntaxTree.unary_op> unary_op
%type <SyntaxTree.binary_op> binary_op
%type <SyntaxTree.expr> expr
%type <SyntaxTree.declare> declare
%type <SyntaxTree.stmnt> stmnt if_stmnt while_stmnt for_stmnt
%type <SyntaxTree.block> block
%start <SyntaxTree.program> program
%%
program:
| ls = list(declare); EOF				{ ls } 
;

declare:
| d = declare_var_stmnt					{ Global d }
| v = IDENTIFIER; ps = param; b = block	{ Function (v, ps, b) }
| MAIN; L_BRACKET; R_BRACKET; b = block { Main b }
;

param:
| L_BRACKET; 
	ps = separated_list(COMMA, IDENTIFIER); 
	R_BRACKET 							{ ps }
;

block:
| L_CBRACKET; 
	stmnts = list(stmnt); 
	R_CBRACKET							{ stmnts }
;

stmnt:
| e = expr; SEMICOLON					{ Expr e }
| RETURN; e = expr; SEMICOLON			{ Return e }
| d = declare_var_stmnt 				{ Local d }
| ifs = if_stmnt						{ ifs }
| whs = while_stmnt						{ whs }
| fos = for_stmnt						{ fos }
;

declare_var_stmnt:
| VAR; v = IDENTIFIER; SEMICOLON		{ Declare v }
| VAR; v = IDENTIFIER; 
	ASSIGN; e = expr; SEMICOLON			{ DeclareAssign (v, e) }
;

if_stmnt: 
| IF; L_BRACKET; e = expr; R_BRACKET; 	
	b = block  							{ If_Then_Else (e, b, []) }
| IF; L_BRACKET; e = expr; R_BRACKET; 
	b1 = block; 
	ELSE; b2 = block 					{ If_Then_Else (e, b1, b2) }
;

while_stmnt:
| WHILE; L_BRACKET; e = expr; R_BRACKET; 
	b = block; 							{ While (e, b) }
;

for_stmnt:
| FOR; L_BRACKET; e1 = expr; SEMICOLON; 
	e2 = expr; SEMICOLON; 
	e3 = expr; R_BRACKET;
	b = block							{ For (e1, e2, e3, b) }
;

expr:
| d = data								{ d }
| op = nullary_op						{ NullaryOp op}
| op = unary_op; e = expr 				{ UnaryOp (op, e) }
| e1 = expr; op = binary_op; e2 = expr 	{ BinaryOp (op, e1, e2) }
| L_BRACKET; e = expr; R_BRACKET		{ e }
| v = IDENTIFIER; ps = fun_call_param;	{ FunCall (v, ps) }
;

fun_call_param:
| L_BRACKET; 
	exprs = separated_list(COMMA, expr); 
	R_BRACKET							{ exprs }
;

data:
| v = IDENTIFIER						{ Var v }
| i = INT 								{ Int i }
| r = REAL								{ Real r }
| c = CHAR 								{ Char c }
| s = STRING 							{ String s }
| b = BOOL								{ Bool b }
;

%inline nullary_op:
| PROMPT		{ Prompt }
;

%inline unary_op:
| SUB			{ Neg }
| PRINT         { Print }
| NOT 			{ Not }
;

%inline binary_op:
| ASSIGN		{ Assign }
| ADD			{ Add }
| SUB			{ Sub }
| MUL			{ Mul }
| DIV			{ Div }
| NEQ			{ Neq }
| EQ 			{ Eq }
| GT			{ Gt }
| GEQ			{ Geq }
| LT			{ Lt }
| LEQ			{ Leq }
| AND			{ And }
| OR			{ Or }
;
