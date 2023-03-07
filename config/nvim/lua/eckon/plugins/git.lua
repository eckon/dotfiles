local nnoremap = require("eckon.utils").nnoremap

local M = {
  {
    "tpope/vim-fugitive",
    event = "BufReadPre",
    cmd = "G",
    init = function()
      nnoremap("<Leader>gg", "<CMD>tab G<CR>", { desc = "Open fugitive buffer" })
      nnoremap("<Leader>gd", "<CMD>Gdiffsplit!<CR>", { desc = "Open git diff split" })
      nnoremap("<Leader>gh", "<CMD>0GcLog<CR>", { desc = "Open git history quickfix" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({ keymaps = {} })
    end,
    init = function()
      nnoremap("<Leader>gb", function()
        require("gitsigns").blame_line({ full = true })
      end, { desc = "Open git blame" })

      nnoremap("]c", function()
        require("gitsigns").next_hunk()
        vim.schedule(function()
          vim.api.nvim_feedkeys("zz", "n", false)
        end)
      end, { desc = "Jump to next git hunk" })

      nnoremap("[c", function()
        require("gitsigns").prev_hunk()
        vim.schedule(function()
          vim.api.nvim_feedkeys("zz", "n", false)
        end)
      end, { desc = "Jump to previous git hunk" })
    end,
  },
}

return M
