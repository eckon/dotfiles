local ns = vim.api.nvim_create_namespace("yaml_base64")

---Format a value with `jq` when it is valid JSON, otherwise return it unchanged
---@param value string
---@return string formatted
---@return boolean is_json
local function format_json(value)
  local ok, decoded = pcall(vim.json.decode, value)
  if not ok or type(decoded) ~= "table" then
    return value, false
  end

  -- `jq` only pretty prints, the value stays json either way
  if vim.fn.executable("jq") == 0 then
    return value, true
  end

  local result = vim.system({ "jq", "." }, { stdin = value, text = true }):wait()
  if result.code ~= 0 or not result.stdout then
    return value, true
  end

  return vim.trim(result.stdout), true
end

---Get the value node of the yaml `key: value` pair under the cursor
---@return TSNode|nil
local function value_under_cursor()
  local parser = vim.treesitter.get_parser(0, "yaml", { error = false })
  if not parser then
    return nil
  end

  -- `get_node` does not parse by itself and would hand out a stale node
  parser:parse(true)

  local node = vim.treesitter.get_node()
  while node and node:type() ~= "block_mapping_pair" do
    node = node:parent()
  end

  local value = node and node:field("value")[1]

  -- only convert single values, a nested block is nothing we can put base64 into
  return value and value:type() == "flow_node" and value or nil
end

local function update_base64()
  local node = value_under_cursor()
  if not node then
    vim.notify("no yaml value under the cursor", vim.log.levels.WARN)
    return
  end

  local value = vim.treesitter.get_node_text(node, 0)

  -- decoding validates length, alphabet and padding, a failure means it was no base64
  local ok, decoded = pcall(vim.base64.decode, value)
  if not ok or #decoded == 0 then
    vim.notify("no base64 value under the cursor", vim.log.levels.WARN)
    return
  end

  local formatted, is_json = format_json(decoded)

  local source_buf = vim.api.nvim_get_current_buf()

  local start_row, start_col, end_row, end_col = node:range()
  local mark_id = vim.api.nvim_buf_set_extmark(source_buf, ns, start_row, start_col, {
    end_row = end_row,
    end_col = end_col,
    -- let the mark grow into replacement text, with the default gravity it would
    -- invert (start after end) and the next save had nothing left to replace
    right_gravity = false,
    end_right_gravity = true,
  })

  require("eckon.helper.utils").open_scratch(formatted, {
    filetype = is_json and "json" or "text",

    on_commit = function(text)
      if not vim.api.nvim_buf_is_valid(source_buf) then
        vim.notify("yaml buffer is gone, cannot write the value back", vim.log.levels.ERROR)
        return false
      end

      local mark_start_row, mark_start_col, details =
        unpack(vim.api.nvim_buf_get_extmark_by_id(source_buf, ns, mark_id, { details = true }))

      if not details then
        vim.notify("lost track of the yaml value", vim.log.levels.ERROR)
        return false
      end

      vim.api.nvim_buf_set_text(
        source_buf,
        mark_start_row,
        mark_start_col,
        details.end_row,
        details.end_col,
        { vim.base64.encode(text) }
      )

      return true
    end,

    on_close = function()
      if vim.api.nvim_buf_is_valid(source_buf) then
        vim.api.nvim_buf_del_extmark(source_buf, ns, mark_id)
      end
    end,
  })
end

require("eckon.helper.custom-command").custom_command.add("YAML: Update base64", {
  desc = "Decode the base64 value under the cursor, update and save encoded value",
  callback = update_base64,
  filetype = "yaml",
})
