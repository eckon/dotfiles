return {
  -- General
  { "tpope/vim-sleuth" },
  {
    "kylechui/nvim-surround",
    event = "BufReadPre",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "echasnovski/mini.nvim",
    event = "BufReadPre",
    version = false,
    config = function()
      require("mini.comment").setup()
      -- this also has ii/ai text objects
      require("mini.indentscope").setup({
        draw = {
          animation = require("mini.indentscope").gen_animation.linear({ duration = 5 }),
        },
      })
    end,
  },

  -- Styling/Appearance/Special
  { "tmux-plugins/vim-tmux-focus-events" },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoQuickFix", "TodoTelescope" },
    event = "BufReadPost",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({ signs = false })
    end,
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({ input = { insert_only = false } })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
