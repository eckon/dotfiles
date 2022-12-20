return {
  'tpope/vim-sleuth',
  { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end },
  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },

  -- Styling/Appearance/Special
  'tmux-plugins/vim-tmux-focus-events',
  {
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup({ style = 'warmer' })
      require('onedark').load()
    end,
  },
}
