if require("eckon.utils").run_minimal() then
  return {}
end

return {
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    config = function()
      ---@diagnostic disable: missing-fields
      require("blink.cmp").setup({
        accept = { auto_brackets = { enabled = true } },
        trigger = { signature_help = { enabled = true } },
        keymap = {
          select_prev = { "<C-p>" },
          select_next = { "<C-n>" },
          scroll_documentation_up = "<C-u>",
          scroll_documentation_down = "<C-d>",
        },
        windows = {
          autocomplete = { border = "single" },
          documentation = { border = "single" },
        },
      })
    end,
  },
  {
    -- NOTE: temporary keep cmp until blink supports search/cmdline completion as well
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
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
    end,
  },
}
