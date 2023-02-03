#!/usr/bin/env bash

games=$(curl -s -A 'Mozilla/5.0' https://nylottery.ny.gov/drupal-api/api/games?_format=json)

if [[ $# -eq 1 ]]; then
    selected_game=$1
else
    selected_game=$(echo $games | jq -r ".[] | .title" | fzf)
fi

if [[ -z $selected_game ]]; then
    exit 0
fi

game_id=$(echo $games | jq -r ".[] | select(.title == \"$selected_game\") | .nid")

echo "Game ID for $selected_game is $game_id"

