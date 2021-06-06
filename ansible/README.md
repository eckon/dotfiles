# Ansible

Way of setting up a completly new machine with my dotfiles, configurations, packages, applications etc.

Simply run the `bootstrap.sh` script to start

## Bootstrap script

When calling without any parameters will call the playbook which will install everything. Generally installations will be skipped if the binary is already available in the dedicated folder.

When calling with parameters, it will take them (seperated with space) and only use these as tags (tags can be also seen when passing an argument).

When calling the script/command inside of the ansible directly, the ansible.cfg file will be used, this results in some better output, timing and profiling.


## Linting / Testing

To keep the style and the quality of these configurations in a good shape use different linters and testing frameworks:

* ansible-lint
  * `ansible-lint`
* yamllint
  * `yamllint ansible/**/*.yml`
* ansible-playbook commands
* `ansible-playbook --syntax-check`
  * `ansible-playbook --check`


