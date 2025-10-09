vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-mini/mini.nvim",
})

require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

require("lualine").setup({
  options = {
    component_separators = {},
    globalstatus = true,
    section_separators = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
