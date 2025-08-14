#!/usr/bin/env bash
# =======================================
# Game DNS Manager - Version 3.0.0
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

set -u

# ---------- Colors & Fast Title ----------
COLORS=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
RESET="\e[0m"

fast_type() { # very fast typer
  local s="$1" d="${2:-0.002}"
  local i; for ((i=0;i<${#s};i++)); do echo -ne "${s:$i:1}"; sleep "$d"; done; echo
}

title() {
  clear
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "${C}"
  fast_type "╔════════════════════════════════════════════╗" 0.002
  fast_type "║            GAME DNS MANAGEMENT             ║" 0.002
  fast_type "╠════════════════════════════════════════════╣" 0.002
  fast_type "║ Version: 3.0.0                             ║" 0.0015
  fast_type "║ Telegram: @Academi_vpn                     ║" 0.0015
  fast_type "║ Admin:    @MahdiAGM0                       ║" 0.0015
  fast_type "╚════════════════════════════════════════════╝" 0.002
  echo -e "${RESET}"
}

footer() {
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "${C}"
  echo "========================================"
  echo " Version: 3.0.0 | @Academi_vpn | @MahdiAGM0"
  echo "========================================"
  echo -e "${RESET}"
}

pause_enter(){ echo; read -rp "Press Enter to continue... " _; }
has_cmd(){ command -v "$1" >/dev/null 2>&1; }

# ---------- Ping / Latency (no sudo, no bc, no timeout) ----------
# تلاش اول: ping (IPv4/IPv6). تلاش دوم: dig (qtime). در غیر این صورت: 9999ms
_extract_ms() { # gets "xx.xx" or "xx" and returns integer
  local raw="$1"
  raw="${raw%%ms*}"
  raw="${raw%% *}"
  raw="${raw%%.*}"
  [[ "$raw" =~ ^[0-9]+$ ]] && echo "$raw" || echo 9999
}

ping_ms_v4(){
  local ip="$1" t
  if has_cmd ping; then
    # BusyBox/inetutils/iputils formats supported
    t=$(ping -n -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | head -n1)
    if [[ -n "$t" ]]; then _extract_ms "$t"; return; fi
  fi
  if has_cmd dig; then
    t=$(dig +tries=1 +time=1 @"$ip" example.com A 2>/dev/null | awk '/Query time:/ {print $4}' | head -n1)
    if [[ -n "$t" ]]; then _extract_ms "$t"; return; fi
  fi
  echo 9999
}

ping_ms_v6(){
  local ip="$1" t
  if has_cmd ping; then
    t=$(ping -6 -n -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | head -n1)
    if [[ -n "$t" ]]; then _extract_ms "$t"; return; fi
  fi
  if has_cmd ping6; then
    t=$(ping6 -n -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | head -n1)
    if [[ -n "$t" ]]; then _extract_ms "$t"; return; fi
  fi
  if has_cmd dig; then
    t=$(dig +tries=1 +time=1 @"$ip" example.com AAAA 2>/dev/null | awk '/Query time:/ {print $4}' | head -n1)
    if [[ -n "$t" ]]; then _extract_ms "$t"; return; fi
  fi
  echo 9999
}

measure_ms(){
  local ip="$1"
  if [[ "$ip" == *:* ]]; then ping_ms_v6 "$ip"; else ping_ms_v4 "$ip"; fi
}

# انتخاب دو DNS برتر با آستانه‌ها 50/80/120ms و در نهایت بهترین موجود
_best_two_threshold(){
  local thr="$1"; shift
  local -a ips=( "$@" )
  local -a pairs=()
  local ip ms cnt=0
  for ip in "${ips[@]}"; do
    [[ -z "$ip" ]] && continue
    ms=$(measure_ms "$ip"); ms=$(_extract_ms "$ms")
    (( (cnt+=1) % 16 == 0 )) && echo -ne "."
    (( ms <= thr )) && pairs+=("$ms $ip")
  done
  echo
  if [ "${#pairs[@]}" -eq 0 ]; then
    echo ""
    return 1
  fi
  printf "%s\n" "${pairs[@]}" | sort -n -k1,1 | awk '{print $2"|" $1}' | head -n 2
}

pick_best_two(){
  local -a pool=( "$@" )
  local out
  out=$(_best_two_threshold 50 "${pool[@]}"); [[ -n "$out" ]] && { echo "$out"; return; }
  out=$(_best_two_threshold 80 "${pool[@]}"); [[ -n "$out" ]] && { echo "$out"; return; }
  out=$(_best_two_threshold 120 "${pool[@]}"); [[ -n "$out" ]] && { echo "$out"; return; }
  # pick best two regardless
  local -a pairs=(); local ip ms
  for ip in "${pool[@]}"; do ms=$(measure_ms "$ip"); ms=$(_extract_ms "$ms"); pairs+=("$ms $ip"); done
  printf "%s\n" "${pairs[@]}" | sort -n -k1,1 | awk '{print $2"|" $1}' | head -n 2
}

show_primary_secondary(){
  local lines="$1" a b ip ms
  a=$(echo "$lines" | sed -n '1p'); b=$(echo "$lines" | sed -n '2p')
  if [ -n "$a" ]; then ip="${a%%|*}"; ms="${a##*|}"; printf "Primary DNS:   %-18s → %sms\n" "$ip" "$ms"; fi
  if [ -n "$b" ]; then ip="${b%%|*}"; ms="${b##*|}"; printf "Secondary DNS: %-18s → %sms\n" "$ip" "$ms"; fi
}

print_numbered(){
  local -a arr=( "$@" ); local i=1 ip ms
  for row in "${arr[@]}"; do ip="${row%%|*}"; ms="${row##*|}"; printf "%3d) %-18s → %sms\n" "$i" "$ip" "$ms"; i=$((i+1)); done
}

# ---------- Country Guess (best effort; اگر بسته بود پیش‌فرض US) ----------
guess_cc(){
  local x
  for u in "https://ipinfo.io/country" "https://ifconfig.co/country-iso" "https://api.country.is"; do
    x=$(curl -fsSL --max-time 3 "$u" 2>/dev/null | tr -d '\r\n[:space:]' | sed 's/[^A-Za-z]//g' | head -c 2)
    [[ -n "$x" ]] && { echo "$x"; return; }
  done
  echo "US"
}

# ---------- Game Lists (50 + 50) ----------
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Arena Breakout" "Clash of Clans"
"Mobile Legends" "Brawl Stars" "Among Us" "Genshin Impact" "Pokemon Go"
"Subway Surfers" "Candy Crush Saga" "Asphalt 9" "Lords Mobile" "AFK Arena"
"Roblox Mobile" "Minecraft Pocket Edition" "Coin Master" "Clash Royale" "Summoners War"
"State of Survival" "Rise of Kingdoms" "Honkai: Star Rail" "Wild Rift" "eFootball Mobile"
"FIFA Mobile" "Apex Legends Mobile" "Diablo Immortal" "Call of Dragons" "War Robots"
"World of Tanks Blitz" "Shadow Fight 3" "8 Ball Pool" "Standoff 2" "Sausage Man"
"MARVEL Snap" "T3 Arena" "Dead by Daylight Mobile" "NIKKE" "PUBG: New State"
"CarX Drift Racing 2" "CSR Racing 2" "Critical Ops" "Ace Racer" "Dragon Ball Legends"
"Plants vs Zombies 2" "Boom Beach" "Archero" "Torchlight: Infinite" "Hearthstone Mobile"
)

pc_console_games=(
"Fortnite" "Warzone" "EA FC 24" "Rocket League" "Apex Legends"
"Minecraft" "GTA V Online" "Red Dead Online" "Battlefield 2042" "Destiny 2"
"Overwatch 2" "NBA 2K24" "NHL 24" "Forza Horizon 5" "Gran Turismo 7"
"Need for Speed Heat" "Rainbow Six Siege" "Call of Duty MWII" "Call of Duty Cold War" "The Division 2"
"Sea of Thieves" "Fall Guys" "Halo Infinite" "Paladins" "Diablo IV"
"SMITE" "ARK: Survival Ascended" "Roblox (Console)" "Genshin Impact (Console)" "World of Tanks"
"World of Warships" "eFootball 2024" "Madden NFL 24" "MLB The Show 24" "WWE 2K24"
"The Crew Motorfest" "Mortal Kombat 1" "Street Fighter 6" "Tekken 8" "For Honor"
"Hunt: Showdown" "THE FINALS" "Helldivers 2" "Tower of Fantasy (Console)" "XDefiant"
"Counter-Strike 2" "Valorant (Console)" "Elden Ring (Console)" "Cyberpunk 2077 (Console)" "Granblue Fantasy Versus"
)

# ---------- DNS Banks (BIG, >300 IPv4 + some IPv6) ----------
# Anycast / Global
GLOBAL_V4=(
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3
8.8.8.8 8.8.4.4 8.26.56.26 8.20.247.20
9.9.9.9 149.112.112.112 9.9.9.10 149.112.112.10 9.9.9.11 149.112.112.11
208.67.222.222 208.67.220.220 208.67.222.123 208.67.220.123
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16
76.76.19.19 76.223.122.150
64.6.64.6 64.6.65.6
77.88.8.8 77.88.8.1 77.88.8.2 77.88.8.88
1.12.12.12 120.53.53.53
80.80.80.80 80.80.81.81
74.82.42.42
185.222.222.222 45.11.45.11
45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10
)

GLOBAL_V6=(
2606:4700:4700::1111 2606:4700:4700::1001
2606:4700:4700::1112 2606:4700:4700::1002
2001:4860:4860::8888 2001:4860:4860::8844
2620:fe::fe 2620:fe::9
2620:119:35::35 2620:119:53::53
)

# Iran
IR_V4=(
178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4 5.200.200.200
46.245.69.2 46.245.69.3 217.218.127.127 31.7.64.1 31.7.64.2
62.201.220.50 62.201.220.51 85.185.39.10 85.185.39.11 185.55.226.26
185.55.225.26 217.11.16.21 217.11.16.22 185.83.114.56 185.117.118.20
)

IR_V6=(2a0a:2b40::1 2a0a:2b41::1)

# UAE
AE_V4=(
94.200.200.200 94.200.200.201 185.37.37.37 185.37.39.39
213.42.20.20 213.42.20.21 31.217.168.2 31.217.168.4
91.73.130.1 91.73.130.2 94.100.128.10 94.100.128.12
)

AE_V6=(2a02:4780::1 2a02:4781::1)

# Saudi Arabia
SA_V4=(
212.26.18.1 212.26.18.2 84.235.6.6 84.235.6.7
185.24.233.2 185.24.233.3 188.54.64.1 188.54.64.2
188.54.64.3 91.223.123.1 91.223.123.2
)

SA_V6=(2a0a:4b80::1 2a0a:4b81::1)

# Turkey
TR_V4=(
195.175.39.39 195.175.39.49 195.175.39.50
81.212.65.50 81.212.65.51 212.156.4.1 212.156.4.2
85.111.3.3 85.111.3.4 176.43.1.1 176.43.1.2 176.43.1.3
88.255.168.248 88.255.168.249 213.14.227.118 213.14.227.119
)

TR_V6=(2a02:ff80::1 2a02:ff81::1)

# Europe (بزرگ)
EU_V4=(
62.210.6.6 62.210.6.7 91.239.100.100 89.233.43.71
84.200.69.80 84.200.70.40 213.133.100.100 213.133.98.98 213.133.99.99
80.67.169.12 80.67.169.40 91.121.157.83 193.183.98.154
176.103.130.130 176.103.130.131 176.103.130.132 176.103.130.134
194.242.2.2 194.242.2.3 195.46.39.39 195.46.39.40
185.228.168.9 185.228.169.9 185.228.168.168 185.228.169.168
193.110.81.0 193.110.81.1 193.110.81.9
94.247.43.254 5.2.75.75 185.43.135.1 185.43.135.2
45.90.28.0 45.90.30.0 9.9.9.9 149.112.112.112
51.38.83.141 51.38.82.127 51.38.81.248 51.38.71.68 51.38.86.66
51.178.67.250 51.178.80.20 51.77.149.160 51.77.153.88 51.77.153.36
135.125.183.46 135.125.183.45 135.125.183.44
)

# US (ISPs + anycast)
US_V4=(
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
204.194.232.200 204.194.234.200
209.244.0.3 209.244.0.4
199.85.126.10 199.85.127.10
45.90.28.193 45.90.30.193
64.6.64.6 64.6.65.6
1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112
24.116.0.53 96.64.12.1 98.38.222.125 98.38.222.66
76.76.19.19 76.223.122.150 74.82.42.42
)

# Asia (adds volume)
ASIA_V4=(
114.114.114.114 114.114.115.115
1.2.4.8 210.2.4.8 223.5.5.5 223.6.6.6
101.226.4.6 218.30.118.6 180.76.76.76
119.29.29.29 182.254.116.116
1.12.12.12 120.53.53.53
)

# Combine master pools
MASTER_V4=(
  "${GLOBAL_V4[@]}" "${IR_V4[@]}" "${AE_V4[@]}" "${SA_V4[@]}" "${TR_V4[@]}"
  "${EU_V4[@]}" "${US_V4[@]}" "${ASIA_V4[@]}"
)

MASTER_V6=(
  "${GLOBAL_V6[@]}" "${IR_V6[@]}" "${AE_V6[@]}" "${SA_V6[@]}" "${TR_V6[@]}"
)

# ---------- Optional per-game bias ----------
declare -A GAME_SEED
GAME_SEED["PUBG Mobile"]="1.1.1.1,8.8.8.8,178.22.122.100"
GAME_SEED["Fortnite"]="1.1.1.1,8.8.4.4,208.67.222.222"
GAME_SEED["Warzone"]="1.1.1.1,9.9.9.9,8.8.4.4"
GAME_SEED["Valorant (Console)"]="1.1.1.1,208.67.220.220,8.8.4.4"

# ---------- Helpers ----------
unique_list(){ awk 'length>6 && !seen[$0]++'; }

country_pool(){
  local cc="$1" ver="${2:-4}"
  case "$cc" in
    IR|Ir|ir) [ "$ver" = "6" ] && printf "%s\n" "${IR_V6[@]}" | unique_list || printf "%s\n" "${IR_V4[@]}" | unique_list ;;
    AE|ae)    [ "$ver" = "6" ] && printf "%s\n" "${AE_V6[@]}" | unique_list || printf "%s\n" "${AE_V4[@]}" | unique_list ;;
    SA|sa)    [ "$ver" = "6" ] && printf "%s\n" "${SA_V6[@]}" | unique_list || printf "%s\n" "${SA_V4[@]}" | unique_list ;;
    TR|tr)    [ "$ver" = "6" ] && printf "%s\n" "${TR_V6[@]}" | unique_list || printf "%s\n" "${TR_V4[@]}" | unique_list ;;
    *)        [ "$ver" = "6" ] && printf "%s\n" "${MASTER_V6[@]}" | unique_list || printf "%s\n" "${MASTER_V4[@]}" | unique_list ;;
  esac
}

