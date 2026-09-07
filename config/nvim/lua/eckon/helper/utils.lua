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

---Opens a custom scratch buffer to work on temporary content and passing work back to the caller at the end.
---Uses a similar approach to git commit message editor, buffer is used like any other and events used to handle processes.
---@param content string
---@param opts { filetype?: string, on_commit?: fun(text: string), on_close?: fun() }
M.open_scratch = function(content, opts)
  opts = opts or {}

  local buf = vim.api.nvim_create_buf(false, false)
  vim.bo[buf].buftype = "acwrite"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = opts.filetype or ""
  vim.api.nvim_buf_set_name(buf, ("scratch://%s/%s"):format(vim.fn.tempname(), "buffer"))
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
  vim.bo[buf].modified = false

  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Scratch Buffer ",
    title_pos = "center",
    footer = " :w apply, :q close ",
    footer_pos = "right",
  })
  vim.wo[win].wrap = false

  if opts.on_commit then
    vim.api.nvim_create_autocmd("BufWriteCmd", {
      buffer = buf,
      callback = function()
        local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
        opts.on_commit(text)
        vim.bo[buf].modified = false
      end,
    })
  end

  if opts.on_close then
    vim.api.nvim_create_autocmd("BufWipeout", {
      buffer = buf,
      once = true,
      callback = opts.on_close,
    })
  end
end

return M
