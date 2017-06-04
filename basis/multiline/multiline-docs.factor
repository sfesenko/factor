USING: help.markup help.syntax strings ;
IN: multiline

HELP: STRING:
{ $syntax "STRING: name\nfoo\n;" }
{ $description "Forms a multiline string literal, or 'here document' stored in the word called name. A semicolon is used to signify the end, and that semicolon must be on a line by itself, not preceeded or followed by any whitespace. The string will have newlines in between lines but not at the end, unless there is a blank line before the semicolon." } ;

HELP: /*
{ $syntax "/* comment */" }
{ $description "Provides C-like comments that can span multiple lines. One caveat is that " { $snippet "/*" } " and " { $snippet "*/" } " are still tokens and must not appear in the comment text itself." }
{ $examples
    { $example "USING: multiline ;"
           "/* I think that I shall never see"
           "   A poem lovely as a tree. */"
            ""
    }
} ;

HELP: heredoc:
{ $syntax "heredoc: marker\n...text...\nmarker" }
{ $values { "marker" "a word (token)" } { "text" "arbitrary text" } { "value" string } }
{ $description "Returns a string delimited by an arbitrary user-defined token. This delimiter must be exactly the text beginning at the first non-blank character after " { $link postpone: heredoc: } " until the end of the line containing " { $link postpone: heredoc: } ". Text is captured until a line is found containing exactly this delimiter string." }
{ $warning "Whitespace is significant." }
{ $examples
    { $example "USING: multiline prettyprint ;"
               "heredoc: END\nx\nEND\n."
               "\"x\\n\""
    }
    { $example "USING: multiline prettyprint sequences ;"
               "2 5 heredoc: zap\nfoo\nbar\nzap\nsubseq ."
               "\"o\\nb\""
    }
} ;

HELP: parse-multiline-string
{ $values { "end-text" "a string delineating the end" } { "str" "the parsed string" } }
{ $description "Parses the input stream until the " { $snippet "end-text" } " is reached and returns the parsed text as a string." }
{ $notes "Used to implement " { $link postpone: /* } "." } ;

ARTICLE: "multiline" "Multiline"
"Multiline strings:"
{ $subsections
    postpone: STRING:
    postpone: heredoc:
}
"Multiline comments:"
{ $subsections postpone: /* }
"Writing new multiline parsing words:"
{ $subsections parse-multiline-string }
;

ABOUT: "multiline"
