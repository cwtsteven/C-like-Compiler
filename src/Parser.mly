%{
	open SyntaxTree
%}

%token <int32> INT
%token <float> REAL
%token <char> CHAR
%token <string> STRING
%token <bool> BOOL

%token TYPEVOID TYPEINT TYPEREAL TYPECHAR TYPESTRING TYPEBOOL

%token <string> IDENTIFIER
%token ASSIGN
%token AND OR NOT
%token ADD SUB MUL DIV
%token EQ NEQ GT GEQ LT LEQ
%token PROMPT PRINT
%token IF ELSE
%token WHILE
%token FOR
%token BREAK CONTINUE
%token MAIN RETURN

%token COMMA
%token COLON SEMICOLON
%token L_BRACKET R_BRACKET
%token L_CBRACKET R_CBRACKET

%token EOF

%nonassoc PRINT
%right ASSIGN
%left AND OR NOT
%left EQ NEQ GT GEQ LT LEQ 
%left ADD SUB
%left MUL DIV

%type <SyntaxTree.type_> type_
%start <SyntaxTree.program> program
%%
program:
| ls = list(top_level); EOF				{ ls } 
;

top_level:
| d = declare_stmnt									{ Global d }
| t = type_; v = IDENTIFIER; ps = params; b = block	{ Function (t, v, ps, b) }
| MAIN; L_BRACKET; R_BRACKET; b = block 			{ Main b }
;

params:
| L_BRACKET; 
	ps = param
	R_BRACKET 							{ ps }
;

param:
| t = type_; v = IDENTIFIER; COMMA; ps = param	{ (t, v) :: ps }
| t = type_; v = IDENTIFIER						{ (t, v) :: [] } 
| 												{ [] }
;

block:
| L_CBRACKET; 
	stmnts = list(stmnt); 
	R_CBRACKET							{ stmnts }
;

stmnt:
| e = expr; SEMICOLON					{ Expr e }
| RETURN; e = expr; SEMICOLON			{ Return e }
| d = declare_stmnt		 				{ Local d }
| ifs = if_stmnt						{ ifs }
| whs = while_stmnt						{ whs }
| fos = for_stmnt						{ fos }
| v = IDENTIFIER; COLON 				{ Label v }
| BREAK; SEMICOLON						{ Break }
| CONTINUE; SEMICOLON					{ Continue ""}
| CONTINUE; v = IDENTIFIER SEMICOLON	{ Continue v }
;

declare_stmnt:
| t = type_; v = IDENTIFIER; SEMICOLON	{ Declare (t, v) }
| t = type_; v = IDENTIFIER; 
	ASSIGN; e = expr; SEMICOLON			{ DeclareAssign (t, v, e) }
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
| FOR; L_BRACKET; TYPEINT; v = IDENTIFIER; ASSIGN; e = expr; SEMICOLON; 
	e2 = expr; SEMICOLON; 
	e3 = expr; R_BRACKET;
	b = block							{ For (DeclareAssign (Int, v, e), e2, e3, b) }
;

expr:
| d = data								{ d }
| op = nullary_op						{ NullaryOp op}
| op = unary_op; e = expr 				{ UnaryOp (op, e) }
| e1 = expr; op = binary_op; e2 = expr 	{ BinaryOp (op, e1, e2) }
| v = IDENTIFIER; ASSIGN; e = expr		{ Assign (v, e) }
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

type_:
| TYPEVOID		{ Void }
| TYPEINT 		{ Int }
| TYPEREAL 		{ Real }
| TYPECHAR		{ Char }
| TYPESTRING 	{ String }
| TYPEBOOL 		{ Bool }
