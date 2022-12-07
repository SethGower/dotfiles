vim.cmd [[autocmd FileType latex,tex,markdown,md,text setlocal spell spelllang=en_us]]
vim.cmd [[autocmd FileType make setlocal noexpandtab]]
vim.cmd [[autocmd FileType gitconfig set ft=dosini]]
vim.cmd [[autocmd FileType zsh set ft=sh]]
vim.cmd [[autocmd BufNewFile,BufRead *.h set ft=c]]
vim.cmd [[autocmd BufNewFile,BufRead *.config set ft=json]]
vim.cmd("autocmd BufEnter " .. vim.fn.stdpath('config') .. "/*.lua set kp=:help") -- sets the keywordprg to :help for init.lua, that way I can do 'K' on a word and look it up quick
