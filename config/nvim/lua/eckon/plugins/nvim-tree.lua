local use_fyler = true

local M = {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = not use_fyler,
    cmd = "NvimTreeFindFileToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        actions = { open_file = { quit_on_open = true } },
        git = { ignore = false },
        renderer = {
          add_trailing = true,
          group_empty = true,
          root_folder_label = false,
          symlink_destination = false,
        },
        view = {
          adaptive_size = true,
          relativenumber = true,
          side = "right",
        },
      })
    end,
    init = function()
      require("eckon.utils").bind_map("n")(
        "<Leader>ft",
        "<CMD>NvimTreeFindFileToggle<CR>",
        { desc = "Nvim-Tree: Toggle find file" }
      )
    end,
  },
  {
    "A7Lavinraj/fyler.nvim",
    enabled = use_fyler,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    branch = "stable",
    config = function()
      local fyler = require("fyler")

      fyler.setup({
        close_on_select = false,
        views = {
          explorer = {
            width = 0.5,
            height = 0.5,
            kind = "split:right",
            border = "single",
          },
        },
      })
    end,
    init = function()
      require("eckon.utils").bind_map("n")(
        "<Leader>ft",
        "<CMD>Fyler kind=split:right<CR>",
        { desc = "Fyler: Toggle find file tree" }
      )
    end,
  },
}

return M
