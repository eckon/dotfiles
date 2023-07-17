local M = {
  "mfussenegger/nvim-lint",
  lazy = true,
  config = function()
    require("lint").linters_by_ft = {
      lua = { "selene" },
      typescript = { "eslint_d" },
      javascript = { "eslint_d" },
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
