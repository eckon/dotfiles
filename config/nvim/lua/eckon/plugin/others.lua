vim.pack.add({
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/MeanderingProgrammer/markdown.nvim",
  "https://github.com/rebelot/kanagawa.nvim",
})

require("nvim-surround").setup()

require("quicker").setup()

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

vim.cmd("colorscheme kanagawa")
