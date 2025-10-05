vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  formatters_by_ft = {
    ["_"] = { "trim_whitespace" },
    javascript = { "prettierd", "eslint_d" },
    javascriptreact = { "prettierd", "eslint_d" },
    json = { "prettierd" },
    lua = { "stylua" },
    markdown = { "prettierd", "markdownlint" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    typescript = { "prettierd", "eslint_d" },
    typescriptreact = { "prettierd", "eslint_d" },
    yaml = { "prettierd" },
  },
})

require("eckon.helper.utils").bind_map("n")("gq", function()
  require("conform").format({ lsp_fallback = true, async = true })
end, { desc = "Conform: Format whole buffer" })

require("eckon.helper.utils").bind_map("n")("gQ", function()
  require("conform").format({ lsp_fallback = true, async = true })
end, { desc = "Conform: Format whole buffer" })
