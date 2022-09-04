require('lualine').setup({
  options = {
    component_separators = {},
    globalstatus = true,
    section_separators = {},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
