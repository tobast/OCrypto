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

let bitv_to_string bitv =
	Bytes.init ((Bitv.length bitv)/8)
		(fun k -> char_of_int (Blowfish.get_byte bitv k));;
let bitv_of_string str =
(*	Bitv.init ((Bytes.length str)*8)
		(fun k -> ((int_of_char str.[k/8]) land (1 lsl (k mod 8))) <> 0);; *)
	let out = Bitv.create ((Bytes.length str)*8) false in
	for k=0 to (Bytes.length str)-1 do
		Blowfish.set_byte out k (int_of_char (str.[k]))
	done;
	out;;

let key = fileToString (Sys.argv.(2))
and data = bitv_of_string (fileToString (Sys.argv.(1))) in

let boxes = Blowfish.initBoxes key in
let outBitv = Blowfish.encrypt boxes data in

writeToFile (Sys.argv.(3)) (bitv_to_string outBitv);

let decrypt = Blowfish.decrypt boxes outBitv in
if (decrypt <> data) then
	raise Exit


