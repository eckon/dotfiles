vim.pack.add({
  "https://github.com/GustavEikaas/easy-dotnet.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
})

-- NOTE: needs `dotnet tool install -g EasyDotnet` and in path
--       so when switching dotnet version, i might need to reinstall it
local dotnet = require("easy-dotnet")

dotnet.setup({
  test_runner = {
    viewmode = "split",
  },
})

local cc = require("eckon.helper.custom-command").custom_command

-- TODO: can we add it only in dotnet repos (the is_dotnet, method does in the plugin always returns true)
cc.add("Dotnet", {
  desc = "Open Easy Dotnet picker",
  callback = "Dotnet",
})

cc.add("Dotnet Testrunner", {
  desc = "Open Easy Dotnet Testrunner",
  callback = function()
    dotnet.testrunner()
  end,
})
