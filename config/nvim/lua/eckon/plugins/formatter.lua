local M = {
  "stevearc/conform.nvim",
  event = "BufReadPre",

  config = function()
    require("conform").setup({
      -- NOTE: manual installation is needed
      formatters_by_ft = {
        lua = { "stylua" },
        markdown = { "prettierd", "markdownlint" },
        json = { "prettierd" },
        javascript = { "prettierd", "eslint_d" },
        javascriptreact = { "prettierd", "eslint_d" },
        typescript = { "prettierd", "eslint_d" },
        typescriptreact = { "prettierd", "eslint_d" },
        yaml = { "prettierd" },
        ["_"] = { "trim_whitespace" },
      },
    })
  end,

  init = function()
    -- `gq` with `formatexpr` is making some problems so for now I`ll overwrite it with whole format formatting
    require("eckon.utils").bind_map("n")("gq", function()
      require("conform").format({ lsp_fallback = true, async = true })
    end, { desc = "Conform: Format whole buffer" })

    -- overwrite ex-mode `gQ` with conform
    require("eckon.utils").bind_map("n")("gQ", function()
      require("conform").format({ lsp_fallback = true, async = true })
    end, { desc = "Conform: Format whole buffer" })
  end,
}

return M
