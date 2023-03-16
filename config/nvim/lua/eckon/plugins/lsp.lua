local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup("eckon_autogroup_lsp", {})

local M = {
  "neovim/nvim-lspconfig",
  cond = not require("eckon.utils").run_minimal(),
  event = "BufReadPre",
  cmd = { "Mason" },
  dependencies = {
    { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    { "jose-elias-alvarez/null-ls.nvim", "jay-babu/mason-null-ls.nvim" },
    "j-hui/fidget.nvim",
    { "simrat39/rust-tools.nvim", "jose-elias-alvarez/typescript.nvim" },
    { "folke/trouble.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
  },
}

M.config = function()
  require("fidget").setup({})
  require("trouble").setup()

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "cssls",
      "emmet_ls",
      "html",
      "jsonls",
      "pyright",
      "rust_analyzer",
      "lua_ls",
      "tailwindcss",
      "taplo",
      "tsserver",
      "vimls",
      "volar",
      "yamlls",
    },
  })

  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.code_actions.eslint_d,
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.formatting.eslint_d,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.stylua,
      require("typescript.extensions.null-ls.code-actions"),
    },
  })

  -- install all sources of above null-ls
  require("mason-null-ls").setup({ automatic_installation = true })

  local lspconfig = require("lspconfig")
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig[server_name].setup({
        capabilities = capabilities,
      })
    end,
    ["rust_analyzer"] = function()
      require("rust-tools").setup({
        server = { settings = { ["rust-analyzer"] = { checkOnSave = { command = "clippy" } } } },
      })
    end,
    ["tsserver"] = function()
      require("typescript").setup({})
    end,
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
    end,
  })
end

autocmd("lspattach", {
  desc = "Ignore formatting of lua_ls", -- it conflicts with stylua
  callback = function(args)
    local bufnr = args.buf
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    for _, client in pairs(clients) do
      if client.name == "lua_ls" then
        client.server_capabilities.documentFormattingProvider = false
      end
    end
  end,
  group = autogroup,
})

autocmd("lspattach", {
  desc = "Stop lsp clients on buffer if buffer too big",
  callback = function(args)
    local bufnr = args.buf
    if vim.api.nvim_buf_line_count(bufnr) < 10000 then
      return
    end

    vim.notify("stopped lsp (file too big)")
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    for _, client in pairs(clients) do
      client.stop()
    end
  end,
  group = autogroup,
})

autocmd("lspattach", {
  desc = "Update omnifunc/formatexpr for current buffer",
  callback = function(args)
    local bufnr = args.buf
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
  end,
  group = autogroup,
})

autocmd("lspattach", {
  desc = "Add lsp specific key maps for current buffer",
  callback = function(args)
    local nnoremap = require("eckon.utils").nnoremap
    local inoremap = require("eckon.utils").inoremap

    nnoremap("K", vim.lsp.buf.hover, { buffer = args.buf, desc = "LSP: Hover Action" })
    nnoremap("gK", vim.lsp.buf.signature_help, { buffer = args.buf, desc = "LSP: Signature Help" })
    inoremap("<C-k>", vim.lsp.buf.signature_help, { buffer = args.buf, desc = "LSP: Signature Help" })

    nnoremap("gd", function()
      require("telescope.builtin").lsp_definitions({ show_line = false })
    end, { buffer = args.buf, desc = "LSP: Go to definitions" })

    nnoremap("gD", function()
      require("telescope.builtin").lsp_type_definitions({ show_line = false })
    end, { buffer = args.buf, desc = "LSP: Go to type definitions" })

    nnoremap("gr", function()
      require("telescope.builtin").lsp_references({ show_line = false, include_declaration = false })
    end, { buffer = args.buf, desc = "LSP: Go to references" })

    nnoremap("<Leader>fL", function()
      require("telescope.builtin").lsp_document_symbols()
    end, { buffer = args.buf, desc = "LSP: Search lsp symbols" })

    nnoremap("[d", vim.diagnostic.goto_prev, { buffer = args.buf, desc = "Jump to previous diagnostic" })
    nnoremap("]d", vim.diagnostic.goto_next, { buffer = args.buf, desc = "Jump to next diagnostic" })

    nnoremap("<Leader>la", vim.lsp.buf.code_action, { buffer = args.buf, desc = "LSP: Code action" })
    nnoremap("<Leader>lr", vim.lsp.buf.rename, { buffer = args.buf, desc = "LSP: Rename variable" })
    nnoremap("<Leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = args.buf, desc = "LSP: Format buffer" })

    nnoremap("<Leader>ld", vim.diagnostic.open_float, { buffer = args.buf, desc = "Open diagnostic float" })
  end,
  group = autogroup,
})

return M
