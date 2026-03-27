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

---Check if the current buffer is git-related (commit, rebase, etc.)
---@return boolean
local function is_git_operation()
  local bufname = vim.api.nvim_buf_get_name(0)
  local filetype = vim.bo.filetype

  -- Check for git filetypes
  if filetype:match("^git") then
    return true
  end

  -- Check for common git buffer names
  if
    bufname:match("COMMIT_EDITMSG")
    or bufname:match("MERGE_MSG")
    or bufname:match("git%-rebase%-todo")
    or bufname:match("addp%-hunk%-edit%.diff")
  then
    return true
  end

  return false
end

-- Skip setup if in git operation
-- If not in a .NET repository, ask if user wants to set it up anyway
if not is_dotnet_repo() or is_git_operation() then
  return
end

-- NOTE: needs `dotnet tool install -g EasyDotnet`
--       and in path `ln -s ~/.dotnet/tools/dotnet-easydotnet ~/.local/bin/dotnet-easydotnet`
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
