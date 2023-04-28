local M = {
  "echasnovski/mini.nvim",
  event = "BufReadPre",
  version = false,
  config = function()
    require("mini.comment").setup()
    -- this also has ii/ai text objects
    require("mini.indentscope").setup()
    require("mini.pairs").setup()
  end,
}

return M
