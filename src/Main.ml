open Lexing
open SyntaxTree
open ErrorHandling
open MenhirLib.General
open ConstantFolding
open ConstantPropagation
module Interpreter = Parser.MenhirInterpreter

(* we manually run the parser by considering each tranisition *)
let rec parse_with_inspecton lexbuf (result : SyntaxTree.program Interpreter.result) : program = 
	match result with
	| Interpreter.InputNeeded env 		-> 	let token = Lexer.read lexbuf in
						   	   				let startp = lexbuf.Lexing.lex_start_p
						   	   				and endp = lexbuf.Lexing.lex_curr_p in
						   	   				let result = Interpreter.offer result (token, startp, endp) in
						   	   				parse_with_inspecton lexbuf result (* request token from lexer whenever the parser needs one, then carry on parsing *)
    | Interpreter.Shifting _	
    | Interpreter.AboutToReduce _ 		-> 	let result = Interpreter.resume result in
    					   	   				parse_with_inspecton lexbuf result (* just carry on parsing *)
	| Interpreter.HandlingError env 	-> 	ErrorHandling.print_parseError env lexbuf; [](* produce meaningful error by inpsecting current state *)
  	| Interpreter.Accepted v 			-> 	v (* return the accepted parse tree *)
  	| Interpreter.Rejected 				-> 	assert false (* why????? you shd be handled by the HandlingError *)

let process lexbuf : program = 
	try parse_with_inspecton lexbuf (Parser.Incremental.program()) with (* Parser.Incremental.program() creates the initial state *)
	| Lexer.SyntaxError msg  -> print_syntaxError lexbuf msg;
						  		exit (-1)

let parse content =
	content
	|> Lexing.from_string
	|> process
	|> ConstantFolding.optimise
	|> ConstantPropagation.optimise
	|> SyntaxTree.string_of_program
	|> print_string;
	print_newline ()

let rec read_to_empty buf =
	let s = read_line () in
		if s = "" then buf
		else (Buffer.add_string buf s; Buffer.add_string buf "\n"; read_to_empty buf)

let _ = 
	read_to_empty (Buffer.create 1)
	|> Buffer.contents
	|> parse;