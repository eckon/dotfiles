local require_dir = require("eckon.helper.utils").require_dir

-- Enforce options as first, as these settings could be needed (leader key)
require("eckon.core.options")
require("eckon.core.keymaps")
require("eckon.core.autocmds")
require("eckon.core.commands")

require("eckon.notes")

require_dir("eckon.plugin", {
  -- ignore = { "lsp", "completion" }, -- Uncomment to disable specific plugins for debugging
})
