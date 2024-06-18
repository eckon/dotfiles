local cc = require("eckon.custom-command").custom_command

cc.add("PairProgramming", {
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

cc.add("VSCode", {
  desc = "Open current project in VSCode",
  callback = "!code $(pwd) -g %",
})

cc.add("Browser", {
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
    vim.notify("Open repo in browser (and copy to clipboard): " .. path)
    vim.ui.open(path)
    vim.fn.setreg("+", path)
  end,
})

cc.add("CopyFilePath", {
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

cc.add("OpenGitLog", {
  desc = "Open Git log/blame",
  callback = function()
    local path = vim.fn.expand("%")
    if path == "" then
      return
    end

    local diff = vim.fn.system("git diff -- " .. path)
    local has_diff = diff ~= ""
    if has_diff then
      vim.notify("File has uncommitted changes, can not open git log")
      return
    end

    local positions = require("eckon.utils").get_visual_selection()
    local range = positions.visual_start.row .. "," .. positions.visual_end.row

    local git_log = "git log -L " .. range .. ":" .. path
    vim.fn.setreg("+", git_log)
    vim.cmd('silent !tmux new-window "' .. git_log .. '"')
  end,
})
