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

[ "of" "in" "out" "inout" ] @keyword.operator

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

(variable_declaration
    (identifier_list (identifier) @variable))

(file_declaration
    (identifier_list (identifier) @variable))

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

(simple_expression
  (term (simple_name) @constant))

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
(block_statement
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

; (signal_interface_declaration
;     (identifier_list
;         (identifier) @variable))

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
(aggregate
    (named_element_association
        (choices
            (simple_expression
                (simple_name) @field))))

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

(simple_variable_assignment
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
