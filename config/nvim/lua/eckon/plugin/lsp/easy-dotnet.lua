vim.pack.add({
  "https://github.com/GustavEikaas/easy-dotnet.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
})

---Check if current working directory or any subdirectory is a .NET repository
---@return boolean
local function is_dotnet_repo()
  local root = vim.fn.getcwd()

  -- Search for .sln or .csproj files recursively in all subdirectories
  local sln_files = vim.fn.glob(root .. "/**/*.sln", false, true)
  local csproj_files = vim.fn.glob(root .. "/**/*.csproj", false, true)

  return #sln_files > 0 or #csproj_files > 0
end

-- Only setup easy-dotnet if in a .NET repository
if not is_dotnet_repo() then
  return
end

-- NOTE: needs `dotnet tool install -g EasyDotnet` and in path
--       so when switching dotnet version, i might need to reinstall it
local dotnet = require("easy-dotnet")

dotnet.setup({
  test_runner = {
    viewmode = "split",
  },
})

local cc = require("eckon.helper.custom-command").custom_command

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
