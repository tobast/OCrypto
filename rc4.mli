
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

val stringToAsciiArray : string -> int array
val stringToAsciiList : string -> int list
val asciiListToString : int list -> string
val ksa : int array -> int array
val encryptData : int list -> int array -> int list
val encrypt : int array -> int list -> int list
val encryptStr : string -> string -> int list
