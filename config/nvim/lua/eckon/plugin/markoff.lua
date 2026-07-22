-- TODO: use public repo when available
-- NOTE: add to runtime for quick local testing/developing
vim.opt.runtimepath:append(vim.fn.expand("~/Development/personal/markoff.nvim"))

local cc = require("eckon.helper.custom-command").custom_command

local markoff = require("markoff")

markoff.setup({
  todo_file = vim.fn.expand("~/Documents/notes/todo.md"),
  archive_file = vim.fn.expand("~/Documents/notes/archive.md"),

  picker = { quit_on_last_buffer = true },

  on_attach = function(buf, api)
    local nmap = require("eckon.helper.utils").bind_map("n", { buffer = buf })
    nmap("<C-o>", api.open_list_last, { desc = "Markoff: open last" })
  end,
})

cc.add("Markoff List", {
  desc = "Show all open TODOs in a picker",
  callback = markoff.open_list,
})
