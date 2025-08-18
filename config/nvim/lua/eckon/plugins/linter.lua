local M = {
  "mfussenegger/nvim-lint",
  lazy = true,

  config = function()
    -- NOTE: manual installation is needed
    require("lint").linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      lua = { "selene" },
      markdown = { "markdownlint" },
      python = { "ruff" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }
  end,

  init = function()
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
      desc = "Try linting on save or open",
      callback = function()
        require("lint").try_lint()
      end,
      group = require("eckon.utils").augroup("linter"),
    })
  end,
}

return M
