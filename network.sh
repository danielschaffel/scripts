#! /bin/sh

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