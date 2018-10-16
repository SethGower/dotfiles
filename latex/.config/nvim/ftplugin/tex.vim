" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

let g:UltiSnipsSnippetDir="~/.config/nvim/UltiSnips/"

let g:AutoPairs['$']='$'
