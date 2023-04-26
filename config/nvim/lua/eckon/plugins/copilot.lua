local M = {
  "zbirenbaum/copilot.lua",
  cond = not require("eckon.utils").run_minimal(),
  cmd = "Copilot",
  event = "InsertEnter",
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
}

return M
