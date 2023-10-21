local custom_command = require("eckon.utils").custom_command

vim.api.nvim_create_user_command("CustomCommand", function()
  vim.ui.select(custom_command.keys(), {
    prompt = 'Run "CustomCommand"',
    format_item = function(item)
      return item .. " - " .. custom_command.get(item).desc
    end,
  }, function(choice)
    if choice == nil then
      return
    end

    custom_command.execute(choice)
  end)
end, { desc = "Select and run predefined custom command" })

custom_command.add("PairProgramming", {
  desc = "Toggle absolute lines (for pair programming)",
  callback = function()
    local is_set = vim.opt.statuscolumn:get() ~= ""
    if is_set then
      vim.opt.statuscolumn = ""
    else
      vim.opt.statuscolumn = "%l %r"
    end
  end,
})

custom_command.add("VSCode", {
  desc = "Open current project in VSCode",
  callback = "!code $(pwd) -g %",
})

custom_command.add("Browser", {
  desc = "Open current buffer file in the browser",
  callback = function()
    local repo_base_path = vim.fn.system([[
        git config --get remote.origin.url \
          | sed 's/\.git//g' \
          | sed 's/:/\//g' \
          | sed 's/git@/https:\/\//'
        ]])

    local repo_branch = vim.fn.system([[
        git config --get remote.origin.url \
          | grep -q 'bitbucket.org' \
            && echo 'src/master' \
            || echo blob/$(git branch --show-current)
        ]])

    if repo_base_path == nil or repo_branch == nil then
      vim.notify("Could not fine repo path")
      return
    end

    local path = vim.trim(repo_base_path) .. "/" .. vim.trim(repo_branch) .. "/" .. vim.fn.expand("%")
    vim.notify("Open repo in browser: " .. path)
    vim.ui.open(path)
  end,
})

custom_command.add("CopyFilePath", {
  desc = "Copy the current file path into system clipboard",
  callback = function()
    local path = vim.fn.expand("%")
    if path == "" then
      return
    end

    vim.fn.setreg("+", path)
    vim.notify('Copied filepath to clipboard: "' .. path .. '"')
  end,
})
