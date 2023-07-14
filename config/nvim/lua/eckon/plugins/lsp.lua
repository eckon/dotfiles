local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup("eckon_autogroup_lsp", {})

local M = {
  "neovim/nvim-lspconfig",
  cond = not require("eckon.utils").run_minimal(),
  event = "BufReadPre",
  cmd = { "Mason" },
  dependencies = {
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      dependencies = "williamboman/mason-lspconfig.nvim",
    },
    { "jose-elias-alvarez/null-ls.nvim", dependencies = "jay-babu/mason-null-ls.nvim" },
    { "j-hui/fidget.nvim", branch = "legacy" },
    { "simrat39/rust-tools.nvim" },
    { "pmizio/typescript-tools.nvim", dependencies = "nvim-lua/plenary.nvim" },
  },
}

M.config = function()
  require("fidget").setup({})

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
      require("typescript-tools").setup({})
    end,
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            hint = { enable = true },
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
  desc = "Add lsp specific key maps for current buffer",
  callback = function(args)
    local bind_map = require("eckon.utils").bind_map
    local nmap = function(lhs, rhs, desc)
      bind_map("n")(lhs, rhs, { desc = "LSP: " .. desc, buffer = args.buf })
    end

    nmap("K", vim.lsp.buf.hover, "Hover Action")
    nmap("gK", vim.lsp.buf.signature_help, "Signature Help")
    bind_map("i")("<C-k>", vim.lsp.buf.signature_help, { buffer = args.buf, desc = "LSP: Signature Help" })

    -- stylua: ignore start
    nmap("gd", function() require("telescope.builtin").lsp_definitions({ show_line = false }) end, "Go to definitions")
    nmap("gD", function() require("telescope.builtin").lsp_type_definitions({ show_line = false }) end, "Go to type definitions")
    nmap("gr", function() require("telescope.builtin").lsp_references({ show_line = false, include_declaration = false }) end, "Go to references")
    nmap("<Leader>fL", function() require("telescope.builtin").lsp_document_symbols() end, "Search lsp symbols")

    nmap("[d", vim.diagnostic.goto_prev, "Jump to previous diagnostic")
    nmap("]d", vim.diagnostic.goto_next, "Jump to next diagnostic")

    nmap("<Leader>la", vim.lsp.buf.code_action, "Code action")
    nmap("<Leader>lr", vim.lsp.buf.rename, "Rename variable")
    nmap("<Leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")

    nmap("<Leader>ld", vim.diagnostic.open_float, "Open diagnostic float")
    -- stylua: ignore end
  end,
  group = autogroup,
})

return M
