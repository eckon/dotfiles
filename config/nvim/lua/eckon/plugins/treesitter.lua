if require("eckon.utils").run_minimal() then
  -- increase performance by even disabling syntax highlighting
  vim.cmd([[ syntax off ]])
  return {}
end

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = { enable = true },
      })
    end,
  },
}

return M
