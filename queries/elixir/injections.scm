; extends

;; sql
(call
  target: ((identifier) @_identifier (#eq? @_identifier "execute"))
  (arguments
    (string
      (quoted_content) @sql)))

;; heex
((call
   target: (dot
             left: (alias) @_mod (#eq? @_mod "EEx")
             right: (identifier) @_func (#eq? @_func "function_from_string"))
   (arguments
     (string
       (quoted_content) @eex))))

;; graphql
(
 (call
  (identifier) @identifier (#eq? @identifier "query")
  (arguments
    (keywords
      (pair
        key: (keyword) @keyword (#eq? @keyword "query: ")
        value: (string (quoted_content) @injection.content)))))
  (#set! injection.language "graphql")
  (#set! injection.include-children true))


(
 (binary_operator
  left: (identifier) @identifier (#eq? @identifier "gql_query")
  right: (string (quoted_content) @injection.content))
  (#set! injection.language "graphql")
  (#set! injection.include-children true))

; Moduledoc
((identifier) @_identifier (#eq? @_identifier "moduledoc")
 (arguments (string (quoted_content) @injection.content))
 (#set! injection.language "markdown_inline")
 (#set! injection.include-children true))

; sql
((binary_operator
   left: (identifier) @identifier (#eq? @identifier "sql_query")
   right: (string (quoted_content) @injection.content))
  (#set! injection.language "sql")
  (#set! injection.include-children true))
