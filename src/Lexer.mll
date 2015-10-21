{
  open Parser
  exception SyntaxError of string

  let incr_linenum lexbuf = 
	let pos = lexbuf.Lexing.lex_curr_p in
	lexbuf.Lexing.lex_curr_p <- { pos with
		Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
		Lexing.pos_bol = pos.Lexing.pos_cnum;
	}
	;;
}

let assign = '='
let add = '+'
let sub = '-'
let mul = '*'
let div = '/'
let eq = "=="
let neq = "!="
let gt = '>'
let geq = ">="
let lt = '<'
let leq = "<="
let prompt = "<<"
let print = ">>"
let logical_and = "&&"
let logical_or = "||"
let logical_not = '!'

let type_void = "void"
let type_int = "int"
let type_real = "real"
let type_char = "char"
let type_string = "string"
let type_bool = "bool"

let main = "main"
let return = "return"
let var = "var"
let if = "if"
let else = "else"
let while = "while"
let for = "for"

let int = ['0'-'9']['0'-'9']*
let real = ['0'-'9']+'.'['0'-'9']+
let char = "'"_"'"
let string = '"'([^'\"']*)'"'
let true = "true"
let false = "false"

let identifier = ['a'-'z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']*

let comma = ','
let semicolon = ';'
let l_bracket = '('
let r_bracket = ')'
let l_curly_bracket = '{'
let r_curly_bracket = '}'

let space = ' '
let tab = '\t'
let eol = '\r' | '\n' | "\r\n"

rule read = parse
| prompt { PROMPT }

| print { PRINT }

| assign { ASSIGN }
| add { ADD }
| sub { SUB }
| mul { MUL }
| div { DIV }
| eq { EQ }
| neq { NEQ }
| gt { GT }
| geq { GEQ }
| lt { LT }
| leq { LEQ }
| logical_and { AND }
| logical_or { OR }
| logical_not { NOT }

| type_void { TYPEVOID }
| type_int { TYPEINT }
| type_real { TYPEREAL }
| type_char { TYPECHAR }
| type_string { TYPESTRING }
| type_bool { TYPEBOOL }

| main { MAIN }
| return { RETURN }
| if { IF }
| else { ELSE }
| while { WHILE }
| for { FOR }

| int { INT (Int32.of_string (Lexing.lexeme lexbuf)) }
| real { REAL (float_of_string (Lexing.lexeme lexbuf)) }
| char { CHAR (Lexing.lexeme_char lexbuf 1) }
| string { STRING (String.sub (Lexing.lexeme lexbuf) 1 ((String.length (Lexing.lexeme lexbuf)) - 2)) }
| true { BOOL true }
| false { BOOL false }

| identifier { IDENTIFIER (Lexing.lexeme lexbuf) }

| comma { COMMA }
| semicolon { SEMICOLON }
| l_bracket { L_BRACKET }
| r_bracket { R_BRACKET }
| l_curly_bracket { L_CBRACKET }
| r_curly_bracket { R_CBRACKET }

| space { read lexbuf }
| tab { read lexbuf}
| eol { incr_linenum lexbuf; read lexbuf }

| eof { EOF }
| _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf))}
