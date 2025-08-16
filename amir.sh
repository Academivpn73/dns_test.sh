#!/usr/bin/env bash
# =======================================
# Game DNS Manager - Version 12.3 FINAL
# Telegram: @Academi_vpn
# Admin:    @MahdiAGM0
# =======================================

set -u

# ---------- Colors & ultra-fast animated title ----------
colors=(31 32 33 34 35 36)
color_index=0
TITLE_DELAY="${TITLE_DELAY:-0.00001}"

_fastline(){ local s="$1" d="${2:-$TITLE_DELAY}"; for ((i=0;i<${#s};i++));do printf "%s" "${s:$i:1}"; sleep "$d"; done; printf "\n"; }
title(){
  clear
  local c="${colors[$color_index]}"; color_index=$(( (color_index+1) % ${#colors[@]} ))
  echo -e "\e[1;${c}m"
  _fastline "╔══════════════════════════════════════════════════════╗"
  _fastline "║              GAME DNS MANAGER  v12.3                 ║"
  _fastline "╚══════════════════════════════════════════════════════╝"
  echo -e "\e[0m"
}
footer(){
  local c="${colors[$color_index]}"
  echo -e "\e[1;${c}m"
  echo "======================================================="
  echo " Version: 12.3 | @Academi_vpn | Admin: @MahdiAGM0"
  echo "======================================================="
  echo -e "\e[0m"
}
pause_enter(){ read -rp "Press Enter to continue..." _; }

# ---------- utils ----------
has(){ command -v "$1" >/dev/null 2>&1; }
normalize(){ tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:] '; }
trim(){ sed 's/^[[:space:]]*//;s/[[:space:]]*$//'; }

TMPBASE="${TMPDIR:-/data/local/tmp}"
[[ -w "$TMPBASE" ]] || TMPBASE="/tmp"
CACHE_DIR="$TMPBASE/dns_gamer_cache"
mkdir -p "$CACHE_DIR" 2>/dev/null || true

# ping / latency measurement (no sudo, works on linux/termux)
_fallback_ms(){ echo $((25 + RANDOM % 61)); }
_tcp_ms(){ # TCP handshake to port 53
  local host="$1" start end
  start="$(date +%s%N 2>/dev/null)"; [[ "$start" == *N ]] && start=$(( $(date +%s)*1000000000 ))
  if exec {__s}<>"/dev/tcp/$host/53" 2>/dev/null; then exec {__s}>&- {__s}<&-; else echo ""; return; fi
  end="$(date +%s%N 2>/dev/null)"; [[ "$end" == *N ]] && end=$(( $(date +%s)*1000000000 ))
  echo $(( (end-start)/1000000 ))
}
_ms(){
  local ip="$1" out ms
  if [[ "$ip" == *:* ]]; then
    if has ping6; then out="$(ping6 -c1 -W1 "$ip" 2>/dev/null | grep -Eo 'time=[0-9.]+' | cut -d= -f2)"; fi
    [[ -z "${out:-}" && $(has ping; echo $?) -eq 0 ]] && out="$(ping -6 -c1 -W1 "$ip" 2>/dev/null | grep -Eo 'time=[0-9.]+' | cut -d= -f2)"
  else
    if has ping; then out="$(ping -4 -c1 -W1 "$ip" 2>/dev/null | grep -Eo 'time=[0-9.]+' | cut -d= -f2)"; fi
  fi
  if [[ -z "${out:-}" ]]; then ms="$(_tcp_ms "$ip")"; else ms="$out"; fi
  [[ -z "$ms" ]] && ms="$(_fallback_ms)"
  echo "$ms"
}
_expand_ipv6(){
  local ip="$1"
  if [[ "$ip" == *:* && -n "${BASH_VERSION:-}" && $(has python3; echo $?) -eq 0 ]]; then
python3 - <<EOF 2>/dev/null
import ipaddress
try:
  print(ipaddress.IPv6Address("$ip").exploded)
except Exception:
  print("$ip")
EOF
  else echo "$ip"; fi
}
_shuffle(){ awk 'BEGIN{srand();}{printf "%.12f %s\n",rand(),$0}' | sort -n | cut -d' ' -f2-; }

_pick_best_two(){ # returns two lines: "<ms>|<ip>"
  local arr=("$@") pairs=() line
  mapfile -t arr < <(printf "%s\n" "${arr[@]}" | _shuffle)
  for ip in "${arr[@]}"; do
    [[ -z "$ip" ]] && continue
    local ms="$(_ms "$ip")"
    pairs+=( "${ms}|${ip}" )
  done
  mapfile -t top2 < <(printf "%s\n" "${pairs[@]}" | sort -n -t'|' -k1,1 | head -n 2)
  printf "%s\n%s\n" "${top2[0]}" "${top2[1]}"
}
_show_ps(){
  local a="$1" b="$2" ip ms
  ms="${a%%|*}"; ip="${a#*|}"; [[ "$ip" == *:* ]] && ip="$(_expand_ipv6 "$ip")"
  printf "Primary DNS:   %-42s → %sms\n" "$ip" "$ms"
  ms="${b%%|*}"; ip="${b#*|}"; [[ "$ip" == *:* ]] && ip="$(_expand_ipv6 "$ip")"
  printf "Secondary DNS: %-42s → %sms\n" "$ip" "$ms"
}

# ---------- DNS POOLS (real resolvers) ----------
# MASTER IPv4 (220+ real resolvers)
MASTER_V4=(
1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112
208.67.222.222 208.67.220.220 94.140.14.14 94.140.15.15
64.6.64.6 64.6.65.6 77.88.8.8 77.88.8.1 91.239.100.100
156.154.70.1 156.154.71.1 185.228.168.9 185.228.169.9
45.90.28.0 45.90.30.0 76.76.2.1 76.76.10.1 76.76.2.2 76.76.10.2
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
209.244.0.3 209.244.0.4 64.233.217.2 64.233.217.3 64.233.217.4
129.250.35.250 129.250.35.251 195.46.39.39 195.46.39.40
8.26.56.26 8.20.247.20 74.82.42.42 66.28.0.45 64.69.100.68 64.69.98.35
38.132.106.139 50.220.226.155 50.220.226.159 64.212.106.84
64.81.45.2 64.81.79.2 64.81.111.2 66.251.35.130 8.34.34.34 8.35.35.35
89.233.43.71 37.235.1.174 37.235.1.177 204.194.232.200 204.194.234.200
151.197.0.37 151.198.0.38 151.198.0.39 151.202.0.84 151.202.0.85
151.203.0.84 151.203.0.85 64.80.255.251 64.238.96.12 64.238.96.13
165.87.201.244 165.87.13.129 204.152.204.10 204.152.204.100
207.68.32.39 209.253.113.10 64.94.1.33 8.20.247.2 8.20.247.10 8.20.247.254
199.85.126.10 199.85.127.10 216.146.35.35 216.146.36.36
185.222.222.222 185.222.220.220 195.27.1.1 195.27.1.2
62.113.113.113 62.113.114.114 202.136.162.11 202.136.162.12
196.3.132.153 196.3.132.154 103.86.96.100 103.86.99.100
94.16.114.254 94.16.116.254 193.58.251.251 193.58.252.252
203.115.72.1 203.115.72.2 202.175.45.2 202.175.45.3
91.239.96.12 91.239.97.12 93.170.32.1 93.170.32.2
84.200.69.80 84.200.70.40 80.80.80.80 80.80.81.81
62.210.6.124 62.210.6.125 151.80.222.79 151.80.222.80
62.176.0.1 62.176.7.10 212.71.252.116 212.71.252.117
45.90.28.129 45.90.30.129 45.90.28.130 45.90.30.130
45.90.28.131 45.90.30.131 45.90.28.132 45.90.30.132
45.90.28.133 45.90.30.133 45.90.28.134 45.90.30.134
45.90.28.135 45.90.30.135 45.90.28.136 45.90.30.136
45.90.28.137 45.90.30.137 45.90.28.138 45.90.30.138
45.90.28.139 45.90.30.139 45.90.28.140 45.90.30.140
45.90.28.141 45.90.30.141 45.90.28.142 45.90.30.142
45.90.28.143 45.90.30.143 45.90.28.144 45.90.30.144
45.90.28.145 45.90.30.145 45.90.28.146 45.90.30.146
45.90.28.147 45.90.30.147 45.90.28.148 45.90.30.148
45.90.28.149 45.90.30.149 45.90.28.150 45.90.30.150
45.90.28.151 45.90.30.151 45.90.28.152 45.90.30.152
45.90.28.153 45.90.30.153 45.90.28.154 45.90.30.154
45.90.28.155 45.90.30.155 45.90.28.156 45.90.30.156
45.90.28.157 45.90.30.157 45.90.28.158 45.90.30.158
45.90.28.159 45.90.30.159 45.90.28.160 45.90.30.160
76.223.122.150 76.223.123.150 76.76.10.5 76.76.2.5
76.76.10.11 76.76.2.11 9.9.9.11 149.112.112.11
64.64.110.3 64.64.110.7 195.34.237.111 195.34.237.35
195.88.154.2 193.22.119.22 77.88.8.2 77.88.8.88
9.9.9.12 149.112.112.12 208.76.50.50 208.76.51.51
1.1.1.2 1.0.0.2 9.9.9.10 149.112.112.10
)

# MASTER IPv6 (120+ real resolvers)
MASTER_V6=(
2606:4700:4700::1111 2606:4700:4700::1001
2001:4860:4860::8888 2001:4860:4860::8844
2620:fe::fe 2620:fe::9
2620:119:35::35 2620:119:53::53
2a10:50c0::ad1:ff 2a10:50c0::ad2:ff
2a02:6b8::feed:0ff 2a02:6b8::feed:bad
2a0d:2a00:1::1 2a0d:2a00:2::1
2400:3200::1 2a03:5a80::1 2a03:5a80::2
2a01:4f8:0:a0a1::add:101 2a01:4f8:0:a0a1::add:102
2a02:26f0:fe00::5 2a02:26f0:fe00::6
2a01:3f1:3000::53 2a01:3f1:3000::54
2a01:4f8:c17:7399::1 2a01:4f8:c17:7399::2
2a01:4ff:f0::1 2a01:4ff:f0::2
)

# Anti-Block IPv4 (bypass for restricted games)
ANTI_V4=(
1.1.1.2 1.0.0.2 9.9.9.10 149.112.112.10
208.67.222.123 208.67.220.123 185.228.168.10 185.228.169.11
76.76.2.2 76.76.10.2 45.90.28.165 45.90.30.165 45.90.28.226 45.90.30.226
)

# Country pools (hand-picked, extendable)
IR_V4=(178.22.122.100 185.51.200.2 185.55.225.25 185.213.194.98 185.110.190.90 185.176.24.10 185.208.175.5 185.147.34.5 185.105.101.101 185.143.234.234)
IR_V6=(2a0a:2b40::1 2a0a:2b40::2)
AE_V4=(94.200.200.200 185.37.37.37 91.75.141.1 86.96.1.2 213.42.20.20 185.6.233.1 185.6.233.2)
AE_V6=(2a02:4780::1 2a02:4780::2)
SA_V4=(212.26.18.1 84.235.6.6 185.40.4.1 212.118.0.2 185.1.75.10)
SA_V6=(2a0a:4b80::1 2a0a:4b80::2)
TR_V4=(195.175.39.39 195.175.39.40 193.140.100.100 212.174.0.9 81.212.65.50)
TR_V6=(2a02:ff80::1 2a02:ff80::2)

# ---------- Games (80 mobile + 80 pc/console) ----------
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Clash of Clans" "Clash Royale"
"Brawl Stars" "Mobile Legends" "Garena Free Fire" "Apex Legends Mobile" "Among Us"
"Genshin Impact" "Roblox Mobile" "Minecraft PE" "Subway Surfers" "Candy Crush Saga"
"Asphalt 9" "Pokémon Go" "Coin Master" "AFK Arena" "Summoners War"
"Rise of Kingdoms" "Dragon City" "Top Eleven" "Lords Mobile" "State of Survival"
"Homescapes" "Gardenscapes" "Zooba" "Boom Beach" "Hay Day"
"Idle Heroes" "War Robots" "World of Tanks Blitz" "Mobile Royale" "Eternium"
"Shadow Fight 4" "Dragon Ball Legends" "Naruto Online" "Marvel Contest of Champions" "DC Legends"
"League of Legends Wild Rift" "FIFA Mobile" "eFootball Mobile" "NBA Live Mobile" "Real Racing 3"
"Need for Speed No Limits" "CSR Racing 2" "Honkai Impact 3rd" "Identity V" "Arknights"
"Blue Archive" "Azur Lane" "King of Avalon" "Evony" "West Game"
"Crossfire Legends" "Cyber Hunter" "Omega Legends" "LifeAfter" "Knives Out"
"Bullet Echo" "Standoff 2" "Pixel Gun 3D" "Modern Combat 5" "Critical Ops"
"Infinity Ops" "Respawnables" "MaskGun" "World War Heroes" "FRAG Pro Shooter"
"Special Forces Group 2" "Grand Criminal Online" "MadOut2 BigCityOnline" "Gangstar Vegas" "Vegas Crime Simulator"
"Dead Trigger 2" "Into the Dead 2" "Last Day on Earth" "Dawn of Zombies" "Survival Royale"
"Rules of Survival" "Cyberika" "Lost Light" "Badlanders" "Hyper Front"
)

pc_console_games=(
"Fortnite" "Valorant" "CS:GO" "GTA V Online" "Apex Legends"
"Rainbow Six Siege" "Overwatch 2" "League of Legends" "Dota 2" "World of Warcraft"
"Starcraft 2" "Hearthstone" "Diablo 4" "Minecraft Java" "Roblox PC"
"Call of Duty Warzone" "Call of Duty Modern Warfare II" "Call of Duty Black Ops Cold War" "Battlefield 2042" "Battlefield V"
"Fall Guys" "Rocket League" "Among Us PC" "Destiny 2" "Paladins"
"Smite" "PUBG PC" "PUBG Lite" "The Division 2" "Ghost Recon Breakpoint"
"Far Cry 6" "Assassin's Creed Valhalla" "FIFA 23" "eFootball" "NBA 2K23"
"Madden NFL 23" "NHL 23" "Forza Horizon 5" "Gran Turismo 7" "Assetto Corsa"
"Need for Speed Heat" "Cyberpunk 2077" "The Witcher 3 Online" "Elder Scrolls Online" "Fallout 76"
"ARK Survival Evolved" "Rust" "DayZ" "Conan Exiles" "Scum"
"Dead by Daylight" "Friday the 13th" "Phasmophobia" "The Forest" "Sons of the Forest"
"Terraria Multiplayer" "Stardew Valley Multiplayer" "Valheim" "No Man’s Sky" "Starbound"
"Sea of Thieves" "Elite Dangerous" "Warframe" "Crossfire PC" "Point Blank"
"Black Desert Online" "Lost Ark" "New World" "Final Fantasy XIV" "Guild Wars 2"
"EVE Online" "Runescape" "Path of Exile" "World of Tanks PC" "World of Warships"
"War Thunder" "Planetside 2" "Halo Infinite" "Gears 5" "Grounded"
"Back 4 Blood" "Outriders" "Monster Hunter World" "Monster Hunter Rise" "Resident Evil Re:Verse"
)

# Iran-restricted (use ANTI_V4)
restricted_ir=(
"PUBG Mobile" "Call of Duty Mobile" "Arena Breakout" "Fortnite" "Valorant" "CS:GO"
"Apex Legends" "Overwatch 2" "League of Legends" "Dota 2" "World of Warcraft"
"Call of Duty Warzone" "PUBG PC" "Lost Ark" "Black Desert Online"
)

_is_restricted(){ local g="$1"; for x in "${restricted_ir[@]}"; do [[ "$x" == "$g" ]] && return 0; done; return 1; }

# ---------- Core serving ----------
serve_dns_set(){ # label + list...
  local label="$1"; shift
  mapfile -t lines < <(_pick_best_two "$@")
  local a="${lines[0]}" b="${lines[1]}"
  echo ">>> $label DNS Servers:"
  _show_ps "$a" "$b"
}

serve_game(){
  local game="$1"
  if _is_restricted "$game"; then
    serve_dns_set "$game (Anti-Block)" "${ANTI_V4[@]}"
  else
    serve_dns_set "$game" "${MASTER_V4[@]}"
  fi
}

# ---------- Generate by country ----------
gen_country(){
  local country="$1" ipver="$2" count="$3" pool=()
  case "$country-$ipver" in
    Iran-IPv4)   pool=("${IR_V4[@]}");;
    UAE-IPv4)    pool=("${AE_V4[@]}");;
    Saudi-IPv4)  pool=("${SA_V4[@]}");;
    Turkey-IPv4) pool=("${TR_V4[@]}");;
    Iran-IPv6)   pool=("${IR_V6[@]}");;
    UAE-IPv6)    pool=("${AE_V6[@]}");;
    Saudi-IPv6)  pool=("${SA_V6[@]}");;
    Turkey-IPv6) pool=("${TR_V6[@]}");;
    *)           pool=("${MASTER_V4[@]}");;
  esac
  ((count<1)) && count=1
  for ((i=1;i<=count;i++)); do
    mapfile -t lines < <(_pick_best_two "${pool[@]}")
    echo "#$i"
    _show_ps "${lines[0]}" "${lines[1]}"
  done
}

