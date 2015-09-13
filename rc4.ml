
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

let stringToAsciiArray keystr =
	Array.init (String.length keystr) (fun k -> int_of_char (keystr.[k]));;

let stringToAsciiList str =
	let len = String.length str in
	let rec doProcess pos =
		if pos = len then
			[]
		else
			(int_of_char (str.[pos])) :: (doProcess (pos+1))
	in
	doProcess 0;;

let asciiListToString alist =
	let nStr = Bytes.create (List.length alist) in
	let rec mkStr pos = function
	| [] -> ()
	| hd::tl ->
		Bytes.set nStr pos (char_of_int hd);
		mkStr (pos+1) tl
	in mkStr 0 alist;
	nStr;;

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
		let nj = (j + perm.(i) + key.(i mod (Array.length key))) mod 256 in
		swap i nj;
		iter (i+1) nj
	in
	iter 0 0;
	perm;;

let encryptData data perm =
	let swap i j =
		let tmp = perm.(i) in
		perm.(i) <- perm.(j);
		perm.(j) <- tmp
	in
	let genByte i j =
		let ni = (i+1) mod 256 in
		let nj = (j + perm.(ni)) mod 256 in
		swap ni nj;
		let xorByte = perm.( (perm.(ni) + perm.(nj)) mod 256) in 
		(xorByte, ni, nj)
	in
	let rec ignoreBytes i j = function
	| 0 -> (i,j)
	| rem ->
		let _,ni,nj = genByte i j in
		ignoreBytes ni nj (rem-1)
	in

	let rec doEncrypt i j out = function
	| [] -> List.rev out
	| hd::tl ->
		let xorByte, ni, nj = genByte i j in
		doEncrypt ni nj ((xorByte lxor hd)::out) tl
	in

	let i, j = ignoreBytes 0 0 1536 in
	(* NOTE ignoring 1536 bytes of the cypherstream due to recommandations.
	1536: see ssh RFC 4345 at http://tools.ietf.org/html/rfc4345 *)
	doEncrypt i j [] data;;

let encrypt key data =
	encryptData data (ksa key);;

let encryptStr key data =
	encrypt (stringToAsciiArray key) (stringToAsciiList data);;
