return {
  "nvim-mini/mini.nvim",
  event = "BufReadPre",
  version = false,
  config = function()
    -- buffer based file explorer
    require("mini.files").setup({
      mappings = {
        -- default `q` -> use esc to allow for macros recoding via ´q´
        close = "<ESC>",
        -- use `L` and `H` via `go_x_plus` default mapping instead (makes moving in the buffer easier)
        go_in = "",
        go_out = "",
      },
      windows = { preview = true, width_preview = 50 },
    })

    -- mainly for git diff information
    require("mini.diff").setup({
      view = { style = "sign" },
      mappings = { goto_first = "[C", goto_prev = "[c", goto_next = "]c", goto_last = "]C" },
    })

    -- show indent and this also has ii/ai text objects
    require("mini.indentscope").setup({
      draw = { animation = require("mini.indentscope").gen_animation.linear({ duration = 5 }) },
    })
  end,
  init = function()
    local nmap = require("eckon.utils").bind_map("n")
    nmap("<Leader>fe", function()
      require("mini.files").open(vim.api.nvim_buf_get_name(0))
    end, { desc = "Mini: Open File Explorer" })
  end,
}
