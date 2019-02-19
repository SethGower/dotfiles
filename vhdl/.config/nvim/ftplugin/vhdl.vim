" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

let g:UltiSnipsSnippetDir="~/.config/nvim/UltiSnips/"

let g:vhdl_indent_genportmap = 0 " Keeps Vim from indenting port maps too much
let g:HDL_Clock_Period = 100
let g:HDL_Author = system("git config --global user.name")

nnoremap <leader>c <Plug>SpecialVHDLPasteComponent
nnoremap <leader>i <Plug>SpecialVHDLPasteInstance
nnoremap <leader>e <Plug>SpecialVHDLPasteEntity

let g:ale_vhdl_ghdl_options = "--ieee=synopsys"

setlocal comments=:--
setlocal formatoptions+=cro

" Simple shortcuts from https://github.com/salinasv/vim-vhdl/
iabbrev <buffer> con constant
iabbrev <buffer> dt downto
iabbrev <buffer> sig signal
iabbrev <buffer> var variable
iabbrev <buffer> gen generate
iabbrev <buffer> ot others
iabbrev <buffer> sl std_logic
iabbrev <buffer> slv std_logic_vector
iabbrev <buffer> uns unsigned
iabbrev <buffer> toi to_integer
iabbrev <buffer> tos to_signed
iabbrev <buffer> tou to_unsigned
