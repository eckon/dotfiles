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
        size = 1.5 * 1024 * 1024, -- size check - 1.5MB
        line_length = 500, -- average line length check, to handle minified files
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
      -- enhanced vim.ui.input
      input = { enabled = true },
      picker = {
        enabled = true,
        layout = {
          preset = function()
            return vim.o.columns >= 120 and "ivy" or "ivy_split"
          end,
        },
        matcher = { frecency = true },
      },
      styles = {
        ---@diagnostic disable-next-line: missing-fields
        blame_line = { width = 0.9, height = 0.9 },
        ---@diagnostic disable-next-line: missing-fields
        notification = { wo = { wrap = true } },
        ---@diagnostic disable-next-line: missing-fields
        ["notification.history"] = { width = 0.9, height = 0.9 },
        -- make vim.ui.input handle like any other buffer (esc to normal mode, esc again to close)
        ---@diagnostic disable-next-line: missing-fields
        input = {
          keys = {
            i_esc = { "<esc>", "stopinsert", mode = "i" },
            n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n" },
          },
        },
      },
    })
  end,
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.print = function(...)
      require("snacks").debug.inspect(...)
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("snacks").input.input(...)
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("snacks").picker.select(...)
    end

    local nmap = require("eckon.utils").bind_map("n")
    nmap("<TAB><TAB>", function()
      require("snacks").picker.pick()
    end, { desc = "snacks picker" })
  end,
}

cc.add("Browser", {
  desc = "Open buffer in browser",
  callback = "lua Snacks.gitbrowse()",
})

cc.add("Git Log", {
  desc = "Open Git log/blame",
  callback = "lua Snacks.git.blame_line()",
})

cc.add("Show Notifications", {
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
