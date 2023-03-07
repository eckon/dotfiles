local nnoremap = require("eckon.utils").nnoremap

local M = {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeFindFileToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
    init = function()
      nnoremap("<Leader>ft", "<CMD>NvimTreeFindFileToggle<CR>", { desc = "Toggle tree view" })
    end,
  },
}

return M
