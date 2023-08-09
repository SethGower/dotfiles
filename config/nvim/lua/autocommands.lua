vim.cmd [[autocmd FileType latex,tex,markdown,md,text setlocal spell spelllang=en_us]]
vim.cmd [[autocmd FileType make setlocal noexpandtab]]
vim.cmd [[autocmd FileType gitconfig set ft=dosini]]
vim.cmd [[autocmd BufNewFile,BufRead *.h set ft=c]]
vim.cmd [[autocmd BufNewFile,BufRead *.config set ft=json]]

vim.api.nvim_create_autocmd('FileType', {
    pattern = "zsh",
    command = "set ft=sh"
})

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { "/home/sgower/.config/nvim/*.lua", "/home/sgower/.dotfiles/config/nvim/*.lua" },
    command = "set kp=:help"
})
