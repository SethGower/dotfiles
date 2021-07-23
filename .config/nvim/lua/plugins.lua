local use = require('packer').use
return require('packer').startup(function()
  use 'wbthomason/packer.nvim'          -- packer manages itself
  use 'SirVer/ultisnips'                -- Snippets from Ultisnips
  use 'honza/vim-snippets'              -- default snippets for Ultisnips
  use 'vim-airline/vim-airline'         -- airline status line
  use 'windwp/nvim-autopairs'           -- auto pairs for certain characters
  use 'junegunn/vim-easy-align'         -- better alignment
  use 'tpope/vim-commentary'            -- comments lines with motions
  use 'airblade/vim-rooter'             -- changes CWD to root of project
  use 'tpope/vim-fugitive'              -- git commands in vim
  use 'kshenoy/vim-signature'           -- adds markers to the sign column
  use 'moll/vim-bbye'                   -- better buffer deletion
  use 'aymericbeaumet/vim-symlink'      -- read symlinks for pwd
  use 'nvim-treesitter/nvim-treesitter' -- treesitter interface for vim
  use 'neovim/nvim-lspconfig'           -- LSP configuration for built in LSP
  use 'kosayoda/nvim-lightbulb'         -- Lightbulb icon for code actions
  use 'gennaro-tedesco/nvim-jqx'        -- Easily navigate json trees
  use 'ray-x/lsp_signature.nvim'        -- Adds signature help in a popup for functions with info from LSP

  -- Better matchit. Matching beginning and ends of branched statements (if,
  -- for, etc)
  use {
    'andymass/vim-matchup',
    config = function()
      vim.g.matchup_matchparen_offscreen = {} -- disables the showing match offscreen. This was annoying
    end
  }

  -- Using ALE specifically for Matlab and mlint, since the mlint plugin was
  -- buggy
  use {
    'dense-analysis/ale',
    ft = {'matlab'},
    config = function()
      vim.g.ale_linters = {matlab = {'mlint'}}
      vim.g.ale_linters_explicit = true
      vim.cmd[[ALEEnable]]
    end
  }

  -- Dispatch adds better background compilation than :make
  use {
    'tpope/vim-dispatch',
    cmd = {'Make', 'Dispatch', 'Start'}
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
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  -- git interface stuff for nvim. Mainly for git blame
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
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
    requires = {'Shougo/deoplete.nvim'}
  }

  -- VimTeX for better development of LaTeX
  use {
    'lervag/vimtex',
    ft= 'tex',
    opt=true
  }

  -- VHDL plugin for copying and pasting entities and such
  use {
    'JPR75/vip',
    ft='vhdl',
    opt=true
  }

  -- Dracula colorscheme https://draculatheme.com/
  use {
    'dracula/vim',
    as='dracula'
  }

  -- Tree Sitter extensions
  use {
    'p00f/nvim-ts-rainbow',           -- Adds rainbow parentheses based on tree sitter
    'windwp/nvim-ts-autotag',         -- Auto close tags with tree sitter
    'romgrk/nvim-treesitter-context', -- Provide context from tree-sitter
    'nvim-treesitter/playground',     -- Playground for tree-sitter

    requires = {'nvim-treesitter/nvim-treesitter'}
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

end)
