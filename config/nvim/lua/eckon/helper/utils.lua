local M = {}

---Dynamically require all Lua files in a directory
---@param dir string Directory path relative to lua/ (e.g., "eckon.plugin")
---@param opts? table Options: { ignore = { "file1", "file2" } }
M.require_dir = function(dir, opts)
  opts = opts or {}
  local ignore = opts.ignore or {}
  local ignore_map = {}
  for _, v in ipairs(ignore) do
    ignore_map[v] = true
  end

  local path = vim.fn.stdpath("config") .. "/lua/" .. dir:gsub("%.", "/")
  local files = vim.fn.glob(path .. "/*.lua", false, true)

  for _, file in ipairs(files) do
    local module_name = vim.fn.fnamemodify(file, ":t:r")
    if module_name ~= "init" and not ignore_map[module_name] then
      local module_path = dir .. "." .. module_name
      require(module_path)
    end
  end
end

---Create augroup with my unique prefix
---@param name string
---@param options? table
---@return integer
M.augroup = function(name, options)
  return vim.api.nvim_create_augroup("eckon_augroup_" .. name, options or {})
end

---Create partial function to store mode and options
---Example: To get back a function with preset mode and options
---local nmap = bind_map("n")
---@param mode string|table
---@param outer_options? table
M.bind_map = function(mode, outer_options)
  ---Function to set a mapping of a given mode and a set of options
  ---@param lhs string
  ---@param rhs string|function
  ---@param inner_options? table
  return function(lhs, rhs, inner_options)
    local options = vim.tbl_extend("force", outer_options or {}, inner_options or {})
    vim.keymap.set(mode, lhs, rhs, options)
  end
end

---Extend the treesitter foldtext to enhance it with custom information
---Like: Number of lines folded
---
---Example usage:
---
---```lua
---  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
---  -- manually extending "v:lua.vim.treesitter.foldtext()"
---  vim.opt.foldtext = "v:lua.require('eckon.utils').foldtext()"
---```
---
---@return string|{ [1]: string, [2]: string[] }[]
M.foldtext = function()
  local ts_foldtext = vim.treesitter.foldtext()
  local line_counter = string.format("  --- [%s lines]", vim.v.foldend - vim.v.foldstart + 1)
  local formatted_foldtext = { line_counter, "Folded" }

  -- not yet sure when this happens, but added to be type-safe
  if type(ts_foldtext) == "string" then
    local line = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, false)[1]
    return { { line, "Normal" }, formatted_foldtext }
  end

  table.insert(ts_foldtext, formatted_foldtext)
  return ts_foldtext
end

---Get start and end positions of current visual selection
---@return { visual_start: { row: integer, column: integer }, visual_end: { row: integer, column: integer }, visual_start_0: { row: integer, column: integer } }
M.get_visual_selection = function()
  -- both have the line number in 2nd place and row number in 3rd place
  local current_cursor = vim.fn.getpos(".") or {}
  local tail_visual_selection = vim.fn.getpos("v") or {}

  local start_position = current_cursor
  local end_position = tail_visual_selection

  if start_position[2] > end_position[2] then
    start_position, end_position = end_position, start_position
  end

  -- in case both are on the same line
  if start_position[2] == end_position[2] and start_position[3] > end_position[3] then
    start_position, end_position = end_position, start_position
  end

  return {
    visual_start = {
      row = start_position[2],
      column = start_position[3],
    },
    -- some functions are zero based, so allow this to be set to not manually adding/subtracting 1
    visual_start_0 = {
      row = start_position[2] - 1,
      column = start_position[3] - 1,
    },
    visual_end = {
      row = end_position[2],
      column = end_position[3],
    },
  }
end

---Exit visual mode, if currently in visual mode
M.exit_visual_mode = function()
  if M.is_visual_mode() then
    vim.cmd("normal! " .. vim.fn.mode())
  end
end

---Check if we are currently in visual mode
---@return boolean
M.is_visual_mode = function()
  local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)
  local cur_mode = vim.fn.mode()

  return cur_mode == "v" or cur_mode == "V" or cur_mode == ctrl_v
end

---Check if we are currently in insert mode
---@return boolean
M.is_insert_mode = function()
  return vim.fn.mode() == "i"
end

---Save and restore the current cursor position
---This is useful for things that move the cursor but the user does want to keep it at the same position
---@return function restore callback to restore the previous cursor position
M.save_cursor_position = function()
  local initial_cursor_position = vim.api.nvim_win_get_cursor(0)
  return function()
    vim.api.nvim_win_set_cursor(0, initial_cursor_position)
  end
end

---Returns if we are currently running on wsl
---@return boolean
M.is_windows_wsl = function()
  return vim.fn.has("wsl") == 1 and vim.fn.has("linux") == 1
end

---Returns if we are currently running on linux
---@return boolean
M.is_linux = function()
  return vim.fn.has("linux") == 1 and vim.fn.has("unix") == 1
end

return M
