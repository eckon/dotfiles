# Neovim Configuration

My development-focused Neovim setup that follows the Unix philosophy of "Do One Thing and Do It Well".

## Philosophy

Uses external tools (terminal multiplexers, git, scripts) instead of editor plugins where possible.
The configuration is structured as a Lua project with full LSP support for navigation and development.

## Structure

- **[`init.lua`](./init.lua)** - Entry point that loads my other configurations/plugins
- **`lua/eckon/*`** - My different Lua helpers, plugins and configurations
  - **`init.lua`** - Is the index and will handle sub configuration parts
- **`after/ftplugin/`** - Filetype-specific configurations
- **`lsp/`** - Language server configurations

## Installation

After running the main setup script:

1. **First launch** - Neovim will prompt to install plugins via `vim.pack.add()`
   - Confirm installation for each plugin
   - Some Treesitter parsers will be installed, this will block neovim for a bit
     - New filetypes will be installed when required
     - All need the `tree-sitter-cli` to work

2. **Install LSP/Formatter/linter tools**:

   ```vim
   :Mason
   :MasonInstall <names>
   ```

3. **Verify setup**:

   ```vim
   :checkhealth
   ```

## Plugin Management

This configuration uses Neovim's built-in package management with custom commands:

- Access via `<Leader><Leader>` (space space) to open the custom command menu
- **Update packages**: Run custom command "Update packages" to update all plugins
- **Delete package**: Run custom command "Delete package" to remove installed plugins

## Development

- **Formatting**: [stylua](https://github.com/JohnnyMorganz/StyLua) for Lua code
- **Type annotations**: [LuaLS](https://luals.github.io/wiki/annotations/) for better development

## References

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)
