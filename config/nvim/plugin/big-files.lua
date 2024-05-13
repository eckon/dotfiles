if require("eckon.utils").run_minimal() then
  return
end

vim.api.nvim_create_autocmd("BufReadPre", {
  desc = "Disallow big files to be opened via fully featured vim setup",
  callback = function(event)
    local file_path = vim.api.nvim_buf_get_name(event.buf)
    -- need to check the file directly, because we want to check if this file can be loaded into the buffer
    local size = vim.fn.getfsize(file_path)

    -- 2MB as the limit
    if size < 2 * 1024 * 1024 then
      return
    end

    vim.cmd([[ bwipeout! ]])

    local formatted_size = string.format("%.2f", size / (1024 * 1024)) .. "MB"
    local file_name = vim.fn.fnamemodify(file_path, ":t")
    vim.notify(
      'Wiped big buffer: "' .. file_name .. '" (' .. formatted_size .. ") use `vi` minimal mode instead",
      vim.log.levels.ERROR
    )
  end,
  group = require("eckon.utils").augroup("big_file"),
})
