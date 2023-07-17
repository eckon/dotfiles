local M = {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup()
    end,
    init = function()
      local bind_map = require("eckon.utils").bind_map
      local nmap = function(lhs, rhs, desc)
        bind_map("n")(lhs, rhs, { desc = "Git: " .. desc })
      end

      -- stylua: ignore start
      nmap("<Leader>gb", function() require("gitsigns").blame_line({ full = true }) end, "Open git blame")
      nmap("<Leader>gu", function() require("gitsigns").undo_stage_hunk() end, "Unstage hunk")
      nmap("<Leader>gs", function() require("gitsigns").stage_hunk() end, "Stage hunk")

      bind_map("v")("<Leader>gs", function()
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Git: Stage visual hunk" })

      nmap("]c", function()
        require("gitsigns").next_hunk()
        vim.schedule(function() vim.api.nvim_feedkeys("zz", "n", false) end)
      end, "Jump to next git hunk")

      nmap("[c", function()
        require("gitsigns").prev_hunk()
        vim.schedule(function() vim.api.nvim_feedkeys("zz", "n", false) end)
      end, "Jump to previous git hunk")
      -- stylua: ignore end
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
      require("eckon.utils").bind_map("n")("<Leader>gg", function()
        require("neogit").open({})
      end, { desc = "Neogit: Open" })
    end,
  },
}

return M
