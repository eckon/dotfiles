if require("eckon.utils").run_minimal() then
  -- increase performance by even disabling syntax highlighting
  vim.cmd([[ syntax off ]])
  return {}
end

local M = {
  "nvim-treesitter/nvim-treesitter",
  event = "BufReadPost",
  build = ":TSUpdate",
  dependencies = { "Wansmer/treesj" },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      ensure_installed = "all",
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          if vim.api.nvim_buf_line_count(bufnr) < 10000 then
            return false
          end

          vim.notify("Stopped Treesitter (file too big)")
          return true
        end,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<S-CR>",
          node_decremental = "<BS>",
        },
      },
    })

    require("treesj").setup({ use_default_keymaps = false })
  end,
  init = function()
    require("eckon.utils").bind_map("n")("s", function()
      require("treesj").toggle()
    end, { desc = "Treesj: Toggle split/join" })
  end,
}

return M
