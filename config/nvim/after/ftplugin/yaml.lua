---Function to de/encode base64 content
---@param mode 'encode' | 'decode'
local function base64Convert(mode)
  local positions = require("eckon.helper.utils").get_visual_selection()

  -- only handle single lines
  if #positions.text > 1 then
    return
  end

  local content = positions.text[1]
  local converted = content

  if mode == "encode" then
    converted = vim.base64.encode(content)
  end

  if mode == "decode" then
    -- decoding throws on anything that is not valid base64, so just keep the selection as is
    local ok, decoded = pcall(vim.base64.decode, content)
    if not ok then
      return
    end

    converted = decoded
  end

  vim.api.nvim_buf_set_text(
    0,
    positions.visual_start.row - 1,
    positions.visual_start.column - 1,
    positions.visual_end.row - 1,
    positions.visual_end.column,
    { converted }
  )

  -- keep cursor on the first selection
  vim.api.nvim_win_set_cursor(0, { positions.visual_start.row, positions.visual_start.column })

  -- get out of visual mode
  vim.cmd.normal({ vim.api.nvim_get_mode().mode, bang = true })
end

local vmap = require("eckon.helper.utils").bind_map("v")

vmap("E", function()
  base64Convert("encode")
end, { desc = "Take visual selection and encode it with base64", buffer = true, silent = true })

vmap("D", function()
  base64Convert("decode")
end, { desc = "Take visual selection and decode it with base64", buffer = true, silent = true })
