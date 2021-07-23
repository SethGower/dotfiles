" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

setlocal comments=:%
setlocal commentstring=\%\ %s
setlocal formatoptions+=cro
setlocal textwidth=0

hi MLint guifg=Yellow

command -nargs=0 Testbench :0r ~/.config/nvim/skeleton/testbench.m

let g:matchup_matchparen_offscreen = {'method': 'popup'}
