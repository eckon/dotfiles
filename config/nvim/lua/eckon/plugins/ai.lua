if require("eckon.utils").run_minimal() then
  return {}
end

local ai_options = {
  deactivated = 0,
  copilot = 1,
  supermaven = 2,
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
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = { accept = "<M-CR>", next = "<M-n>", prev = "<M-p>" },
        },
      })
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    enabled = use_ai == ai_options.supermaven,
    config = function()
      require("supermaven-nvim").setup({ keymaps = { accept_suggestion = "<M-CR>", accept_word = "<M-n>" } })
    end,
  },
}

return M
