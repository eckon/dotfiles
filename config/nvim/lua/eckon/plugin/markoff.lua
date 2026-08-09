-- TODO: use public repo when available
-- NOTE: add to runtime for quick local testing/developing
vim.opt.runtimepath:append(vim.fn.expand("~/Development/personal/markoff.nvim"))

local cc = require("eckon.helper.custom-command").custom_command
local map = require("eckon.helper.utils").bind_map

local markoff = require("markoff")

markoff.setup({ file = { todo = "~/Documents/notes/todo.md" } })

map("n")("m", markoff.toggle)

cc.add("Markoff List", {
  desc = "Show all open TODOs in a picker",
  callback = markoff.toggle,
})
