# Ansible

Way of setting up a completely new machine or update an existing one (locally) with my dotfiles, configurations, packages, applications etc.

The different parts can be found inside the [tasks folder](./roles/install/tasks), as an example a task for all `editor` related things can be found there.
Abstractable things like variables (package names, config locations, etc.) can be found in the [main.yml](./roles/install/defaults/main.yml) file, this is probably the place others want to have a look into as it includes not the installation logic but what will be installed/linked/etc.

One of the main ideas behind this setup is to be `idempotent`, meaning that the playbook can be run as many times as we want, it will still "work" on an already setup machine and even fix things that are missing.


## Install

Run the following to run the playbook with the different tasks.

```bash
$ ./bootstrap.sh
```


## Linting / Testing

To keep the style and the quality of these configurations in a good shape use different linters and testing frameworks:

* ansible-lint
  * `ansible-lint`
* yamllint
  * `yamllint ansible/**/*.yml`
* ansible-playbook commands
  * `ansible-playbook --syntax-check`
  * `ansible-playbook --check`
