local custom_command = require("eckon.utils").custom_command

custom_command(
  "PairProgramming",
  [[tabdo windo set statuscolumn=%l\ %r]],
  { desc = "Show absolute lines for pair programming" }
)

custom_command("VSCode", "!code $(pwd) -g %", { desc = "Open current project in VSCode" })

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

  if repo_base_path == nil or repo_branch == nil then
    vim.notify("Could not fine repo path")
    return
  end

  local path = vim.trim(repo_base_path) .. "/" .. vim.trim(repo_branch) .. "/" .. vim.fn.expand("%")
  vim.notify("Open repo in browser: " .. path)
  vim.ui.open(path)
end, { desc = "Open current buffer file in the browser" })
