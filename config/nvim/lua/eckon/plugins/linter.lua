local M = {
  "mfussenegger/nvim-lint",
  lazy = true,
  config = function()
    require("lint").linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      lua = { "selene" },
      markdown = { "markdownlint" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }
  end,
  init = function()
    require("eckon.mason-helper").ensure_package_installed.add({
      "eslint_d",
      "markdownlint",
      "selene",
    })

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
