vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  -- NOTE: manual installation is needed
  formatters_by_ft = {
    ["_"] = { "trim_whitespace" },
    javascript = { "prettierd", "eslint_d" },
    javascriptreact = { "prettierd", "eslint_d" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    lua = { "stylua" },
    markdown = { "prettierd", "markdownlint" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    typescript = { "prettierd", "eslint_d" },
    typescriptreact = { "prettierd", "eslint_d" },
    yaml = { "prettierd" },
  },
})

local nmap = require("eckon.helper.utils").bind_map("n")

-- `gq` with `formatexpr` is making some problems so for now I`ll overwrite it with whole format formatting
nmap("gq", function()
  require("conform").format({ lsp_fallback = true, async = true })
end, { desc = "Conform: Format whole buffer" })

-- overwrite ex-mode `gQ` with conform
nmap("gQ", function()
  require("conform").format({ lsp_fallback = true, async = true })
end, { desc = "Conform: Format whole buffer" })
