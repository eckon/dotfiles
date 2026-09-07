local ns = vim.api.nvim_create_namespace("yaml_base64")

---Format a value with `jq` when it is valid JSON, otherwise return it unchanged
---@param value string
---@return string formatted
---@return boolean is_json
local function format_json(value)
  if vim.fn.executable("jq") == 0 then
    return value, false
  end

  local result = vim.system({ "jq", "." }, { stdin = value, text = true }):wait()
  if result.code ~= 0 or not result.stdout then
    return value, false
  end

  return vim.trim(result.stdout), true
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

local function toggle()
  local node = value_under_cursor()
  if not node then
    vim.notify("no yaml value under the cursor", vim.log.levels.WARN)
    return
  end

  local value = vim.treesitter.get_node_text(node, 0)

  -- only continue if we have base64 data, otherwise exit
  if #value == 0 or #value % 4 ~= 0 or not value:find("^[%w+/]+=?=?$") then
    vim.notify("no base64 value under the cursor", vim.log.levels.WARN)
    return
  end

  local start_row, start_column, end_row, end_column = node:range()
  local decoded = vim.base64.decode(value)
  local formatted, is_json = format_json(decoded)
  local source_buf = vim.api.nvim_get_current_buf()
  local mark_id =
    vim.api.nvim_buf_set_extmark(source_buf, ns, start_row, start_column, { end_row = end_row, end_col = end_column })

  require("eckon.helper.utils").open_scratch(formatted, {
    filetype = is_json and "json" or "text",
    on_commit = function(text)
      local mark_start_row, mark_start_col, details =
        unpack(vim.api.nvim_buf_get_extmark_by_id(source_buf, ns, mark_id, { details = true }))
      local encoded = vim.base64.encode(text)

      vim.api.nvim_buf_set_text(
        source_buf,
        mark_start_row,
        mark_start_col,
        details.end_row,
        details.end_col,
        { encoded }
      )

      -- re-anchor the mark to the text just written, otherwise it collapses to a
      -- zero-width point and the next save has nothing left to replace
      vim.api.nvim_buf_set_extmark(source_buf, ns, mark_start_row, mark_start_col, {
        id = mark_id,
        end_row = mark_start_row,
        end_col = mark_start_col + #encoded,
      })
    end,
    on_close = function()
      vim.api.nvim_buf_del_extmark(source_buf, ns, mark_id)
    end,
  })
end

require("eckon.helper.custom-command").custom_command.add("YAML: Update base64", {
  desc = "Decode the base64 value under the cursor, update and save encoded value",
  callback = toggle,
  filetype = "yaml",
})
