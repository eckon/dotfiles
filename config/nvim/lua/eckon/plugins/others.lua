return {
  {
    "kylechui/nvim-surround",
    event = "BufReadPre",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "stevearc/quicker.nvim",
    config = function()
      require("quicker").setup()
    end,
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    config = function()
      local custom_config = {
        heading = { backgrounds = { "DiffChange" } },
        checkbox = {
          unchecked = { highlight = "DiagnosticOk" },
          checked = { highlight = "DiagnosticInfo" },
          custom = {
            todo = { raw = "[-]", rendered = "󰥔 ", highlight = "DiagnosticWarn" },
            canceled = { raw = "[/]", rendered = "󰜺 ", highlight = "DiagnosticError" },
          },
        },
        bullet = { highlight = "DiagnosticHint" },
      }

      require("render-markdown").setup(custom_config)
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
