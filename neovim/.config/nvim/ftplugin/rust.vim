setlocal foldmethod=syntax
map <leader>rr :RustRun<CR>

let g:rust_clip_command = 'xclip -selection clipboard'
compiler cargo
