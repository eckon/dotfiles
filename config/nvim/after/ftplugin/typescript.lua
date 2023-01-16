local custom_command = require("eckon.utils").custom_command
local async_external_command = require("eckon.utils").async_external_command

---Run tsc to populate quickfix list
local function run_tsc_into_qf()
  async_external_command("npx", { "tsc" }, function(tsc_output)
    if #tsc_output == 0 then
      vim.notify("No tsc diagnostics found in project")
      return
    end

    local qf_list = {}
    for _, value in pairs(tsc_output) do
      -- parse example: `src/main.ts(13,5): error TS2304: Argument ...`
      -- lua specific `%\` escapes `\` and `-` is non greedy for `*` and `%d` is for digits
      local _, _, path, row, col, message = string.find(value, "(.-)%((%d*),(%d*)%): (.*)")
      if path ~= nil then
        local qf_entry = {
          filename = path,
          lnum = row,
          col = col,
          text = message,
        }
        table.insert(qf_list, qf_entry)
      end
    end

    vim.fn.setqflist(qf_list, "a")
    -- open quickfix and return to previous buffer (as qf will auto focus)
    vim.api.nvim_command("copen")
    vim.api.nvim_command("wincmd p")
  end)
end

custom_command("TscToQuickfix", function()
  vim.fn.setqflist({}, "r")
  run_tsc_into_qf()
end)
