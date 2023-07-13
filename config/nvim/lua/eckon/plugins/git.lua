local nnoremap = require("eckon.utils").nnoremap
local vnoremap = require("eckon.utils").vnoremap

local M = {
  {
    "tpope/vim-fugitive",
    event = "BufReadPre",
    cmd = "G",
    enabled = false,
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
      require("gitsigns").setup()
    end,
    init = function()
      nnoremap("<Leader>gb", function()
        require("gitsigns").blame_line({ full = true })
      end, { desc = "Open git blame" })

      nnoremap("<Leader>gs", function()
        require("gitsigns").stage_hunk()
      end, { desc = "Stage hunk" })

      vnoremap("<Leader>gs", function()
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage visual hunk" })

      nnoremap("<Leader>gu", function()
        require("gitsigns").undo_stage_hunk()
      end, { desc = "Unstage hunk" })

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
  {
    "NeogitOrg/neogit",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "sindrets/diffview.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
    },
    cmd = "Neogit",
    config = function()
      require("neogit").setup({ integrations = { diffview = true } })
    end,
    init = function()
      nnoremap("<Leader>gg", function()
        require("neogit").open({})
      end, { desc = "Open neogit" })
    end,
  },
}

return M
