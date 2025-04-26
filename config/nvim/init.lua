-- needs to be set before lazy is loaded
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- package/plugins management
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
  local lazy_repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazy_repo,
    lazy_path,
  })
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup("eckon.plugins", {
  change_detection = { notify = false },
})
