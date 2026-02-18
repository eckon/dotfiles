vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- icon-set, most likely triggered via other parts that depend on it
require("mini.icons").setup()

-- buffer based file explorer
require("mini.files").setup({
  mappings = {
    -- default `q` -> use esc to allow for macros recording via ´q´
    close = "<ESC>",
    -- use `L` and `H` via `go_x_plus` default mapping instead (makes moving in the buffer easier)
    go_in = "",
    go_out = "",
  },
  windows = { preview = true, width_preview = 50 },
})

local nmap = require("eckon.helper.utils").bind_map("n")
nmap("<Leader>fe", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "Mini: Open File Explorer" })

-- mainly for git diff information
require("mini.diff").setup({
  view = { style = "sign" },
  mappings = { goto_first = "[C", goto_prev = "[c", goto_next = "]c", goto_last = "]C" },
})

-- show indent and this also has ii/ai text objects
require("mini.indentscope").setup({
  draw = { animation = require("mini.indentscope").gen_animation.linear({ duration = 5 }) },
})
