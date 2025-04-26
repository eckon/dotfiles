local cc = require("eckon.custom-command").custom_command

local M = {
  "MagicDuck/grug-far.nvim",
  config = function()
    require("grug-far").setup({
      startInInsertMode = false,
      windowCreationCommand = "tab split",
    })
  end,
}

cc.add("Search & Replace", {
  desc = "Open advanced search & replace via grug-far",
  callback = function()
    require("grug-far").open()
  end,
})

return M
