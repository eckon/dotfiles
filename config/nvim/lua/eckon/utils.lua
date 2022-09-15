local M = {}

---Trim string to remove empty trailing lines and new lines
---@param str string
---@return string
local function trim_string(str)
  local replace, _ = string.gsub(str, '%s+', '')
  return replace
end

M.trim = trim_string

---Create user command with 'CC'-prefix for quick access
---@param name string
---@param cmd string|function
---@param options? table
local function custom_command(name, cmd, options)
  options = options or {}
  vim.api.nvim_create_user_command('CC' .. name, cmd, options)
end

---Command completion function, to sort and filter passed complete values
---@param completion_strings table
---@param passed_arguments table
---@return table
local function command_complete_filter(completion_strings, passed_arguments)
  -- filter completions out, which the caller did not type on the command line
  local filtered_completion_strings = vim.tbl_filter(function(s)
    return s:sub(1, #passed_arguments) == passed_arguments
  end, completion_strings)

  table.sort(filtered_completion_strings)

  return filtered_completion_strings
end

M.custom_command = custom_command
M.command_complete_filter = command_complete_filter

---Create partial function to store mode and options
---@param mode string|table
---@param outer_options? table
local function bind_map(mode, outer_options)
  outer_options = outer_options or { noremap = true }

  ---Function to set a mapping of a given mode and a set of options
  ---@param lhs string
  ---@param rhs string|function
  ---@param inner_options? table
  return function(lhs, rhs, inner_options)
    local options = vim.tbl_extend('force', outer_options, inner_options or {})
    vim.keymap.set(mode, lhs, rhs, options)
  end
end

M.nmap = bind_map('n', { noremap = false })
M.noremap = bind_map({ 'n', 'v', 'o' })

M.nnoremap = bind_map('n')
M.inoremap = bind_map('i')
M.vnoremap = bind_map('v')

M.onoremap = bind_map('o')
M.xnoremap = bind_map('x')

return M
