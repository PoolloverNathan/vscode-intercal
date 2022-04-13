@builtin "whitespace.ne"
@builtin "number.ne"

#test -> unsigned_int
main -> statement:*
statement -> _ label:? _ ident _ chance:? _ command _ again:? _
command -> (spot | sub) _ "<-" _ expr
         | tail _ "<-" _ expr ("BY" expr):*
		 
		 | label _ "NEXT"
		 | "FORGET" _ expr
		 | "RESUME" _ expr
		 
		 | "STASH" _ store (_ "+" _ store):*
		 | "RETRIEVE" _ store (_ "+" _ store):*
		 | "IGNORE" _ store (_ "+" _ store):*
		 | "REMEMBER" _ store (_ "+" _ store):*
		 
		 | "ABSTAIN" (_ expr) _ "FROM" _ gerund (_ "+" _ gerund):*
		 | "REINSTATE" _ gerund (_ "+" _ gerund):*
		 | "ABSTAIN" (_ expr) _ "FROM" _ label
		 | "REINSTATE" _ label
		 
		 | "READ" _ "OUT" _ store
		 | "WRITE" _ "IN" _ store
		 
		 | "GIVE" _ "UP"
         | "TRY" _ "AGAIN"
		 | ("COME" | "NEXT") _ "FROM" _ label
		 | ("COME" | "NEXT") _ "FROM" _ expr
		 | ("COME" | "NEXT") _ "FROM" _ gerund
		 
		 
gerund -> "CALCULATING" | "NEXTING" | "FORGETTING" | "RESUMING"
        | "STASHING" | "RETRIEVING" | "IGNORING" | "REMEMBERING"
		| "ABSTAINING" | "REINSTATING"
		| "READING OUT" | "WRITING IN"
		| "COMING FROM" | "NEXTING FROM"

expr -> store | "" unsigned_int
gexpr -> "\"" expr "\"" | "'" expr "'"

ident -> ("MAYBE" _):? ("PLEASE" _ "DO":? {% () => true %} | "DO" {% () => false %}) (_ "NOT" | "N'T"):?
  {% (maybe, polite, abstained) => {
	return {
		choicepoint: maybe,
		polite,
		abstained
	}
  } %}

label -> "(" unsigned_int ")" {% (, num) => Number(num) %}
chance -> "%" unsigned_int {% (, chance) => 100 / Number(chance) %}
store -> spot | tail | sub
spot -> ("." | ":") unsigned_int
tail -> ("," | ";") unsigned_int
sub -> tail _ "SUB" _ expr
again -> "ONCE" | "AGAIN"