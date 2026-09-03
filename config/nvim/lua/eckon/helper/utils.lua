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

---@class eckon.Position
---@field row integer
---@field column integer

---@class eckon.VisualSelection
---@field visual_start eckon.Position start of the selection
---@field visual_end eckon.Position end of the selection
---@field text string[] selected lines

---Get the current visual selection, or the cursor position when not in visual mode
---Rows and columns are 1-based and both ends are inclusive, so they match `string.sub`
---@return eckon.VisualSelection
M.get_visual_selection = function()
  local from, to = vim.fn.getpos("v"), vim.fn.getpos(".")

  -- gives a { start, end } pair per line, already ordered no matter which end the cursor is on
  local region = vim.fn.getregionpos(from, to)
  local first, last = region[1][1], region[#region][2]

  return {
    visual_start = { row = first[2], column = first[3] },
    visual_end = { row = last[2], column = last[3] },
    text = vim.fn.getregion(from, to),
  }
end

return M
