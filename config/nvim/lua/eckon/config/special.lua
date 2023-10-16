local is_wsl = vim.fn.has("wsl") == 1
local is_notes = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") == "notes"

local bind_map = require("eckon.utils").bind_map

-- WSL
if is_wsl then
  -- overwrites normal <Leader>y to use clipboard (pipe selection into command)
  bind_map("v")(
    "<Leader>y",
    'y<CMD>system("/mnt/c/windows/system32/clip.exe", @")<CR>',
    { desc = "Copy into windows system clipboard (from wsl)" }
  )
end

-- NOTES
if is_notes then
  local nmap = function(lhs, rhs, desc)
    bind_map("n")(lhs, rhs, { desc = "Notes: " .. desc })
  end

  nmap("<Leader>nd", function()
    vim.ui.input({ prompt = "Search for daily note (default today)" }, function(input)
      -- CTRL-C will return, CR will give empty string which defaults to today
      if input == nil then
        return
      end

      -- if year is longer than a normal year string 1234 then we have an error
      local year = vim.fn.system({ "date", "+%Y", "-d", input }):gsub("\n", "")
      if #year > 4 then
        vim.notify("Could not find date: " .. year)
        return
      end

      local month = vim.fn.system({ "date", "+%m-%B", "-d", input }):gsub("\n", "")
      local date = vim.fn.system({ "date", "+%Y-%m-%d", "-d", input }):gsub("\n", "")
      local day = vim.fn.system({ "date", "+%A", "-d", input }):gsub("\n", "")

      -- create date in format: 2023/01-January/2023-01-01
      local file_path = "daily/" .. year .. "/" .. month .. "/" .. date .. ".md"
      if vim.fn.filereadable(file_path) == 0 then
        vim.fn.mkdir(vim.fn.fnamemodify(file_path, ":h"), "p")
        vim.fn.writefile({
          "# " .. date .. " (" .. day .. ")",
          "",
          "## work",
          "",
          "### daily",
          "",
          "## private",
        }, file_path)
      end

      vim.cmd("e " .. file_path)
    end)
  end, "Open daily note")

  nmap("<Leader>no", function()
    vim.ui.select({ "daily", "iu", "private", "all" }, {
      prompt = "Select root",
      format_item = function(item)
        return item
      end,
    }, function(choice)
      if choice == nil or choice == "" then
        return
      end

      local root = choice
      if choice == "all" then
        root = "**"
      end

      -- TODO: use ripgrep instead
      -- TODO: maybe split daily with rest
      local pattern = "- \\[ \\]"
      local paths = root .. "/**"
      vim.api.nvim_command("vimgrep '" .. pattern .. "' " .. paths)
      vim.api.nvim_command("copen")
    end)
  end, "Search for open tasks")
end
