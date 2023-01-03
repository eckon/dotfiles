return {
  -- General
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "kylechui/nvim-surround", event = "VeryLazy", config = function() require("nvim-surround").setup() end },
  { "numToStr/Comment.nvim", event = "VeryLazy", config = function() require("Comment").setup() end },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
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
  { "tmux-plugins/vim-tmux-focus-events", event = "VeryLazy" },
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
