vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  -- NOTE: tools are installed via mise (`config/mise/config.toml`)
  formatters_by_ft = {
    ["_"] = { "trim_whitespace" },
    cs = { "easy_dotnet" }, -- NOTE: this is bare-bones, also manually run `dotnet format`
    css = { "prettierd" },
    javascript = { "prettierd", "eslint_d" },
    javascriptreact = { "prettierd", "eslint_d" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    lua = { "stylua" },
    markdown = { "rumdl" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    sh = { "shfmt" },
    toml = { "taplo" },
    typescript = { "prettierd", "eslint_d" },
    typescriptreact = { "prettierd", "eslint_d" },
    yaml = { "prettierd" },
  },
})

local nmap = require("eckon.helper.utils").bind_map("n")

-- `gq` with `formatexpr` is making some problems so for now I'll overwrite it with whole format formatting
nmap("gq", function()
  require("conform").format({ lsp_format = "fallback", async = true })
end, { desc = "Conform: Format whole buffer" })
