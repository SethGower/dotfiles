set autoindent
set cindent
set shiftwidth=4
set textwidth=0
set comments=:#
set formatoptions+=r
set formatoptions+=q


set cpoptions-=<          " allow '<keycode>' forms in mappings, e.g. <CR>
inoremap # X<BS>#
set cinkeys-=0#           " # in column 1 does not prevent >> from indenting
set indentkeys-=0#

set foldmethod=syntax
" syntax region tclBlock  start="{" end="}" transparent fold
syn keyword tclStatement        proc global return lindex

syn keyword tclStatement        global return lindex
syn match   tclStatement        "proc" contained
" add the (slightly extended) region rule
syntax region tclFunc start="^\z(\s*\)proc.*{$" end="^\z1}$" transparent fold contains=ALL
