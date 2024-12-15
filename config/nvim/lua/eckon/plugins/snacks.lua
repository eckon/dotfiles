local cc = require("eckon.custom-command").custom_command

local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.utils").augroup("snacks")

local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      -- way of ignoring many plugins on big files, see bigfiles filetype
      bigfile = {
        enabled = true,
        setup = function(ctx)
          vim.schedule(function()
            -- always disable syntax for big files just to be sure
            vim.bo[ctx.buf].syntax = "off"
          end)
        end,
      },
      -- pretty toast like notifications
      notifier = { enabled = true },
      -- enhanced statusline
      statuscolumn = { enabled = true },
      -- indent guide (without text objects)
      indent = {
        enabled = true,
        indent = { only_scope = true, only_current = true },
      },
      -- text objects for indentation (ii, ai and [i, ]i)
      scope = { enabled = true, cursor = false },
      styles = {
        blame_line = { width = 0.9, height = 0.9 },
        notification = { wo = { wrap = true } },
        ["notification.history"] = { width = 0.9, height = 0.9 },
      },
    })
  end,
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.print = function(...)
      require("snacks.debug").inspect(...)
    end
  end,
}

cc.add("Browser", {
  desc = "Open buffer in browser",
  callback = "lua Snacks.gitbrowse()",
})

cc.add("GitLog", {
  desc = "Open Git log/blame",
  callback = "lua Snacks.git.blame_line()",
})

cc.add("ShowNotifications", {
  desc = "Open all previous `vim.notify` messages",
  callback = "lua Snacks.notifier.show_history()",
})

autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    require("snacks.rename").on_rename_file(event.data.from, event.data.to)
  end,
  group = augroup,
})

local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
autocmd("User", {
  pattern = "NvimTreeSetup",
  callback = function()
    local events = require("nvim-tree.api").events
    events.subscribe(events.Event.NodeRenamed, function(data)
      if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
        data = data
        require("snacks.rename").on_rename_file(data.old_name, data.new_name)
      end
    end)
  end,
  group = augroup,
})

return M
