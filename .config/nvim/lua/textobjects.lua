local M = {}

---Visually select an indented area
M.indent_textobject_selection = function ()
  ---Check if given line number is blank
  ---@param line_number number
  ---@return boolean
  local is_blank_line = function (line_number)
    local blank_line_pattern = '^%s*$'
    local line_content = vim.fn.getline(line_number)
    return string.match(line_content, blank_line_pattern) ~= nil
  end

  -- if cursor is on blank line, jump to the next indent instead
  if is_blank_line(vim.fn.line('.')) then
    local next_non_blank = vim.fn.nextnonblank(vim.fn.line('.'))
    if next_non_blank == 0 then
      return
    end

    vim.cmd(tostring(next_non_blank))
  end


  -- handle passed ranges for other indentation levels
  local base_indent = vim.fn.indent(vim.fn.line('.'))
  if vim.v.count > 0 then
    base_indent = base_indent - vim.o.shiftwidth * (vim.v.count - 1)
    if base_indent < 0 then
      base_indent = 0
    end
  end

  ---Check if wanted indent is 'under'-reached
  ---meaning a non blank line and an indent smaller than the base is found
  ---@param line_number number
  ---@return boolean
  local has_higher_indent = function (line_number)
    return is_blank_line(line_number) or vim.fn.indent(line_number) >= base_indent
  end

  -- go to start of selection
  local prev_line = vim.fn.line('.') - 1
  while prev_line > 0 and has_higher_indent(prev_line) do
    vim.cmd('-')
    prev_line = vim.fn.line('.') - 1
  end

  -- start visual selection after reaching start location
  vim.cmd('normal! V')

  -- go to end of selection
  local next_line = vim.fn.line('.') + 1
  local last_line = vim.fn.line('$')
  while next_line <= last_line and has_higher_indent(next_line) do
    vim.cmd('+')
    next_line = vim.fn.line('.') + 1
  end
end

M.indent_around_textobject = function ()
  M.indent_textobject_selection()
  -- after selecting the indented area, switch to the start of the selection
  vim.cmd('normal! o')
  -- and add one line on the top (one up)
  vim.cmd('-')
  -- then switch to the end of the selection
  vim.cmd('normal! o')
  -- and add one line to the bottom (one down)
  vim.cmd('+')
end

M.indent_inner_textobject = function ()
  M.indent_textobject_selection()
end

return M
