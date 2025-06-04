local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.utils").augroup("lsp")

local M = {
  -- used for more complicated setups, all handled by the `vim.lsp.enable()` part
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", build = ":MasonUpdate", lazy = false },
    { "folke/lazydev.nvim", ft = { "lua" } },
    { "mrcjkb/rustaceanvim", version = "^6", lazy = false },
    { "pmizio/typescript-tools.nvim", dependencies = "nvim-lua/plenary.nvim" },
    -- used in the `/lsp` folder
    { "b0o/schemastore.nvim" },
  },
}

M.config = function()
  require("lazydev").setup()

  require("typescript-tools").setup({
    settings = { tsserver_file_preferences = { includeInlayParameterNameHints = "all" } },
  })

  require("mason").setup()

  -- NOTE: manual installation is needed
  -- edge cases therefore removed:
  -- - ts_ls         -> typescript-tools - handles all of it  -> **DO NOT INSTALL**
  -- - rust_analyzer -> rustaceanvim     - handles only setup -> **DO INSTALL**
  -- NOTE: lsp settings are in the `/lsp` folder, they extent (not replace) lspconfig
  local servers = {
    "cssls",
    "emmet_ls",
    "html",
    "jsonls",
    "lua_ls",
    "marksman",
    "pyright",
    "tailwindcss",
    "taplo",
    "terraformls",
    "vimls",
    "vue_ls",
    "yamlls",
  }

  -- NOTE: keeping both capabilities, until I decide for one or the other completion engine
  -- used for cmp, without keep the lspconfig but remove the capabilities
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  -- used for blink.cmp
  -- local capabilities = require("blink.cmp").get_lsp_capabilities()

  -- NOTE: this is just the default, other parts might overwrite it again (e.g. root_markers)
  vim.lsp.config("*", { capabilities = capabilities, root_markers = { ".git" } })
  vim.lsp.enable(servers)

  -- enable inlay hints by default in all buffers with lsp and this feature
  vim.lsp.inlay_hint.enable(true)
end

autocmd("lspattach", {
  desc = "Add lsp specific key maps for current buffer",
  callback = function(args)
    local bind_map = require("eckon.utils").bind_map
    local nmap = function(lhs, rhs, desc)
      bind_map("n")(lhs, rhs, { desc = "LSP: " .. desc, buffer = args.buf })
    end

    -- `K` is default to hover in neovim, for more see `lsp-defaults`

    nmap("gd", function()
      require("snacks").picker.lsp_definitions()
    end, "Go to definitions")

    nmap("grr", function()
      require("snacks").picker.lsp_references()
    end, "Go to references")

    nmap("gri", function()
      require("snacks").picker.lsp_implementations()
    end, "Go to implementations")
  end,
  group = augroup,
})

-- took from: https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md#-examples
autocmd("LspProgress", {
  desc = "Show LSP progress independent on notifier",
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    ---@diagnostic disable-next-line: param-type-mismatch
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
