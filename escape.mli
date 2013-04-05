
(*
 * Character and string escaping utilities
 *)

(** OCaml types used to represent wide characters and strings *)
type wchar = int64
type wstring = wchar list

(** escape various constructs in accordance with C lexical rules *)
val escape_char : char -> string
val escape_string : string -> string
val escape_wchar : wchar -> string
val escape_wstring : wstring -> string
