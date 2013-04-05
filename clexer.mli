(* This interface is generated manually. The corresponding .ml file is 
 * generated automatically and is placed in ../obj/clexer.ml. The reason we 
 * want this interface is to avoid confusing make with freshly generated 
 * interface files *)


val init: filename:string -> Lexing.lexbuf
val finish: unit -> unit

(* This is the main parser function *)
val initial: Lexing.lexbuf -> Cparser.token


val push_context: unit -> unit (* Start a context  *)
val add_type: string -> unit (* Add a new string as a type name  *)
val add_identifier: string -> unit (* Add a new string as a variable name  *)
val pop_context: unit -> unit (* Remove all names added in this context  *)

val get_white: unit -> string
val get_extra_lexeme: unit -> string
val clear_white: unit -> unit
val clear_lexeme: unit -> unit
val currentLoc : unit -> Cabs.cabsloc

