require("eckon.plugin.kanagawa")

require("eckon.plugin.lsp")
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

require("eckon.plugin.nvim-surround")
require("eckon.plugin.markdown")
require("eckon.plugin.quicker")
require("eckon.plugin.snacks")
require("eckon.plugin.treesitter")
