return {
  "folke/lazydev.nvim",
  ft = { "lua" },
  config = function()
    require("lazydev").setup()
    vim.lsp.enable("lua_ls")
  end,
}
