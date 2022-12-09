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

    use {
        'lukas-reineke/indent-blankline.nvim',
        config = [[require'plugins.others'.indentline()]]
    }
    -- Snippets from Ultisnips
    use {
        'SirVer/ultisnips',
        config = [[require 'plugins.others'.ultisnips()]]
    }

    use 'honza/vim-snippets'         -- default snippets for Ultisnips
    use 'kshenoy/vim-signature'      -- adds markers to the sign column

    use {
        'junegunn/vim-easy-align',
        cmd = "EasyAlign"
    }
    use 'tpope/vim-commentary' -- comments lines with motions

    use {
        'tpope/vim-fugitive',
        cmd = { "G", "Gvdiffsplit", "Gvdiffsplit!", "GBrowse", "GBrowse!" }
    }

    use {
        'shumphrey/fugitive-gitlab.vim', -- gitlab provider for :GBrowse for fugitive
        after = 'vim-fugitive',
        cmd = { "GBrowse", "GBrowse!" }
    }

    use {
        'tpope/vim-rhubarb', -- github provider for :GBrowse for fugitive
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
    } -- auto pairs for certain characters
    use {
        'amal-khailtash/vim-xdc-syntax',
        ft = 'xdc'
    } -- Syntax highlighting for XDC files

    -- LSP configuration for built in LSP
    use {
        'neovim/nvim-lspconfig',
        config = [[require('plugins.lsp').setup()]]
    }

    use {
        'ray-x/lsp_signature.nvim', -- Adds signature help in a popup for functions with info from LSP
        'kosayoda/nvim-lightbulb', -- Lightbulb icon for code actions
        after = 'nvim-lspconfig'
    }

    use {
        'jose-elias-alvarez/null-ls.nvim',
        config = [[require('plugins.null-ls')]],
        after = 'nvim-lspconfig'
    } -- Null LS provides linting for linters that don't support LSP, adding for VSG, can use for others

    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        after = 'nvim-lspconfig',
        config = [[require'plugins.others'.trouble()]],
    }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        config = [[require("nvim-tree").setup()]],
        cmd = 'NvimTree*'
    }

    use {
        'ygm2/rooter.nvim',
        config = function()
            vim.g.rooter_pattern = { '.git', 'Makefile', '_darcs', '.hg', '.bzr', '.svn', 'node_modules',
                'CMakeLists.txt' }
            vim.g.outermost_root = true
        end
    }
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

    use {
        { 'SethGower/nvim-ts-rainbow',
            branch = "adding-vhdl",
        }, -- Adds rainbow parentheses based on tree sitter
        'windwp/nvim-ts-autotag', -- Auto close tags with tree sitter
        'romgrk/nvim-treesitter-context', -- Provide context from tree-sitter

        after = { 'nvim-treesitter' }
    }
    use {
        'nvim-treesitter/playground', -- Playground for tree-sitter
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }

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
        'fhill2/telescope-ultisnips.nvim', -- Ultisnips extension for Telescope
        requires = 'nvim-telescope/telescope.nvim',
        after = { 'telescope.nvim', 'ultisnips' }
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
        config = function()
            require 'plugins.auto-session'
        end,

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

    -- completion using deoplete
    use {
        'Shougo/deoplete.nvim',
        run = [[vim.cmd('UpdateRemotePlugins')]],
        config = [[vim.g['deoplete#enable_at_startup'] = 1]]
    }

    -- -- LSP completion source for deoplete
    use {
        'deoplete-plugins/deoplete-lsp',
        requires = { 'Shougo/deoplete.nvim' }
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

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = [[require'plugins.lualine']]
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
