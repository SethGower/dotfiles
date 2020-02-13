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

set wildignore+=*.o,*.obj,*.oem4,*.xearp*,*.xe66,*.xem4
let g:ale_c_clangformat_options = '-style="{BasedOnStyle: LLVM, IndentWidth: 4}"'
