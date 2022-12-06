local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
end

local use = require('packer').use
return require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- packer manages itself
    use 'SirVer/ultisnips' -- Snippets from Ultisnips
    use 'honza/vim-snippets' -- default snippets for Ultisnips
    use 'vim-airline/vim-airline' -- airline status line
    use 'windwp/nvim-autopairs' -- auto pairs for certain characters
    use 'junegunn/vim-easy-align' -- better alignment
    use 'tpope/vim-commentary' -- comments lines with motions
    use 'tpope/vim-fugitive' -- git commands in vim
    use 'shumphrey/fugitive-gitlab.vim' -- gitlab provider for :GBrowse for fugitive
    use 'tpope/vim-rhubarb' -- github provider for :GBrowse for fugitive
    use 'kshenoy/vim-signature' -- adds markers to the sign column
    use 'moll/vim-bbye' -- better buffer deletion
    use 'aymericbeaumet/vim-symlink' -- read symlinks for pwd
    use 'gennaro-tedesco/nvim-jqx' -- Easily navigate json trees
    -- use 'github/copilot.vim'              -- Github Copilot
    use 'Numkil/ag.nvim' -- Silver Searcher
    use 'amal-khailtash/vim-xdc-syntax' -- Syntax highlighting for XDC files

    -- LSP configuration for built in LSP
    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('plugins.lsp')
        end
    }

    use {
        'adoyle-h/lsp-toggle.nvim', -- Toggle specific LSPs
        'ray-x/lsp_signature.nvim', -- Adds signature help in a popup for functions with info from LSP
        'kosayoda/nvim-lightbulb', -- Lightbulb icon for code actions
        requires = 'neovim/nvim-lspconfig'
    }


    use {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            require('plugins.null-ls')
        end,
        requires = 'neovim/nvim-lspconfig'
    } -- Null LS provides linting for linters that don't support LSP, adding for VSG, can use for others


    use {
        'shaunsingh/oxocarbon.nvim',
        run = './install.sh'
    }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    -- project management for neovim
    -- use {
    --     "ahmedkhalf/project.nvim",
    --     config = function()
    --         require("project_nvim").setup {
    --             patterns = {"^Makefile"},
    --             ignore_lsp = {"sumneko_lua"}
    --         }
    --     end
    -- }
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
        config = function()
            require("plugins.toggle-term")
        end
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
        config = function()
            require 'plugins.tree-sitter'
        end
    }

    use {
        { 'SethGower/nvim-ts-rainbow',
            branch = "adding-vhdl",
        }, -- Adds rainbow parentheses based on tree sitter
        'windwp/nvim-ts-autotag', -- Auto close tags with tree sitter
        'romgrk/nvim-treesitter-context', -- Provide context from tree-sitter
        'nvim-treesitter/playground', -- Playground for tree-sitter

        requires = { 'nvim-treesitter/nvim-treesitter' }
    }

    -- Better matchit. Matching beginning and ends of branched statements (if,
    -- for, etc)
    -- use {
    --   'andymass/vim-matchup',
    --   config = function()
    --     vim.g.matchup_matchparen_offscreen = {} -- disables the showing match offscreen. This was annoying
    --   end
    -- }

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
        }
    }
    use {
        'fhill2/telescope-ultisnips.nvim', -- Ultisnips extension for Telescope
        'olacin/telescope-gitmoji.nvim',
        requires = 'nvim-telescope/telescope.nvim'
    }

    -- Harpoon
    use {
        'ThePrimeagen/harpoon',
        requires = { { 'nvim-lua/plenary.nvim' } },
        config = function() require('telescope').load_extension('harpoon') end
    }


    use {
        'rmagatti/auto-session', -- Session management
        config = function() require 'plugins.auto-session' end

    }
    -- Session Lens for session and telescope cooperation
    use {
        'rmagatti/session-lens',
        requires = { 'rmagatti/auto-session', 'nvim-telescope/telescope.nvim' },
        config = function()
            require('session-lens').setup({
                path_display = { 'shorten' },
                previewer = true
            })
        end
    }
    -- git interface stuff for nvim. Mainly for git blame
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('plugins.git-signs')
        end
    }

    -- completion using deoplete
    use {
        'Shougo/deoplete.nvim',
        run = function() vim.cmd('UpdateRemotePlugins') end,
        config = function() vim.g['deoplete#enable_at_startup'] = 1 end
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
        opt = true
    }

    -- VHDL plugin for copying and pasting entities and such
    use {
        'JPR75/vip',
        ft = 'vhdl',
        opt = true
    }

    -- Dracula colorscheme https://draculatheme.com/
    use {
        'dracula/vim',
        as = 'dracula'
    }


    -- Glow for markdown previews
    use {
        'npxbr/glow.nvim',
        run = 'GlowInstall'
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

    if packer_bootstrap then
        require('packer').sync()
    end
end)
