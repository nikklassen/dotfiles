#!/bin/bash
BASE="$(dirname $0)"
PATH="/usr/local/bin/:$PATH"
API_KEY=$(cat "$BASE/.config/apikey")
LOC=($(cat "$BASE/.config/location"))
# curl -s "http://api.openweathermap.org/data/2.5/weather?lat=${LOC[0]}&lon=${LOC[1]}&units=metric&appid=${API_KEY}" | jq -r '"\(.main.temp | round) °C"'
curl -s "http://api.openweathermap.org/data/2.5/weather?lat=${LOC[0]}&lon=${LOC[1]}&units=metric&appid=${API_KEY}"
