vim.pack.add({ "https://github.com/glacambre/firenvim" })

if vim.g.started_by_firenvim == true then
  vim.cmd(":call firenvim#install(0)")
  vim.o.laststatus = 0
  vim.o.cmdheight = 0
  vim.g.firenvim_config = {
    localSettings = {
      -- use `C-e` instead to manually use neovim in the browser
      [".*"] = { takeover = "never" },
    },
  }
end
