local cc = require("eckon.helper.custom-command").custom_command

require("eckon.plugin.colorscheme.kanagawa")
require("eckon.plugin.colorscheme.catppuccin")

vim.cmd.colorscheme("catppuccin")

cc.add("Colorschemes", {
  desc = "Quick selection of different installed colorschemes",
  callback = function()
    require("snacks").picker.colorschemes()
  end,
})
