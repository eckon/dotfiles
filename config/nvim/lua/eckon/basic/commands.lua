local custom_command = require("eckon.utils").custom_command
local command_complete_filter = require("eckon.utils").command_complete_filter

-- quickly setup vim for pair programming
custom_command("PairProgramming", "tabdo windo set norelativenumber")

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

-- resource lua based vim config
custom_command("Resource", function(data)
  -- lua caches the loaded packages in package.loaded
  -- to resource these, clear them and then rerun the init.lua file
  for name, _ in pairs(package.loaded) do
    if name:match("^eckon") then
      package.loaded[name] = nil
      vim.notify("Cleared: " .. name)
    end

    -- if caller passes package name, also clear cache for given name
    if data.args ~= "" then
      if name:match(data.args) then
        package.loaded[name] = nil
        vim.notify("Cleared: " .. name)
      end
    end
  end

  dofile(vim.env.MYVIMRC)
end, {
  nargs = "?",
  complete = function(arg)
    local package_names = {}
    for name, _ in pairs(package.loaded) do
      -- only show root packages (that do not include a '.')
      if not name:match("%.") then
        table.insert(package_names, name)
      end
    end

    return command_complete_filter(package_names, arg)
  end,
})
