#!/usr/bin/env bash

killall -q polybar
polybar bar >/dev/null 2>&1 & disown
