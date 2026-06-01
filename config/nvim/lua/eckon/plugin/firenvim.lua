vim.pack.add({ "https://github.com/glacambre/firenvim" })

-- for now always trigger it, in the future handle it via hooks, see https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack#hooks
-- vim.cmd(":call firenvim#install(0)")

if vim.g.started_by_firenvim == true then
  vim.o.laststatus = 0
  vim.o.cmdheight = 0
  vim.g.firenvim_config = {
    localSettings = {
      -- use `C-e` instead to manually use neovim in the browser
      [".*"] = { takeover = "never" },
    },
  }
end
