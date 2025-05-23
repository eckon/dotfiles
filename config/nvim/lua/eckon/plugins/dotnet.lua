-- maybe also add other specific dotnet stuff here?
-- would be nice if i could have language specifc parts in its own (looking at ts etc)
local M = {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("easy-dotnet").setup()
  end,
}

return M
