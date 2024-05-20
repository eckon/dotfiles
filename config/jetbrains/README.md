# Jetbrains

As far as I can see, there is no easy way of handling configurations.
Most parts are more integrated into the whole jetbrains ecosystem,
for example syncing the settings via jetbrains accounts or
setting up a git repo that just pushes a lot to the repo.

One option that seems to be somewhat ok is sadly not really automatic.
For it you have to manually export and import the needed data.
But sadly it seems like not all options will be exported that way.
This can be done via: `File` -> `Manage IDE Settings` -> `Import/Export`

This has the benefit of the configs being not as noisy as other options and
also including the installed plugins.
For that reason I will store these settings here and
update them manually when the times comes.

Additionally it seems some plugins will have their own config locations,
which then can be handled automatically:

- IdeaVim: `~/.config/ideavim/ideavimrc`

## Setup to export

I do not want to export all things,
so the following should only be exported and saved here:

- `installed.txt`
  - shows all installed plugins
- `options/`
  - most are default, expect for
    (which are not included in the export as far as I can see)
    - enable prettier for better js formatting
  - vim settings should be done via `~/.config/ideavim/ideavimrc`

## Differences to remember

- keybindings
  - `Find anything`  -> `SHIFT SHIFT`
  - `Command Pallet` -> `CTRL-SHIFT-A`
