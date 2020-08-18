#!/bin/sh

get_time() {
    date "+%D | %I:%M:%S"
}

get_wifi() {
    # if [ -d "/sys/class/net/wlp3s0" ]
    # echo $(iwconfig wlp3s0 | grep "ESSID" | awk -F: '{print $2}')
    # then
    #     echo $(cat /sys/class/net/wlp3s0/operstate)
    # else
    #     echo "NO WIFI!"
    # fi
    # echo "|"
    # Show wifi 📶 and percent strength or 📡 if none.
# Show 🌐 if connected to ethernet or ❎ if none.

case $BLOCK_BUTTON in
	1) setsid "$TERMINAL" -e nmtui & ;;
	3) notify-send "🌐 Internet module" "\- Click to connect
📡: no wifi connection
📶: wifi connection with quality
❎: no ethernet
🌐: ethernet working
" ;;
	6) "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
	down) wifiicon="📡 " ;;
	up) wifiicon="$(awk '/^\s*w/ { print "📶", int($3 * 100 / 70) "% " }' /proc/net/wireless)" ;;
esac

printf "%s%s\n" "$wifiicon" "$(sed "s/down/❎/;s/up/🌐/" /sys/class/net/e*/operstate 2>/dev/null)"
}

get_battery() {
    if [ $(cat /sys/class/power_supply/ADP1/online) = "1" ]
    then
        echo "Charging |"
    else
        for x in /sys/class/power_supply/BAT?/capacity;
        do
            echo $(echo $x | cut -d / -f 5) $(cat $x)"% |"
        done
    fi

}

get_volume() {
     echo "Volume:"$(amixer sget Master | awk -F"[][]" '/dB/ { print $2 }')"|"
}

status() {
    get_volume
	get_wifi
    get_battery
    get_time
}

while true
    do
    xsetroot -name "$( status | tr '\n' ' ')"
    sleep 30s
    done
