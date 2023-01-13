local M = {}

---Trim string to remove empty trailing lines and new lines
---@param str string
---@return string
local function trim_string(str)
  local replace, _ = string.gsub(str, "%s+", "")
  return replace
end

M.trim = trim_string

---Create user command with 'CC'-prefix for quick access
---@param name string
---@param cmd string|function
---@param options? table
local function custom_command(name, cmd, options)
  options = options or {}
  vim.api.nvim_create_user_command("CC" .. name, cmd, options)
end

---Command completion function, to sort and filter passed complete values
---@param completion_strings table
---@param passed_arguments table
---@return table
local function command_complete_filter(completion_strings, passed_arguments)
  -- filter completions out, which the caller did not type on the command line
  local filtered_completion_strings = vim.tbl_filter(
    function(s) return s:sub(1, #passed_arguments) == passed_arguments end,
    completion_strings
  )

  table.sort(filtered_completion_strings)

  return filtered_completion_strings
end

M.custom_command = custom_command
M.command_complete_filter = command_complete_filter

---Create async job for running external commands and calling a callback on the output
---@param command string
---@param args table
---@param callback fun(output: table)
local function async_external_command(command, args, callback)
  local uv = vim.loop
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local command_output = {}

  local handle
  handle, _ = uv.spawn(command, {
    args = args,
    -- sdtin / stdout / stderr
    stdio = { nil, stdout, stderr },
    detached = true,
  }, function()
    -- some commands return valid data and error code, so can not check here
    vim.schedule(function() callback(command_output) end)
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
  end)

  -- some commands output line by line -> insert everything into one table
  -- if send in a dump, then the user needs to manually split it
  uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if not data then
      return
    end

    table.insert(command_output, data)
  end)

  uv.read_start(stderr, function(err, data)
    assert(not err, err)
    -- seems like i need to ignore these as otherwise also valid calls will log error
    if not data then
      return
    end

    local args_string = ""
    vim.tbl_map(function(a) args_string = args_string .. " " .. a end, args)
    local message = "Error while trying to run " .. command .. args_string
    vim.schedule(function() vim.notify(message .. ":\n\n" .. data) end)
  end)
end

M.async_external_command = async_external_command

---Create partial function to store mode and options
---@param mode string|table
---@param outer_options? table
local function bind_map(mode, outer_options)
  outer_options = outer_options or { noremap = true }

  ---Function to set a mapping of a given mode and a set of options
  ---@param lhs string
  ---@param rhs string|function
  ---@param inner_options? table
  return function(lhs, rhs, inner_options)
    local options = vim.tbl_extend("force", outer_options, inner_options or {})
    vim.keymap.set(mode, lhs, rhs, options)
  end
end

M.nmap = bind_map("n", { noremap = false })
M.noremap = bind_map({ "n", "v", "o" })

M.nnoremap = bind_map("n")
M.inoremap = bind_map("i")
M.vnoremap = bind_map("v")

M.onoremap = bind_map("o")
M.xnoremap = bind_map("x")

return M