candidates_for_game(){
  local game="$1" ver="${2:-4}"
  local cc; cc="$(guess_cc)"
  local -a pool=()
  local seed="${GAME_SEED[$game]:-}"
  if [ -n "$seed" ]; then IFS=',' read -r -a arr <<< "$seed"; pool+=("${arr[@]}"); fi
  mapfile -t reg < <(country_pool "$cc" "$ver")
  pool+=("${reg[@]}")
  if [ "$ver" = "6" ]; then pool+=("${MASTER_V6[@]}"); else pool+=("${MASTER_V4[@]}"); fi
  printf "%s\n" "${pool[@]}" | unique_list
}

# ---------- Menus ----------
menu_mobile(){
  title
  echo "Mobile Games:"
  local i=1; for g in "${mobile_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  echo
  read -rp "Pick game number: " n
  [[ ! "$n" =~ ^[0-9]+$ ]] && echo "Invalid"; pause_enter; return
  (( n<1 || n>${#mobile_games[@]} )) && echo "Invalid"; pause_enter; return
  local game="${mobile_games[$((n-1))]}"
  echo "Collecting & testing DNS (fast checks)..."
  mapfile -t pool < <(candidates_for_game "$game" 4)
  local res; res="$(pick_best_two "${pool[@]}")"
  if [ -z "$res" ]; then echo "❌ No reachable DNS."; pause_enter; return; fi
  show_primary_secondary "$res"
  footer; pause_enter
}

menu_pc(){
  title
  echo "PC/Console Games:"
  local i=1; for g in "${pc_console_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  echo
  read -rp "Pick game number: " n
  [[ ! "$n" =~ ^[0-9]+$ ]] && echo "Invalid"; pause_enter; return
  (( n<1 || n>${#pc_console_games[@]} )) && echo "Invalid"; pause_enter; return
  local game="${pc_console_games[$((n-1))]}"
  echo "Collecting & testing DNS (fast checks)..."
  mapfile -t pool < <(candidates_for_game "$game" 4)
  local res; res="$(pick_best_two "${pool[@]}")"
  if [ -z "$res" ]; then echo "❌ No reachable DNS."; pause_enter; return; fi
  show_primary_secondary "$res"
  footer; pause_enter
}

menu_search(){
  title
  echo "Search Game DNS (Name + Device)"
  read -rp "Game name: " gname
  read -rp "Device (Mobile/PC/Console): " dev
  gname="${gname:-Generic Game}"; dev="${dev:-Device}"
  echo "Testing best DNS for: $gname ($dev)..."
  mapfile -t pool < <(candidates_for_game "$gname" 4)
  local res; res="$(pick_best_two "${pool[@]}")"
  if [ -z "$res" ]; then echo "❌ No reachable DNS."; pause_enter; return; fi
  show_primary_secondary "$res"
  footer; pause_enter
}

cc_from_choice(){
  case "$1" in
    1) echo "IR" ;;
    2) echo "AE" ;;
    3) echo "SA" ;;
    4) echo "TR" ;;
    *) echo "" ;;
  esac
}

menu_generator(){
  title
  echo "DNS Generator"
  echo " 1) Iran"
  echo " 2) UAE"
  echo " 3) Saudi Arabia"
  echo " 4) Turkey"
  read -rp "Select (1-4): " c
  local cc; cc="$(cc_from_choice "$c")"
  [ -z "$cc" ] && echo "Invalid"; pause_enter; return
  read -rp "IPv4 or IPv6? (4/6) [4]: " v; v="${v:-4}"
  read -rp "How many results? [20]: " k; k="${k:-20}"

  declare -a base=()
  if [ "$v" = "6" ]; then
    mapfile -t base < <(country_pool "$cc" 6)
  else
    mapfile -t base < <(country_pool "$cc" 4)
  fi
  if [ "${#base[@]}" -eq 0 ]; then echo "No candidates."; pause_enter; return; fi

  echo "Measuring latency..."
  declare -a pairs=()
  local ip ms
  local cnt=0
  for ip in "${base[@]}"; do
    ms=$(measure_ms "$ip"); ms=$(_extract_ms "$ms")
    pairs+=("$ms $ip")
    (( (cnt+=1) % 18 == 0 )) && echo -ne "."
  done
  echo
  mapfile -t ranked < <(printf "%s\n" "${pairs[@]}" | sort -n -k1,1 | awk '{print $2"|" $1}')

  declare -a under50=()
  for row in "${ranked[@]}"; do
    val="${row##*|}"; [[ "$val" =~ ^[0-9]+$ ]] || val=9999
    (( val <= 50 )) && under50+=("$row")
    [ "${#under50[@]}" -ge "$k" ] && break
  done
  if [ "${#under50[@]}" -eq 0 ]; then
    echo "⚠️ No entries under 50ms; showing best $k overall."
    under50=("${ranked[@]:0:$k}")
  fi
  print_numbered "${under50[@]}"
  footer; pause_enter
}

# ---------- Main ----------
main_menu(){
  while true; do
    title
    cat <<'EOF'
1) Mobile Games DNS
2) PC/Console Games DNS
3) Search Game DNS (name + device)
4) DNS Generator (Iran / UAE / Saudi / Turkey)
0) Exit
EOF
    read -rp "Select: " op
    case "$op" in
      1) menu_mobile ;;
      2) menu_pc ;;
      3) menu_search ;;
      4) menu_generator ;;
      0) exit 0 ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

main_menu
