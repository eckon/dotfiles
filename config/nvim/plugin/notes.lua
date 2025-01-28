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

    write_content({
      "# " .. date .. " (" .. day .. ")",
      "",
      "## work",
      "",
      "### repeating tasks",
      "",
      "- [ ] check-in",
      "- [ ] reserve desk (now and later)",
      "- [ ] get flex room for daily (if enough people are there)",
      "- [ ] get food and drink",
      "- [ ] check todays [food](https://www.sv-restaurant.de/bigdutchman-vechta/home)",
      "- [ ] mails",
      "- [ ] jira board",
      "- [ ] put spent time in tickets",
      "- [ ] write down potential retro topics",
      "- [ ] check my goals and tasks",
      "  - [ ] UI/UX tag and focus on new tasks",
      "  - [ ] DX tag and setting new standards",
      "  - [ ] Research tag and creation of new dev-day tasks",
      "  - [ ] Knowledge-Share tag and taking Hendrik tasks",
      "  - [ ] Improving Monitoring",
      "- [ ] check-out",
      "",
      "### normal tasks",
      "",
      "- [ ] move previous work tasks here",
      "",
      "## private",
      "",
      "- [ ] look into [[todo]]",
    })
  end

  vim.cmd("e " .. file_path)
end

local cc = require("eckon.custom-command").custom_command

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
        -- search should allow regex, so dont escape automatically
        no_esc = true,
        search = "^- \\[ \\]",
        -- we have templates, ignore them always
        fzf_opts = { ["--query"] = "!_templates " },
      }

      if choice ~= "all" then
        opts.fzf_opts["--query"] = opts.fzf_opts["--query"] .. "'" .. choice .. " "
      end

      require("fzf-lua").grep(opts)
    end)
  end,
})
