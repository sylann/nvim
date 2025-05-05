; extends

; "sql ..." -> string content becomes sql
((string_content) @injection.content
    (#match? @injection.content "^sql")
    (#set! injection.language "sql"))

; *_html = "..." -> string content becomes html
; html_* = "..." -> string content becomes html
(assignment
    left: (identifier) @variable
    right: (string ((string_content) @injection.content))
    (#match? @variable "(^html|html$)")
    (#set! injection.language "html"))

; *_css = "..." -> string content becomes css
; css_* = "..." -> string content becomes css
(assignment
    left: (identifier) @variable
    right: (string ((string_content) @injection.content))
    (#match? @variable "(^css|css$)")
    (#set! injection.language "css"))

; *_js = "..." -> string content becomes js
; js_* = "..." -> string content becomes js
(assignment
    left: (identifier) @variable
    right: (string ((string_content) @injection.content))
    (#match? @variable "(^js|js$)")
    (#set! injection.language "js"))
