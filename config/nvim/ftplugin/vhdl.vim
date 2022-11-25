" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

let g:UltiSnipsSnippetDir = "~/.config/nvim/UltiSnips/"

let g:vhdl_indent_genportmap = 0 " Keeps Vim from indenting port maps too much
let g:HDL_Clock_Period       = 100
let g:HDL_Author             = system("git config --global user.name")

if exists(":EasyAlign")
    map <leader>v: :EasyAlign :>l1<CR>
    map <leader>v= :EasyAlign =<CR>
    map <leader>vs :EasyAlign =<CR>
    map <leader>vw :EasyAlign =<CR>
    " map <leader>v, :Tabularize /,=<CR>
endif

if exists(':Rooter')
    let g:rooter_patterns = ['.hdl_checker.config', 'vhdl_ls.toml']
endif

setlocal comments=:--
setlocal commentstring=--%s
setlocal formatoptions+=cro
setlocal textwidth=0

" Simple shortcuts from https://github.com/salinasv/vim-vhdl/
iabbrev <buffer> con constant
iabbrev <buffer> dt  downto
iabbrev <buffer> sig signal
iabbrev <buffer> var variable
iabbrev <buffer> gen generate
iabbrev <buffer> ot  others
iabbrev <buffer> sl  std_logic
iabbrev <buffer> slv std_logic_vector
iabbrev <buffer> lv  std_logic_vector
iabbrev <buffer> uns unsigned
iabbrev <buffer> toi to_integer
iabbrev <buffer> tos to_signed
iabbrev <buffer> tou to_unsigned

map <F9> :setl autoread<CR>:let b:current_file = @%<CR>:w!<CR>:execute '!vsg -f ' . b:current_file ' --fix --configuration ./vsg_config.yaml'<CR><CR>:edit<CR>:setl noautoread<CR>
