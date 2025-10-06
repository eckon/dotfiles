-- completion needs to be before lsp, as lsp depends on it
require("eckon.plugin.completion")
require("eckon.plugin.lsp")

require("eckon.plugin.lsp_lua")
require("eckon.plugin.lsp_rust")
require("eckon.plugin.lsp_typescript")

require("eckon.plugin.formatter")
require("eckon.plugin.linter")
require("eckon.plugin.lualine")
require("eckon.plugin.mini")

local use_fyler = true
if use_fyler then
  require("eckon.plugin.fyler")
else
  require("eckon.plugin.nvim-tree")
end

require("eckon.plugin.others")
require("eckon.plugin.snacks")
require("eckon.plugin.treesitter")
