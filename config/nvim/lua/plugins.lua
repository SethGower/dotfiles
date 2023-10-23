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
---------------------
--  Plugin Config  --
---------------------
-- BufEnter is kinda not lazy
-- local lazy_events = { "BufRead", "BufWinEnter", "BufNewFile" }

local Events = {
    OpenFile = { "BufReadPost", "BufNewFile" },
    InsertMode = { "InsertEnter" },
    EnterWindow = { "BufEnter" },
    CursorMove = { "CursorMoved" },
    Modified = { "TextChanged", "TextChangedI" }
}
return require('lazy').setup({

    ----------------------------
    -- Colors and Appearance
    ----------------------------
    'kshenoy/vim-signature', -- adds markers to the sign column
    {
        "dracula/vim",
        name = "dracula",
        lazy = true,
        priority = 1000,
    },

    { -- Adds virtual text for indentation levels and shows whitespace
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        opts = {},
        config = function ()
            require("plugins.others").indentline()
        end
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            { 'kyazdani42/nvim-web-devicons' }
        },
        config = function ()
            require 'plugins.lualine'
        end,
    },

    ----------------------------
    -- Completion Engine
    ----------------------------
    { -- Snippet sources
        "honza/vim-snippets",
        "rafamadriz/friendly-snippets",
        event = Events.InsertMode,
    },

    { -- Snippet engine
        "L3MON4D3/LuaSnip",
        event = Events.InsertMode,
        config = function ()
            require("plugins.completions").luasnip()
        end
    },

    { -- Completion engine
        "hrsh7th/nvim-cmp",
        dependencies = "LuaSnip",
        module = "cmp",
        event = Events.InsertMode,
        config = function ()
            require("plugins.completions").config()
        end
    },

    { -- Completion engine plugins
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        dependencies = "nvim-cmp",
        event = Events.InsertMode,
    },
    ----------------------------
    -- Utilities
    ----------------------------
    'editorconfig/editorconfig-vim',       -- To have nvim use the settings in .editorconfig files
    'tpope/vim-sleuth',                    -- handles tab expansion based on current file indentation
    'junegunn/vim-easy-align',             -- Aligning tool to align on delimeters
    'tpope/vim-commentary',                -- comments lines with motions
    'moll/vim-bbye',                       -- better buffer deletion
    'aymericbeaumet/vim-symlink',          -- read symlinks for pwd
    {
        'alexghergh/nvim-tmux-navigation', -- Tmux Navigation
        config = function ()
            local nvim_tmux_nav = require('nvim-tmux-navigation')

            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }

            vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            -- vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end
    },
    {
        'rcarriga/nvim-notify',
        config = function ()
            require 'plugins.others'.notify()
        end
    },
    { -- auto pairs for certain characters
        'windwp/nvim-autopairs',
        config = function ()
            require 'plugins.auto-pairs'
        end
    },
    {
        'rmagatti/auto-session', -- Session management
        config = function ()
            require 'plugins.auto-session'
        end,
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        config = function ()
            require("nvim-tree").setup()
        end,
    },

    { -- Sets the current working directory based on certain patterns
        'ygm2/rooter.nvim',
        config = function ()
            vim.g.rooter_pattern = { '.git', 'Makefile', '_darcs', '.hg', '.bzr', '.svn', 'node_modules',
                'CMakeLists.txt' }
            vim.g.outermost_root = true
        end
    },

    { -- Adds easier to use terminal that can be accessed within nvim
        "akinsho/toggleterm.nvim",
        config = function ()
            require("plugins.toggle-term")
        end,
        cmd = "ToggleTerm",
        keys = {
            { '<c-\\>', "<cmd>ToggleTerm<cr>", desc = "Toggle Term" },
        }
    },
    { -- GDB Integration
        'sakhnik/nvim-gdb',
        build = ':!./install.sh',
        cmd = { 'GdbStart', 'GdbStartLLDB' },
    },
    {
        'tpope/vim-dispatch',
        cmd = { 'Make', 'Dispatch', 'Start' }
    },
    {
        'tweekmonster/startuptime.vim',
        cmd = 'StartupTime'
    },
    ----------------------------
    -- Git stuff
    ----------------------------
    { -- Git commands within Neovim
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb",
        'shumphrey/fugitive-gitlab.vim',
        evend = Events.EnterWindow
    },
    { -- Git modification signs
        "lewis6991/gitsigns.nvim",
        event = Events.OpenFile,
        config = function ()
            require('plugins.git-signs')
        end
    },
    ----------------------------
    -- Treesitter
    ----------------------------
    { -- Treesitter front end
        "nvim-treesitter/nvim-treesitter",
        build = ':TSUpdate',
        event = Events.OpenFile,
        config = function ()
            require("plugins.tree-sitter")
        end
    },
    {                                     -- Automatically close HTML/XML tags
        "windwp/nvim-ts-autotag",
        'romgrk/nvim-treesitter-context', -- Provide context from tree-sitter
        {
            'nvim-treesitter/playground', -- Playground for tree-sitter
            cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }
        },
        dependencies = "nvim-treesitter",
        event = Events.InsertMode,
    },
    { -- Easy navigation between pairs
        "andymass/vim-matchup",
        dependencies = "nvim-treesitter",
        event = Events.OpenFile,
        config = function ()
            require("plugins.others").matchup()
        end,
    },
    ----------------------------
    -- Language Server
    ----------------------------
    'tamago324/nlsp-settings.nvim', -- A plugin I am trying for json based local config of lsp servers

    {                               -- Neovim Language Server
        "neovim/nvim-lspconfig",
        event = Events.OpenFile,
        config = function ()
            require("plugins.lsp").setup()
        end,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim"
        }
    },
    { -- Null LS provides linting for linters that don't support LSP, adding for VSG, can use for others
        'jose-elias-alvarez/null-ls.nvim',
        config = function ()
            require('plugins.lsp').null_ls()
        end,
        dependencies = {
            { "neovim/nvim-lspconfig" },
        }
    },
    { -- Images inside neovim LSP completion menu
        "onsails/lspkind-nvim",
        event = Events.InsertMode,
        config = function ()
            require("lspkind").init(require("plugins.lspkind_icons"))
        end
    },
    {
        "ray-x/lsp_signature.nvim",
        event = Events.OpenFile,
        config = function ()
            require("lsp_signature").setup({
                bind = true,
                handler_opts = {
                    border = "rounded"
                },
                hint_enable = false
            })
        end
    },
    { -- Better looking LSP referneces, diagnostics, and such
        "folke/trouble.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        config = function ()
            require 'plugins.others'.trouble()
        end
    },
    ----------------------------
    -- Searching
    ----------------------------
    'Numkil/ag.nvim',
    { -- Fuzzy search
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
        },
        event = Events.EnterWindow,
        config = function ()
            require 'plugins.telescope'
        end
    },

    { -- Telescope plugins
        {
            "ThePrimeagen/harpoon",
            config = function ()
                require("plugins.others").harpoon()
            end,
        },
        {
            'rmagatti/session-lens',
            config = function ()
                require("plugins.others").session_lens()
            end,
        },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-media-files.nvim" },
        { "olacin/telescope-gitmoji.nvim" },
        lazy = true,
    },
    ----------------------------
    -- Filetype Specific
    ----------------------------
    { -- VimTeX for better development of LaTeX
        'lervag/vimtex',
        ft = 'tex',
    },

    { -- VHDL plugin for copying and pasting entities and such
        'JPR75/vip',
        cmd = { "Viy", "Vii", "Vic" },
    },
    { -- Preview markdown
        "iamcco/markdown-preview.nvim",
        build = function () vim.fn['mkdp#util#install']() end,
        ft = { 'markdown' },
    },
    { -- Syntax highlighting for XDC files
        'amal-khailtash/vim-xdc-syntax',
        ft = 'xdc'
    },
    {
        'gennaro-tedesco/nvim-jqx',
        ft = "json"
    },

})
