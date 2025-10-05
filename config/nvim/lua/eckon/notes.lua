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

  -- macs `date` function is different, use `gdate` then as this is like linux
  local date_function = "date"
  if vim.fn.executable("gdate") == 1 then
    date_function = "gdate"
  end

  local date_result = vim.fn
    .system({
      date_function,
      date_format_parameter,
      "-d",
      input,
    })
    :gsub("\n", "")

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

    write_content({
      "# " .. date .. " (" .. day .. ")",
      "",
      "- [ ] do some basic physical exercises",
      "- [ ] look into [[todo]]",
      "- [ ] check-in",
      "- [ ] reserve desk for today and following days",
      "- [ ] reserve room for today and following days",
      "- [ ] check food",
      "- [ ] check emails",
      "- [ ] check jira",
      "- [ ] put spent time in tickets",
      "- [ ] write down potential retro topics",
      "- [ ] check my goals and tasks",
      "  - [ ] `UI/UX` tag and focus on new tasks",
      "  - [ ] `DX` / `TechnicalDebt` tag and improve workflows",
      "  - [ ] `Research` tag and creation of new dev-day tasks",
      "  - [ ] `Knowledge-Share` tag and taking Hendrik tasks",
      "  - [ ] `Monitoring` tag and Improving Monitoring",
      "- [ ] check-out",
      "- [ ] delete these tasks and do not commit them",
      "",
      "## work",
      "",
      "- [ ] move previous work tasks here and delete this task",
      "",
      "## private",
      "",
      "- [ ] move previous private tasks here and delete this task",
    })
  end

  vim.cmd("e " .. file_path)
end

local cc = require("eckon.helper.custom-command").custom_command

cc.add("Daily Note", {
  desc = "Open todays daily note",
  callback = function()
    open_daily_note()
  end,
})

cc.add("Daily Note Custom", {
  desc = "Open custom daily note",
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
  desc = "Search open tasks",
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

      local opts = {
        -- search is in live search, user then can use normal picker to further filter
        live = false,
        regex = true,
        search = "^- \\[ \\]",
        exclude = { "_templates" },
      }

      if choice ~= "all" then
        opts.dirs = { choice }
      end

      require("snacks").picker.grep(opts)
    end)
  end,
})
