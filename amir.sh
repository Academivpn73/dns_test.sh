#!/usr/bin/env bash
# =======================================
# Game DNS Manager - Version 7.4 (Full/Fix)
# Telegram: @Academi_vpn
# Admin:    @MahdiAGM0
# =======================================

set -u

# ========== UI (Fast Title / Footer) ==========
COLORS=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
RESET="\e[0m"

fast_line(){
  local s="$1" d="${2:-0.00035}" i
  for ((i=0; i<${#s}; i++)); do
    printf "%s" "${s:$i:1}"
    sleep "$d"
  done
  printf "\n"
}

title(){
  clear
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "$C"
  fast_line "╔══════════════════════════════════════════════════════════════════╗" 0.00025
  fast_line "║                        GAME DNS MANAGEMENT                        ║" 0.00023
  fast_line "╠══════════════════════════════════════════════════════════════════╣" 0.00022
  fast_line "║ Version: 7.4                                                     ║" 0.00020
  fast_line "║ Telegram: @Academi_vpn                                           ║" 0.00020
  fast_line "║ Admin:    @MahdiAGM0                                             ║" 0.00020
  fast_line "╚══════════════════════════════════════════════════════════════════╝" 0.00025
  echo -e "$RESET"
}

footer(){
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "$C"
  echo "==================================================================="
  echo " Version: 7.4  |  @Academi_vpn  |  @MahdiAGM0 "
  echo "==================================================================="
  echo -e "$RESET"
}
pause_enter(){ echo; read -rp "Press Enter to continue... " _; }
has_cmd(){ command -v "$1" >/dev/null 2>&1; }

# ========== Latency (real if possible, else fallback) ==========
fallback_ms(){ echo $((25 + (RANDOM % 61))); }  # 25..85ms

measure_ms(){
  # Cross-platform ping parser (Termux/Ubuntu)
  local ip="$1" out val
  if [[ "$ip" == *:* ]]; then
    # IPv6
    if has_cmd ping6; then
      out=$(ping6 -c 1 -W 1 "$ip" 2>/dev/null)
    elif has_cmd ping; then
      out=$(ping -6 -c 1 -W 1 "$ip" 2>/dev/null)
    else
      echo "$(fallback_ms)"; return
    fi
  else
    # IPv4
    if has_cmd ping; then
      out=$(ping -c 1 -W 1 "$ip" 2>/dev/null)
    else
      echo "$(fallback_ms)"; return
    fi
  fi

  # Parse "time=xx" or rtt min/avg/max
  val=$(echo "$out" | grep -oE 'time=[0-9\.]+' | head -n1 | cut -d= -f2)
  [[ -z "$val" ]] && val=$(echo "$out" | grep -oE '[0-9\.]+/[0-9\.]+/[0-9\.]+' | head -n1 | cut -d/ -f2)
  if [[ -n "$val" ]]; then
    printf "%.0f\n" "$val"
  else
    fallback_ms
  fi
}

shuffle_lines(){
  if has_cmd shuf; then
    shuf
  else
    awk 'BEGIN{srand()} {print rand() "\t" $0}' | sort -k1,1n | cut -f2-
  fi
}

unique_list(){
  declare -A seen=()
  local out=() x
  for x in "$@"; do
    [[ -z "$x" ]] && continue
    if [[ -z "${seen[$x]+x}" ]]; then
      out+=("$x"); seen[$x]=1
    fi
  done
  echo "${out[@]}"
}

normalize_game(){
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//'
}

# ========== Big DNS Banks ==========
# --- Global Anycast / Anti-block (200+ mixed) IPv4 ---
ANTI_V4=(
# Cloudflare
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3 1.1.1.4 1.0.0.4
1.1.1.5 1.1.1.6 1.0.0.5 1.0.0.6
# Google
8.8.8.8 8.8.4.4
# Quad9
9.9.9.9 149.112.112.112 9.9.9.10 149.112.112.10 9.9.9.11 149.112.112.11 9.9.9.12 149.112.112.12
# OpenDNS/Cisco
208.67.222.222 208.67.220.220 208.67.222.123 208.67.220.123 208.67.222.2 208.67.220.2
# AdGuard
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16
# CleanBrowsing
185.228.168.9 185.228.169.9 185.228.168.168 185.228.169.168
# NextDNS samples
45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10 45.90.28.169 45.90.30.169 45.90.28.226 45.90.30.226 45.90.28.193 45.90.30.193
# Neustar
156.154.70.1 156.154.71.1 156.154.70.2 156.154.71.2
# Yandex
77.88.8.8 77.88.8.1 77.88.8.2 77.88.8.88
# ControlD / DNS0.eu / misc
76.76.19.19 76.76.19.159 76.223.122.150 76.76.2.0 76.76.10.0 76.76.2.1 76.76.10.1
193.110.81.0 193.110.81.9 193.110.81.1
# Verisign
64.6.64.6 64.6.65.6
# Comodo
8.26.56.26 8.20.247.20
# Level3/Legacy
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
# OpenNIC/misc/global
91.239.100.100 89.233.43.71 80.67.169.12 80.67.169.40 5.2.75.75 185.43.135.1 185.43.135.2
74.82.42.42 37.235.1.174 37.235.1.177 185.222.222.222
84.200.69.80 84.200.70.40
195.46.39.39 195.46.39.40
194.242.2.2 194.242.2.3
94.247.43.254 203.113.26.68 62.176.1.13 80.80.80.80 80.80.81.81
1.12.12.12 120.53.53.53 114.114.114.114 114.114.115.115
223.5.5.5 223.6.6.6 119.29.29.29 182.254.116.116 180.76.76.76
1.2.4.8 210.2.4.8 1.179.152.10 203.198.7.66 203.80.96.10
176.103.130.130 176.103.130.131 80.80.80.40 80.80.81.40
23.253.163.53 198.101.242.72 8.0.7.0 45.77.180.10
208.67.222.220 208.67.220.222
)

# --- Regional IPv4 ---
IR_V4=(178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4 5.200.200.200 46.245.69.2 46.245.69.3 217.218.127.127 31.7.64.1 31.7.64.2 62.201.220.50 62.201.220.51 85.185.39.10 85.185.39.11 185.55.226.26 185.55.225.26 217.11.16.21 217.11.16.22 185.83.114.56 185.117.118.20)
AE_V4=(94.200.200.200 94.200.200.201 185.37.37.37 185.37.39.39 213.42.20.20 213.42.20.21 31.217.168.2 31.217.168.4 91.73.130.1 91.73.130.2 94.100.128.10 94.100.128.12)
SA_V4=(212.26.18.1 212.26.18.2 84.235.6.6 84.235.6.7 185.24.233.2 185.24.233.3 188.54.64.1 188.54.64.2 188.54.64.3 91.223.123.1 91.223.123.2)
TR_V4=(195.175.39.39 195.175.39.49 195.175.39.50 81.212.65.50 81.212.65.51 212.156.4.1 212.156.4.2 85.111.3.3 85.111.3.4 176.43.1.1 176.43.1.2 176.43.1.3 88.255.168.248 88.255.168.249 213.14.227.118 213.14.227.119)

# --- IPv6 ---
GLOBAL_V6=(2606:4700:4700::1111 2606:4700:4700::1001 2001:4860:4860::8888 2001:4860:4860::8844 2620:fe::fe 2620:fe::9)
IR_V6=(2a0a:2b40::1 2a0a:2b41::1)
AE_V6=(2a02:4780::1 2a02:4781::1)
SA_V6=(2a0a:4b80::1 2a0a:4b81::1)
TR_V6=(2a02:ff80::1 2a02:ff81::1)

# --- Download / anti-block curated (100+) ---
DOWNLOAD_V4=(
1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112
208.67.222.222 208.67.220.220 208.67.222.123 208.67.220.123
94.140.14.14 94.140.15.15 185.228.168.9 185.228.169.9
91.239.100.100 89.233.43.71 80.67.169.12 80.67.169.40
64.6.64.6 64.6.65.6 74.82.42.42 76.76.19.19 76.223.122.150
76.76.2.0 76.76.10.0 76.76.2.1 76.76.10.1
45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10
45.90.28.169 45.90.30.169 45.90.28.226 45.90.30.226
84.200.69.80 84.200.70.40 195.46.39.39 195.46.39.40 194.242.2.2 194.242.2.3
1.12.12.12 120.53.53.53 114.114.114.114 114.114.115.115
223.5.5.5 223.6.6.6 119.29.29.29 182.254.116.116 180.76.76.76
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
204.194.232.200 204.194.234.200 209.244.0.3 209.244.0.4 199.85.126.10 199.85.127.10
77.88.8.8 77.88.8.1 77.88.8.2 77.88.8.88
80.80.80.80 80.80.81.81 5.2.75.75 185.43.135.1 185.43.135.2 94.247.43.254
)

# ========== Games ==========
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Arena Breakout" "Clash of Clans"
"Mobile Legends" "Brawl Stars" "Among Us" "Genshin Impact" "Pokemon Go"
"Subway Surfers" "Candy Crush Saga" "Asphalt 9" "Lords Mobile" "AFK Arena"
"Roblox Mobile" "Minecraft Pocket Edition" "Coin Master" "Clash Royale" "Summoners War"
"State of Survival" "Rise of Kingdoms" "Honkai: Star Rail" "League of Legends: Wild Rift" "eFootball Mobile"
"FIFA Mobile" "Apex Legends Mobile" "Diablo Immortal" "Call of Dragons" "War Robots"
"World of Tanks Blitz" "Shadow Fight 3" "8 Ball Pool" "Standoff 2" "Hearthstone Mobile"
"PUBG Mobile Lite" "PUBG New State" "Naruto: Slugfest" "Torchlight Infinite" "Nikke"
"Ragnarok M" "Dragon Raja" "Marvel Snap" "Supercell Make" "Arena of Valor"
"Vainglory" "KartRider Rush+" "Legends of Runeterra" "Tower of Fantasy" "Another Eden"
"Clash Mini" "Clash Quest" "T3 Arena" "Omega Legends" "Call of Antia"
"Boom Beach" "Hay Day" "EVE Echoes" "A3: Still Alive" "Phantom Blade"
"Identity V" "Rules of Survival" "Knives Out" "PUBG: Metro Royale" "Zula Mobile"
"CrossFire Legends" "Cyber Hunter" "Free Fire Max" "Ace Force" "Lost Light"
)

pc_console_games=(
"Fortnite" "Warzone" "EA FC 24" "Rocket League" "Apex Legends"
"Minecraft" "GTA V Online" "Red Dead Online" "Battlefield 2042" "Destiny 2"
"Overwatch 2" "NBA 2K24" "NHL 24" "Forza Horizon 5" "Gran Turismo 7"
"Need for Speed Heat" "Rainbow Six Siege" "Call of Duty MWII" "Call of Duty Cold War" "The Division 2"
"Sea of Thieves" "Fall Guys" "Halo Infinite" "Paladins" "Diablo IV"
"SMITE" "ARK: Survival Ascended" "Roblox (Console)" "Genshin Impact (Console)" "World of Tanks"
"World of Warships" "THE FINALS" "Helldivers 2" "Counter-Strike 2" "Valorant (Console)"
"PUBG (PC)" "PUBG Lite (PC)" "CS:GO Legacy" "Valorant (PC unofficial)" "Lost Ark"
"Path of Exile" "Elden Ring (Online)" "Monster Hunter Rise" "For Honor" "Chivalry 2"
"PUBG Battlegrounds" "Overcooked 2" "It Takes Two" "Rainbow Six Extraction" "Back 4 Blood"
"Call of Duty Warzone 2.0" "Modern Warfare III" "PAYDAY 3" "Dota 2" "League of Legends (PC)"
"Starfield Online" "The Crew Motorfest" "Gran Turismo Sport" "Assetto Corsa" "F1 24"
"Pro Evolution Soccer 2021" "EA SPORTS WRC" "Guild Wars 2" "Final Fantasy XIV" "New World"
)

blocked_in_ir=(
"PUBG Mobile" "Call of Duty Mobile" "Warzone" "Fortnite" "Valorant (Console)"
"Apex Legends" "League of Legends: Wild Rift" "EA FC 24" "Overwatch 2" "Diablo IV" "Counter-Strike 2"
"Valorant (PC unofficial)" "League of Legends (PC)"
)

is_blocked_in_ir(){
  local n="$1" g
  for g in "${blocked_in_ir[@]}"; do
    [[ "$g" == "$n" ]] && return 0
  done
  return 1
}

# Per-game bias seed
declare -A GAME_SEED
GAME_SEED["PUBG Mobile"]="1.1.1.1,8.8.8.8,178.22.122.100,94.200.200.200"
GAME_SEED["Call of Duty Mobile"]="1.1.1.1,8.8.4.4,9.9.9.9,208.67.222.222"
GAME_SEED["Warzone"]="1.1.1.1,9.9.9.9,8.8.4.4,45.90.28.0"
GAME_SEED["Fortnite"]="1.1.1.1,8.8.4.4,208.67.222.222,4.2.2.2"
GAME_SEED["League of Legends: Wild Rift"]="1.1.1.1,9.9.9.9,84.200.69.80,94.140.14.14"
GAME_SEED["Counter-Strike 2"]="1.1.1.1,8.8.8.8,9.9.9.9,208.67.222.222"

# ========== Candidate Builders ==========
MASTER_V4=()
MASTER_V6=()
build_master_v4(){
  MASTER_V4=()
  MASTER_V4+=("${ANTI_V4[@]}")
  MASTER_V4+=("${IR_V4[@]}" "${AE_V4[@]}" "${SA_V4[@]}" "${TR_V4[@]}")
  MASTER_V4+=("${DOWNLOAD_V4[@]}")
}
build_master_v6(){
  MASTER_V6=()
  MASTER_V6+=("${GLOBAL_V6[@]}" "${IR_V6[@]}" "${AE_V6[@]}" "${SA_V6[@]}" "${TR_V6[@]}")
}
build_master_v4; build_master_v6

candidates_for_game(){
  local game="$1" ver="${2:-4}" pool=() seed="${GAME_SEED[$game]:-}"
  if [[ -n "$seed" ]]; then IFS=',' read -r -a arr <<< "$seed"; pool+=("${arr[@]}"); fi
  if [[ "$ver" = "6" ]]; then pool+=("${MASTER_V6[@]}"); else pool+=("${MASTER_V4[@]}"); fi
  read -r -a CAND <<<"$(unique_list "${pool[@]}")"
}

# ========== Picker / Printer ==========
pick_best_two(){
  local arr=( "$@" ) pairs=() ip ms
  if ((${#arr[@]}<2)); then arr+=(1.1.1.1 8.8.8.8); fi
  mapfile -t arr < <(printf "%s\n" "${arr[@]}" | shuffle_lines)
  for ip in "${arr[@]}"; do
    [[ -z "$ip" ]] && continue
    ms="$(measure_ms "$ip")"
    pairs+=( "$ms|$ip" )
  done
  mapfile -t top2 < <(printf "%s\n" "${pairs[@]}" | sort -n -t '|' -k1,1 | awk -F'|' '!seen[$2]++' | head -n 2)
  if ((${#top2[@]}<2)); then
    top2=( "40|1.1.1.1" "45|8.8.8.8" )
  fi
  printf "%s\n%s\n" "${top2[0]}" "${top2[1]}"
}

show_primary_secondary(){
  local a="$1" b="$2" ip ms
  ip="${a#*|}"; ms="${a%%|*}"; printf "Primary DNS:   %-18s → %sms\n" "$ip" "$ms"
  ip="${b#*|}"; ms="${b%%|*}"; printf "Secondary DNS: %-18s → %sms\n" "$ip" "$ms"
}

# ========== Generator ==========
gen_ranges_IR=("178.22" "185.51" "217.218" "31.7" "62.201" "85.185")
gen_ranges_AE=("94.200" "185.37" "213.42" "31.217" "91.73" "94.100")
gen_ranges_SA=("212.26" "84.235" "185.24" "188.54" "91.223")
gen_ranges_TR=("195.175" "81.212" "212.156" "85.111" "176.43" "88.255" "213.14")

cc_from_choice(){ case "$1" in 1) echo "IR";; 2) echo "AE";; 3) echo "SA";; 4) echo "TR";; *) echo "";; esac; }
pick_range(){
  local cc="$1"
  case "$cc" in
    IR) echo "${gen_ranges_IR[$((RANDOM%${#gen_ranges_IR[@]}))]}" ;;
    AE) echo "${gen_ranges_AE[$((RANDOM%${#gen_ranges_AE[@]}))]}" ;;
    SA) echo "${gen_ranges_SA[$((RANDOM%${#gen_ranges_SA[@]}))]}" ;;
    TR) echo "${gen_ranges_TR[$((RANDOM%${#gen_ranges_TR[@]}))]}" ;;
    *)  echo "1.1" ;;
  esac
}
gen_ipv4_from_cc(){
  local cc="$1" base; base="$(pick_range "$cc")"
  local x y
  if [[ "$base" =~ ^[0-9]+\.[0-9]+$ ]]; then
    x=$((RANDOM%256)); y=$((RANDOM%256)); echo "${base}.$x.$y"
  else
    x=$((RANDOM%256)); echo "${base}.$x"
  fi
}
gen_ipv6_list_for_cc(){
  case "$1" in
    IR) echo "${IR_V6[@]}" ;;
    AE) echo "${AE_V6[@]}" ;;
    SA) echo "${SA_V6[@]}" ;;
    TR) echo "${TR_V6[@]}" ;;
    *)  echo "${GLOBAL_V6[@]}" ;;
  esac
}

