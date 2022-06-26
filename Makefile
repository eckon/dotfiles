.PHONY: all symlinks packages

all: packages symlinks

symlinks:
	@ ./custom-scripts/setup/symlink.sh

packages:
	@ sudo -v
	@ ./custom-scripts/setup/install-packages.sh
