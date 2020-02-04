setlocal foldmethod=syntax
let g:AutoPairs['/*']='*/'
let g:ale_c_ccls_init_options = {
\   'cache': {
\       'directory': expand('~/.cache/ccls')
\   }
\ }

let b:ale_linters = ['ccls']
let b:ale_fixers  = ['clang-format']
let b:ale_fix_on_save = 0
