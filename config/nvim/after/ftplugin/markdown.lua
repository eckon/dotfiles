vim.opt_local.spell = true

vim.opt_local.colorcolumn = { "120" }
vim.opt_local.textwidth = 120

vim.opt_local.wrap = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

vim.b.miniindentscope_disable = true

vim.cmd([[
  iabbrev <buffer> D <C-R>=system('date "+%Y-%m-%d" -d ""')[:-2]
  \<LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT>
]])

local bind_map = require("eckon.utils").bind_map

bind_map("v")("L", function()
  local positions = require("eckon.utils").get_visual_selection()
  local lines = vim.api.nvim_buf_get_lines(0, positions.visual_start.row - 1, positions.visual_end.row, false)

  -- lines allows multiple but links do not really help on multiple lines, so only allow one line
  if #lines > 1 then
    return
  end

  local content = lines[1]:sub(positions.visual_start.column, positions.visual_end.column)
  lines[1] = lines[1]:sub(1, positions.visual_start.column - 1)
    .. "["
    .. content
    .. "]("
    .. vim.fn.getreg("+")
    .. ")"
    .. lines[1]:sub(positions.visual_end.column + 1)

  vim.api.nvim_buf_set_lines(0, positions.visual_start.row - 1, positions.visual_end.row, false, lines)

  -- keep cursor on the first selection
  vim.api.nvim_win_set_cursor(0, { positions.visual_start.row, positions.visual_start.column })
  require("eckon.utils").exit_visual_mode()
end, { desc = "Paste markdown link on visual selection", buffer = true, silent = true })

bind_map({ "n", "v", "i" })("<C-s>", function()
  local positions = require("eckon.utils").get_visual_selection()
  local lines = vim.api.nvim_buf_get_lines(0, positions.visual_start_0.row, positions.visual_end.row, false)
  local is_visual_mode = require("eckon.utils").is_visual_mode()

  local is_dirty = false
  local cursor_shift = -1

  for i, line in ipairs(lines) do
    -- only allow one change at a time: ` ` > `-` > `[ ]` > `[x]` > `[/]` > `[ ]`
    -- from open/pending to done
    if lines[i] == line then
      lines[i] = lines[i]:gsub("- %[[ %-]%]", "- [x]")
    end

    -- from done to canceled
    if lines[i] == line then
      lines[i] = lines[i]:gsub("- %[x%]", "- [/]")
    end

    -- from canceled to open
    if lines[i] == line then
      lines[i] = lines[i]:gsub("- %[/%]", "- [ ]")
    end

    -- promote bullet point to checkbox while keeping indentation
    if lines[i] == line and not is_visual_mode then
      lines[i] = lines[i]:gsub("^(%s*)[%-%*] (.*)", "%1- [ ] %2")
      cursor_shift = 3
    end

    -- create bullet point on nothing while keeping indentation
    if lines[i] == line and not is_visual_mode then
      lines[i] = lines[i]:gsub("^(%s*)(.*)", "%1- %2")
      cursor_shift = 1
    end

    if lines[i] ~= line then
      is_dirty = true
    end
  end

  -- only update if we actually changed something (to keep undo actions clean)
  if is_dirty then
    vim.api.nvim_buf_set_lines(0, positions.visual_start_0.row, positions.visual_end.row, false, lines)

    -- keep cursor at the shifted position, mainly relevant for single lines
    if not is_visual_mode then
      vim.api.nvim_win_set_cursor(0, { positions.visual_start.row, positions.visual_end.column + cursor_shift })
    end
  end
end, { desc = "Create/Switch bullet-point/checkbox state", buffer = true, silent = true })
