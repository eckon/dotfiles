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

## Workflow

- IMPORTANT: After making ANY code changes, I must ALWAYS:
  - Run `just check` to format, lint and check the code
  - Ask me if the changes should be committed
  - Create a commit with a descriptive message
    - Do not include that the code was done by an AI

## Code Organization

- Group related configurations in config/ directory
- Keep bootstrap scripts focused and modular
- Use descriptive names for script files
- Place reusable functions in utils.lua
- Follow existing file structure patterns

## Neovim

- when changing something in my neovim setup, always try opening it to see if it still runs
- if the changes are easily tested by calling them, do so
  - then the user does not need to manually test it each time
