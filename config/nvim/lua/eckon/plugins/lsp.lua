local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.utils").augroup("lsp")

local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  cmd = { "Mason", "MasonUpdate" },
  dependencies = {
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      dependencies = "williamboman/mason-lspconfig.nvim",
    },
    { "folke/lazydev.nvim", ft = { "lua" } },
    { "mrcjkb/rustaceanvim", version = "^5", lazy = false },
    { "pmizio/typescript-tools.nvim", dependencies = "nvim-lua/plenary.nvim" },
  },
}

M.config = function()
  require("lazydev").setup()

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "cssls",
      "emmet_ls",
      "html",
      "jsonls",
      "lua_ls",
      "marksman",
      "pyright",
      "rust_analyzer",
      "tailwindcss",
      "taplo",
      "terraformls",
      "ts_ls",
      "typst_lsp",
      "vimls",
      "volar",
      "yamlls",
    },
  })

  -- install packages for formatter and linter
  require("eckon.mason-helper").ensure_package_installed.execute()

  local lspconfig = require("lspconfig")
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      -- used for cmp, without keep the lspconfig but remove the capabilities
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig[server_name].setup({
        capabilities = capabilities,
      })
    end,
    ["rust_analyzer"] = function()
      -- do not call anything to not overwrite rustaceanvim
    end,
    ["ts_ls"] = function()
      require("typescript-tools").setup({
        settings = { tsserver_file_preferences = { includeInlayParameterNameHints = "all" } },
      })
    end,
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            hint = { enable = true },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
    end,
  })
end

autocmd("lspattach", {
  desc = "Enable inlay hints by default in all buffers with lsp",
  callback = function()
    vim.lsp.inlay_hint.enable(true)
  end,
  group = augroup,
})

autocmd("lspattach", {
  desc = "Add lsp specific key maps for current buffer",
  callback = function(args)
    local bind_map = require("eckon.utils").bind_map
    local nmap = function(lhs, rhs, desc)
      bind_map("n")(lhs, rhs, { desc = "LSP: " .. desc, buffer = args.buf })
    end

    -- `K` is default to hover in neovim, for more see `lsp-defaults`
    nmap("gd", function()
      require("telescope.builtin").lsp_definitions({ show_line = false })
    end, "Go to definitions")

    nmap("gD", function()
      require("telescope.builtin").lsp_type_definitions({ show_line = false })
    end, "Go to type definitions")

    nmap("grr", function()
      require("telescope.builtin").lsp_references({ show_line = false, include_declaration = false })
    end, "Go to references")

    nmap("<Leader>fL", function()
      require("telescope.builtin").lsp_document_symbols()
    end, "Search lsp symbols")

    nmap("<Leader>fd", function()
      require("telescope.builtin").diagnostics()
    end, "List all diagnostics")

    nmap("<Leader>la", function()
      vim.print("Use: `gra` instead")
    end, "Code action")

    nmap("<Leader>lr", function()
      vim.print("Use: `grn` instead")
    end, "Rename variable")
  end,
  group = augroup,
})

-- took from: https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md#-examples
autocmd("LspProgress", {
  desc = "Show LSP progress independent on notifier",
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(vim.lsp.status(), "info", {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
          ---@diagnostic disable-next-line: undefined-field
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
  group = augroup,
})

return M
