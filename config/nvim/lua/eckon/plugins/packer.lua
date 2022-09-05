require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  -- General
  use('kylechui/nvim-surround')
  use('numToStr/Comment.nvim')
  use('tpope/vim-sleuth')

  -- Navigation
  use('kyazdani42/nvim-tree.lua')
  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
  })
  use('phaazon/hop.nvim')

  -- Treesitter
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })

  -- LSP
  use('neovim/nvim-lspconfig')
  use({ 'williamboman/mason.nvim', requires = { 'williamboman/mason-lspconfig.nvim' } })
  use('jose-elias-alvarez/null-ls.nvim')

  use('https://git.sr.ht/~whynothugo/lsp_lines.nvim')
  use('j-hui/fidget.nvim')

  -- Completion
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    },
  })

  -- Git
  use('lewis6991/gitsigns.nvim')
  use({ 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' })

  -- Debugger
  use('mfussenegger/nvim-dap')
  use('theHamsta/nvim-dap-virtual-text')

  -- Notes
  use({ 'nvim-neorg/neorg', requires = 'nvim-lua/plenary.nvim' })

  -- Syntax/Styling/Appearance/Special
  use('kyazdani42/nvim-web-devicons')
  use('lewis6991/impatient.nvim')
  use('navarasu/onedark.nvim')
  use('nvim-lualine/lualine.nvim')
  use('tmux-plugins/vim-tmux-focus-events')
end)
