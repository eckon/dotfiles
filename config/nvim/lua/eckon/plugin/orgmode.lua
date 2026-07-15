vim.pack.add({ "https://github.com/nvim-orgmode/orgmode" })

local base_path = "~/Documents/notes/orgfiles/"

require("orgmode").setup({
  org_agenda_files = base_path .. "**/*",
  org_default_notes_file = base_path .. "refile.org",
  mappings = {
    agenda = { org_agenda_show_help = "?" },
    capture = { org_capture_show_help = "?" },
    note = { org_show_help = "?" },
    org = { org_show_help = "?" },
    edit_src = { org_edit_src_show_help = "?" },
  },
})

vim.lsp.enable("org")
