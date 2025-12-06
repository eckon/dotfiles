local cc = require("eckon.helper.custom-command").custom_command

vim.pack.add({
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-mini/mini.nvim",
})

require("mini.icons").setup()

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

  -- enhanced statuscolumn (merge relative/current-line, handle folds, handle git changes, etc.)
  statuscolumn = { enabled = true },

  -- enhanced vim.ui.input (mainly for rename action etc. to use vim motion in there)
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
  },
})

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
  callback = function()
    require("snacks").picker.pick()
  end,
})

cc.add("Browser", {
  desc = "Open buffer in browser",
  callback = function()
    require("snacks").gitbrowse()
  end,
})

cc.add("Git Log", {
  desc = "Open Git log/blame",
  callback = function()
    require("snacks").git.blame_line()
  end,
})
