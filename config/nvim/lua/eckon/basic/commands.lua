local custom_command = require("eckon.utils").custom_command

-- show absolute lines for pair programming
custom_command("PairProgramming", [[tabdo windo set statuscolumn=%l\ %r]])

-- open current project and goto the current buffer file in vscode
custom_command("VSCode", "!code $(pwd) -g %")

-- open current buffer file in the browser (needs to be cloned over git with ssh)
custom_command("Browser", function()
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

  local cmd = '!xdg-open "'
    .. vim.trim(repo_base_path)
    .. "/"
    .. vim.trim(repo_branch)
    .. "/"
    .. vim.fn.expand("%")
    .. '"'

  vim.api.nvim_command(cmd)
end)
