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
    config = function() require("gitsigns").setup({ keymaps = {} }) end,
    init = function()
      nnoremap(
        "<Leader>gb",
        function() require("gitsigns").blame_line({ full = true }) end,
        { desc = "Open git blame" }
      )

      nnoremap("]c", "<CMD>Gitsigns next_hunk<CR>zz", { desc = "Next git hunk" })
      nnoremap("[c", "<CMD>Gitsigns prev_hunk<CR>zz", { desc = "Previous git hunk" })
    end,
  },
}

return M
