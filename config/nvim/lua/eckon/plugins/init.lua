return {
  -- General
  { "tpope/vim-sleuth" },
  { "kylechui/nvim-surround", event = "BufReadPre", config = function() require("nvim-surround").setup() end },
  { "numToStr/Comment.nvim", event = "BufReadPre", config = function() require("Comment").setup() end },

  -- Styling/Appearance/Special
  { "tmux-plugins/vim-tmux-focus-events" },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoQuickFix", "TodoTelescope" },
    event = "BufReadPost",
    dependencies = "nvim-lua/plenary.nvim",
    config = function() require("todo-comments").setup({ signs = false }) end,
  },
  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup({ style = "warmer" })
      require("onedark").load()
    end,
  },
}
