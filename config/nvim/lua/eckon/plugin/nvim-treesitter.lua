-- NOTE: this plugin needs the `tree-sitter-cli` to exist in the environment
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

-- NOTE: this plugin runs the setup call with default values on adding, so no need to do anything here
local treesitter = require("nvim-treesitter")

-- handle fenced code blocks in markdown, or in vim help, these are not getting auto installed as its based on filetype
treesitter.install({
  "bash",
  "json",
  "lua",
  "sql",
  "vim",
})

-- enforce an update on startup to never be outdated
treesitter.update()

-- filetypes where treesitter should not be started
local excluded_filetypes = {
  "csv", -- normal highlight is way better (show cases different columns)
}

-- installation and starting of treesitter does not happen automatically anymore, so handle it by filetype
vim.api.nvim_create_autocmd("FileType", {
  desc = "Start and install treesitter on filetypes that exist",
  callback = function(args)
    local filetype = vim.treesitter.language.get_lang(args.match) or args.match
    local ts_exists = vim.list_contains(treesitter.get_available(), filetype)
    local is_excluded = vim.list_contains(excluded_filetypes, args.match)

    -- check if the current filetype has a treesitter parser and if so install and start it
    if ts_exists and not is_excluded then
      local max_wait_time = 1000 * 10 -- 10 sec
      treesitter.install(filetype):wait(max_wait_time)

      vim.treesitter.start()
    end
  end,
  group = require("eckon.helper.utils").augroup("treesitter"),
})
