-- BufEnter is kinda not lazy
-- local lazy_events = { "BufRead", "BufWinEnter", "BufNewFile" }

local Events = {
    OpenFile = { "BufReadPost", "BufNewFile" },
    InsertMode = { "InsertEnter" },
    EnterWindow = { "BufEnter" },
    CursorMove = { "CursorMoved" },
    Modified = { "TextChanged", "TextChangedI" }
}
return {
    { -- Adds virtual text for indentation levels and shows whitespace
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        opts = {},
        config = function ()
            local ibl = require("ibl")
            vim.opt.list = true
            vim.opt.listchars:append "space:⋅"
            vim.opt.listchars:append "eol:↴"

            ibl.setup({
                scope = {
                    enabled = true
                }
            })
        end
    },
    {
        'rcarriga/nvim-notify',
        opts = {
            background_colour = "#000000"
        }
    },
    ----------------------------
    -- Colors and Appearance
    ----------------------------
    'kshenoy/vim-signature', -- adds markers to the sign column
    { "EdenEast/nightfox.nvim" },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            no_italic = false,
            term_colors = true,
            transparent_background = true,
        }
    },
    {
        'norcalli/nvim-colorizer.lua',
        config = function ()
            require('colorizer').setup()
        end
    },
    {
        "dracula/vim",
        name = "dracula",
        lazy = true,
        priority = 1000,
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
            local luasnip = require('luasnip')

            luasnip.config.set_config {
                history = true,
                updateevents = "TextChanged,TextChangedI",
            }

            -- Extend honza/vim-snippets "all" to LuaSnip all
            luasnip.filetype_extend("all", { "_" })

            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_snipmate').lazy_load()
            require('luasnip.loaders.from_lua').lazy_load()

            vim.cmd(
                [[imap <silent><expr> <C-j> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-j>' ]])
            vim.cmd([[inoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(-1)<Cr>]])
            vim.cmd([[snoremap <silent> <C-j> <cmd>lua require('luasnip').jump(1)<Cr>]])
            vim.cmd([[snoremap <silent> <C-k> <cmd>lua require('luasnip').jump(-1)<Cr>]])
        end
    },
    ----------------------------
    -- Utilities
    ----------------------------
    'editorconfig/editorconfig-vim', -- To have nvim use the settings in .editorconfig files
    'tpope/vim-sleuth',              -- handles tab expansion based on current file indentation
    'moll/vim-bbye',                 -- better buffer deletion
    'aymericbeaumet/vim-symlink',    -- read symlinks for pwd
    'dstein64/nvim-scrollview',      -- Adds a scrollbar with LSP warning/error signs
    -- 'mg979/vim-visual-multi',
    {
        "folke/noice.nvim",
        opts = {
            lsp = {
                signature = { enabled = true },
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,       -- add a border to hover docs and signature help
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },


    { -- Sets the current working directory based on certain patterns
        'ygm2/rooter.nvim',
        config = function ()
            vim.g.rooter_pattern = { '.git', 'Makefile', '_darcs', '.hg', '.bzr', '.svn', 'node_modules',
                'CMakeLists.txt' }
            vim.g.outermost_root = true
        end
    },

    { -- GDB Integration
        'sakhnik/nvim-gdb',
        build = ':!./install.sh',
        cmd = { 'GdbStart', 'GdbStartLLDB' },
    },
    {
        'tweekmonster/startuptime.vim',
        cmd = 'StartupTime'
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

    -- { -- Ctrl-<hjkl> navigation with TMUX
    --     "numToStr/Navigator.nvim",
    --     opts = {
    --         auto_save = nil,
    --         disable_on_zoom = true
    --     },
    -- },
    {
        "GR3YH4TT3R93/zellij-nav.nvim",
        cond = os.getenv("ZELLIJ") == "0", -- Only load plugin if in active Zellij instance
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<A-h>", "<cmd>ZellijNavigateLeft<CR>",        { silent = false, desc = "navigate left or tab" } },
            { "<A-j>", "<cmd>ZellijNavigateDown<CR>",        { silent = false, desc = "navigate down" } },
            { "<A-k>", "<cmd>ZellijNavigateUp<CR>",          { silent = false, desc = "navigate up" } },
            { "<A-l>", "<cmd>ZellijNavigateRight<CR>",       { silent = false, desc = "navigate right or tab" } },
            { "<A-n>", "<cmd>ZellijNewPane<CR>",             { silent = false, desc = "Open new Zellij Floating pane" } },
            { "<A-s>", "<cmd>ZellijNewPaneSplit<CR>",        { silent = false, desc = "Open Zellij pane split below" } },
            { "<A-v>", "<cmd>ZellijNewPaneVSplit<CR>",       { silent = false, desc = "Open Zellij pane split to the right" } },
            { "<A-f>", "<cmd>ZellijToggleFloatingPanes<CR>", { silent = false, desc = "Toggle Zellij Floating pane" } },
            { "<A-x>", "<cmd>ZellijClosePane<CR>",           { silent = false, desc = "Close current Zellij Pane" } },
            { "<A-t>", "<cmd>ZellijNewTab<CR>",              { silent = false, desc = "Open a new Zellij tab" } },
        },
        opts = {},
    },


    ----------------------------
    -- Git stuff
    ----------------------------
    { -- Git commands within Neovim
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb",
        {
            'shumphrey/fugitive-gitlab.vim',
            config = function (...)
                vim.g.fugitive_gitlab_domains = { 'https://gitlab.csde.caci.com' }
            end
        },
        event = Events.EnterWindow
    },
    ----------------------------
    -- Language Server
    ----------------------------
    -- 'tamago324/nlsp-settings.nvim', -- A plugin I am trying for json based local config of lsp servers
    "neovim/nvim-lspconfig",
    {
        'jmbuhr/otter.nvim', -- Otter allows having embedded LSP on other language snippets (like when code is embedded in a markdown)
        filetype =
        {
            "markdown", -- since there can be code blocks of other langs
            "lua",      -- can have embedded vimscript
            "vim"       -- can have embedded lua
        }
    },
    -- TODO: Do I really need this anymore, now that I have nix and home-manager?
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "rust_hdl",
                "lua-language-server"
            }
        }
    },
    -- {
    --     "williamboman/mason-lspconfig.nvim",
    --     dependencies = {
    --         "neovim/nvim-lspconfig",
    --         "williamboman/mason.nvim",
    --     },
    --     opts = {
    --         automatic_installation = true
    --     }
    -- },
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
    ----------------------------
    -- Filetype Specific
    ----------------------------
    { -- VimTeX for better development of LaTeX
        'lervag/vimtex',
        ft = 'tex',
    },

    { -- VHDL plugin for copying and pasting entities and such
        'JPR75/vip',
        filetype = { "vhdl" },
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
    'isobit/vim-caddyfile',

}
