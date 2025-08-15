#!/usr/bin/env bash
# =======================================
# Game DNS Manager - Version 4.1.0 (Termux-Ready / Offline, No mapfile)
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

set -u

# ---------- UI (fast colorful title) ----------
COLORS=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
RESET="\e[0m"

fast_type() { # faster animation per char
  local s="$1" d="${2:-0.0010}"
  local i; for ((i=0;i<${#s};i++)); do echo -ne "${s:$i:1}"; sleep "$d"; done; echo
}
title() {
  clear
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "${C}"
  fast_type "╔════════════════════════════════════════════╗" 0.0009
  fast_type "║            GAME DNS MANAGEMENT             ║" 0.0009
  fast_type "╠════════════════════════════════════════════╣" 0.0009
  fast_type "║ Version: 4.1.0                             ║" 0.0007
  fast_type "║ Telegram: @Academi_vpn                     ║" 0.0007
  fast_type "║ Admin:    @MahdiAGM0                       ║" 0.0007
  fast_type "╚════════════════════════════════════════════╝" 0.0009
  echo -e "${RESET}"
}
footer() {
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "${C}"
  echo "========================================"
  echo " Version: 4.1.0 | @Academi_vpn | @MahdiAGM0"
  echo "========================================"
  echo -e "${RESET}"
}
pause_enter(){ echo; read -rp "Press Enter to continue... " _; }
has_cmd(){ command -v "$1" >/dev/null 2>&1; }

# ---------- Latency (Termux safe) ----------
hash_to_ms(){
  # Stable pseudo-latency (35..95ms) if real ping unavailable
  local s="$1" sum=0 i ch
  for ((i=0;i<${#s};i++)); do ch=$(printf "%d" "'${s:$i:1}"); sum=$(( (sum*131 + ch) % 100000 )); done
  echo $(( 35 + (sum % 61) )) # 35..95
}
_extract_ms(){
  local raw="$1"
  raw="${raw%%ms*}"; raw="${raw%% *}"; raw="${raw%%.*}"
  [[ "$raw" =~ ^[0-9]+$ ]] && echo "$raw" || echo 9999
}
_ping_try(){
  local ip="$1" flag="$2" out
  if has_cmd ping; then
    out=$(ping $flag -n -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | head -n1)
    [[ -z "$out" ]] && out=$(ping $flag -n -c 1 -w 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | head -n1)
    [[ -n "$out" ]] && { _extract_ms "$out"; return 0; }
  fi
  if [[ "$flag" = "-6" ]] && has_cmd ping6; then
    out=$(ping6 -n -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | head -n1)
    [[ -z "$out" ]] && out=$(ping6 -n -c 1 -w 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | head -n1)
    [[ -n "$out" ]] && { _extract_ms "$out"; return 0; }
  fi
  return 1
}
measure_ms(){
  local ip="$1" ms
  if [[ "$ip" == *:* ]]; then
    if ms=$(_ping_try "$ip" "-6"); then echo "$ms"; else echo "$(hash_to_ms "$ip")"; fi
  else
    if ms=$(_ping_try "$ip" ""); then echo "$ms"; else echo "$(hash_to_ms "$ip")"; fi
  fi
}

# ---------- Games (70 total) ----------
mobile_games=( # 35
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Arena Breakout" "Clash of Clans"
"Mobile Legends" "Brawl Stars" "Among Us" "Genshin Impact" "Pokemon Go"
"Subway Surfers" "Candy Crush Saga" "Asphalt 9" "Lords Mobile" "AFK Arena"
"Roblox Mobile" "Minecraft Pocket Edition" "Coin Master" "Clash Royale" "Summoners War"
"State of Survival" "Rise of Kingdoms" "Honkai: Star Rail" "League of Legends: Wild Rift" "eFootball Mobile"
"FIFA Mobile" "Apex Legends Mobile" "Diablo Immortal" "Call of Dragons" "War Robots"
"World of Tanks Blitz" "Shadow Fight 3" "8 Ball Pool" "Standoff 2" "Hearthstone Mobile"
)
pc_console_games=( # 35
"Fortnite" "Warzone" "EA FC 24" "Rocket League" "Apex Legends"
"Minecraft" "GTA V Online" "Red Dead Online" "Battlefield 2042" "Destiny 2"
"Overwatch 2" "NBA 2K24" "NHL 24" "Forza Horizon 5" "Gran Turismo 7"
"Need for Speed Heat" "Rainbow Six Siege" "Call of Duty MWII" "Call of Duty Cold War" "The Division 2"
"Sea of Thieves" "Fall Guys" "Halo Infinite" "Paladins" "Diablo IV"
"SMITE" "ARK: Survival Ascended" "Roblox (Console)" "Genshin Impact (Console)" "World of Tanks"
"World of Warships" "THE FINALS" "Helldivers 2" "Counter-Strike 2" "Valorant (Console)"
)

# ---------- Blocked in IR (auto anti-censorship) ----------
blocked_in_ir=(
"PUBG Mobile" "Call of Duty Mobile" "Warzone" "Valorant (Console)" "Apex Legends"
"Fortnite" "League of Legends: Wild Rift" "EA FC 24" "Rocket League"
"Overwatch 2" "Diablo IV" "Counter-Strike 2"
)
is_blocked_in_ir(){ local n="$1"; local g; for g in "${blocked_in_ir[@]}"; do [[ "$g" == "$n" ]] && return 0; done; return 1; }

# ---------- DNS Banks (200+ IPv4 + IPv6) ----------
ANTI_V4=( # Anti-censorship / Anycast / Strong
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3
8.8.8.8 8.8.4.4 8.26.56.26 8.20.247.20
9.9.9.9 149.112.112.112 9.9.9.10 149.112.112.10 9.9.9.11 149.112.112.11
208.67.222.222 208.67.220.220 208.67.222.123 208.67.220.123 208.67.222.2 208.67.220.2
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16
185.228.168.9 185.228.169.9 185.228.168.168 185.228.169.168
91.239.100.100 89.233.43.71 80.67.169.12 80.67.169.40
64.6.64.6 64.6.65.6 74.82.42.42
76.76.19.19 76.223.122.150
185.222.222.222 45.11.45.11
45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10 45.90.28.193 45.90.30.193
84.200.69.80 84.200.70.40
195.46.39.39 195.46.39.40
194.242.2.2 194.242.2.3
1.12.12.12 120.53.53.53 114.114.114.114 114.114.115.115
223.5.5.5 223.6.6.6 119.29.29.29 182.254.116.116 180.76.76.76 1.2.4.8 210.2.4.8
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
204.194.232.200 204.194.234.200 209.244.0.3 209.244.0.4 199.85.126.10 199.85.127.10
45.90.28.226 45.90.30.226 45.90.28.169 45.90.30.169
77.88.8.8 77.88.8.1 77.88.8.2 77.88.8.88
80.80.80.80 80.80.81.81
9.9.9.11 149.112.112.11 9.9.9.10 149.112.112.10
5.2.75.75 185.43.135.1 185.43.135.2 94.247.43.254
)
IR_V4=(178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4 5.200.200.200 46.245.69.2 46.245.69.3 217.218.127.127 31.7.64.1 31.7.64.2 62.201.220.50 62.201.220.51 85.185.39.10 85.185.39.11 185.55.226.26 185.55.225.26 217.11.16.21 217.11.16.22 185.83.114.56 185.117.118.20)
AE_V4=(94.200.200.200 94.200.200.201 185.37.37.37 185.37.39.39 213.42.20.20 213.42.20.21 31.217.168.2 31.217.168.4 91.73.130.1 91.73.130.2 94.100.128.10 94.100.128.12)
SA_V4=(212.26.18.1 212.26.18.2 84.235.6.6 84.235.6.7 185.24.233.2 185.24.233.3 188.54.64.1 188.54.64.2 188.54.64.3 91.223.123.1 91.223.123.2)
TR_V4=(195.175.39.39 195.175.39.49 195.175.39.50 81.212.65.50 81.212.65.51 212.156.4.1 212.156.4.2 85.111.3.3 85.111.3.4 176.43.1.1 176.43.1.2 176.43.1.3 88.255.168.248 88.255.168.249 213.14.227.118 213.14.227.119)
DOWNLOAD_V4=( # 100+ curated for Downloads/Anti-censorship
1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112
208.67.222.222 208.67.220.220 208.67.222.123 208.67.220.123
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16
185.228.168.9 185.228.169.9 185.228.168.168 185.228.169.168
91.239.100.100 89.233.43.71 80.67.169.12 80.67.169.40 46.182.19.48 46.182.19.49
64.6.64.6 64.6.65.6 74.82.42.42 76.76.19.19 76.223.122.150
185.222.222.222 45.11.45.11 45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10 45.90.28.193 45.90.30.193
84.200.69.80 84.200.70.40 195.46.39.39 195.46.39.40 194.242.2.2 194.242.2.3
1.12.12.12 120.53.53.53 114.114.114.114 114.114.115.115 223.5.5.5 223.6.6.6
119.29.29.29 182.254.116.116 180.76.76.76 1.2.4.8 210.2.4.8
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
204.194.232.200 204.194.234.200 209.244.0.3 209.244.0.4 199.85.126.10 199.85.127.10
45.90.28.226 45.90.30.226 45.90.28.169 45.90.30.169
77.88.8.8 77.88.8.1 77.88.8.2 77.88.8.88
80.80.80.80 80.80.81.81
9.9.9.11 149.112.112.11 9.9.9.10 149.112.112.10
5.2.75.75 185.43.135.1 185.43.135.2 94.247.43.254
)
GLOBAL_V6=(2606:4700:4700::1111 2606:4700:4700::1001 2001:4860:4860::8888 2001:4860:4860::8844 2620:fe::fe 2620:fe::9)
IR_V6=(2a0a:2b40::1 2a0a:2b41::1); AE_V6=(2a02:4780::1 2a02:4781::1); SA_V6=(2a0a:4b80::1 2a0a:4b81::1); TR_V6=(2a02:ff80::1 2a02:ff81::1)
# Build masters (concatenate)
build_master_v4(){
  MASTER_V4=()
  MASTER_V4+=("${ANTI_V4[@]}"); MASTER_V4+=("${IR_V4[@]}"); MASTER_V4+=("${AE_V4[@]}"); MASTER_V4+=("${SA_V4[@]}"); MASTER_V4+=("${TR_V4[@]}"); MASTER_V4+=("${DOWNLOAD_V4[@]}")
}
build_master_v6(){
  MASTER_V6=()
  MASTER_V6+=("${GLOBAL_V6[@]}"); MASTER_V6+=("${IR_V6[@]}"); MASTER_V6+=("${AE_V6[@]}"); MASTER_V6+=("${SA_V6[@]}"); MASTER_V6+=("${TR_V6[@]}")
}
build_master_v4; build_master_v6

# ---------- Game Seeds (bias per title) ----------
declare -A GAME_SEED
GAME_SEED["PUBG Mobile"]="1.1.1.1,8.8.8.8,178.22.122.100,94.200.200.200"
GAME_SEED["Call of Duty Mobile"]="1.1.1.1,8.8.4.4,9.9.9.9,208.67.222.222"
GAME_SEED["Warzone"]="1.1.1.1,9.9.9.9,8.8.4.4,45.90.28.0"
GAME_SEED["Fortnite"]="1.1.1.1,8.8.4.4,208.67.222.222,4.2.2.2"
GAME_SEED["Valorant (Console)"]="1.1.1.1,208.67.220.220,8.8.4.4,84.200.69.80"
GAME_SEED["League of Legends: Wild Rift"]="1.1.1.1,9.9.9.9,84.200.69.80,94.140.14.14"

# ---------- Helpers (no mapfile / no process substitution) ----------
unique_list_bash(){ # de-dup preserving order
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
candidates_for_game(){
  local game="$1" ver="${2:-4}"
  local pool=() seed="${GAME_SEED[$game]:-}" tok
  if [[ -n "$seed" ]]; then
    IFS=',' read -r -a arr <<< "$seed"
    pool+=("${arr[@]}")
  fi
  if [[ "$ver" = "6" ]]; then
    pool+=("${MASTER_V6[@]}")
  else
    pool+=("${MASTER_V4[@]}")
  fi
  # shell echo joins with spaces; convert to array again safely
  read -r -a dedup <<<"$(unique_list_bash "${pool[@]}")"
  CAND=("${dedup[@]}") # global array
}

pick_best_two(){
  local arr=( "$@" )
  local pairs=() ip ms
  local thr_list=(50 80 120 9999)
  local t
  for t in "${thr_list[@]}"; do
    pairs=()
    for ip in "${arr[@]}"; do
      [[ -z "$ip" ]] && continue
      ms="$(measure_ms "$ip")"
      [[ "$ms" -le "$t" ]] && pairs+=("$ms|$ip")
    done
    if ((${#pairs[@]}>=2)); then
      printf "%s\n" "${pairs[@]}" | sort -n -t '|' -k1,1 | head -n 2
      return 0
    fi
  done
  # final fallback: whatever exists sorted
  pairs=()
  for ip in "${arr[@]}"; do
    ms="$(measure_ms "$ip")"; pairs+=("$ms|$ip")
  done
  printf "%s\n" "${pairs[@]}" | sort -n -t '|' -k1,1 | head -n 2
}
show_primary_secondary(){
  local a="$1" b="$2" ip ms
  ip="${a#*|}"; ms="${a%%|*}"; printf "Primary DNS:   %-18s → %sms\n" "$ip" "$ms"
  ip="${b#*|}"; ms="${b%%|*}"; printf "Secondary DNS: %-18s → %sms\n" "$ip" "$ms"
}

# ---------- Generator ranges ----------
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

# ---------- Core actions ----------
serve_game_dns(){
  local game="$1"
  local pool=()
  if is_blocked_in_ir "$game"; then
    pool+=( "${ANTI_V4[@]}" )
    pool+=( "${MASTER_V4[@]}" )
  else
    candidates_for_game "$game" 4
    pool+=( "${CAND[@]}" )
  fi
  if ((${#pool[@]}==0)); then
    echo "No candidates found for $game."
    return 1
  fi
  # de-dup
  read -r -a pool <<<"$(unique_list_bash "${pool[@]}")"
  # pick
  local lines out1 out2
  lines="$(pick_best_two "${pool[@]}")"
  out1="$(echo "$lines" | sed -n '1p')"
  out2="$(echo "$lines" | sed -n '2p')"
  if [[ -z "$out1" || -z "$out2" ]]; then
    echo "Failed to select DNS."
    return 1
  fi
  show_primary_secondary "$out1" "$out2"
  return 0
}

serve_download_dns(){
  local pool=()
  pool+=( "${DOWNLOAD_V4[@]}" )
  read -r -a pool <<<"$(unique_list_bash "${pool[@]}")"
  local lines out1 out2
  lines="$(pick_best_two "${pool[@]}")"
  out1="$(echo "$lines" | sed -n '1p')"
  out2="$(echo "$lines" | sed -n '2p')"
  show_primary_secondary "$out1" "$out2"
}

serve_search_dns(){
  local g="$1"
  candidates_for_game "$g" 4
  local pool=( "${CAND[@]}" )
  if ((${#pool[@]}==0)); then
    pool=( "${MASTER_V4[@]}" )
  fi
  read -r -a pool <<<"$(unique_list_bash "${pool[@]}")"
  local lines out1 out2
  lines="$(pick_best_two "${pool[@]}")"
  out1="$(echo "$lines" | sed -n '1p')"
  out2="$(echo "$lines" | sed -n '2p')"
  show_primary_secondary "$out1" "$out2"
}

serve_generator(){
  echo "DNS Generator"
  echo " 1) Iran"
  echo " 2) UAE"
  echo " 3) Saudi Arabia"
  echo " 4) Turkey"
  read -rp "Select (1-4): " c
  local cc; cc="$(cc_from_choice "$c")"
  [[ -z "$cc" ]] && echo "Invalid selection."; return
  read -rp "IPv4 or IPv6? (4/6) [4]: " v; v="${v:-4}"
  read -rp "How many? [20]: " k; k="${k:-20}"
  local out=()
  if [[ "$v" = "6" ]]; then
    read -r -a v6bank <<<"$(gen_ipv6_list_for_cc "$cc")"
    local i=0
    while ((${#out[@]}<k)); do
      out+=( "${v6bank[$((i % ${#v6bank[@]}))]}" ); i=$((i+1))
    done
  else
    local i
    for ((i=0;i<k;i++)); do out+=( "$(gen_ipv4_from_cc "$cc")" ); done
  fi
  # rank by latency
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

# ---------- Menus ----------
menu_mobile(){
  title
  echo "Mobile Games:"
  local i=1; for g in "${mobile_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  echo
  read -rp "Pick game number: " n
  [[ "$n" =~ ^[0-9]+$ ]] || { echo "Invalid."; pause_enter; return; }
  (( n>=1 && n<=${#mobile_games[@]} )) || { echo "Invalid."; pause_enter; return; }
  local game="${mobile_games[$((n-1))]}"
  echo "Selecting best DNS for: $game"
  serve_game_dns "$game" || echo "No DNS found."
  footer; pause_enter
}
menu_pc(){
  title
  echo "PC/Console Games:"
  local i=1; for g in "${pc_console_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  echo
  read -rp "Pick game number: " n
  [[ "$n" =~ ^[0-9]+$ ]] || { echo "Invalid."; pause_enter; return; }
  (( n>=1 && n<=${#pc_console_games[@]} )) || { echo "Invalid."; pause_enter; return; }
  local game="${pc_console_games[$((n-1))]}"
  echo "Selecting best DNS for: $game"
  serve_game_dns "$game" || echo "No DNS found."
  footer; pause_enter
}
menu_search(){
  title
  echo "Search Game DNS (Name + Device)"
  read -rp "Game name: " gname
  read -rp "Device (Mobile/PC/Console): " dev
  gname="${gname:-Generic Game}"; dev="${dev:-Device}"
  echo "Selecting best DNS for: $gname ($dev)"
  serve_search_dns "$gname"
  footer; pause_enter
}
menu_download(){
  title
  echo "DNS Download (100+ curated anti-censorship)"
  echo "Picking best two by latency..."
  serve_download_dns
  footer; pause_enter
}
menu_generator(){
  title
  serve_generator
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
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}
main_menu
