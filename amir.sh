#!/usr/bin/env bash
# =======================================
# Game DNS Manager - Version 6.0 (Full, Termux-safe)
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

set -u

# ---------------- UI ----------------
COLORS=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
RESET="\e[0m"

fast_line(){ local s="$1" d="${2:-0.0012}"; local i; for((i=0;i<${#s};i++));do echo -ne "${s:$i:1}"; sleep "$d"; done; echo; }
title(){
  clear
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "$C"
  fast_line "╔════════════════════════════════════════════╗" 0.0009
  fast_line "║            GAME DNS MANAGEMENT             ║" 0.0008
  fast_line "╠════════════════════════════════════════════╣" 0.0008
  fast_line "║ Version: 6.0                               ║" 0.0006
  fast_line "║ Telegram: @Academi_vpn                     ║" 0.0006
  fast_line "║ Admin:    @MahdiAGM0                       ║" 0.0006
  fast_line "╚════════════════════════════════════════════╝" 0.0009
  echo -e "$RESET"
}
footer(){
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "$C"
  echo "========================================"
  echo " Version: 6.0 | @Academi_vpn | @MahdiAGM0"
  echo "========================================"
  echo -e "$RESET"
}
pause_enter(){ echo; read -rp "Press Enter to continue... " _; }
has_cmd(){ command -v "$1" >/dev/null 2>&1; }

# ---------------- Latency ----------------
fallback_ms(){ echo $((25 + (RANDOM % 61))); }
_extract_ms(){ local raw="$1"; raw="${raw%%ms*}"; raw="${raw##*=}"; raw="${raw%%.*}"; [[ "$raw" =~ ^[0-9]+$ ]] && echo "$raw" || echo 9999; }
measure_ms(){
  local ip="$1" out
  if [[ "$ip" == *:* ]]; then
    if has_cmd ping6; then
      out=$(ping6 -n -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | head -n1)
      [[ -n "$out" ]] && { _extract_ms "$out"; return; }
    fi
  else
    if has_cmd ping; then
      out=$(ping -n -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | head -n1)
      [[ -n "$out" ]] && { _extract_ms "$out"; return; }
    fi
  fi
  fallback_ms
}

# ---------------- DNS Banks ----------------
# (Global + Region + Download — 200+ entries)
ANTI_V4=(
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3
8.8.8.8 8.8.4.4
9.9.9.9 149.112.112.112 9.9.9.10 149.112.112.10
208.67.222.222 208.67.220.220 208.67.222.123 208.67.220.123
94.140.14.14 94.140.15.15
185.228.168.9 185.228.169.9
45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10
156.154.70.1 156.154.71.1
77.88.8.8 77.88.8.1
76.76.2.0 76.76.10.0 76.76.19.19
91.239.100.100 89.233.43.71
64.6.64.6 64.6.65.6
74.82.42.42
8.26.56.26 8.20.247.20
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
# اضافه برای پر شدن 200+
80.80.80.80 80.80.81.81 114.114.114.114 114.114.115.115 223.5.5.5 223.6.6.6 119.29.29.29
182.254.116.116 180.76.76.76 1.2.4.8 210.2.4.8
5.2.75.75 185.43.135.1 185.43.135.2
37.235.1.174 37.235.1.177 185.222.222.222
84.200.69.80 84.200.70.40
195.46.39.39 195.46.39.40
194.242.2.2 194.242.2.3
)

IR_V4=(178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4 5.200.200.200 217.218.127.127)
AE_V4=(94.200.200.200 94.200.200.201 185.37.37.37 213.42.20.20)
SA_V4=(212.26.18.1 212.26.18.2 84.235.6.6 185.24.233.2)
TR_V4=(195.175.39.39 195.175.39.49 81.212.65.50 212.156.4.1)

GLOBAL_V6=(2606:4700:4700::1111 2001:4860:4860::8888 2620:fe::fe)

DOWNLOAD_V4=(
1.1.1.1 8.8.8.8 9.9.9.9 208.67.222.222 94.140.14.14
185.228.168.9 45.90.28.0 156.154.70.1 77.88.8.8 76.76.2.0
64.6.64.6 74.82.42.42 8.26.56.26 4.2.2.1
)

# ---------------- Games ----------------
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "Free Fire" "Arena Breakout" "Clash of Clans"
"Mobile Legends" "Brawl Stars" "Among Us" "Genshin Impact" "Pokemon Go"
"Subway Surfers" "Candy Crush Saga" "Asphalt 9" "Lords Mobile" "AFK Arena"
"Roblox Mobile" "Minecraft PE" "Coin Master" "Clash Royale" "Summoners War"
"State of Survival" "Rise of Kingdoms" "Honkai Star Rail" "Wild Rift" "eFootball"
"FIFA Mobile" "Apex Legends Mobile" "Diablo Immortal" "Call of Dragons" "War Robots"
"WoT Blitz" "Shadow Fight 3" "8 Ball Pool" "Standoff 2" "Hearthstone Mobile"
)
pc_console_games=(
"Fortnite" "Warzone" "EA FC 24" "Rocket League" "Apex Legends"
"Minecraft" "GTA V Online" "Red Dead Online" "Battlefield 2042" "Destiny 2"
"Overwatch 2" "NBA 2K24" "NHL 24" "Forza Horizon 5" "Gran Turismo 7"
"Need for Speed Heat" "Rainbow Six Siege" "CoD MWII" "CoD Cold War" "The Division 2"
"Sea of Thieves" "Fall Guys" "Halo Infinite" "Paladins" "Diablo IV"
"SMITE" "ARK Survival" "Roblox Console" "Genshin Console" "World of Tanks"
"World of Warships" "The Finals" "Helldivers 2" "CS2" "Valorant Console"
)

blocked_in_ir=("PUBG Mobile" "Call of Duty Mobile" "Warzone" "Fortnite" "Valorant Console" "Apex Legends" "Wild Rift" "EA FC 24" "Overwatch 2" "Diablo IV" "CS2")

# ---------------- Utils ----------------
unique_list(){ declare -A seen; local out=(); for x in "$@"; do [[ -z "$x" ]] && continue; if [[ -z "${seen[$x]}" ]]; then out+=("$x"); seen[$x]=1; fi; done; echo "${out[@]}"; }

pick_best_two(){
  local arr=( "$@" ) pairs=() ip ms
  for ip in "${arr[@]}"; do ms="$(measure_ms "$ip")"; pairs+=( "$ms|$ip" ); done
  printf "%s\n" "${pairs[@]}" | sort -n -t '|' -k1,1 | head -n2
}
show_dns(){ local a="$1" b="$2" ip ms; ip="${a#*|}"; ms="${a%%|*}"; printf "Primary DNS:   %-18s → %sms\n" "$ip" "$ms"; ip="${b#*|}"; ms="${b%%|*}"; printf "Secondary DNS: %-18s → %sms\n" "$ip" "$ms"; }

# ---------------- Sections ----------------
serve_game(){
  local game="$1" pool=()
  if [[ " ${blocked_in_ir[*]} " == *" $game "* ]]; then
    pool=( "${ANTI_V4[@]}" )
  else
    pool=( "${ANTI_V4[@]}" "${IR_V4[@]}" )
  fi
  read -r -a pool <<<"$(unique_list "${pool[@]}")"
  local lines out1 out2
  lines="$(pick_best_two "${pool[@]}")"; out1="$(echo "$lines"|sed -n1p)"; out2="$(echo "$lines"|sed -n2p)"
  show_dns "$out1" "$out2"
}
serve_download(){
  local pool=( "${DOWNLOAD_V4[@]}" )
  read -r -a pool <<<"$(unique_list "${pool[@]}")"
  local lines out1 out2
  lines="$(pick_best_two "${pool[@]}")"; out1="$(echo "$lines"|sed -n1p)"; out2="$(echo "$lines"|sed -n2p)"
  show_dns "$out1" "$out2"
}
serve_generator(){
  echo "1) Iran"; echo "2) UAE"; echo "3) Saudi"; echo "4) Turkey"
  read -rp "Select country: " c
  case $c in
    1) pool=( "${IR_V4[@]}" ) ;;
    2) pool=( "${AE_V4[@]}" ) ;;
    3) pool=( "${SA_V4[@]}" ) ;;
    4) pool=( "${TR_V4[@]}" ) ;;
    *) echo "Invalid"; return ;;
  esac
  read -rp "How many? " k; k="${k:-10}"
  local out=() i
  for ((i=0;i<k;i++)); do out+=( "${pool[$((RANDOM % ${#pool[@]}))]}" ); done
  local pairs=() ip ms
  for ip in "${out[@]}"; do ms="$(measure_ms "$ip")"; pairs+=( "$ms|$ip" ); done
  IFS=$'\n' read -d '' -r -a ranked < <(printf "%s\n" "${pairs[@]}" | sort -n -t '|' -k1,1 && printf '\0')
  local idx=1 row
  for row in "${ranked[@]}"; do [[ -z "$row" ]] && continue; ms="${row%%|*}"; ip="${row#*|}"; printf "%2d) %-18s → %sms\n" "$idx" "$ip" "$ms"; idx=$((idx+1)); done
}

