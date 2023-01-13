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
      -- lua specific `%\` escapes `\` and `-` is non greedy for `*`
      local _, _, path, row, col, message = string.find(value, "(.-)%((.-),(.-)%): (.*)")
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

---Run eslint to populate quickfix list
local function run_eslint_into_qf()
  async_external_command("npx", { "eslint", "-f", "unix", "./**/*.ts" }, function(eslint_output)
    if #eslint_output == 0 then
      vim.notify("No linting errors found in project")
      return
    end

    -- eslint returns one big string -> split by new line and join into table
    local data = {}
    for output in eslint_output[1]:gmatch("[^\r\n]+") do
      table.insert(data, output)
    end

    local qf_list = {}
    for _, value in pairs(data) do
      -- parse example: `/home/<repo>/src/main.ts:22:1: Delete `⏎⏎⏎` [Error/prettier/prettier]`
      -- lua specific `%\` escapes `\` and `-` is non greedy for `*`
      local _, _, path, row, col, message = string.find(value, "(.-):(.-):(.-)%: (.*)")
      if path ~= nil then
        local qf_entry = {
          filename = path,
          lnum = row,
          -- for some reason eslint points on the missing symbol which does not exist (one symbol after last letter)
          col = tonumber(col) - 1,
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

custom_command("EslintToQuickfix", function()
  vim.fn.setqflist({}, "r")
  run_eslint_into_qf()
end)

-- TODO: add implementation for testing
custom_command("JestToQuickfix", function()
  vim.fn.setqflist({}, "r")
  run_jest_into_qf()
end)

custom_command("TypescriptToQuickfix", function()
  vim.fn.setqflist({}, "r")
  run_tsc_into_qf()
  run_eslint_into_qf()
end)
