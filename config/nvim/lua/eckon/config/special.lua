local is_wsl = vim.fn.has("wsl") == 1
local is_notes = vim.fn.fnamemodify(vim.fn.system({ "git", "remote", "get-url", "origin" }), ":t"):gsub("\n", "")
  == "notes.git"

local bind_map = require("eckon.utils").bind_map

-- WSL
if is_wsl then
  -- overwrites normal <Leader>y to use clipboard (pipe selection into command)
  bind_map("v")(
    "<Leader>y",
    'y<CMD>call system("/mnt/c/Windows/System32/clip.exe", @")<CR>',
    { desc = "Copy into windows system clipboard (from wsl)" }
  )
end

-- NOTES
if is_notes then
  local nmap = function(lhs, rhs, desc)
    bind_map("n")(lhs, rhs, { desc = "Notes: " .. desc })
  end

  nmap("<Leader><Leader>d", function()
    vim.ui.input({ prompt = "Search for daily note (default today)" }, function(input)
      -- CTRL-C will return, CR will give empty string which defaults to today
      if input == nil then
        return
      end

      -- add env to force date to return english dates
      vim.env.LC_ALL = "en_US"
      local date_result = vim.fn.system({ "date", "+(%Y) (%m-%B) (%Y-%m-%d) (%A)", "-d", input }):gsub("\n", "")
      vim.env.LC_ALL = nil

      if vim.v.shell_error ~= 0 then
        vim.notify('Input not valid: "' .. input .. '"\n' .. 'Got error: "' .. date_result .. '"')
        return
      end

      local year = date_result:gsub("%((.*)%) %(.*%) %(.*%) %(.*%)", "%1")
      local month = date_result:gsub("%(.*%) %((.*)%) %(.*%) %(.*%)", "%1")
      local date = date_result:gsub("%(.*%) %(.*%) %((.*)%) %(.*%)", "%1")
      local day = date_result:gsub("%(.*%) %(.*%) %(.*%) %((.*)%)", "%1")

      -- create date in format: 2023/01-January/2023-01-01
      local file_path = "daily/" .. year .. "/" .. month .. "/" .. date .. ".md"
      if vim.fn.filereadable(file_path) == 0 then
        vim.fn.mkdir(vim.fn.fnamemodify(file_path, ":h"), "p")

        vim.fn.writefile({ "# " .. date .. " (" .. day .. ")" }, file_path)
        vim.fn.writefile({ "## work" }, file_path, "a")

        -- reoccuring task for work
        if day == "Friday" then
          vim.fn.writefile({ "- [ ] fill out PMS [[pms]]" }, file_path, "a")
        end

        vim.fn.writefile({ "## private" }, file_path, "a")
        vim.fn.writefile({ "- [ ] workout" }, file_path, "a")
        vim.fn.writefile({ "- [ ] study" }, file_path, "a")
      end

      vim.cmd("e " .. file_path)
    end)
  end, "Open daily note")

  nmap("<Leader><Leader>o", function()
    vim.ui.select({ "daily", "iu", "private", "all" }, {
      prompt = "Select root for open tasks",
      format_item = function(item)
        return item
      end,
    }, function(choice)
      if choice == nil or choice == "" then
        return
      end

      local opts = { search = "^- \\[ \\]", use_regex = true }
      if choice ~= "all" then
        opts.search_dirs = { choice }
      end

      require("telescope.builtin").grep_string(opts)
    end)
  end, "Search for open tasks")
end
