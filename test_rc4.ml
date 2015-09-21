(***
 * Very slow as it converts a few times the data between different types,
 * but it doesn't matter for testing purposes.
 ***)

let arrayToBitv arr = 
	let out = Bitv.create ((Array.length arr)*8) false in
	for byte = 0 to (Array.length arr)-1 do
		Rc4_bitv.set_byte out byte arr.(byte)
	done;
	out;;

let fileToString file =
	let handle = open_in file in
	let len = in_channel_length handle in
	let out = Bytes.create len in
	let readbytes = input handle out 0 len in
	if (readbytes <> len && readbytes <> 0) then
		raise (Failure (Printf.sprintf "ERROR: couldn't read all of %s." file));
	close_in handle;
	out;;

let writeToFile file str =
	let handle = open_out file in
	output_string handle str;
	close_out handle;;

let testonfile keyfile datafile outfile =
	let key = fileToString keyfile in
	let datahandle = open_in datafile in
	let outhandle = open_out outfile in

	let data = ref [] in
	(try
		while true do
			data := (input_byte datahandle) :: !data
		done
	with End_of_file -> ());
	close_in datahandle;
	data := List.rev (!data);

	let aData = (arrayToBitv (Array.of_list (!data))) in
	let begTime = Sys.time () in
	let out = Rc4_bitv.encrypt aData key in 
	print_string "Ellapsed "; print_float (Sys.time () -. begTime); print_string "s."; print_newline ();
	
	for byteId = 0 to ((Bitv.length out)/8)-1 do
		let byte = Rc4_bitv.get_byte out byteId in
		output_byte outhandle byte
	done;

	close_out outhandle;;

let argv = Sys.argv in
testonfile argv.(1) argv.(2) argv.(3);;

