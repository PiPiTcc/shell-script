#!/sbin/sh

## @说明: 一键开启无线调试
## @兼容性: Android 5+
## @测试设备: DUK-AL20(7.0)

abort() {
  echo "$@" 1>&2
  sleep 3
  exec exit 1
}

get_ip() {
  ifconfig wlan0 | grep "inet addr\:" | awk -F: '{print $2}' | sed 's/ .*//g'
}

set_mod() {
  local ip=$(get_ip)
  local result=$(ps | grep adbd)
  if [ "$result" = "" ]; then
    setprop service.tcp.adb.port 5555
    stop adbd
    start adbd && echo "已开启无线调试:\n$ip:5555"
  else
    setprop service.tcp.adb.port 0
    stop adbd && echo "已关闭无线调试"
  fi
}

main() {
  [[ ! $(id -u) = 0 ]] && abort "! 请以Root身份运行"
  [[ $(which -a adbd) = "" ]] && abort "! 设备不支持无线调试"
  [[ $(get_ip) = "" ]] && abort "! 请连接WiFi"
  set_mod
}

main
