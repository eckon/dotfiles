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
    mappings = {
      -- References from defaults:
      -- run a test (in buffer or testrunner): `<leader>r`  (`t` for all in buffer or `R` for all as a whole)
      -- jump to file from testrunner:         `g`
      expand = { lhs = "<CR>", desc = "expand" },
      peek_stacktrace = { lhs = "?", desc = "peek stacktrace of failed test" },
    },
  },
  notifications = {
    -- use the new ui2 and do not keep printing progression messages, only one for start and one for end (which gets overwritten)
    handler = function(start_event)
      -- multiple processes get started, so only overwrite the message, that relates to each other
      local message_number = tostring(math.random(1000))
      vim.api.nvim_echo(
        { { start_event.job.name } },
        false,
        { id = message_number, kind = "progress", status = "running", title = "Dotnet" }
      )

      return function(finish_event)
        vim.api.nvim_echo(
          { { finish_event.result.msg } },
          false,
          { id = message_number, kind = "progress", status = "success", title = "Dotnet" }
        )
      end
    end,
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
