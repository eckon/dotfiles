vim.g.mapleader = " "

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

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({ import = "eckon.plugins" }, {
  change_detection = { notify = false },
})
