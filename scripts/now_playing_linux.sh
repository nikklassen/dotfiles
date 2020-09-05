spotifyid=$(ps -ef | grep '[/]usr/share/spotify/spotify$' | awk '{print $2}' | head -1)
currentsong=$(wmctrl -l -p | grep $spotifyid | sed -n 's/.* - //p')
echo $currentsong
