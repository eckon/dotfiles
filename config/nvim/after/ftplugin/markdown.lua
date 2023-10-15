vim.opt_local.spell = true

vim.opt_local.colorcolumn = ""
vim.opt_local.conceallevel = 2
vim.opt_local.listchars:append({ tab = "  " })

vim.opt_local.wrap = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

-- todo highlight is ugly so ill overwrite it for now (probably should be done differently)
vim.api.nvim_set_hl(0, "@text.todo", { link = "Question" })

require("eckon.utils").bind_map({ "n", "v" })("S", function()
  local positions = require("eckon.utils").get_visual_selection()
  local range = positions.visual_start.row .. "," .. positions.visual_end.row
  local toggle_checkbox = "s/\\v(\\[[ xX]])/\\=submatch(1) == '[ ]' ? '[x]' : '[ ]'/ge"

  local restore_cursor = require("eckon.utils").save_cursor_position()

  vim.api.nvim_command(":" .. range .. toggle_checkbox)
  vim.api.nvim_command("nohlsearch")

  restore_cursor()
end, { desc = "Toggle checkbox", buffer = true, silent = true })

-- notetaking specific part, if not notetaking then ignore
if vim.fn.isdirectory(vim.fn.getcwd() .. "/daily") == 0 then
  return
end

require("eckon.utils").custom_command.add("DailyNote", {
  desc = "Open searched daily note",
  callback = function()
    vim.ui.input({ prompt = "Search for daily note" }, function(input)
      -- CTRL-C will return, CR will give empty string which defaults to today
      if input == nil then
        return
      end

      -- if year is longer than a normal year string 1234 then we have an error
      local year = vim.fn.system({ "date", "+%Y", "-d", input }):gsub("\n", "")
      if #year > 4 then
        vim.notify("Could not find date: " .. year)
        return
      end

      local month = vim.fn.system({ "date", "+%m-%B", "-d", input }):gsub("\n", "")
      local date = vim.fn.system({ "date", "+%Y-%m-%d", "-d", input }):gsub("\n", "")
      local day = vim.fn.system({ "date", "+%A", "-d", input }):gsub("\n", "")

      -- create date in format: 2023/01-January/2023-01-01
      local file_path = "daily/" .. year .. "/" .. month .. "/" .. date .. ".md"
      if vim.fn.filereadable(file_path) == 0 then
        vim.fn.mkdir(vim.fn.fnamemodify(file_path, ":h"), "p")
        vim.fn.writefile({
          "# " .. date .. " (" .. day .. ")",
          "",
          "## work",
          "### daily",
          "",
          "## private",
        }, file_path)
      end

      vim.cmd("e " .. file_path)
    end)
  end,
})
