
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

type blowfishBoxes (* Declared in .ml, holds a blowfish subkey *)

val get_byte : Bitv.t -> int -> int
val set_byte : Bitv.t -> int -> int -> unit

(***
 * encrypts a single 64 bits blocks, splitted into two 32 bit blocks.
 * Puts the result into the given bit vectors, which can be the same to work
 * in-place.
 * Uses boxes created by initBoxes.
 * encryptBlock : boxes -> leftBlock -> rightBlock -> outLeft -> outRight
 ***)
val encryptBlock : blowfishBoxes -> Bitv.t -> Bitv.t -> Bitv.t -> Bitv.t -> unit

(***
 * decrypts a single 64 bits blocks, splitted into two 32 bit blocks.
 * Puts the result into the given bit vectors, which can be the same to work
 * in-place.
 * Uses boxes created by initBoxes.
 * encryptBlock : boxes -> leftBlock -> rightBlock -> outLeft -> outRight
 ***)
val decryptBlock : blowfishBoxes -> Bitv.t -> Bitv.t -> Bitv.t -> Bitv.t -> unit


(***
 * Encrypts a full message using the key <boxes>.
 * encrypt : boxes -> data -> encryptedData
 ***)
val encrypt : blowfishBoxes -> Bitv.t -> Bitv.t

(***
 * Decrypts a full message using the key <boxes>.
 * decrypt : boxes -> encryptedData -> data
 ***)
val decrypt : blowfishBoxes -> Bitv.t -> Bitv.t

(***
 * Initializes the boxes (ie. encryption environment) with the given key
 * (as a bitset).
 * initBoxes : key -> boxes
 ***)
val initBoxes : string -> blowfishBoxes

