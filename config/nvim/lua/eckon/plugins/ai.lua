local ai_options = {
  deactivated = 0,
  copilot = 1,
}

local use_ai = ai_options.deactivated

local M = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    enabled = use_ai == ai_options.copilot,
    config = function()
      require("copilot").setup({
        filetypes = { bigfile = false },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = { accept = "<M-CR>", next = "<M-n>", prev = "<M-p>" },
        },
      })
    end,
  },
}

return M
