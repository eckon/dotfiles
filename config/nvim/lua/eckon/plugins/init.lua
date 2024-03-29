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
      require("mini.files").setup({ windows = { preview = true } })

      -- this also has ii/ai text objects
      require("mini.indentscope").setup({
        draw = { animation = require("mini.indentscope").gen_animation.linear({ duration = 5 }) },
      })

      -- this also shows lsp progress
      require("mini.notify").setup()
      vim.notify = require("mini.notify").make_notify()
    end,
    init = function()
      require("eckon.utils").bind_map("n")("<Leader>fe", function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0))
      end, { desc = "Mini: Open File Explorer" })
    end,
  },
  {
    "folke/flash.nvim",
    event = "BufReadPre",
    config = function()
      require("flash").setup({
        modes = {
          search = { enabled = false },
          char = { enabled = false },
        },
      })
    end,
    init = function()
      require("eckon.utils").bind_map({ "n", "o", "x" })("H", function()
        require("flash").jump()
      end, { desc = "Flash: Jump" })
    end,
  },

  -- Styling/Appearance/Special
  { "tmux-plugins/vim-tmux-focus-events" },
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
