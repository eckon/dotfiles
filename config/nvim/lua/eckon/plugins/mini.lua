return {
  "echasnovski/mini.nvim",
  event = "BufReadPre",
  version = false,
  config = function()
    -- buffer based file explorer
    require("mini.files").setup({ windows = { preview = true, width_preview = 50 } })

    -- show indent and this also has ii/ai text objects
    require("mini.indentscope").setup({
      draw = { animation = require("mini.indentscope").gen_animation.linear({ duration = 5 }) },
    })

    -- show better notifications and lsp progress
    require("mini.notify").setup()
    vim.notify = require("mini.notify").make_notify()

    -- mainly for git diff information
    require("mini.diff").setup({
      view = { style = "sign" },
      mappings = { goto_first = "[C", goto_prev = "[c", goto_next = "]c", goto_last = "]C" },
    })
  end,
  init = function()
    local nmap = require("eckon.utils").bind_map("n")
    nmap("<Leader>fe", function()
      require("mini.files").open(vim.api.nvim_buf_get_name(0))
    end, { desc = "Mini: Open File Explorer" })

    require("eckon.custom-command").custom_command.add("ShowNotifications", {
      desc = "Open all previous `vim.notify` messages",
      callback = "lua MiniNotify.show_history()",
    })
  end,
}
