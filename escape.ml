
(** OCaml types used to represent wide characters and strings *)
type wchar = int64
type wstring = wchar list


let escape_char = function
  | '\007' -> "\\a"
  | '\b' -> "\\b"
  | '\t' -> "\\t"
  | '\n' -> "\\n"
  | '\011' -> "\\v"
  | '\012' -> "\\f"
  | '\r' -> "\\r"
  | '"' -> "\\\""
  | '\'' -> "\\'"
  | '\\' -> "\\\\"
  | ' ' .. '~' as printable -> String.make 1 printable
  | unprintable -> Printf.sprintf "\\%03o" (Char.code unprintable)

let escape_string str =
  let length = String.length str in
  let buffer = Buffer.create length in
  for index = 0 to length - 1 do
    Buffer.add_string buffer (escape_char (String.get str index))
  done;
  Buffer.contents buffer

(* a wide char represented as an int64 *)
let escape_wchar =
  (* limit checks whether upper > probe *)
  let limit upper probe = (Int64.to_float (Int64.sub upper probe)) > 0.5 in
  let fits_byte = limit (Int64.of_int 0x100) in
  let fits_octal_escape = limit (Int64.of_int 0o1000) in
  let fits_universal_4 = limit (Int64.of_int 0x10000) in
  let fits_universal_8 = limit (Int64.of_string "0x100000000") in
  fun charcode ->
    if fits_byte charcode then
      escape_char (Char.chr (Int64.to_int charcode))
    else if fits_octal_escape charcode then
      Printf.sprintf "\\%03Lo" charcode
    else if fits_universal_4 charcode then
      Printf.sprintf "\\u%04Lx" charcode
    else if fits_universal_8 charcode then
      Printf.sprintf "\\u%04Lx" charcode
    else
      invalid_arg "Cprint.escape_string_intlist"

(* a wide string represented as a list of int64s *)
let escape_wstring (str : int64 list) =
  let length = List.length str in
  let buffer = Buffer.create length in
  let append charcode =
    let addition = escape_wchar charcode in
    Buffer.add_string buffer addition
  in
  List.iter append str;
  Buffer.contents buffer
