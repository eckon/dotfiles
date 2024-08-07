local is_notes = vim.fn.fnamemodify(vim.fn.system({ "git", "remote", "get-url", "origin" }), ":t"):gsub("\n", "")
  == "notes.git"

if not is_notes then
  return
end

---Create a new daily note or open an existing one, default today
---@param date_string? string
local function open_daily_note(date_string)
  local input = date_string or "today"
  local date_format_parameter = "+(%Y) (%m-%B) (%Y-%m-%d) (%A)"
  local date_result = vim.fn.system({ "date", date_format_parameter, "-d", input }):gsub("\n", "")

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
    write_content({
      "## work",
      "### repeating tasks",
      "- [ ] reserve desk",
      "  - [ ] today",
      "  - [ ] next day",
      "- [ ] get food and drink",
      "- [ ] check",
      "  - [ ] check-in",
      "  - [ ] [food](https://www.sv-restaurant.de/bigdutchman-vechta/home)",
      "  - [ ] put spent time in tickets (or overflow ticket if non specific)",
      "  - [ ] check-out",
      "### normal tasks",
      "- [ ] move previous work tasks here",
    })

    write_content({
      "## private",
      "### repeating tasks",
      "- [ ] do babbel",
      "- [ ] do workout",
      "### normal tasks",
      "- [ ] move previous normal tasks here",
    })
  end

  vim.cmd("e " .. file_path)
end

local cc = require("eckon.custom-command").custom_command

cc.add("DailyNote", {
  desc = "Notes: Open todays daily note",
  callback = function()
    open_daily_note()
  end,
})

cc.add("DailyNoteCustom", {
  desc = "Notes: Open custom daily note",
  callback = function()
    vim.ui.input({ prompt = "Search for daily note" }, function(input)
      -- CTRL-C will return, CR will give empty string
      if input == nil or input == "" then
        return
      end

      -- check if input is a valid date
      vim.fn.system({ "date", "+%Y", "-d", input })
      if vim.v.shell_error ~= 0 then
        -- fallback to dialog if input is not a valid date
        local dialog_result = vim.fn
          .system({
            "yad",
            "--calendar",
            "--date-format=%Y-%m-%d",
            "--center",
            '--title="Select Date"',
          })
          :gsub("\n", "")

        -- output can have error inside, so we only take the last 10 characters (which is the date)
        local length = string.len(dialog_result)
        input = string.sub(dialog_result, length - 10, length)
      end

      open_daily_note(input)
    end)
  end,
})

cc.add("Todo", {
  desc = "Notes: Search open tasks",
  callback = function()
    vim.ui.select({ "daily", "big-dutchman", "private", "all" }, {
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
  end,
})
