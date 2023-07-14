local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup("eckon_autogroup_linter", {})

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
    autocmd({ "BufWritePost", "BufReadPost" }, {
      desc = "Try linting on save or open",
      callback = function()
        require("lint").try_lint()
      end,
      group = autogroup,
    })
  end,
}

return M