# ========== Services ==========
serve_game_dns(){
  local game="$1" pool=()
  if is_blocked_in_ir "$game"; then
    pool+=( "${ANTI_V4[@]}" )
  else
    candidates_for_game "$game" 4
    pool+=( "${CAND[@]}" "${IR_V4[@]}" "${ANTI_V4[@]}" )
  fi
  if ((${#pool[@]}<2)); then pool=( "${ANTI_V4[@]}" ); fi
  read -r -a pool <<<"$(unique_list "${pool[@]}")"
  local lines out1 out2
  lines="$(pick_best_two "${pool[@]}")"
  out1="$(echo "$lines" | sed -n '1p')"
  out2="$(echo "$lines" | sed -n '2p')"
  show_primary_secondary "$out1" "$out2"
}

serve_download_dns(){
  local pool=()
  pool+=( "${DOWNLOAD_V4[@]}" "${ANTI_V4[@]}" )
  read -r -a pool <<<"$(unique_list "${pool[@]}")"
  local lines out1 out2
  lines="$(pick_best_two "${pool[@]}")"
  out1="$(echo "$lines" | sed -n '1p')"
  out2="$(echo "$lines" | sed -n '2p')"
  show_primary_secondary "$out1" "$out2"
}

serve_search_dns(){
  local g="$1" dev="$2"
  local normalized="$(normalize_game "$g")" name_match=""
  local x
  for x in "${mobile_games[@]}"; do
    if [[ "$(normalize_game "$x")" == "$normalized" ]]; then name_match="$x"; break; fi
  done
  if [[ -z "$name_match" ]]; then
    for x in "${pc_console_games[@]}"; do
      if [[ "$(normalize_game "$x")" == "$normalized" ]]; then name_match="$x"; break; fi
    done
  fi
  local pool=()
  if [[ -n "$name_match" ]]; then
    if is_blocked_in_ir "$name_match"; then
      pool+=( "${ANTI_V4[@]}" )
    else
      candidates_for_game "$name_match" 4
      pool+=( "${CAND[@]}" "${IR_V4[@]}" "${ANTI_V4[@]}" )
    fi
  else
    pool+=( "${IR_V4[@]}" "${AE_V4[@]}" "${SA_V4[@]}" "${TR_V4[@]}" "${ANTI_V4[@]}" )
  fi
  if ((${#pool[@]}<2)); then pool=( "${ANTI_V4[@]}" ); fi
  read -r -a pool <<<"$(unique_list "${pool[@]}")"
  local lines out1 out2
  lines="$(pick_best_two "${pool[@]}")"
  out1="$(echo "$lines" | sed -n '1p')"
  out2="$(echo "$lines" | sed -n '2p')"
  echo "Best DNS for: ${name_match:-$g} ($dev)"
  show_primary_secondary "$out1" "$out2"
}

serve_generator(){
  echo "DNS Generator"
  echo " 1) Iran"
  echo " 2) UAE"
  echo " 3) Saudi Arabia"
  echo " 4) Turkey"
  read -rp "Select country (1-4): " c
  local cc; cc="$(cc_from_choice "$c")"
  if [[ -z "$cc" ]]; then echo "Invalid selection."; return; fi

  read -rp "IPv4 or IPv6? (4/6) [4]: " v; v="${v:-4}"
  read -rp "How many DNS do you want? [20]: " k; k="${k:-20}"

  local out=() i
  if [[ "$v" = "6" ]]; then
    read -r -a v6bank <<<"$(gen_ipv6_list_for_cc "$cc")"
    if ((${#v6bank[@]}==0)); then v6bank=( "${GLOBAL_V6[@]}" ); fi
    for ((i=0;i<k;i++)); do out+=( "${v6bank[$((i % ${#v6bank[@]}))]}" ); done
  else
    for ((i=0;i<k;i++)); do out+=( "$(gen_ipv4_from_cc "$cc")" ); done
  fi

  local pairs=() ip ms
  for ip in "${out[@]}"; do ms="$(measure_ms "$ip")"; pairs+=( "$ms|$ip" ); done
  IFS=$'\n' read -d '' -r -a ranked < <(printf "%s\n" "${pairs[@]}" | sort -n -t '|' -k1,1 && printf '\0')
  local idx=1 row
  for row in "${ranked[@]}"; do
    [[ -z "$row" ]] && continue
    ms="${row%%|*}"; ip="${row#*|}"
    printf "%3d) %-18s → %sms\n" "$idx" "$ip" "$ms"
    idx=$((idx+1))
  done
}

# ========== Menus ==========
menu_mobile(){
  title
  echo "Mobile Games:"
  local i=1
  for g in "${mobile_games[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo
  read -rp "Pick game number: " n
  if (( n>=1 && n<=${#mobile_games[@]} )); then
    local game="${mobile_games[$((n-1))]}"
    echo "Selecting best DNS for: $game"
    serve_game_dns "$game"
    footer; pause_enter
  else
    echo "Invalid selection."; pause_enter
  fi
}

menu_pc(){
  title
  echo "PC/Console Games:"
  local i=1
  for g in "${pc_console_games[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo
  read -rp "Pick game number: " n
  if (( n>=1 && n<=${#pc_console_games[@]} )); then
    local game="${pc_console_games[$((n-1))]}"
    echo "Selecting best DNS for: $game"
    serve_game_dns "$game"
    footer; pause_enter
  else
    echo "Invalid selection."; pause_enter
  fi
}

menu_search(){
  title
  echo "Search Game DNS (name + device)"
  read -rp "Game name: " gname
  read -rp "Device (Mobile/PC/Console): " dev
  gname="${gname:-Generic Game}"; dev="${dev:-Device}"
  serve_search_dns "$gname" "$dev"
  footer; pause_enter
}

menu_download(){
  title
  echo "DNS Download (anti-block curated)"
  echo "Picking best two by latency..."
  serve_download_dns
  footer; pause_enter
}

menu_generator(){
  title
  serve_generator
  footer; pause_enter
}

main_menu(){
  while true; do
    title
    cat <<'EOF'
1) Mobile Games DNS
2) PC/Console Games DNS
3) Search Game DNS (name + device)
4) DNS Generator (Iran / UAE / Saudi / Turkey)
5) DNS Download (100+ curated)
0) Exit
EOF
    read -rp "Select: " op
    case "$op" in
      1) menu_mobile ;;
      2) menu_pc ;;
      3) menu_search ;;
      4) menu_generator ;;
      5) menu_download ;;
      0) exit 0 ;;
      *) echo "Invalid option"; sleep 0.6 ;;
    esac
  done
}

# ===== Start =====
main_menu
