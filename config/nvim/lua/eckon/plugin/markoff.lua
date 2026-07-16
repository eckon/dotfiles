-- TODO: use public repo when available
vim.pack.add({ { src = "~/Development/personal/markoff.nvim" } })

local cc = require("eckon.helper.custom-command").custom_command

require("markoff").setup({
  todo_file = vim.fn.expand("~/Documents/notes/todo.md"),

  on_attach = function(buf, api)
    local nmap = require("eckon.helper.utils").bind_map("n", { buffer = buf })

    nmap("td", api.mark_done,      { desc = "Markoff: mark done" })
    nmap("tx", api.mark_cancelled, { desc = "Markoff: mark cancelled" })
    nmap("tp", api.set_priority,   { desc = "Markoff: set priority" })
    nmap("tc", api.set_context,    { desc = "Markoff: set context" })
    nmap("tn", api.new_entry,      { desc = "Markoff: new entry" })
  end,
})

local markoff = require("markoff")

cc.add("Markoff Agenda", {
  desc = "Show all open TODOs in a picker",
  callback = markoff.agenda,
})

cc.add("Markoff Agenda Context", {
  desc = "Show open TODOs filtered by a selected context",
  callback = markoff.agenda_context,
})
