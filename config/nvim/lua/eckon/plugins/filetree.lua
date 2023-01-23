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
    init = function() nnoremap("<Leader>ft", "<CMD>NvimTreeFindFileToggle<CR>", { desc = "Toggle tree view" }) end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
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
          auto_expand_width = true,
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
  },
}

return M
