local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
end

vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])
local use = require('packer').use
return require('packer').startup(function()
    use 'wbthomason/packer.nvim'     -- packer manages itself
    use 'moll/vim-bbye'              -- better buffer deletion
    use 'aymericbeaumet/vim-symlink' -- read symlinks for pwd
    use 'tpope/vim-sleuth'           -- handles tab expansion based on current file indentation
    use 'honza/vim-snippets'         -- default snippets snipmate style
    use 'kshenoy/vim-signature'      -- adds markers to the sign column
    use 'tpope/vim-commentary'       -- comments lines with motions

    use {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',
        requires = 'hrsh7th/nvim-cmp'
    }
    use {
        'hrsh7th/nvim-cmp',
        config = [[require'plugins.completions']]
    }

    -- Snippets Engine that's written in Lua so it's faster
    use {
        'L3MON4D3/LuaSnip',
        config = [[require'plugins.others'.snippets()]]
    }
    -- Adds virtual text for indentation levels and shows whitespace
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = [[require'plugins.others'.indentline()]]
    }

    use {
        'junegunn/vim-easy-align',
        cmd = "EasyAlign"
    }

    -- Git interface, so good it should be illegal
    use {
        'tpope/vim-fugitive',
        cmd = { "G", "Gvdiffsplit", "Gvdiffsplit!", "GBrowse", "GBrowse!", "Gread", "Gwrite" }
    }

    -- gitlab provider for :GBrowse for fugitive
    use {
        'shumphrey/fugitive-gitlab.vim',
        after = 'vim-fugitive',
        cmd = { "GBrowse", "GBrowse!" }
    }

    -- github provider for :GBrowse for fugitive
    use {
        'tpope/vim-rhubarb',
        after = 'vim-fugitive',
        cmd = { "GBrowse", "GBrowse!" }
    }

    -- Easily navigate json trees
    use {
        'gennaro-tedesco/nvim-jqx',
        ft = "json"
    }

    -- Silver Searcher
    use {
        'Numkil/ag.nvim',
        cmd = 'Ag'
    }

    -- auto pairs for certain characters
    use {
        'windwp/nvim-autopairs',
        config = [[require 'plugins.auto-pairs']]
    }

    -- Syntax highlighting for XDC files
    use {
        'amal-khailtash/vim-xdc-syntax',
        ft = 'xdc'
    }

    -- Mason handles installation of LSP servers, DAP servers, linters, and
    -- formatters
    use {
        'williamboman/mason-lspconfig.nvim',
        requires = 'williamboman/mason.nvim',
    }

    -- LSP configuration for built in LSP
    use {
        'neovim/nvim-lspconfig',
        config = [[require('plugins.lsp').setup()]]
    }

    use {
        'jose-elias-alvarez/null-ls.nvim',
        config = [[require('plugins.null-ls')]],
    } -- Null LS provides linting for linters that don't support LSP, adding for VSG, can use for others

    -- Better looking LSP referneces, diagnostics, and such
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        after = 'nvim-lspconfig',
        config = [[require'plugins.others'.trouble()]],
    }

    -- File tree for Neovim. Similar to the vim NerdTree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        config = [[require("nvim-tree").setup()]],
        cmd = 'NvimTree*'
    }

    -- Sets the current working directory based on certain patterns
    use {
        'ygm2/rooter.nvim',
        config = function()
            vim.g.rooter_pattern = { '.git', 'Makefile', '_darcs', '.hg', '.bzr', '.svn', 'node_modules',
                'CMakeLists.txt' }
            vim.g.outermost_root = true
        end
    }

    -- Adds easier to use terminal that can be accessed within nvim
    use {
        "akinsho/toggleterm.nvim",
        tag = '*',
        config = [[require("plugins.toggle-term")]],
        cmd = "ToggleTerm",
        keys = { 'n', '<c-\\>' }
    }

    -- GDB Integration
    use {
        'sakhnik/nvim-gdb',
        run = ':!./install.sh',
        cmd = { 'GdbStart', 'GdbStartLLDB' },
    }

    -- treesitter interface for vim
    use {
        'nvim-treesitter/nvim-treesitter',
        branch = 'v0.8.0',
        run = ':TSUpdate',
        config = [[require 'plugins.tree-sitter']]
    }

    -- Various Treesitter modules
    use {
        'windwp/nvim-ts-autotag', -- Auto close tags with tree sitter
        'romgrk/nvim-treesitter-context', -- Provide context from tree-sitter
        {
            'SethGower/nvim-ts-rainbow',
            branch = "adding-vhdl",
        }, -- Adds rainbow parentheses based on tree sitter
        {
            'nvim-treesitter/playground', -- Playground for tree-sitter
            cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }
        },
        after = { 'nvim-treesitter' },
        requires = { 'nvim-treesitter/nvim-treesitter' }
    }

    -- Better matchit. Matching beginning and ends of branched statements (if,
    -- for, etc)
    use {
        'andymass/vim-matchup',
        config = [[require'plugins.others'.matchup()]]
    }

    -- Dispatch adds better background compilation than :make
    use {
        'tpope/vim-dispatch',
        cmd = { 'Make', 'Dispatch', 'Start' }
    }

    -- Automatically add licenses to the top of file
    use {
        'antoyo/vim-licenses',
        config = function()
            vim.g.licenses_copyright_holders_name = 'Gower, Seth <sethzerish@gmail.com>'
        end
    }

    -- Lua Fuzzy Searcher
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim'
        },
        config = [[require 'plugins.telescope']],
        cmd = "Telescope",
        module = "telescope"

    }

    use {
        'olacin/telescope-gitmoji.nvim',
        requires = 'nvim-telescope/telescope.nvim',
        after = 'telescope.nvim'
    }

    -- Harpoon
    use {
        'ThePrimeagen/harpoon',
        requires = { { 'nvim-lua/plenary.nvim' } },
        after = 'telescope.nvim',
        config = [[require 'plugins.others'.harpoon()]],
    }


    use {
        'rmagatti/auto-session', -- Session management
        config = [[require 'plugins.auto-session']]

    }

    -- Session Lens for session and telescope cooperation
    use {
        'rmagatti/session-lens',
        after = 'telescope.nvim',
        config = [[require 'plugins.others'.session_lens()]]
    }
    -- git interface stuff for nvim. Mainly for git blame
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = [[require('plugins.git-signs')]]
    }

    -- VimTeX for better development of LaTeX
    use {
        'lervag/vimtex',
        ft = 'tex',
    }

    -- VHDL plugin for copying and pasting entities and such
    use {
        'JPR75/vip',
        cmd = { "Viy", "Vii", "Vic" },
    }

    -- Dracula colorscheme https://draculatheme.com/
    use {
        'dracula/vim',
        as = 'dracula'
    }


    -- Glow for markdown previews
    use {
        'npxbr/glow.nvim',
        run = 'GlowInstall',
        ft = "markdown"
    }

    -- Markdown Preview for live preview
    use {
        'iamcco/markdown-preview.nvim',
        run = "call mkdp#util#install()",
        ft = 'markdown'
    }

    -- Plugin for calculating average startup time
    use {
        'tweekmonster/startuptime.vim',
        cmd = 'StartupTime'
    }

    -- statusline plugin
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = [[require'plugins.lualine']]
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
