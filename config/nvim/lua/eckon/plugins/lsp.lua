local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.utils").augroup("lsp")
local mason_helper = require("eckon.mason-helper")

local M = {
  -- NOTE: keep lspconfig for more difficult lsp setups also some plugins use it interally
  --       simpler setups are done manually to see if i can move away from lspconfig
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
  require("typescript-tools").setup({
    settings = { tsserver_file_preferences = { includeInlayParameterNameHints = "all" } },
  })

  require("mason").setup()
  require("mason-lspconfig").setup()

  local handled_manually = {
    "lua_ls",
    "marksman",
  }

  local handled_by_mason = {
    "cssls",
    "emmet_ls",
    "html",
    "jsonls",
    "pyright",
    "rust_analyzer",
    "tailwindcss",
    "taplo",
    "terraformls",
    "ts_ls",
    "vimls",
    "volar",
    "yamlls",
  }

  -- try installing packages for lsps, formatters and linters at least once
  mason_helper.ensure_package_installed.add(handled_manually)
  mason_helper.ensure_package_installed.add(handled_by_mason)
  mason_helper.ensure_package_installed.execute()

  -- NOTE: setup basic lsps manually, to someday move away from lspconfig alltogether
  vim.lsp.enable(handled_manually)

  local lspconfig = require("lspconfig")
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      -- used for cmp, without keep the lspconfig but remove the capabilities
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- used for blink.cmp
      -- local capabilities = require("blink.cmp").get_lsp_capabilities()
      lspconfig[server_name].setup({ capabilities = capabilities })
    end,

    -- ignore these, they will be handled either manually or by another plugin
    ["lua_ls"] = function() end,
    ["marksman"] = function() end,
    ["rust_analyzer"] = function() end,
    ["ts_ls"] = function() end,
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

    local ok, _ = pcall(require, "fzf-lua")
    if not ok then
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.notify("LSP required plugins are not installed, please install fzf-lua", "error")
      return
    end

    -- `K` is default to hover in neovim, for more see `lsp-defaults`

    nmap("gd", function()
      require("fzf-lua").lsp_definitions()
    end, "Go to definitions")

    -- this should collect all things, but might not find everything thats expected
    nmap("gD", function()
      require("fzf-lua").lsp_finder()
    end, "Go to everything via finder")

    nmap("grr", function()
      require("fzf-lua").lsp_references()
    end, "Go to references")

    nmap("gri", function()
      require("fzf-lua").lsp_implementations()
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
