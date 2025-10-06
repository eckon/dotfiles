local cc = require("eckon.helper.custom-command").custom_command

vim.pack.add({
  "https://github.com/folke/snacks.nvim",
  -- sub dependency
  "https://github.com/nvim-tree/nvim-web-devicons",
})

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

  -- enhanced vim.ui.select and be used as a picker for many things
  picker = {
    enabled = true,
    layout = { preset = "ivy_split" },
    matcher = { frecency = true },
    sources = {
      select = { layout = { preset = "vscode" } },
      pickers = { layout = { preset = "vscode" } },
      grep = { hidden = true, ignored = true },
      files = { hidden = true },
      buffers = { hidden = true },
    },
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

-- snacks.picker
local bind_map = require("eckon.helper.utils").bind_map
local nmap = function(lhs, rhs, desc)
  bind_map("n")(lhs, rhs, { desc = "Picker: " .. desc })
end

nmap("<Leader>ff", function()
  require("snacks").picker.files()
end, "Search files")

nmap("<Leader>fa", function()
  require("snacks").picker.grep({ regex = false })
end, "Grep files without regex")

nmap("<Leader>fA", function()
  require("snacks").picker.grep()
end, "Grep files with regex")

nmap("<Leader>fq", function()
  require("snacks").picker.qflist()
end, "Search quickfix list entries")

nmap("<Leader>fb", function()
  require("snacks").picker.buffers()
end, "Search open buffers")

nmap("<Leader>fg", function()
  require("snacks").picker.git_status()
end, "Search git changes")

nmap("<Leader>fh", function()
  require("snacks").picker.help()
end, "Search help")

-- continue with previous search
nmap("<Leader>fc", function()
  require("snacks").picker.resume()
end, "Resume")

nmap("<Leader>fr", function()
  require("snacks").picker.resume()
end, "Resume")

cc.add("Pickers", {
  desc = "Show all available picker",
  callback = "lua Snacks.picker.pick()",
})

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
