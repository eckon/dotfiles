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
      require("kanagawa").setup({
        overrides = function()
          return {
            -- update kanagawa to handle new treesitter highlight captures
            -- change color theme in case this is not being added in the future
            ["@string.regexp"] = { link = "@string.regex" },
            ["@variable.parameter"] = { link = "@parameter" },
            ["@exception"] = { link = "@exception" },
            ["@string.special.symbol"] = { link = "@symbol" },
            ["@markup.strong"] = { link = "@text.strong" },
            ["@markup.italic"] = { link = "@text.emphasis" },
            ["@markup.heading"] = { link = "@text.title" },
            ["@markup.raw"] = { link = "@text.literal" },
            ["@markup.quote"] = { link = "@text.quote" },
            ["@markup.math"] = { link = "@text.math" },
            ["@markup.environment"] = { link = "@text.environment" },
            ["@markup.environment.name"] = { link = "@text.environment.name" },
            ["@markup.link.url"] = { link = "Special" },
            ["@markup.link.label"] = { link = "Identifier" },
            ["@comment.note"] = { link = "@text.note" },
            ["@comment.warning"] = { link = "@text.warning" },
            ["@comment.danger"] = { link = "@text.danger" },
            ["@diff.plus"] = { link = "@text.diff.add" },
            ["@diff.minus"] = { link = "@text.diff.delete" },
          }
        end,
      })

      vim.cmd("colorscheme kanagawa")
    end,
  },
}
