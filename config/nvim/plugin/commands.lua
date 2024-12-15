local cc = require("eckon.custom-command").custom_command

cc.add("Pair Programming", {
  desc = "Toggle absolute lines",
  callback = function()
    ---@diagnostic disable-next-line: undefined-field
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
  end,
})

cc.add("VS Code", {
  desc = "Open project in VSCode",
  callback = "!code $(pwd) -g %",
})

cc.add("Copy File Path", {
  desc = "Copy file path to system clipboard",
  callback = function()
    local path = vim.fn.expand("%")
    if path == "" then
      return
    end

    vim.fn.setreg("+", path)
    vim.notify('Copied filepath to clipboard: "' .. path .. '"', "info", { title = "Copied filepath" })
  end,
})
