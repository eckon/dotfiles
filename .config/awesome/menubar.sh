#!/usr/bin/env bash

mem() {
  mem="$(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
  echo "Mem: $mem"
}

vol() {
  vol="$(amixer -D pulse get Master | awk -F'[][]' 'END{print $4":"$2}')"
  echo "Vol: $vol"
}

bat() {
  battery="$(cat /sys/class/power_supply/BAT0/capacity)"
  status="$(cat /sys/class/power_supply/BAT0/status)"

  if [ "$status" = "Discharging" ]; then
    chargeSymbol="(-)"
  else
    chargeSymbol="(+)"
  fi

  echo "Bat$chargeSymbol: $battery%"
}

echo "| $(mem) | $(vol) | $(bat) |"
