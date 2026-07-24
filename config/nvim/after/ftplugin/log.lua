-- Helper functions to handle different kinds of logs

-- dotnet with json
-- mostly in the workflow: k9s -> failing pod -> open in vim (log type) -> format via this
local function format_dotnet_json_logs()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local out = {}

  -- splits str on \n and pushes each part into out
  local function push_lines(str)
    for part in tostring(str):gmatch("([^\n]*)\n?") do
      table.insert(out, part)
    end
  end

  for _, line in ipairs(lines) do
    local start_pos = line:find('{"', 1, true)
    if start_pos then
      local json_part = line:sub(start_pos)

      local ok, obj = pcall(vim.json.decode, json_part)
      if ok and obj then
        local timestamp = obj.Timestamp or "?"
        local level = obj.LogLevel or "?"
        local category = obj.Category or "?"
        local message = obj.Message or ""
        local exception = obj.Exception or "no exception"

        -- header line is always single-line, safe to insert directly
        table.insert(out, string.format("%s [%s] %s", timestamp, level, category))

        -- message and exception may contain \n  →  split them
        push_lines(message)
        table.insert(out, "")
        push_lines(exception)
        table.insert(out, "")
      end
    end
  end

  if #out == 0 then
    vim.notify("No valid JSON log lines found", vim.log.levels.WARN)
    return
  end

  vim.cmd("new")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "log"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
end

local cc = require("eckon.helper.custom-command").custom_command
cc.add("Log: Format dotnet json", {
  desc = "Format dotnet json logs",
  callback = format_dotnet_json_logs,
})
