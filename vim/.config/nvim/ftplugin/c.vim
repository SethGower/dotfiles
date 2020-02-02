setlocal foldmethod=syntax
let g:AutoPairs['/*']='*/'
let g:ale_c_ccls_init_options = {
\   'cache': {
\       'directory': expand('~/.cache/ccls')
\   }
\ }
