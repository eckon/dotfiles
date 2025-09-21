# Neovim Configuration

My development-focused Neovim setup that follows the Unix philosophy of "Do One Thing and Do It Well".

## Philosophy

Uses external tools (terminal multiplexers, git, scripts) instead of editor plugins where possible.
The configuration is structured as a Lua project with full LSP support for navigation and development.

## Structure

- **[`init.lua`](./init.lua)** - Entry point that bootstraps the plugin manager
- **`lua/eckon/plugins/`** - Plugin configurations
- **`after/ftplugin/`** - Filetype-specific configurations
- **`plugin/`** - General Vim configurations
- **`lsp/`** - Language server configurations
- **`lua/eckon/`** - Custom utilities

## Installation

After running the main setup script:

1. **First launch** - Neovim will automatically install:
   - Plugin manager and plugins
   - Treesitter parsers
2. **Install LSP tools**:

   ```vim
   :Mason
   ```

3. **Verify setup**:

   ```vim
   :checkhealth
   ```

## Development

- **Formatting**: [stylua](https://github.com/JohnnyMorganz/StyLua) for Lua code
- **Type annotations**: [LuaLS](https://luals.github.io/wiki/annotations/) for better development

## References

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)
