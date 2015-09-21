
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

val get_byte : Bitv.t -> int -> int
val set_byte : Bitv.t -> int -> int -> unit
val bitv_of_string : string -> Bitv.t

(*
val ksa : string -> int array
val encryptData : Bitv.t -> int array -> Bitv.t
*)

(***
 * Encrypts/decrypts a Bitv.t of data using a given key.
 * encrypt : data -> key -> encrypted_data
 ***)
val encrypt : Bitv.t -> string -> Bitv.t
