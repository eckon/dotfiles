#!/usr/bin/env bash

memory() {
  memory="$(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
  echo "Mem: $memory"
}

volume() {
  state="$(amixer -D pulse get Master | awk -F'[][]' 'END{print $4}')"
  if [ "$state" = "off" ]; then
    echo "Vol: OFF"
    return
  fi

  volume="$(amixer -D pulse get Master | awk -F'[][]' 'END{print $2}')"
  echo "Vol: $volume"
}

battery() {
  battery="$(cat /sys/class/power_supply/BAT0/capacity)"
  status="$(cat /sys/class/power_supply/BAT0/status)"

  if [ "$status" = "Discharging" ]; then
    echo "Bat(-): $battery%"
    return
  fi

  if [ "$battery" -lt 95 ]; then
    echo "Bat(+): $battery%"
    return
  fi

  echo "Bat: FULL"
}

echo "| $(memory) | $(volume) | $(battery) |"
