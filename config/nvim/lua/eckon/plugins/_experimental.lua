local nnoremap = require("eckon.utils").nnoremap

local M = {
  {
    "echasnovski/mini.nvim",
    version = false,
    dependencies = {},
    config = function()
      require("mini.pairs").setup()
      require('mini.comment').setup()
      -- require('mini.surround').setup()
      -- this has ii/ai text objects
      -- NOTE: remove custom indent textobjects if this works well
      require('mini.indentscope').setup()
    end,
    -- init = function() end,
  },
}

return M
