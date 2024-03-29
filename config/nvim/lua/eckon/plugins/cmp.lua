if require("eckon.utils").run_minimal() then
  return {}
end

local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
  },
}

M.config = function()
  local cmp = require("cmp")

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
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),

    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
    }),

    ---@diagnostic disable-next-line: missing-fields
    formatting = {
      format = function(_, vim_item)
        local label = vim_item.abbr
        local truncated_label = vim.fn.strcharpart(label, 0, 50)

        -- shorten really long completion labels
        if truncated_label ~= label then
          vim_item.abbr = truncated_label .. "…"
        end

        return vim_item
      end,
    },
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  })
end

return M
