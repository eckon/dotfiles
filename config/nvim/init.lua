-- options needs to be the first
require("eckon.config.options")

-- this is triggered via lazy.nvim (VeryLazy event)
vim.api.nvim_create_autocmd("User", {
  desc = "Set autocmds/commands/keymaps later on (to have more buffer info)",
  pattern = "VeryLazy",
  callback = function()
    require("eckon.config.autocmds")
    require("eckon.config.commands")
    require("eckon.config.keymaps")
    require("eckon.config.special")
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
