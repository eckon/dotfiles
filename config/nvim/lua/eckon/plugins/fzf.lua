local cc = require("eckon.custom-command").custom_command

local M = {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

M.config = function()
  require("fzf-lua").setup({
    -- TODO: this will allow history to be saved, but it uses ctrl-p/n to navigate
    -- so need to find a way to map it to arrow keys before using them
    -- (seems like this is something that is handled by fzf itself, not this plugin)
    -- fzf_opts = { ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history" },
    keymaps = { show_details = false },
  })
end

M.init = function()
  local bind_map = require("eckon.utils").bind_map
  local nmap = function(lhs, rhs, desc)
    bind_map("n")(lhs, rhs, { desc = "Fzf: " .. desc })
  end

  -- find files (excluding .git via toggle)
  nmap("<Leader>ff", function()
    require("fzf-lua").files()
  end, "Search files based on filename")

  -- find in all vial live grep (normal grep via toggle)
  nmap("<Leader>fa", function()
    require("fzf-lua").live_grep({ hidden = true })
  end, "(Live-)Grep files")

  -- search in quickfix (generally press enter with multiple files to populate quickfix)
  -- do `alt-a` to highlight all files to achieve adding all files to quickfix
  nmap("<Leader>fq", function()
    require("fzf-lua").quickfix()
  end, "Search quickfix list entries")

  nmap("<Leader>fb", function()
    require("fzf-lua").buffers()
  end, "Search open buffers")

  nmap("<Leader>fg", function()
    require("fzf-lua").git_status()
  end, "Search git changes")

  nmap("<Leader>fl", function()
    require("fzf-lua").blines()
  end, "Search current buffer")

  nmap("<Leader>fh", function()
    require("fzf-lua").helptags()
  end, "Search help tags")

  nmap("<Leader>fc", function()
    require("fzf-lua").resume()
  end, "Continue/Resume last search")
end

-- Setup keymaps which are not often used as custom commands instead
cc.add("LSP Symbols", {
  desc = "Search lsp symbols",
  callback = function()
    require("fzf-lua").lsp_document_symbols()
  end,
})

cc.add("Current Diagnostics", {
  desc = "Search buffer diagnostics",
  callback = function()
    require("fzf-lua").diagnostics()
  end,
})

cc.add("FZF/Finder builtin", {
  desc = "Show all FZF/Finder builtins",
  callback = function()
    require("fzf-lua").builtin()
  end,
})

cc.add("Keymaps", {
  desc = "Search keymaps",
  callback = function()
    require("fzf-lua").keymaps()
  end,
})

cc.add("LSP Symbols", {
  desc = "Open Git log/blame",
  callback = function()
    require("fzf-lua").lsp_document_symbols()
  end,
})

return M
