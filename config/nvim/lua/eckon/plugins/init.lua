return {
  -- General
  { 'tpope/vim-sleuth', event = 'VeryLazy' },
  { 'kylechui/nvim-surround', event = 'VeryLazy', config = function() require('nvim-surround').setup() end },
  { 'numToStr/Comment.nvim', event = 'VeryLazy', config = function() require('Comment').setup() end },

  -- Styling/Appearance/Special
  { 'tmux-plugins/vim-tmux-focus-events', event = 'VeryLazy' },
  {
    'navarasu/onedark.nvim',
    lazy = false,
    config = function()
      require('onedark').setup({ style = 'warmer' })
      require('onedark').load()
    end,
  },
}
