# Visual Studio

As far as I can see, there is no easy way of handling configurations.
Most parts are more integrated into the whole visual studio ecosystem,
for example syncing the settings via visual studio accounts.

An option is to export the config and then import it, sadly this is not really
a good solution as the file is gigantic and most likely will not include
some more important things like which extensions should be installed.

## Important default keybindings

Some of these might be doable with other configurations like vim plugin

- `Open File` -> `CTRL-T`
- `Command Palette` -> `CTRL-Q`
- `Commenting` -> `CTRL-K CTRL-/`
- `Quick Action` -> `CTRL-.`

## Manual configuration

Instead of using the gigantic export or an account, I'll use a basic list here to
note down which extensions and which options are important to me:

- set dark theme

### Plugins

- `vsvim`
  - set following keybindings to be handled by vsvim via the vs ui (vim keybindings)
    - `CTRL-D` `CTRL-U`
    - `CTRL-I` `CTRL-O`
  - copy `vsvimrc` file to `c/user/<name>/.vsvimrc` on windows
    - _until dotfiles repo works on windows_
