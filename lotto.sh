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

echo "------------------------------"
echo " $selected_game"
echo "------------------------------"

case $selected_game in
    "Mega Millions")
        bonus_label="Mega Ball"
        ;;
    "Powerball")
        bonus_label="Powerball"
        ;;
    *)
        bonus_label="Bonus Number"
        ;;
esac

curl -s -A 'Mozilla/5.0' "https://nylottery.ny.gov/drupal-api/api/v2/winning_numbers?_format=json&nid=$game_id&page=0" \
    | jq -r ".rows[] |
        \"Date: \"+.date,
        \"Winning Numbers: \"+(.winning_numbers | join(\", \")),
        if (.bonus_number | length) != 0 then \"$bonus_label: \" + .bonus_number + \"\n\" else \"\" end"

