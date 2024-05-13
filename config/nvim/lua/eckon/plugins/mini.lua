return {
  "echasnovski/mini.nvim",
  event = "BufReadPre",
  version = false,
  config = function()
    require("mini.files").setup({ windows = { preview = true } })

    -- this also has ii/ai text objects
    require("mini.indentscope").setup({
      draw = { animation = require("mini.indentscope").gen_animation.linear({ duration = 5 }) },
    })

    -- this also shows lsp progress
    require("mini.notify").setup()
    vim.notify = require("mini.notify").make_notify()
  end,
  init = function()
    require("eckon.utils").bind_map("n")("<Leader>fe", function()
      require("mini.files").open(vim.api.nvim_buf_get_name(0))
    end, { desc = "Mini: Open File Explorer" })
  end,
}
