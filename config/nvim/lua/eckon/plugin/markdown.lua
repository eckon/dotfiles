vim.pack.add({ "https://github.com/MeanderingProgrammer/markdown.nvim" })

require("render-markdown").setup({
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
})
