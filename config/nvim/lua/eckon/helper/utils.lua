local M = {}

---Create augroup with my unique prefix
---@param name string
---@param options? vim.api.keyset.create_augroup
---@return integer
M.augroup = function(name, options)
  return vim.api.nvim_create_augroup("eckon_augroup_" .. name, options or {})
end

---Create partial function to store mode and options
---Example: To get back a function with preset mode and options
---local nmap = bind_map("n")
---@param mode string|string[]
---@param outer_options? vim.keymap.set.Opts
---@return fun(lhs: string, rhs: string|function, inner_options?: vim.keymap.set.Opts)
M.bind_map = function(mode, outer_options)
  return function(lhs, rhs, inner_options)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", outer_options or {}, inner_options or {}))
  end
end

---@class eckon.VisualSelection
---@field range vim.Range 0-based and end-exclusive, same indexing as the buffer api
---@field text string[] selected lines

---Get the current visual selection, or the cursor position when not in visual mode
---@return eckon.VisualSelection
M.get_visual_selection = function()
  local from, to = vim.fn.getpos("v"), vim.fn.getpos(".")

  -- gives a { start, end } pair per line, already ordered no matter which end the cursor is on
  local region = vim.fn.getregionpos(from, to)
  local first, last = region[1][1], region[#region][2]

  return {
    -- getregionpos is 1-based and end-inclusive, vim.range.mark converts that to its own
    -- 0-based end-exclusive form, but only while 'selection' is left at the default "inclusive"
    range = vim.range.mark(0, first[2], first[3] - 1, last[2], last[3] - 1),
    text = vim.fn.getregion(from, to),
  }
end

return M
