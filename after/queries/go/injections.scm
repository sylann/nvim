; FROM https://github.com/ray-x/go.nvim/blob/master/after/queries/go/injections.scm

; inject sql in single line strings
; e.g. db.GetContext(ctx, "SELECT * FROM users WHERE name = 'John'")

((call_expression
  (selector_expression
   field: (field_identifier) @_field)
  (argument_list
   (interpreted_string_literal) @sql))
 (#any-of? @_field "Exec" "GetContext" "ExecContext" "SelectContext" "In"
                   "RebindNamed" "Rebind" "Query" "QueryRow" "QueryRowxContext"
                   "NamedExec" "MustExec" "Get" "Queryx"
                   )
 (#offset! @sql 0 1 0 -1))

; still buggy for nvim 0.10
((call_expression
  (selector_expression
   field: (field_identifier) @_field (#any-of? @_field "Exec" "GetContext" "ExecContext"
                                      "SelectContext" "In" "RebindNamed" "Rebind" "Query"
                                      "QueryRow" "QueryRowxContext" "NamedExec" "MustExec"
                                      "Get" "Queryx"
                                      ))
  (argument_list
   (interpreted_string_literal) @injection.content))
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.language "sql"))

; fallback keyword and comment based injection

([
  (interpreted_string_literal)
  (raw_string_literal)
 ] @sql
 (#contains? @sql "-- sql" "--sql" "ADD CONSTRAINT" "ALTER TABLE" "ALTER COLUMN"
                  "DATABASE" "FOREIGN KEY" "GROUP BY" "HAVING" "CREATE INDEX" "INSERT INTO"
                  "NOT NULL" "PRIMARY KEY" "UPDATE SET" "TRUNCATE TABLE" "LEFT JOIN" "add constraint" "alter table" "alter column" "database" "foreign key" "group by" "having" "create index" "insert into"
                  "not null" "primary key" "update set" "truncate table" "left join")
 (#offset! @sql 0 1 0 -1))

; nvim 0.10
([
  (interpreted_string_literal)
  (raw_string_literal)
 ] @injection.content
 (#contains? @injection.content "-- sql" "--sql" "ADD CONSTRAINT" "ALTER TABLE" "ALTER COLUMN"
                  "DATABASE" "FOREIGN KEY" "GROUP BY" "HAVING" "CREATE INDEX" "INSERT INTO"
                  "NOT NULL" "PRIMARY KEY" "UPDATE SET" "TRUNCATE TABLE" "LEFT JOIN" "add constraint" "alter table" "alter column" "database" "foreign key" "group by" "having" "create index" "insert into"
                  "not null" "primary key" "update set" "truncate table" "left join")
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.language "sql"))


; Inject the SQL language in strings that are the assignment
; value for a variable which name contains "sql"
(short_var_declaration
    left: (expression_list
            (identifier) @_id (#match? @_id "sql"))
    right: (expression_list
             (raw_string_literal) @sql (#offset! @sql 0 1 0 -1)))
