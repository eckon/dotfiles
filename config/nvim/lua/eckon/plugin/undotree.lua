local cc = require("eckon.helper.custom-command").custom_command

vim.cmd.packadd("nvim.undotree")

cc.add("Undotree", {
  desc = "Open Undotree view",
  callback = function()
    require("undotree").open({
      -- increase default width and add filetype to add keybindings via `ftplugin`
      command = "50vnew | setlocal ft=undotree",
      title = function(buf)
        local file_path = vim.api.nvim_buf_get_name(buf)
        local file_name = vim.fn.fnamemodify(file_path, ":t")

        return "Undotree: " .. file_name
      end,
    })
  end,
})
