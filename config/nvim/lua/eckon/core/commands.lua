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

cc.add("Update packages", {
  desc = "Update packages to the latest version",
  callback = function()
    vim.pack.update(nil, { force = true })
  end,
})

cc.add("Delete package", {
  desc = "Delete/Uninstall installed package",
  callback = function()
    local packages = vim.pack.get()
    local package_list = {}

    for _, pkg in ipairs(packages) do
      table.insert(package_list, {
        name = pkg.spec.name,
        src = pkg.spec.src,
        active = pkg.active,
        rev = pkg.rev,
      })
    end

    if #package_list == 0 then
      vim.notify("No packages installed", vim.log.levels.WARN)
      return
    end

    table.sort(package_list, function(a, b)
      -- always show inactive plugins first
      if a.active ~= b.active then
        return not a.active
      end

      return a.name < b.name
    end)

    -- add option of deleting all packages (mainly to install "frozen" packages
    table.insert(package_list, 1, { name = "ALL" })

    vim.ui.select(package_list, {
      prompt = "Select package to delete:",
      format_item = function(item)
        local status = item.active and "[active]" or "[inactive]"
        return string.format("%-25s %-15s %s", item.name, status, item.rev)
      end,
    }, function(choice)
      if choice then
        if choice.name == "ALL" then
          local ret = vim.fn.confirm("This will delete all packages, are you sure?", "&Yes\n&No", 2)
          -- 1 = Yes, 2 = No
          if ret == 1 then
            local del_packages = {}
            for _, pkg in ipairs(packages) do
              table.insert(del_packages, pkg.spec.name)
            end

            vim.pack.del(del_packages)
          end

          return
        end

        vim.pack.del({ choice.name })
      end
    end)
  end,
})
