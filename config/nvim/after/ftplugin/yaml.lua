local bind_map = require("eckon.utils").bind_map

---Helper to de/encode in one function
---@param decode? boolean
local function encode(decode)
  local positions = require("eckon.utils").get_visual_selection()
  local lines = vim.api.nvim_buf_get_lines(0, positions.visual_start.row - 1, positions.visual_end.row, false)

  -- only handle single lines
  if #lines > 1 then
    return
  end

  local content = lines[1]:sub(positions.visual_start.column, positions.visual_end.column)

  local encoded_content = vim.fn.system("echo -n " .. content .. " | base64 -w0"):gsub("\n", "")
  if decode then
    encoded_content = vim.fn.system("echo -n " .. content .. " | base64 -d -w0"):gsub("\n", "")
  end

  lines[1] = lines[1]:sub(1, positions.visual_start.column - 1)
    .. encoded_content
    .. lines[1]:sub(positions.visual_end.column + 1)

  vim.api.nvim_buf_set_lines(0, positions.visual_start.row - 1, positions.visual_end.row, false, lines)

  -- keep cursor on the first selection
  vim.api.nvim_win_set_cursor(0, { positions.visual_start.row, positions.visual_start.column })
  require("eckon.utils").exit_visual_mode()
end

bind_map("v")("E", function()
  encode()
end, { desc = "Take visual selection and encode it with base64", buffer = true, silent = true })

bind_map("v")("D", function()
  encode(true)
end, { desc = "Take visual selection and decode it with base64", buffer = true, silent = true })
