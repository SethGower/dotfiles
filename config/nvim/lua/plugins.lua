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
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "moon"
        },
    },

    { -- Highlight todo comments
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "telescope.nvim"
        },
        event = Events.OpenFile,
        opts = {
            signs = false,
            highlight = {
                pattern = [[.*<(KEYWORDS)\s*:?]], -- vim regex
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                -- Don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):?]], -- ripgrep regex
            },
        }
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
    'editorconfig/editorconfig-vim', -- To have nvim use the settings in .editorconfig files
    'tpope/vim-sleuth',              -- handles tab expansion based on current file indentation
    'junegunn/vim-easy-align',       -- Aligning tool to align on delimeters
    'moll/vim-bbye',                 -- better buffer deletion
    'aymericbeaumet/vim-symlink',    -- read symlinks for pwd
    'dstein64/nvim-scrollview',
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
            require("plugins.nvim-tree-config").setup()
        end,
        -- cmd = "NvimTreeFindFile"
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
    {
        'stevearc/conform.nvim',
        opts = {},
        config = require('plugins.others').conform
    },
    { -- Updated comment plugin, compared to tpope/commentary.vim
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false,
    },
    { -- Auto buffer resizing
        "anuvyklack/windows.nvim",
        dependencies = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim"
        },
        event = Events.EnterWindow,
        opts = {
            autowidth = {
                enable = true,
                winwidth = 10,
                filetype = {
                    help = 2,
                },
            },
            ignore = {
                buftype = { "quickfix" },
                filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "fzf", "TelescopePrompt", "TelescopeResults" }
            },
            animation = {
                enable = true,
                duration = 300,
                fps = 30,
                easing = "in_out_sine"
            }
        },
    },

    { -- Toggle True/False, Yes/No, etc..
        "rmagatti/alternate-toggler",
        cmd = "ToggleAlternate",
        opts = {
            alternates = {
                ["=="] = "!=",
                ["yes"] = "no",
                ["no"] = "yes",
                ["NO"] = "YES",
                ["false"] = "true",
                ["FALSE"] = "TRUE",
            }
        }
    },

    { -- Ctrl-<hjkl> navigation with TMUX
        "numToStr/Navigator.nvim",
        opts = {
            auto_save = nil,
            disable_on_zoom = true
        },
    },

    { -- Various small utilies
        "echasnovski/mini.nvim",
        branch = 'main',
        event = Events.OpenFile,
        config = function ()
            require("plugins.mini").config()
        end
    },

    ----------------------------
    -- Git stuff
    ----------------------------
    { -- Git commands within Neovim
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb",
        'shumphrey/fugitive-gitlab.vim',
        event = Events.EnterWindow
    },
    { -- Git modification signs
        "lewis6991/gitsigns.nvim",
        event = Events.OpenFile,
        config = function ()
            require('plugins.git-signs')
        end
    },
    {
        "harrisoncramer/gitlab.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "stevearc/dressing.nvim",     -- Recommended but not required. Better UI for pickers.
            "nvim-tree/nvim-web-devicons" -- Recommended but not required. Icons in discussion tree.
        },
        enabled = true,
        build = function () require("gitlab.server").build(true) end, -- Builds the Go binary
        config = function ()
            require("gitlab").setup({
                config_path = vim.fn.expand("~/")
            })
            local gitlab = require("gitlab")
            local gitlab_server = require("gitlab.server")
            vim.keymap.set("n", "glb", gitlab.choose_merge_request)
            vim.keymap.set("n", "glr", gitlab.review)
            vim.keymap.set("n", "gls", gitlab.summary)
            vim.keymap.set("n", "glA", gitlab.approve)
            vim.keymap.set("n", "glR", gitlab.revoke)
            vim.keymap.set("n", "glc", gitlab.create_comment)
            vim.keymap.set("v", "glc", gitlab.create_multiline_comment)
            vim.keymap.set("v", "glC", gitlab.create_comment_suggestion)
            vim.keymap.set("n", "glO", gitlab.create_mr)
            vim.keymap.set("n", "glm", gitlab.move_to_discussion_tree_from_diagnostic)
            vim.keymap.set("n", "gln", gitlab.create_note)
            vim.keymap.set("n", "gld", gitlab.toggle_discussions)
            vim.keymap.set("n", "glaa", gitlab.add_assignee)
            vim.keymap.set("n", "glad", gitlab.delete_assignee)
            vim.keymap.set("n", "glla", gitlab.add_label)
            vim.keymap.set("n", "glld", gitlab.delete_label)
            vim.keymap.set("n", "glra", gitlab.add_reviewer)
            vim.keymap.set("n", "glrd", gitlab.delete_reviewer)
            vim.keymap.set("n", "glp", gitlab.pipeline)
            vim.keymap.set("n", "glo", gitlab.open_in_browser)
            vim.keymap.set("n", "glM", gitlab.merge)
            vim.keymap.set("n", "glu", gitlab.copy_mr_url)
            vim.keymap.set("n", "glP", gitlab.publish_all_drafts)
        end,
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
    {                                                  -- Automatically close HTML/XML tags
        "windwp/nvim-ts-autotag",
        'romgrk/nvim-treesitter-context',              -- Provide context from tree-sitter
        'JoosepAlviste/nvim-ts-context-commentstring', -- Set the commentstring based on location in file
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
    'jmbuhr/otter.nvim',            -- Otter allows having embedded LSP on other language snippets (like when code is embedded in a markdown)

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
    {
        -- Null LS provides linting for linters that don't support LSP, adding for VSG, can use for others. None LS is a
        -- community maintained version of null-ls since null-ls was deprecated/archived by the original author
        'nvimtools/none-ls.nvim',
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
        -- {
        --     "ThePrimeagen/harpoon",
        --     config = function ()
        --         require("plugins.others").harpoon()
        --     end,
        -- },
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
