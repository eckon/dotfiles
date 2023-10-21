local M = {
  "stevearc/conform.nvim",
  event = "BufReadPre",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        markdown = { "prettierd", "markdownlint" },
        json = { "prettierd" },
        javascript = { "prettierd", "eslint_d" },
        typescript = { "prettierd", "eslint_d" },
        ["_"] = { "trim_whitespace" },
      },
    })
  end,
  init = function()
    require("eckon.utils").bind_map("n")("<Leader>lf", function()
      require("conform").format({ lsp_fallback = true, async = true })
    end, { desc = "Conform: Format buffer" })
  end,
}

return M
