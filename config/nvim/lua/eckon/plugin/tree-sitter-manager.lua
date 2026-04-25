vim.pack.add({ "https://github.com/romus204/tree-sitter-manager.nvim" })

require("tree-sitter-manager").setup({
  -- handle fenced code blocks in markdown, or in vim help, these are not getting auto installed as its based on filetype
  ensure_installed = {
    "bash",
    "json",
    "lua",
    "sql",
    "vim",
  },

  -- normal highlight is way better (show cases different columns)
  nohighlight = { "csv" },

  -- install missing parsers when editing a new file
  auto_install = true,
})
