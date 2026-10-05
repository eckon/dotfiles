-- show dotnet json logs (with stack traces) from k9s in a readable form
-- workflow: k9s -> failing pod -> open logs in vim -> run this

---Decode the json part of a line, k9s puts pod name and timestamp in front of it
---@param line string
---@return table|nil
local function decode_line(line)
  local start_pos = line:find("{", 1, true)
  if not start_pos then
    return nil
  end

  local ok, obj = pcall(vim.json.decode, line:sub(start_pos), { luanil = { object = true } })
  return ok and type(obj) == "table" and obj or nil
end

---Get the level of a non json line (datadog tracer output)
---@param line string
---@return string level "other" when the format is unknown
local function native_level(line)
  -- `[2026-09-30 06:42:17.971 | warning | PId: 1 | TId: 1] message`
  -- `09/30/26 06:42:17.971 AM [1|1] [info] message`
  local level = line:match("%[%d+%-%d+%-%d+ [%d:%.]+ | (%w+) |") or line:match("%[%d+|%d+%] %[(%w+)%]")
  return level and level:lower() or "other"
end

---@param lines string[]
---@return string[] out
---@return integer[] source_lines source line of every output line
---@return integer json_count
local function format_lines(lines)
  local out, source_lines = {}, {}
  local json_count = 0

  -- current run of non json lines
  local skip_from, skip_to = nil, nil
  local skip_levels = {} ---@type table<string, integer>

  local function add(text, source_line)
    table.insert(out, text)
    source_lines[#out] = source_line
  end

  -- message and exception can be multiline
  local function add_indented(text, indent, source_line)
    for _, part in ipairs(vim.split(tostring(text), "\r?\n")) do
      add(indent .. part, source_line)
    end
  end

  local function add_skipped()
    if not skip_from then
      return
    end

    local levels = vim.tbl_keys(skip_levels)
    table.sort(levels, function(a, b)
      return skip_levels[a] > skip_levels[b]
    end)
    local summary = vim.tbl_map(function(level)
      return ("%d %s"):format(skip_levels[level], level)
    end, levels)

    local count = skip_to - skip_from + 1
    local text = ("~~ %d non-json lines skipped (lines %d-%d): %s ~~"):format(
      count,
      skip_from,
      skip_to,
      table.concat(summary, ", ")
    )
    add(text, skip_from)
    add("", skip_to)

    skip_from, skip_to, skip_levels = nil, nil, {}
  end

  for index, line in ipairs(lines) do
    local obj = decode_line(line)

    if obj then
      add_skipped()
      json_count = json_count + 1

      -- the date is the same for most logs, the time is enough
      local timestamp = tostring(obj.Timestamp or "?")
      local time = timestamp:match("T([%d:%.]+)") or timestamp
      local level = tostring(obj.LogLevel or "?"):upper()
      add(("%s  %s  %s"):format(time, level, obj.Category or "?"), index)

      add_indented(obj.Message or "", "  ", index)
      if obj.Exception and obj.Exception ~= "" then
        add("", index)
        add_indented(obj.Exception, "    ", index)
      end
      add("", index)
    elseif line:match("%S") then
      skip_from = skip_from or index
      skip_to = index
      local level = native_level(line)
      skip_levels[level] = (skip_levels[level] or 0) + 1
    end
  end
  add_skipped()

  return out, source_lines, json_count
end

local function format_dotnet_json_logs()
  local source_buf = vim.api.nvim_get_current_buf()
  local out, source_lines, json_count = format_lines(vim.api.nvim_buf_get_lines(0, 0, -1, false))

  if json_count == 0 then
    vim.notify("No valid JSON log lines found", vim.log.levels.WARN)
    return
  end

  -- scratch buffer in the same window, so <C-o>/<C-i> switch between it and the log
  -- it is hidden instead of wiped when left, otherwise the jumplist can not get back to it
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "log"

  vim.cmd("normal! m'")
  vim.api.nvim_win_set_buf(0, buf)
  vim.wo[0][0].wrap = true

  vim.keymap.set("n", "<CR>", function()
    if not vim.api.nvim_buf_is_valid(source_buf) then
      vim.notify("Original log buffer is gone", vim.log.levels.WARN)
      return
    end

    local source_line = source_lines[vim.fn.line(".")] or 1
    vim.cmd("normal! m'")
    vim.api.nvim_win_set_buf(0, source_buf)
    vim.api.nvim_win_set_cursor(0, { source_line, 0 })
    vim.cmd("normal! zz")
  end, { buffer = buf, desc = "Jump to the original log line" })
end

require("eckon.helper.custom-command").custom_command.add("Log: Format dotnet json", {
  desc = "Show dotnet json logs formatted in a scratch buffer",
  callback = format_dotnet_json_logs,
  filetype = "log",
})
