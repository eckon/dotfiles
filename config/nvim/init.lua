-- options needs to be the first
require("eckon.config.options")

if not require("eckon.utils").run_minimal() then
  -- this needs to happen in the normal init, as the VerzyLazy event is triggered too late
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
end

-- this is triggered via lazy.nvim (VeryLazy event)
vim.api.nvim_create_autocmd("User", {
  desc = "Set autocmds/commands/keymaps later on (to have more buffer info)",
  pattern = "VeryLazy",
  callback = function()
    require("eckon.config.autocmds")
    require("eckon.config.commands")
    require("eckon.config.keymaps")

    require("eckon.special.notes")
  end,
  group = require("eckon.utils").augroup("load_config"),
})

-- package/plugins management
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup("eckon.plugins")
