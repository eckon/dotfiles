vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.files").setup({
  mappings = {
    close = "<ESC>",
    go_in = "",
    go_out = "",
  },
  windows = { preview = true, width_preview = 50 },
})

require("mini.diff").setup({
  view = { style = "sign" },
  mappings = { goto_first = "[C", goto_prev = "[c", goto_next = "]c", goto_last = "]C" },
})

require("mini.indentscope").setup({
  draw = { animation = require("mini.indentscope").gen_animation.linear({ duration = 5 }) },
})

local nmap = require("eckon.helper.utils").bind_map("n")
nmap("<Leader>fe", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "Mini: Open File Explorer" })
