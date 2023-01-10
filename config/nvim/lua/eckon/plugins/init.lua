return {
  -- General
  { "tpope/vim-sleuth" },
  { "kylechui/nvim-surround", config = function() require("nvim-surround").setup() end },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  {
    "folke/which-key.nvim",
    config = function()
      local key = require("which-key")
      key.setup({ plugins = { spelling = { enabled = true } } })
      key.register({
        f = { name = "find" },
        g = { name = "git" },
        l = { name = "lsp" },
      }, { prefix = "<Leader>" })
    end,
  },

  -- Styling/Appearance/Special
  { "tmux-plugins/vim-tmux-focus-events" },
  { "karb94/neoscroll.nvim", event = "BufReadPre", config = function() require("neoscroll").setup() end },
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
