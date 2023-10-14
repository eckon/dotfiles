local custom_command = require("eckon.utils").custom_command
local bind_map = require("eckon.utils").bind_map

vim.opt_local.spell = true

vim.opt_local.colorcolumn = ""
vim.opt_local.conceallevel = 2
vim.opt_local.listchars:append({ tab = "  " })

vim.opt_local.wrap = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

-- todo highlight is ugly so ill overwrite it for now (probably should be done differently)
vim.api.nvim_set_hl(0, "@text.todo", { link = "Question" })

bind_map({ "n", "v" })("S", function()
  local pos1, pos2 = vim.fn.line("."), vim.fn.line("v")
  if pos1 > pos2 then
    pos1, pos2 = pos2, pos1
  end

  local initial_cursor_position = vim.api.nvim_win_get_cursor(0)
  local toggle_checkbox = "s/\\v(\\[[ xX]])/\\=submatch(1) == '[ ]' ? '[x]' : '[ ]'/ge"
  vim.api.nvim_command(":" .. pos1 .. "," .. pos2 .. toggle_checkbox)
  vim.api.nvim_command("nohlsearch")
  vim.api.nvim_win_set_cursor(0, initial_cursor_position)
end, { desc = "Toggle checkbox", buffer = true, silent = true })

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
