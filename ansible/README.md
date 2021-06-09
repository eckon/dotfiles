# Ansible

Way of setting up a completly new machine with my dotfiles, configurations, packages, applications etc.

Simply run the `bootstrap.sh` script to start


## Linting / Testing

To keep the style and the quality of these configurations in a good shape use different linters and testing frameworks:

* ansible-lint
  * `ansible-lint`
* yamllint
  * `yamllint ansible/**/*.yml`
* ansible-playbook commands
  * `ansible-playbook --syntax-check`
  * `ansible-playbook --check`
