local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- If we can't install plugins, don't bother
vim.g.plugins_installed = vim.fn.has("nvim-0.8.0") ~= 0
if not vim.g.plugins_installed then
    return
end
---------------------
--  Plugin Config  --
---------------------
return require('lazy').setup("plugin-specs")
