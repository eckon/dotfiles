vim.pack.add({ "https://github.com/folke/lazydev.nvim" })

-- only needed if we touch any lua file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    require("lazydev").setup()
    vim.lsp.enable("lua_ls")
  end,
  once = true,
  group = require("eckon.helper.utils").augroup("lsp_lua"),
})
