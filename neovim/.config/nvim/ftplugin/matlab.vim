" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

setlocal comments=:%
setlocal commentstring=\%\ %s
setlocal formatoptions+=cro
setlocal textwidth=0


if exists(":Tabularize")
    map <leader>v= :Tabularize /=<CR>
endif

function RunMatlab()

endfunction
