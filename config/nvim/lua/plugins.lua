local fn = vim.fn

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
local lazy_events = { "BufRead", "BufWinEnter", "BufNewFile" }

local Events = {
    OpenFile = { "BufReadPost", "BufNewFile" },
    InsertMode = { "InsertEnter" },
    EnterWindow = { "BufEnter" },
    CursorMove = { "CursorMoved" },
    Modified = { "TextChanged", "TextChangedI" }
}
return require('lazy').setup({
    'Numkil/ag.nvim',
    'moll/vim-bbye',                 -- better buffer deletion
    'aymericbeaumet/vim-symlink',    -- read symlinks for pwd
    'tpope/vim-sleuth',              -- handles tab expansion based on current file indentation
    'honza/vim-snippets',            -- default snippets snipmate style
    'kshenoy/vim-signature',         -- adds markers to the sign column
    'tpope/vim-commentary',          -- comments lines with motions
    'editorconfig/editorconfig-vim', -- To have nvim use the settings in .editorconfig files
    'tamago324/nlsp-settings.nvim',  -- A plugin I am trying for json based local config of lsp servers
    'junegunn/vim-easy-align',
    {
        "dracula/vim",
        name = "dracula",
        lazy = true,
        priority = 1000,
    },

    { -- Syntax highlighting for XDC files
        'amal-khailtash/vim-xdc-syntax',
        ft = 'xdc'
    },
    {
        'rcarriga/nvim-notify',
        config = function ()
            require 'plugins.others'.notify()
        end
    },
    {
        'L3MON4D3/LuaSnip',
        config = function ()
            require 'plugins.others'.snippets()
        end
    },
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

    { -- Adds virtual text for indentation levels and shows whitespace
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        opts = {},
        config = function ()
            require("plugins.others").indentline()
        end
    },
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
    {
        'gennaro-tedesco/nvim-jqx',
        ft = "json"
    },
    { -- auto pairs for certain characters
        'windwp/nvim-autopairs',
        config = function ()
            require 'plugins.auto-pairs'
        end
    },
    { -- Treesitter front end
        "nvim-treesitter/nvim-treesitter",
        build = ':TSUpdate',
        event = Events.OpenFile,
        config = function ()
            require("plugins.tree-sitter")
        end
    },
    { -- Automatically close HTML/XML tags
        "windwp/nvim-ts-autotag",
        {
            'nvim-treesitter/playground', -- Playground for tree-sitter
            cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }
        },
        dependencies = "nvim-treesitter",
        event = Events.InsertMode,
    },
    {
        {
            'nvim-treesitter/playground', -- Playground for tree-sitter
            cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }
        },
        'romgrk/nvim-treesitter-context', -- Provide context from tree-sitter
        dependencies = "nvim-treesitter",
    },
    { -- Easy navigation between pairs
        "andymass/vim-matchup",
        dependencies = "nvim-treesitter",
        event = Events.OpenFile,
        config = function ()
            require("plugins.others").matchup()
        end,
    },
    { -- Neovim Language Server
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
    {
        'rmagatti/auto-session', -- Session management
        config = function ()
            require 'plugins.auto-session'
        end,
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
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
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            { 'kyazdani42/nvim-web-devicons' }
        },
        config = function ()
            require 'plugins.lualine'
        end,
    },
    {
        'tweekmonster/startuptime.vim',
        cmd = 'StartupTime'
    }
})
