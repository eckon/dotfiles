vim.pack.add({
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

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

require("eckon.helper.utils").bind_map("n")(
  "<Leader>ft",
  "<CMD>NvimTreeFindFileToggle<CR>",
  { desc = "Nvim-Tree: Toggle find file" }
)
