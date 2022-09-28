require('packer').startup(function(use)
  use('wbthomason/packer.nvim')
  use('lewis6991/impatient.nvim')

  -- General
  use('tpope/vim-sleuth')
  use({
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup()
    end,
  })

  use({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  })

  -- Navigation
  use({ 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' })
  use({
    { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' } },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  })

  -- Treesitter
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })

  -- LSP
  use('neovim/nvim-lspconfig')
  use({ 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' })
  use('jose-elias-alvarez/null-ls.nvim')
  use('j-hui/fidget.nvim')

  -- Completion
  use({
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
  })

  -- Git
  use('lewis6991/gitsigns.nvim')
  use({ 'sindrets/diffview.nvim', requires = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' } })

  -- Debugger
  use('mfussenegger/nvim-dap')
  use('theHamsta/nvim-dap-virtual-text')

  -- Notes
  use({ 'nvim-neorg/neorg', run = ':Neorg sync-parsers', requires = 'nvim-lua/plenary.nvim' })

  -- Syntax/Styling/Appearance/Special
  use('tmux-plugins/vim-tmux-focus-events')
  use({ 'nvim-lualine/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons' })
  use({
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup({ style = 'warmer' })
      require('onedark').load()
    end,
  })
end)
