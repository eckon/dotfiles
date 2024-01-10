local is_notes = vim.fn.fnamemodify(vim.fn.system({ "git", "remote", "get-url", "origin" }), ":t"):gsub("\n", "")
  == "notes.git"

if is_notes then
  local bind_map = require("eckon.utils").bind_map
  local nmap = function(lhs, rhs, desc)
    bind_map("n")(lhs, rhs, { desc = "Notes: " .. desc })
  end

  nmap("<Leader><Leader>d", function()
    vim.ui.input({ prompt = "Search for daily note (default today)" }, function(input)
      -- CTRL-C will return, CR will give empty string which defaults to today
      if input == nil then
        return
      end

      local date_result = vim.fn.system({ "date", "+(%Y) (%m-%B) (%Y-%m-%d) (%A)", "-d", input }):gsub("\n", "")
      if vim.v.shell_error ~= 0 then
        vim.notify('Input not valid: "' .. input .. '"\n' .. 'Got error: "' .. date_result .. '"')
        return
      end

      local year, month, date, day = date_result:match("%((.*)%) %((.*)%) %((.*)%) %((.*)%)")

      -- create date in format: 2023/01-January/2023-01-01
      local file_path = "daily/" .. year .. "/" .. month .. "/" .. date .. ".md"
      if vim.fn.filereadable(file_path) == 0 then
        vim.fn.mkdir(vim.fn.fnamemodify(file_path, ":h"), "p")

        ---@param content string | string[]
        local write_content = function(content)
          if type(content) == "string" then
            content = { content }
          end

          vim.fn.writefile(content, file_path, "a")
        end

        write_content("# " .. date .. " (" .. day .. ")")
        write_content("## work")

        -- reoccuring task for work
        if day == "Friday" then
          local week_number = vim.fn.system({ "date", "+%V", "-d", input }):gsub("\n", "")
          write_content("- [ ] fill out PMS [[pms]] for week " .. week_number)
        end

        write_content({
          "## private",
          "### repeated tasks",
          "- [ ] workout",
          "  - [ ] dumbbell",
          "  - [ ] squats",
          "  - [ ] push-ups",
          "  - [ ] sit-ups",
          "- [ ] study",
          "### normal tasks",
        })
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
