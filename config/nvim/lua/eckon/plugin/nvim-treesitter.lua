vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

-- NOTE: this plugin runs the setup call with default values on adding, so no need to do anything here
local treesitter = require("nvim-treesitter")

-- pre-install parsers i will use either way
treesitter.install({
  "bash",
  "json",
  "lua",
  "markdown",
  "sh",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
})

-- enforce an update on startup to never be outdated
treesitter.update()

-- installation and starting of treesitter does not happen automatically anymore, so handle it by filetype
vim.api.nvim_create_autocmd("FileType", {
  desc = "Start and install treesitter on filetypes that exist",
  callback = function(args)
    local file_language = vim.treesitter.language.get_lang(args.match) or args.match
    local all_parsers = treesitter.get_available()

    -- check if the current filetype has a treesitter parser and if so insatll and start it
    for _, parser_language in ipairs(all_parsers) do
      if parser_language == file_language then
        local max_wait_time = 1000 * 30 -- 30 sec
        treesitter.install(parser_language):wait(max_wait_time)

        vim.treesitter.start(args.buf, parser_language)
      end
    end
  end,
  group = require("eckon.helper.utils").augroup("treesitter"),
})
