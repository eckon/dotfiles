local cc = require("eckon.helper.custom-command").custom_command

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
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.notify('Copied filepath to clipboard: "' .. path .. '"')
  end,
})

cc.add("Toggle virtual line diagnostics", {
  desc = "Enable and disable virtual line diagnostics",
  callback = function()
    local current_settings = vim.diagnostic.config()
    if current_settings ~= nil and current_settings.virtual_lines then
      vim.diagnostic.config({ virtual_lines = false })
    else
      vim.diagnostic.config({ virtual_lines = true })
    end
  end,
})

cc.add("Compare files/folder with difftool", {
  desc = "Enable and run difftool",
  callback = function()
    vim.cmd("packadd nvim.difftool")
    vim.fn.feedkeys(":DiffTool ", "n")
  end,
})

cc.add("Open buffer in nvim terminal", {
  desc = "Parse escape sequences colors",
  callback = "call nvim_open_term(0, #{})",
})
