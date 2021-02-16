#!/sbin/sh

## @说明: 重启系统用户界面
## @兼容性: Android 4+
## @测试设备: DUK-AL20(7.0)

abort() {
  echo "$@" 1>&2
  sleep 3
  exec exit 1
}

busybox_exist() {
  if [ ! "$(which -a busybox)" = "" ]; then
    return 0
  else
    return 1
  fi
}

set_mod() {
  local package="com.android.systemui"
  pkill -f $package >/dev/null 2>&1
  if [ ! "$?" = 0 ]; then
    busybox pkill -f $package >/dev/null 2>&1
    local result=$?
    if [ ! "$?" = 0 ]; then
      [[ "$(busybox_exist)" = 1 ]] && abort "! 请安装Busybox"
      [[ ! "$result" = 0 ]] && abort "! 出现了亿点点错误 $result"
    fi
  fi
}

main() {
  [[ ! $(id -u) = 0 ]] && abort "! 请以Root身份运行"
  set_mod
}

main
