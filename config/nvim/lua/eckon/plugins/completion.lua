if require("eckon.utils").run_minimal() then
  return {}
end

-- fallback to cmp as blink has no auto import and has still some completion issues
local use_blink = false

return {
  {
    "saghen/blink.cmp",
    enabled = use_blink,
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    config = function()
      ---@diagnostic disable: missing-fields
      require("blink.cmp").setup({
        accept = { auto_brackets = { enabled = true } },
        trigger = { signature_help = { enabled = true } },
        keymap = {
          accept = "<CR>",
          select_prev = "<C-p>",
          select_next = "<C-n>",
          scroll_documentation_up = "<C-u>",
          scroll_documentation_down = "<C-d>",
        },
        windows = {
          autocomplete = { border = "single", selection = "manual" },
          documentation = { border = "single", auto_show = true },
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })

      -- NOTE: these parts are here even for blink, as I like the completion in filter/commandline
      --       but blink does not support it yet
      if use_blink then
        return
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<ESC>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),

        formatting = {
          format = function(_, vim_item)
            local label = vim_item.abbr
            if label == nil then
              return vim_item
            end

            local truncated_label = vim.fn.strcharpart(label, 0, 50)
            -- shorten really long completion labels
            if truncated_label ~= label then
              vim_item.abbr = truncated_label .. "…"
            end

            return vim_item
          end,
        },
      })
    end,
  },
}
