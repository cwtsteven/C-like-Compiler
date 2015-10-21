let read_file filename buf = 
	let file = open_in filename in
	try
		while true do
			buf := !buf ^ input_line file
		done
	with
	| End_of_file -> close_in file