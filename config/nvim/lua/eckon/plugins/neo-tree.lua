local nnoremap = require("eckon.utils").nnoremap

local M = {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      -- never want to update the root of my repo (which `bs` and `.` does)
      window = {
        mappings = {
          ["<bs>"] = "none",
          ["."] = "none",
        },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt.relativenumber = true
            vim.opt.number = true
          end,
        },
      },
    })
  end,
  init = function()
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
    nnoremap("<Leader>ft", "<CMD>Neotree toggle reveal_force_cwd<CR>", { desc = "Toggle file tree" })
  end,
}

return M
