#!/usr/bin/env bash

get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
    echo $default_value
  else
    echo $option_value
  fi
}

get_tmux_window_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-window-options -v "$option")
  if [ -z "$option_value" ]; then
    echo $default_value
  else
    echo $option_value
  fi
}

# normalize the percentage string to always have a length of 5
normalize_percent_len() {
  # the max length that the percent can reach, which happens for a two digit number with a decimal house: "99.9%"
  max_len=5
  percent_len=${#1}
  let diff_len=$max_len-$percent_len
  # if the diff_len is even, left will have 1 more space than right
  let left_spaces=($diff_len+1)/2
  let right_spaces=($diff_len)/2
  printf "%${left_spaces}s%s%${right_spaces}s\n" "" $1 ""
}

bargraph() {
  arg_percentage="$1"
  bg_color="${2:-#282a36}"
  fg_color="${3:-#f8f8f2}"

  # ▁, ▂, ▃, ▄, ▅, ▆, ▇, █
  # 0%, 12.5%, 25%, 37.5%, 50%, 62.5%, 75%, 87.5%, 100%
  # use awk to round the percentage to the nearest integer
  percentage=$(echo "$arg_percentage" | awk '{print int($1+0.5)}')
  display_percentage=$(echo "$arg_percentage" | awk '{printf " %0.1f ", $1}')
  if [ $percentage -lt 12 ]; then
    echo "[#[bg=$bg_color]▁]$display_percentage%"
  elif [ "$percentage" -lt 25 ]; then
    echo "[#[fg=#50fa7b]#[bg=$bg_color]▂#[fg=$fg_color]]$display_percentage%"
  elif [ "$percentage" -lt 37 ]; then
    echo "[#[fg=#50fa7b]#[bg=$bg_color]▃#[fg=$fg_color]]$display_percentage%"
  elif [ "$percentage" -lt 50 ]; then
    echo "[#[fg=#f1fa8c]#[bg=$bg_color]▄#[fg=$fg_color]]$display_percentage%"
  elif [ "$percentage" -lt 62 ]; then
    echo "[#[fg=#f1fa8c]#[bg=$bg_color]▅#[fg=$fg_color]]$display_percentage%"
  elif [ "$percentage" -lt 75 ]; then
    echo "[#[fg=#FF5555]#[bg=$bg_color]▆#[fg=$fg_color]]$display_percentage%"
  elif [ "$percentage" -lt 87 ]; then
    echo "[#[fg=#FF5555]#[bg=$bg_color]▇#[fg=$fg_color]]$display_percentage%"
  else
    echo "[#[fg=#FF5555]#[bg=$bg_color]▇#[fg=$fg_color]]$display_percentage%"
  fi
}

