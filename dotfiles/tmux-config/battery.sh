#!/bin/zsh
total=5;
percent=$(pmset -g batt | grep -o '[0-9]*[0-9][0-9]%');

echo $percent;
