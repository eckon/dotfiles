local utils = require("eckon.helper.custom-command")

---Decode base64, but only when the result is plain readable text
---Short words can be valid base64 by accident, so a successful decode alone is not enough
---@param value string
---@return string|nil decoded nil when this does not look like base64 encoded text
local function decode_base64(value)
  -- base64 always comes in blocks of 4 characters out of a fixed alphabet
  if #value == 0 or #value % 4 ~= 0 or not value:find("^[%w+/]+=?=?$") then
    return nil
  end

  local ok, decoded = pcall(vim.base64.decode, value)

  -- allow newlines/tabs, a multiline value is still text we want to decode
  if not ok or decoded:find("[^\32-\126\n\t]") then
    return nil
  end

  return decoded
end

---Get the value node of the yaml `key: value` pair under the cursor
---@return TSNode|nil
local function value_under_cursor()
  local ok = pcall(function()
    vim.treesitter.get_parser(0, "yaml"):parse(true)
  end)
  if not ok then
    return nil
  end

  local node = vim.treesitter.get_node()
  while node and node:type() ~= "block_mapping_pair" do
    node = node:parent()
  end

  local value = node and node:field("value")[1]

  -- only convert single values, a nested block is nothing we can put base64 into
  return value and value:type() == "flow_node" and value or nil
end

---Encode/decode the yaml value under the cursor
local function toggle()
  local node = value_under_cursor()
  if not node then
    vim.notify("Base64: no yaml value under the cursor", vim.log.levels.WARN)
    return
  end

  local value = vim.treesitter.get_node_text(node, 0)
  local converted = decode_base64(value) or vim.base64.encode(value)
  local start_row, start_column, end_row, end_column = node:range()

  vim.api.nvim_buf_set_text(0, start_row, start_column, end_row, end_column, vim.split(converted, "\n"))
end

utils.custom_command.add(
  "Yaml: Toggle base64",
  { desc = "Encode/decode the base64 value under the cursor", callback = toggle, filetype = "yaml" }
)
