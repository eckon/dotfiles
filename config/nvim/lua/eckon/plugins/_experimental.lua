local nnoremap = require("eckon.utils").nnoremap

local M = {
  -- {
  --   "",
  --   dependencies = {},
  --   config = function() end,
  --   init = function() end,
  -- },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    config = function()
      require("oil").setup({
        keymaps = {
          ["<TAB>"] = "actions.preview",
          ["q"] = "actions.close",
          ["<BS>"] = "actions.parent",
        },
        view_options = { show_hidden = true },
      })
    end,
    init = function()
      nnoremap("<Leader>fe", function()
        require("oil").open()
      end, { desc = "Open File Explorer" })
    end,
  },
}

return M
