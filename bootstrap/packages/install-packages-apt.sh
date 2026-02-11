#!/usr/bin/env bash

set -euo pipefail

sudo apt install -y \
  autoconf \
  automake \
  bison \
  build-essential \
  cmake \
  pkg-config \
  libevent-dev         $(: "event notification library") \
  libfuse2             $(: "filesystem in userspace") \
  libncurses5-dev      $(: "terminal UI library") \
  libncursesw5-dev     $(: "ncurses with wide character support") \
  entr                 $(: "run commands when files change") \
  moreutils            $(: "additional Unix utilities") \
  unzip \
  watchman             $(: "file watching service") \
  wget \
  xclip                $(: "clipboard utility for X11") \
  yad                  $(: "display dialogs from shell scripts")
