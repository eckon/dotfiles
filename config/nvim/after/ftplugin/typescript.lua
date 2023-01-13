local custom_command = require("eckon.utils").custom_command

custom_command("TscToQuickfix", function()
  local uv = vim.loop
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local tsc_output = {}

  local handle
  handle, _ = uv.spawn("npx", {
    args = { "tsc" },
    -- sdtin / stdout / stderr
    stdio = { nil, stdout, stderr },
    detached = true,
  }, function()
    vim.schedule(function()
      if #tsc_output == 0 then
        vim.notify("No tsc diagnostics of project")
        return
      end

      local qf_list = {}
      for _, value in pairs(tsc_output) do
        -- parse example: `src/main.ts(13,5): error TS2304: Argument ...`
        -- lua specific `%\` escapes `\` and `-` is non greedy for `*`
        local _, _, path, row, col, message = string.find(value, "(.-)%((.-),(.-)%): (.*)")

        local qf_entry = {
          filename = path,
          lnum = row,
          col = col,
          text = message,
        }
        table.insert(qf_list, qf_entry)
      end

      -- overwrite qf, open qf and move to previous buffer (to keep cursor at same position)
      vim.fn.setqflist(qf_list, "r")
      -- vim.api.nvim_command("copen")
      vim.api.nvim_command("Trouble quickfix")
      vim.api.nvim_command("wincmd p")
    end)

    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
  end)

  -- will be called on every line -> manually create table
  uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if not data then
      return
    end

    table.insert(tsc_output, data)
  end)

  uv.read_start(stderr, function(err, data)
    assert(not err, err)
    if not data then
      return
    end

    vim.notify("Error while trying to run tsc: " .. data)
  end)
end)
