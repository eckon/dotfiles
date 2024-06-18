local M = {
  "mfussenegger/nvim-lint",
  lazy = true,
  config = function()
    require("lint").linters_by_ft = {
      lua = { "selene" },
      typescript = { "eslint_d" },
      javascript = { "eslint_d" },
      markdown = { "markdownlint" },
    }
  end,
  init = function()
    require("eckon.mason-helper").ensure_package_installed.add({
      "selene",
      "eslint_d",
      "markdownlint",
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
