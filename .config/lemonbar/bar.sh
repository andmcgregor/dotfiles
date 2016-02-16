BATTERY_CAPACITY=/sys/class/power_supply/BAT1/capacity
BATTERY_STATUS=/sys/class/power_supply/BAT1/status

clock() {
  DATETIME=$(date "+%a %b %d, %T")
  echo -n "$DATETIME"
}

battery() {
  echo "`cat $BATTERY_STATUS` (`cat $BATTERY_CAPACITY`%)"
}

cpu() {
  LINE=`ps -eo pcpu |grep -vE '^\s*(0.0|%CPU)' |sed -n '1h;$!H;$g;s/\n/ +/gp'`
  bc <<< $LINE
}

memory() {
  read t f <<< `grep -E 'Mem(Total|Free)' /proc/meminfo |awk '{print $2}'`
  bc <<< "scale=2; 100 - $f / $t * 100" | cut -d. -f1
}

network() {
  read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
  if iwconfig $int1 >/dev/null 2>&1; then
    wifi=$int1
    eth0=$int2
  else
    wifi=$int2
    eth0=$int1
  fi
  ip link show $eth0 | grep 'state UP' >/dev/null && int=$eth0 ||int=$wifi

  #int=eth0

  ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "$int connected" || echo "$int disconnected"
}

volume() {
  amixer get Master | sed -n 'N;s/^.*\[\([0-9]\+%\).*$/\1/p'
}

audio() {
  echo "VOL: $(volume)"
  # dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'
}

while true; do
  # echo "$(battery) %{c}%{F#FFFF00}%{B#0000FF} $(clock) %{F-}%{B-}"
  echo "$(clock) - $(battery) - CPU: $(cpu) - MEM: $(memory) - $(network) - $(audio)"
  sleep 1
done

