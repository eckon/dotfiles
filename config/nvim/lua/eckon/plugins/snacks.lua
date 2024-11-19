return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      bigfile = {
        enabled = true,
        setup = function(ctx)
          vim.schedule(function()
            -- always disable syntax for big files just to be sure
            vim.bo[ctx.buf].syntax = "off"
          end)
        end,
      },
      notifier = { enabled = true },
      styles = {
        blame_line = { width = 0.9, height = 0.9 },
        notification = { wo = { wrap = true } },
        ["notification.history"] = { width = 0.9, height = 0.9 },
      },
    })
  end,
  init = function()
    local cc = require("eckon.custom-command").custom_command

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
  end,
}
