# Visual Studio

As far as I can see, there is no easy way of handling configurations.
Most parts are more integrated into the whole visual studio ecosystem,
for example syncing the settings via visual studio accounts.

An option is to export the config and then import it, sadly this is not really
a good solution as the file is gigantic and most likely will not include
some more important things like which extensions should be installed.

## Manual configuration

Instead of using the gigantic export or an account, ill use a basic list here to
note down which extensions and which options are important to me:

- set dark theme
- overwrite forward/backward jumps
  - search for keyboard (via command pallet / quick menu)
  - filter for `View.Navigate` which has two versions one back and one forth
  - use `CTRL-I` and `CTRL-O` as both are used for non relevant things in vs
    - need to remove `Edit.IncrementalSearch` as this also uses `CTRL-I`

### Plugins

- `vsvim`
  - ignore `rc config`, as this has almost no setting-possibilities
  - set following keybindings to be handled by vim via the visual studio ui
    - `CTRL-D` `CTRL-U`
    - seems like jumplist does not exist here, so `CTRL-I` and `CTRL-O` does nothing
      - do manual overview (see above)

## Differences to remember

- keybindings
  - `Open File` -> `CTRL-T`
  - `Command Pallet` -> `CTRL-Q`
  - `Commenting` -> `CTRL-K CTRL-/`
  - `Quick Action` -> `CTRL-.`
