" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

let g:UltiSnipsSnippetDir="~/.config/nvim/UltiSnips/"

let g:vhdl_indent_genportmap = 0 " Keeps Vim from indenting port maps too much
let g:HDL_Clock_Period = 10
let g:HDL_Author = system("git config --global user.name")

nnoremap <leader>C <Plug>SpecialVHDLPasteComponent
nnoremap <leader>I <Plug>SpecialVHDLPasteInstance
nnoremap <leader>E <Plug>SpecialVHDLPasteEntity

setlocal comments=:--
setlocal formatoptions+=cro

" Simple shortcuts from https://github.com/salinasv/vim-vhdl/
iabbrev <buffer> dt downto
iabbrev <buffer> sig signal
iabbrev <buffer> gen generate
iabbrev <buffer> ot others
iabbrev <buffer> sl std_logic
iabbrev <buffer> slv std_logic_vector
iabbrev <buffer> uns unsigned
iabbrev <buffer> toi to_integer
iabbrev <buffer> tos to_unsigned
iabbrev <buffer> tou to_unsigned
