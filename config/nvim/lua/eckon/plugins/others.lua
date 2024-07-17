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
    "MeanderingProgrammer/markdown.nvim",
    config = function()
      require("render-markdown").setup({
        heading = { backgrounds = { "DiffChange" } },
        checkbox = {
          unchecked = { highlight = "DiagnosticOk" },
          checked = { highlight = "Comment" },
          custom = {
            todo = { raw = "[-]", rendered = "󰥔 ", highlight = "DiagnosticWarn" },
            canceled = { raw = "[/]", rendered = "󰜺 ", highlight = "DiagnosticError" },
          },
        },
        bullet = { highlight = "DiagnosticHint" },
      })
    end,
  },
  {
    -- improved vim.ui
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
