vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

-- NOTE: tools are installed via mise (`config/mise/config.toml`)
require("lint").linters_by_ft = {
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  lua = { "selene" },
  markdown = { "rumdl" },
  python = { "ruff" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
}

-- NOTE: rumdl writes its json output to stdout, but the nvim-lint default reads from stderr
require("lint").linters.rumdl.stream = "stdout"

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
  desc = "Try linting on save or open",
  callback = function()
    require("lint").try_lint()
  end,
  group = require("eckon.helper.utils").augroup("linter"),
})
