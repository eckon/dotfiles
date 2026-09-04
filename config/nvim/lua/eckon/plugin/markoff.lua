-- TODO: use public repo when available
-- NOTE: add to runtime for quick local testing/developing
local markoff_path = vim.fn.expand("~/Development/personal/markoff.nvim")

-- only a local checkout, so skip everything instead of breaking the rest of the plugin setup
if not vim.uv.fs_stat(markoff_path) then
  return
end

vim.opt.runtimepath:append(markoff_path)

local cc = require("eckon.helper.custom-command").custom_command
local map = require("eckon.helper.utils").bind_map

local markoff = require("markoff")

markoff.setup({ file = { todo = "~/Documents/notes/todo.md" } })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markoff_picker",
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
  group = require("eckon.helper.utils").augroup("markoff"),
})

map("n")("m", markoff.toggle)

cc.add("Markoff List", {
  desc = "Show all open TODOs in a picker",
  callback = markoff.toggle,
})