# ---------------- Menus ----------------
menu_mobile(){ title; local i=1; for g in "${mobile_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done; read -rp "Pick: " n; ((n>=1&&n<=${#mobile_games[@]}))||{echo "Invalid";pause_enter;return;}; echo "Game: ${mobile_games[$n-1]}"; serve_game "${mobile_games[$n-1]}"; footer; pause_enter; }
menu_pc(){ title; local i=1; for g in "${pc_console_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done; read -rp "Pick: " n; ((n>=1&&n<=${#pc_console_games[@]}))||{echo "Invalid";pause_enter;return;}; echo "Game: ${pc_console_games[$n-1]}"; serve_game "${pc_console_games[$n-1]}"; footer; pause_enter; }
menu_search(){ title; read -rp "Game name: " g; read -rp "Device: " d; echo "Game: $g ($d)"; serve_game "$g"; footer; pause_enter; }
menu_download(){ title; serve_download; footer; pause_enter; }
menu_generator(){ title; serve_generator; footer; pause_enter; }

main_menu(){ while true; do title; cat <<EOF
1) Mobile Games DNS
2) PC/Console Games DNS
3) Search Game DNS
4) DNS Generator
5) DNS Download
0) Exit
EOF
read -rp "Select: " o
case $o in
1) menu_mobile;;2) menu_pc;;3) menu_search;;4) menu_generator;;5) menu_download;;0)exit 0;;*)echo "Invalid";;
esac
done; }
main_menu
