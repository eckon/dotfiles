# Agent Guidelines

## Code Style

- Use 2 spaces for indentation in all files (Lua, YAML, JSON, Shell)
- Follow prettier formatting for Shell scripts (with prettier-plugin-sh)
- Follow stylua formatting for Lua files
- Use snake_case for variable and function names in Lua
- Keep lines concise and readable, aiming for under 100 characters
- Prefer early returns for error conditions
- Add error handling for file operations and external commands
- Keep code organized with clear section comments in config files
- Place imports at the top of files, grouped by external/internal

## Code Organization

- Group related configurations in config/ directory
- Keep bootstrap scripts focused and modular
- Use descriptive names for script files
- Place reusable functions in utils.lua
- Follow existing file structure patterns

## Configuration File Management

- IMPORTANT: Always edit configuration files in this repository
- Configuration files from this repo are symlinked to `~/.config/`
- DO NOT edit files in `~/.config/` directly - they are symlinks unless they do not exist in this repo
- Always use the source files in this repo
- Examples:
  - Edit `this-repo/config/nvim/init.lua` (NOT `~/.config/nvim/init.lua`)
  - Edit `this-repo/config/git/config` (NOT `~/.config/git/config`)
  - Edit `this-repo/config/opencode/config.json` (NOT `~/.config/opencode/config.json`)

## Neovim

- When changing something in my neovim setup, always try opening it to see if it still runs
- If the changes are easily tested by calling them, do so
  - Then the user does not need to manually test it each time
