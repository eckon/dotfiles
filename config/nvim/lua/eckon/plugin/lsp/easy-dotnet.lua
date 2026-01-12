vim.pack.add({
  "https://github.com/GustavEikaas/easy-dotnet.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
})

---Check if current directory is a .NET repository
---Requires being inside a git repository
---@return boolean
local function is_dotnet_repo()
  -- Must be in a git repository
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
  if not git_root or git_root == "" then
    return false
  end

  -- Check for .sln files in git root
  local sln_files = vim.fn.glob(git_root .. "/*.sln", false, true)
  if #sln_files > 0 then
    return true
  end

  return false
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
