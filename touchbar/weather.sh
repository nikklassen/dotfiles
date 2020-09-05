BASE="$(dirname $0)"
PATH="/usr/local/bin/:$PATH"
API_KEY=$(cat "$BASE/.apikey")
LOC=($(cat "$BASE/.config/location"))
temp=$(curl -s "http://api.openweathermap.org/data/2.5/weather?lat=${LOC[0]}&lon=${LOC[1]}&units=metric&appid=${API_KEY}" | jq -r '"\(.main.temp | round) °C"')
weather_icon=$(echo "$data" | jq -r '.weather[0].icon')

ICON_FILE="$BASE/icons/${weather_icon}.png"
if [ ! -d "$BASE/icons" ]; then
    mkdir -p "$BASE/icons"
fi
if [ ! -f "$ICON_FILE" ]; then
    curl https://openweathermap.org/img/w/${weather_icon}.png -o "$ICON_FILE"
fi
# case "$weather_icon" in
#     01*) weather="☀️" ;;
#     02*) weather="⛅️";;
#     03*|04*) weather="☁️";;
#     09*) weather="☔️";;
#     10*) weather="🌦";;
#     11*) weather="⚡️";;
#     13*) weather="❄️";;
#     50*) weather="🌁";;
# esac

echo "{ \"text\": \"$temp\", \"icon_path\": \"$ICON_FILE\" }"
