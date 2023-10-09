local add_custom_command = require("eckon.utils").custom_command.add
local async_external_command = require("eckon.utils").async_external_command

---Run tsc to populate quickfix list
local function run_tsc_into_qf()
  async_external_command({
    command = "npx",
    args = { "tsc" },
    on_stdout = function(tsc_output)
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
    end,
  })
end

add_custom_command("TscToQuickfix", {
  desc = "Run tsc and populate quickfix list",
  callback = function()
    vim.fn.setqflist({}, "r")
    run_tsc_into_qf()
  end,
})
