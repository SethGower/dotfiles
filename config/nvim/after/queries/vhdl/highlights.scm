; 3.2 Entity declaration {{{
(type_mark) @type
(comment) @comment @spell
(mode) @type.qualifier

(wait_statement) @keyword.coroutine

[ "assert" "report" "severity" ] @debug
(severity_expression
    (simple_name) @constant.builtin (#any-of? @constant.builtin
        "note" "warning" "error" "failure"))

[
    "alias"
    "package"
    "entity"
    "architecture"
    "type"
    "to"
    "downto"
    "signal"
    "variable"
    "record"
    "array"
    "others"
    "process"
    "component"
    "constant"
    "port"
    "generic"
    "generate"
    "function"
    "return"
    "range"
    "map"
] @keyword

(named_association_element
    actual_part: (open) @variable.builtin)

[ "pure" "impure" ] @type.qualifier

[ "is" "begin" "end" ] @keyword.special

[ "of" "in" ] @keyword.operator

[ "for" "loop" "while" ] @repeat

[ "if" "elsif" "else" "case" "then" "when" ] @conditional

(function_body
    designator: (identifier) @function)
(function_body
    at_end: (simple_name) @function)

(procedure_call_statement
    procedure: (simple_name) @function)

[ "library" "use" ] @include

[ "(" ")" "[" "]" ] @punctuation.bracket

[ "." ";" "," ":" ] @punctuation.delimeter

[
    "=>" "<=" "+" ":=" "=" "/=" "<" ">" "-" "*" "/"
    "not" "xor" "and" "nand" "or" "nor"
    (attribute_name "'")
    (index_subtype_definition (any))
] @operator

[
    ((character_literal))
    (integer_decimal)
    (real_decimal)
] @number

(string_literal) @string
(bit_string_literal) @string

(assertion_statement
    (string_expression
        (string_literal) @string @spell))
(report_statement
    (string_expression
        (string_literal) @string @spell))

(physical_literal
    unit: (simple_name) @attribute)

(generic_map_aspect
    (association_list
        (named_association_element
            formal_part: (simple_name) @parameter)))

(port_map_aspect
    (association_list
        (named_association_element
            formal_part: (simple_name) @property)))

(sensitivity_list (_) @variable)

(default_expression (simple_name) @variable)

; TODO: this capture also captures indexing signals as if they're functions.
; Don't know if there's anyway around that, might just need to either have
; function calls highlighted as variables or vice versa
(expression
    (ambiguous_name
        prefix: ((simple_name) @variable)
        (expression_list)))

(conditional_expression
    (simple_name) @variable)

(conditional_expression
    (parenthesized_expression
        (simple_name) @variable))

(relation
    (simple_name) @variable)
(attribute_name
    prefix: (_) @variable
    designator: (_) @field)

; ascending and descending specs. TODO see if these can be merged into one
; query these two are for when there is an expression with multiple arguments,
; such as (a - b - 1 downto 0)
(_
    low: (simple_expression (simple_expression (simple_name) @constant)))
(_
    high: (simple_expression (simple_expression (simple_name) @constant))
)
; ascending and descending specs. TODO see if these can be merged into one
; query these two are for when there is an expression with a single argument
; such as (a downto 0)
(_
    low: ((simple_expression (simple_name) @constant)))
(_
    high: ((simple_expression (simple_name) @constant))
)

(expression
    (simple_expression (simple_name) @variable))

(package_declaration
    name: (identifier) @namespace)
(package_declaration
    at_end: (simple_name) @namespace)

(entity_declaration
    name: (identifier) @namespace
    at_end: (simple_name) @namespace)

(component_declaration
    name: (identifier) @variable
    at_end: (simple_name) @variable)

(full_type_declaration
    name: (identifier) @type.definition)

(record_type_definition
    at_end: (simple_name) @type)

(architecture_body
    name: (identifier) @method
    entity: (simple_name) @namespace
    at_end: (simple_name) @method)

(component_instantiation
    component: (simple_name) @variable)

(label (identifier) @label)

(process_statement
    at_end: (simple_name) @label)

(for_generate_statement
    at_end: (simple_name) @label)

(if_generate_statement
    at_end: (simple_name) @label)

(entity_instantiation
    entity: (selected_name
        prefix: (simple_name) @namespace
        suffix: (simple_name) @namespace))

(library_clause
    (logical_name_list
        library: (simple_name) @namespace))
(use_clause
    (selected_name
        prefix: (selected_name
            prefix: (simple_name) @namespace)
        suffix: (_) @function
))
(use_clause
    (selected_name
        prefix: (simple_name) @namespace
))

(constant_declaration
    (identifier_list
        (identifier) @constant))

(signal_interface_declaration
    (identifier_list
        (identifier) @variable))

(signal_declaration
    (identifier_list
        (identifier) @variable))

(entity_header
    (port_clause
        (signal_interface_declaration
            (identifier_list
                (identifier) @field))))

(component_instantiation_statement
    (label
        (identifier) @label))

(record_type_definition
    (_
    (identifier_list
        (identifier) @field)))

(simple_waveform_assignment
    target: (_) @variable)

(constant_interface_declaration
    (identifier_list
        (identifier) @constant))

(generic_clause
    (constant_interface_declaration
        (identifier_list
            (identifier) @parameter)))

(simple_concurrent_signal_assignment
    target: (simple_name) @variable)

(ambiguous_name
    prefix: (simple_name) @variable)

(ambiguous_name
    prefix: (simple_name) @function.builtin (#match? @function.builtin
        "^\(\(rising\|falling\)_edge\)$"))

(ambiguous_name
    prefix: (simple_name) @type (#match? @type
        "^\(std_logic\(_vector\)\?\|real\|\(to_\)\?\(\(\(un\)\?signed\)\|integer\)\)$"))

; math_real
(ambiguous_name
    prefix: (simple_name) @function.builtin (#any-of? @function.builtin
        "sign" "ceil" "floor" "round" "fmax" "fmin" "uniform" "srand" "rand"
        "get_rand_max" "sqrt" "cbrt" "exp" "log" "log2" "sin" "cos" "tan" "asin"
        "acos" "atan" "atan2" "sinh" "cosh" "tanh" "asinh" "acosh" "atanh"))

(procedure_call_statement
    procedure: (simple_name) @function.builtin (#any-of? @function.builtin
        "sign" "ceil" "floor" "round" "fmax" "fmin" "uniform" "srand" "rand"
        "get_rand_max" "sqrt" "cbrt" "exp" "log" "log2" "sin" "cos" "tan" "asin"
        "acos" "atan" "atan2" "sinh" "cosh" "tanh" "asinh" "acosh" "atanh"))

(expression (simple_name) @variable)

(expression
    (simple_name) @variable.builtin (#match? @variable.builtin
       "^\(true\|false\)$"))

((simple_name) @variable.builtin (#eq? @variable.builtin "now"))

(parameter_specification
    name: (identifier) @variable)

;; error highlighting
(ERROR) @error

(entity_header [
    (generic_map_aspect) @error.illegal.map_aspect.generic
    (port_map_aspect)    @error.illegal.map_aspect.port
  ])

(entity_header
  (port_clause)
  (generic_clause) @error.order.generic_after_port)

(entity_header
  (port_clause)
  (port_clause) @error.repeated.clause.port)

(entity_header
  (generic_clause)
  (generic_clause) @error.repeated.clause.generic)

(entity_header [
    (generic_clause ")" @error.missing.semicolon.after_clause .)
    (port_clause    ")" @error.missing.semicolon.after_clause .)
  ])

(entity_declaration
  (declarative_part [
    (variable_declaration)
    (component_declaration)
    (configuration_specification)
  ] @error.illegal.declaration))

(entity_declaration
  (concurrent_statement_part [
    (block_statement)
    (component_instantiation_statement)
    (simple_concurrent_signal_assignment)
    (conditional_concurrent_signal_assignment)
    (selected_concurrent_signal_assignment)
    (for_generate_statement)
    (if_generate_statement)
    (case_generate_statement)
    (PSL_Property_Declaration)
    (PSL_Sequence_Declaration)
    (PSL_Clock_Declaration)
  ] @error.illegal.statement))

;; tree-sitter-cli
;; NOTE: Only simple cases
(entity_declaration
  (concurrent_statement_part
    (process_statement
      (sequence_of_statements [
        (simple_waveform_assignment)
        (simple_force_assignment)
        (simple_release_assignment)
      ] @error.illegal.assignment.in_passive_process))
  ))

;; nvim-tree-sitter
((simple_waveform_assignment)
 (#has-ancestor?
    @error.illegal.assignment.in_passive_process
    entity_declaration))

;; nvim-tree-sitter
((simple_force_assignment)
 (#has-ancestor?
    @error.illegal.assignment.in_passive_process
    entity_declaration))

;; nvim-tree-sitter
((simple_release_assignment)
 (#has-ancestor?
    @error.illegal.assignment.in_passive_process
    entity_declaration))

((entity_declaration
   name: (_) @_h
 at_end: (_) @error.misspeling.name @_t)
         (#not-eq? @_h @_t))
; }}}
; 3.3 Architecture bodies {{{
(architecture_body
  (declarative_part
    (variable_declaration) @error.illegal.declaration))

((architecture_body
   name: (_) @_h
 at_end: (_) @error.misspeling.name @_t)
         (#not-eq? @_h @_t))
; }}}
; 4.2 Subprogram declaration {{{
(procedure_declaration
  ["pure" "impure"] @error.unexpected.purity)

(procedure_declaration
  designator: (operator_symbol) @error.illegal.designator.operator_symbol)

(procedure_declaration
  (return) @error.unexpected.return)

;;
(function_declaration
  designator: (_) . (function_parameter_clause)? . ";" @error.missing.return)

;;
(subprogram_header [
    (port_clause)     @error.illegal.clause.port
    (port_map_aspect) @error.illegal.map_aspect.port
  ])

(subprogram_header
  (generic_clause)
  (generic_clause) @error.repeated.clause.generic)

(subprogram_header
  (generic_map_aspect)
  (generic_map_aspect) @error.repeated.map_aspect.generic)

; FIXME
; Negation rule not supported yet (tree-sitter version v0.19.4)
;(subprogram_header
; . !(generic_clause)*
; .  (generic_map_aspect  ["generic" "map"] @error.missing.clause.generic)
; . !(generic_clause)*)

; WORKARROUND
; Only single common case
(subprogram_header
. (generic_map_aspect) @error.missing.clause.generic
. )

(subprogram_header
  (generic_map_aspect)
  (generic_clause) @error.order.clause_after_map_aspect)

(subprogram_header [
    (generic_clause     (semicolon) @error.unexpected.semicolon.after_clause     .)
    (generic_map_aspect (semicolon) @error.unexpected.semicolon.after_map_aspect .)
  ])
; }}}
; 4.2 Subprogram bodies {{{
(procedure_body
  ["pure" "impure"] @error.unexpected.purity)

(procedure_body
  designator: (operator_symbol) @error.illegal.designator.operator_symbol)

(procedure_body
  at_end: (operator_symbol) @error.illegal.designator.operator_symbol)

(procedure_body
  (return) @error.unexpected.return)

(procedure_body
  (declarative_part [
    (incomplete_type_declaration)
    (signal_declaration)
    (component_declaration)
    (configuration_specification)
    (disconnection_specification)
    (PSL_Assert_Directive)
    (PSL_Assume_Directive)
    (PSL_Assume_Guarantee_Directive)
    (PSL_Restrict_Directive)
    (PSL_Restrict_Guarantee_Directive)
    (PSL_Cover_Directive)
    (PSL_Fairness_Directive)
    (PSL_Strong_Fairness_Directive)
    (PSL_Property_Declaration)
    (PSL_Sequence_Declaration)
    (PSL_Clock_Declaration)
  ] @error.illegal.declaration))

(procedure_body
  (declarative_part
    (shared_variable_declaration "shared" @error.unexpected.shared)))

(procedure_body
          "procedure"
  at_end: "function"  @error.misspeling.subprogram_kind)

((procedure_body
 designator: (_) @_h
     at_end: (_) @error.misspeling.designator @_t)
             (#not-eq? @_h @_t))
;;
(function_body
  designator: (_) . (function_parameter_clause)? . "is" @error.missing.return)

(function_body
  at_end: ["pure" "impure"] @error.unexpected.purity.at_end)

(function_body
  (declarative_part [
    (signal_declaration)
    (component_declaration)
    (configuration_specification)
    (disconnection_specification)
    (PSL_Assert_Directive)
    (PSL_Assume_Directive)
    (PSL_Assume_Guarantee_Directive)
    (PSL_Restrict_Directive)
    (PSL_Restrict_Guarantee_Directive)
    (PSL_Cover_Directive)
    (PSL_Fairness_Directive)
    (PSL_Strong_Fairness_Directive)
    (PSL_Property_Declaration)
    (PSL_Sequence_Declaration)
    (PSL_Clock_Declaration)
  ] @error.illegal.declaration))

(function_body
  (declarative_part
    (shared_variable_declaration "shared" @error.unexpected.shared)))

(function_body
          "function"
  at_end: "procedure" @error.misspeling.subprogram_kind)

((function_body
 designator: (_) @_h
     at_end: (_) @error.misspeling.designator @_t)
             (#not-eq? @_h @_t))
; }}}
; 4.3 Subprogram instantiation {{{
(procedure_instantiation_declaration
  ["pure" "impure"] @error.unexpected.purity)

(procedure_instantiation_declaration
  designator: (operator_symbol) @error.illegal.designator.operator_symbol)

(procedure_instantiation_declaration
  (signature (return) @error.unexpected.return))

;;
(function_instantiation_declaration
  (signature (type_mark) ("," (type_mark))* . "]" @error.missing.return))

;;
(subprogram_map_aspect [
    (generic_clause)  @error.illegal.clause.generic
    (port_clause)     @error.illegal.clause.port
    (port_map_aspect) @error.illegal.map_aspect.port
  ])

(subprogram_map_aspect
  (generic_map_aspect)
  (generic_map_aspect) @error.repeated.map_aspect.generic)

(subprogram_map_aspect
  (generic_map_aspect (semicolon) @error.unexpected.semicolon.after_map_aspect .))
; }}}
; 4.2.2.1 Formal parameter list {{{
(procedure_parameter_clause [
    (signal_interface_declaration    (mode ["buffer" "linkage"]) @error.illegal.mode)
    (variable_interface_declaration  (mode ["buffer" "linkage"]) @error.illegal.mode)
    (signal_interface_declaration  (default_expression) @error.illegal.default_expression)
    (type_interface_declaration)      @error.illegal.interface.type
    (procedure_interface_declaration) @error.illegal.interface.procedure
    (function_interface_declaration)  @error.illegal.interface.function
    (package_interface_declaration)   @error.illegal.interface.package
  ])

(function_parameter_clause [
    (signal_interface_declaration    (mode ["out" "inout" "buffer" "linkage"]) @error.illegal.mode)
    (signal_interface_declaration  (default_expression) @error.illegal.default_expression)
    (variable_interface_declaration)  @error.illegal.interface.variable
    (file_interface_declaration)      @error.illegal.interface.file
    (type_interface_declaration)      @error.illegal.interface.type
    (procedure_interface_declaration) @error.illegal.interface.procedure
    (function_interface_declaration)  @error.illegal.interface.function
    (package_interface_declaration)   @error.illegal.interface.package
  ])
; }}}
; 4.5 Subprogram overloading {{{
((operator_symbol) @error.illegal.operator_symbol
  (#not-match? @error.illegal.operator_symbol "^\"(and|or|nand|nor|xnor|s[rl]l|s[rl]a|ro[rl]|mod|rem|abs|not|\\+|\\-|&|\\?\\?|\\??[<>/]?=|\\??[<>]|\\*\\??)\"$"))
; }}}
; 4.5.3 Signatures {{{
(signature
  "[" . "]" @error.missing.type_mark)

(return
  "," @error.unexpected.comma)
; }}}
; 4.7 Package declarations {{{
(package_header [
    (port_clause)     @error.illegal.clause.port
    (port_map_aspect) @error.illegal.map_aspect.port
  ])

(package_header
  (generic_clause)
  (generic_clause) @error.repeated.clause.generic)

(package_header
  (generic_map_aspect)
  (generic_map_aspect) @error.repeated.map_aspect.generic)

; FIXME
; Negation rule not supported yet (tree-sitter version v0.19.4)
;(package_header
; . !(generic_clause)*
; .  (generic_map_aspect) @error.missing.clause.generic
; . !(generic_clause)*)

; WORKARROUND
; Only common case
(package_header
. (generic_map_aspect) @error.missing.clause.generic
. )

(package_header
  (generic_map_aspect)
  (generic_clause) @error.order.clause_after_map_aspect)

(package_header [
    (generic_clause     ")" @error.missing.semicolon.after_clause     .)
    (generic_map_aspect ")" @error.missing.semicolon.after_map_aspect .)
  ])

(package_declaration
  (declarative_part [
    (procedure_body)
    (function_body)
    (configuration_specification)
  ] @error.illegal.declaration))

(package_declaration
  (declarative_part
    (full_type_declaration
      (protected_type_body) @error.illegal.declaration)))

(procedure_body
  (declarative_part
    (package_declaration
      (declarative_part [
        (signal_declaration)
        (disconnection_specification)
        (PSL_Property_Declaration)
        (PSL_Sequence_Declaration)
        (PSL_Clock_Declaration)
      ] @error.illegal.declaration))))

(procedure_body
  (declarative_part
    (package_declaration
      (declarative_part
        (shared_variable_declaration "shared" @error.unexpected.shared)))))

(function_body
  (declarative_part
    (package_declaration
      (declarative_part [
        (signal_declaration)
        (disconnection_specification)
        (PSL_Property_Declaration)
        (PSL_Sequence_Declaration)
        (PSL_Clock_Declaration)
      ] @error.illegal.declaration))))

(function_body
  (declarative_part
    (package_declaration
      (declarative_part
        (shared_variable_declaration "shared" @error.unexpected.shared)))))

(process_statement
  (declarative_part
    (package_declaration
      (declarative_part [
        (signal_declaration)
        (disconnection_specification)
        (PSL_Property_Declaration)
        (PSL_Sequence_Declaration)
        (PSL_Clock_Declaration)
      ] @error.illegal.declaration))))

(process_statement
  (declarative_part
    (package_declaration
      (declarative_part
        (shared_variable_declaration "shared" @error.unexpected.shared)))))

(full_type_declaration
  (protected_type_body
    (declarative_part
      (package_declaration
        (declarative_part [
          (signal_declaration)
          (disconnection_specification)
          (PSL_Property_Declaration)
          (PSL_Sequence_Declaration)
          (PSL_Clock_Declaration)
        ] @error.illegal.declaration)))))

(full_type_declaration
  (protected_type_body
    (declarative_part
      (package_declaration
        (declarative_part
          (shared_variable_declaration "shared" @error.unexpected.shared))))))

((package_declaration
   name: (_) @_h
 at_end: (_) @error.misspeling.name @_t)
         (#not-eq? @_h @_t))
; }}}
; 4.8 Package bodies {{{
(package_body
  (declarative_part [
    (signal_declaration)
    (component_declaration)
    (configuration_specification)
    (disconnection_specification)
    (PSL_Assert_Directive)
    (PSL_Assume_Directive)
    (PSL_Assume_Guarantee_Directive)
    (PSL_Restrict_Directive)
    (PSL_Restrict_Guarantee_Directive)
    (PSL_Cover_Directive)
    (PSL_Fairness_Directive)
    (PSL_Strong_Fairness_Directive)
    (PSL_Property_Declaration)
    (PSL_Sequence_Declaration)
    (PSL_Clock_Declaration)
  ] @error.illegal.declaration))

(procedure_body
  (declarative_part
    (package_body
      (declarative_part
        (shared_variable_declaration "shared" @error.unexpected.shared)))))

(function_body
  (declarative_part
    (package_body
      (declarative_part
        (shared_variable_declaration "shared" @error.unexpected.shared)))))

(process_statement
  (declarative_part
    (package_body
      (declarative_part
        (shared_variable_declaration "shared" @error.unexpected.shared)))))

(full_type_declaration
  (protected_type_body
    (declarative_part
      (package_body
        (declarative_part
          (shared_variable_declaration "shared" @error.unexpected.shared))))))

((package_body
 package: (_) @_h
  at_end: (_) @error.misspeling.name @_t)
          (#not-eq? @_h @_t))
; }}}
; 4.9 Package instantiation declarations {{{
(package_map_aspect [
    (generic_clause)  @error.illegal.clause.generic
    (port_clause)     @error.illegal.clause.port
    (port_map_aspect) @error.illegal.map_aspect.port
  ])

(package_map_aspect
  (generic_map_aspect)
  (generic_map_aspect) @error.repeated.map_aspect.generic)

(package_map_aspect
  (generic_map_aspect (semicolon) @error.unexpected.semicolon.after_map_aspect .))
; }}}
; 5.2 Scalar types {{{
(ascending_range
   low: (simple_expression (integer_decimal))
  high: (simple_expression (real_decimal))) @error.illegal.range

(ascending_range
   low: (simple_expression (real_decimal))
  high: (simple_expression (integer_decimal))) @error.illegal.range

(descending_range
   high: (simple_expression (integer_decimal))
    low: (simple_expression (real_decimal))) @error.illegal.range

(descending_range
   high: (simple_expression (real_decimal))
    low: (simple_expression (integer_decimal))) @error.illegal.range
; }}}
; 5.2.2 Enumeration types {{{
((enumeration_type_definition
  literal: (_) @_a
  literal: (_) @error.repeated.enumerator @_b)
 (#eq? @_a @_b))
; }}}
; 5.2.4 Physical types {{{
((physical_type_definition
  (primary_unit_declaration
    name: (_) @_p)
  (secondary_unit_declaration
    name: (_) @error.repeated.unit @_s))
 (#eq? @_p @_s))

((physical_type_definition
  (secondary_unit_declaration
    name: (_) @_a)
  (secondary_unit_declaration
    name: (_) @error.repeated.unit @_b))
 (#eq? @_a @_b))

(secondary_unit_declaration
  (physical_literal [ (real_decimal) (based_real) ] @error.illegal.floating_point))

((full_type_declaration
  name: (_) @_h
  (physical_type_definition
    at_end: (_) @error.misspeling.name @_t))
 (#not-eq? @_h @_t))
; }}}
; 5.3.2 Array types {{{
(index_constraint
  (subtype_indication
    (resolution_function) @error.unexpected.resolution_function))

(parameter_specification
  (subtype_indication
    (resolution_function) @error.unexpected.resolution_function))

(full_type_declaration
  name: (_) @_t
  (constrained_array_definition
    (subtype_indication
      (type_mark (_) @error.repeated.type @_e)))
    (#eq? @_t @_e))

(full_type_declaration
  name: (_) @_t
  (unbounded_array_definition
    (subtype_indication
      (type_mark (_) @error.repeated.type @_e)))
    (#eq? @_t @_e))
; }}}
; 5.3.2.3 Predefined array types {{{
; Predefine array types shall be one dimensional
(subtype_indication
  (type_mark
    (simple_name) @_t
    (#match? @_t "^(string|(boolean|bit|integer|real|time)_vector)$"))
  (array_constraint
    (index_constraint
        (_)
        (_) @error.illegal.discrete_range)))

; String subtypes shall be indexed by positive numbers
(subtype_indication
  (type_mark
    (simple_name) @_t
    (#eq? @_t "string"))
  (array_constraint
    (index_constraint
      (_
        (simple_expression
          (integer_decimal)
            @error.illegal.index.zero @_l
            (#eq? @_l "0"))))))

(subtype_indication
  (type_mark
    (simple_name) @_t
    (#eq? @_t "string"))
  (array_constraint
    (index_constraint
      (_
        (simple_expression
          (sign) @error.illegal.index.negative)))))

; Others predefined array types are indexed by natural numbers
(subtype_indication
  (type_mark
    (simple_name) @_t
    (#match? @_t "^(boolean|bit|integer|real|time)_vector$"))
  (array_constraint
    (index_constraint
      (_
        (simple_expression
          (sign) @error.illegal.index.negative)))))
; }}}
; 5.3.3 Record types {{{
((identifier_list
  (_) @_a
  (_) @error.repeated.identifier @_b)
 (#eq? @_a @_b))

(record_type_definition
  (element_declaration
    (identifier_list (_) @_a))
  (element_declaration
    (identifier_list (_) @error.repeated.identifier @_b))
 (#eq? @_a @_b))

((full_type_declaration
  name: (_) @_h
  (record_type_definition
    at_end: (_) @error.misspeling.name @_t))
 (#not-eq? @_h @_t))
; }}}

