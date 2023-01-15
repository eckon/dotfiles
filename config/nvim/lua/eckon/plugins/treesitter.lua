local M = {
  "nvim-treesitter/nvim-treesitter",
  event = "BufReadPost",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-context" },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- more startuptime with `all` setting, but can be ignored for now
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

    require("treesitter-context").setup()
  end,
}

return M
