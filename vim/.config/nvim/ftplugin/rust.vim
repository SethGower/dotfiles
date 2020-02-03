setlocal foldmethod=syntax
map <leader>rr :RustRun<CR>
let b:ale_fix_on_save = 0
let b:ale_linters = ['rls']
let b:ale_fixers = ['rustfmt']
