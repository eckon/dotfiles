local nnoremap = require("eckon.utils").nnoremap

local M = {
  "kyazdani42/nvim-tree.lua",
  cmd = "NvimTreeFindFileToggle",
  enabled = false,
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      actions = { open_file = { quit_on_open = true } },
      git = { ignore = false },
      renderer = {
        add_trailing = true,
        group_empty = true,
      },
      view = {
        adaptive_size = true,
        hide_root_folder = true,
        relativenumber = true,
      },
    })
  end,
  init = function() nnoremap("<Leader>.", "<CMD>NvimTreeFindFileToggle<CR>", { desc = "Toggle tree view" }) end,
}

return M
