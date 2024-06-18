if require("eckon.utils").run_minimal() then
  return {}
end

local use_supermaven = true

local M = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    enabled = not use_supermaven,
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
    enabled = use_supermaven,
    config = function()
      require("supermaven-nvim").setup({ keymaps = { accept_suggestion = "<M-CR>", accept_word = "<M-n>" } })
    end,
  },
}

return M
