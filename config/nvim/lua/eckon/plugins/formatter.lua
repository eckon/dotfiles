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

    -- allow `gq` to format with conform
    vim.opt.formatexpr = "v:lua.require('conform').format()"
  end,
  init = function()
    require("eckon.mason-helper").ensure_package_installed.add({
      "stylua",
      "prettierd",
      "markdownlint",
      "eslint_d",
    })

    -- keep using `gq` for partial formats, and overwrite ex-mode `gQ` with conform
    require("eckon.utils").bind_map("n")("gQ", function()
      require("conform").format({ lsp_fallback = true, async = true })
    end, { desc = "Conform: Format whole buffer" })

    require("eckon.utils").bind_map("n")("<Leader>lf", function()
      vim.print("Use: `gq`/`gQ` instead")
    end, { desc = "Conform: Format buffer" })
  end,
}

return M
