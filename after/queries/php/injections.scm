; extends

; If a string is preceded by a comment and this comment contains a valid
; language name, the string content gets re parsed as this language.
; Handles cases where the string is nested 1 or 2 levels deep.
;
; Could also force a specific language with:
; ((comment) @comment
;  (#match? @comment " *(sql|SQL) *")
;  (_(string_content) @injection.content
;   (#set! injection.language "sql")))

((comment) @injection.language
 (_(string_content) @injection.content))

((comment) @injection.language
 (_(_(string_content) @injection.content)))
