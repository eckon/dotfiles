local custom_command = require("eckon.utils").custom_command
local bind_map = require("eckon.utils").bind_map

vim.opt_local.spell = true

vim.opt_local.colorcolumn = ""
vim.opt_local.conceallevel = 2
vim.opt_local.listchars:append({ tab = "  " })

vim.opt_local.wrap = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

bind_map({ "n", "v" })(
  "S",
  ":s/\\v(\\[[ xX]])/\\=submatch(1) == '[ ]' ? '[x]' : '[ ]'/g<CR>",
  { desc = "Toggle checkbox", buffer = true }
)

-- notetaking specific part, if not notetaking then ignore
if vim.fn.isdirectory(vim.fn.getcwd() .. "/daily") == 0 then
  return
end

custom_command.add("DailyNote", {
  desc = "Open todays daily note",
  callback = function()
    -- create date in format: 2023/01-January/2023-01-01
    local date_structure = os.date("%Y/%m-%B/%Y-%m-%d")
    local file_path = "daily/" .. date_structure .. ".md"

    if vim.fn.filereadable(file_path) == 0 then
      vim.fn.writefile({
        "# " .. os.date("%Y-%m-%d"),
        "",
        "## work",
        "### daily",
        "",
        "## private",
      }, file_path)
    end

    vim.cmd("e " .. file_path)
  end,
})
