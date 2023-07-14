local M = {
  "mhartington/formatter.nvim",
  cmd = "Format",
  config = function()
    require("formatter").setup({
      filetype = {
        lua = { require("formatter.filetypes.lua").stylua },
        typescript = {
          require("formatter.filetypes.typescript").prettierd,
          require("formatter.filetypes.typescript").eslint_d,
        },
        javascript = {
          require("formatter.filetypes.javascript").prettierd,
          require("formatter.filetypes.javascript").eslint_d,
        },
        json = { require("formatter.filetypes.json").prettierd },
        ["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
      },
    })
  end,
  init = function()
    require("eckon.utils").bind_map("n")("<Leader>lf", "<CMD>Format<CR>", { desc = "Formatter: Run in buffer" })
  end,
}

return M
