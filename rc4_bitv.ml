
(*
    This file is part of OCrypto.

    OCrypto is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OCrypto is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with OCrypto.  If not, see <http://www.gnu.org/licenses/>.
*)

let int_of_bool = function
| false -> 0
| true -> 1;;

let get_byte bitv pos =
	let rec mkbyte pos out = function
	| 0 -> out
	| rem -> mkbyte (pos+1)
		((out lsl 1) + (int_of_bool (Bitv.get bitv pos))) (rem-1)
	in mkbyte (8*pos) 0 8;;

let set_byte bitv pos nbyte =
	let byteval = ref nbyte in
	for bpos = (8*pos+7) downto (8*pos) do
		Bitv.set bitv bpos ((!byteval mod 2) = 1);
		byteval := !byteval / 2
	done;;

let bitv_of_string str =
	let bitv = Bitv.create ((String.length str)*8) false in
	for ch=0 to (String.length str)-1 do
		set_byte bitv ch (int_of_char str.[ch])
	done;
	bitv;;
(*
let bitv_to_hex bitv = 
	let str = ref "" in
	for pos=0 to (Bitv.length bitv)/8-1 do
		let digs = (Printf.sprintf "%x" (get_byte bitv pos)) in
		str := (!str) ^ (if String.length digs < 2 then "0" else "")^digs
	done;
	!str;;
*)
let ksa key =
	let perm = Array.init 256 (fun x -> x) in
	let swap i j =
		let tmp = perm.(i) in
		perm.(i) <- perm.(j);
		perm.(j) <- tmp
	in
	let rec iter i j = match i with
	| 256 -> ()
	| i ->
		let nj = (j + perm.(i) + (get_byte key (i mod ((Bitv.length key)/8))))
			mod 256 in
		swap i nj;
		iter (i+1) nj
	in
	iter 0 0;
	perm;;

let encryptData data perm =
	assert ((Bitv.length data) mod 8 = 0);
	let swap i j =
		let tmp = perm.(i) in
		perm.(i) <- perm.(j);
		perm.(j) <- tmp
	in
	let genByte i j =
		let ni = (i+1) mod 256 in
		let nj = (j+perm.(ni)) mod 256 in
		swap ni nj;
		let byte = perm.( (perm.(ni) + perm.(nj)) mod 256 ) in
		(byte, ni, nj)
	in
	let genBytes i j num =
		let out = Bitv.create (num*8) false in
		let rec fillBytes i j pos = function
		| 0 -> (out,i,j)
		| rem ->
			let byte,ni,nj = genByte i j in
			set_byte out pos byte;
			fillBytes ni nj (pos+1) (rem-1)
		in fillBytes i j 0 num
	in

	let _,i,j = genBytes 0 0 1536 in (* Ignore 1536 bytes *)
	let xorbytes,i,j = genBytes i j ((Bitv.length data)/8) in
	Bitv.bw_xor data xorbytes;;

let encrypt data key =
	encryptData data (ksa key);;