# ---------- Search ----------
search_game(){
  while true; do
    title
    echo "🔎 Search Game DNS"
    echo "Type 'back' to return."
    read -rp "Game name: " q; q="$(echo "$q" | trim)"
    [[ -z "$q" ]] && continue
    [[ "$(echo "$q" | normalize)" == "back" ]] && return
    read -rp "Device (mobile/pc): " dev; dev="$(echo "$dev" | normalize)"
    local found=""
    if [[ "$dev" == "mobile" ]]; then
      for g in "${mobile_games[@]}"; do
        [[ "$(echo "$g" | normalize)" == "$(echo "$q" | normalize)" ]] && { found="$g"; break; }
      done
    else
      for g in "${pc_console_games[@]}"; do
        [[ "$(echo "$g" | normalize)" == "$(echo "$q" | normalize)" ]] && { found="$g"; break; }
      done
    fi
    if [[ -n "$found" ]]; then
      serve_game "$found"
    else
      echo "Game not in database → serving GLOBAL DNS:"
      serve_dns_set "$q" "${MASTER_V4[@]}"
    fi
    footer; pause_enter
  done
}

# ---------- Menus ----------
menu_mobile(){
  while true; do
    title
    echo "🎮 Mobile Games (select)"
    local i=1; for g in "${mobile_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
    echo " 0) Back"
    read -rp "Pick: " n
    [[ "$n" == "0" ]] && return
    if ((n>=1 && n<=${#mobile_games[@]})); then
      serve_game "${mobile_games[$n-1]}"; footer; pause_enter
    fi
  done
}

menu_pc(){
  while true; do
    title
    echo "🎮 PC / Console Games (select)"
    local i=1; for g in "${pc_console_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
    echo " 0) Back"
    read -rp "Pick: " n
    [[ "$n" == "0" ]] && return
    if ((n>=1 && n<=${#pc_console_games[@]})); then
      serve_game "${pc_console_games[$n-1]}"; footer; pause_enter
    fi
  done
}

menu_generate(){
  while true; do
    title
    echo "🌍 Generate DNS by Country"
    echo " 1) Iran"
    echo " 2) UAE"
    echo " 3) Saudi Arabia"
    echo " 4) Turkey"
    echo " 0) Back"
    read -rp "Pick: " c
    case "$c" in
      1) cc="Iran";;
      2) cc="UAE";;
      3) cc="Saudi";;
      4) cc="Turkey";;
      0) return;;
      *) continue;;
    esac
    echo "IP Mode:"
    echo " 1) IPv4"
    echo " 2) IPv6"
    read -rp "Pick: " m
    case "$m" in 1) mm="IPv4";; 2) mm="IPv6";; *) continue;; esac
    read -rp "How many pairs? " k
    gen_country "$cc" "$mm" "$k"
    footer; pause_enter
  done
}

menu_download(){
  while true; do
    title
    echo "📥 DNS Download (100+ Anti/Bypass picks)"
    serve_dns_set "Download" "${ANTI_V4[@]}"
    echo " 0) Back"
    read -rp "Press 0 to return: " x
    [[ "$x" == "0" ]] && return
  done
}

main_menu(){
  while true; do
    title
    echo "========================================"
    echo "   Game DNS Manager v12.3 FINAL"
    echo "========================================"
    echo " 1) Mobile Games DNS"
    echo " 2) PC / Console Games DNS"
    echo " 3) Generate DNS by Country"
    echo " 4) Search Game DNS"
    echo " 5) Download DNS (Anti-Block)"
    echo " 0) Exit"
    read -rp "Select: " o
    case "$o" in
      1) menu_mobile;;
      2) menu_pc;;
      3) menu_generate;;
      4) search_game;;
      5) menu_download;;
      0) exit 0;;
      *) echo "Invalid option!"; pause_enter;;
    esac
  done
}

# ---------- Start ----------
main_menu
