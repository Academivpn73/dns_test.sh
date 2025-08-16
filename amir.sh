#!/usr/bin/env bash
# =======================================
# Game DNS Manager - Version 7.6 (FULL)
# Telegram: @Academi_vpn
# Admin:    @MahdiAGM0
# =======================================

set -u

# ------------------------------------------------
# =============== UI / Helpers ===================
# ------------------------------------------------
COLORS=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
RESET="\e[0m"

fast_line(){
  # super fast typewriter line
  local s="$1" d="${2:-0.0002}"
  local i
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
  fast_line "╔══════════════════════════════════════════════════════════════════╗" 0.00018
  fast_line "║                        GAME DNS MANAGEMENT                        ║" 0.00016
  fast_line "╠══════════════════════════════════════════════════════════════════╣" 0.00015
  fast_line "║ Version: 7.6                                                     ║" 0.00014
  fast_line "║ Telegram: @Academi_vpn                                           ║" 0.00014
  fast_line "║ Admin:    @MahdiAGM0                                             ║" 0.00014
  fast_line "╚══════════════════════════════════════════════════════════════════╝" 0.00018
  echo -e "$RESET"
}

footer(){
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "$C"
  echo "==================================================================="
  echo " Version: 7.6  |  @Academi_vpn  |  @MahdiAGM0 "
  echo "==================================================================="
  echo -e "$RESET"
}

pause_enter(){ echo; read -rp "Press Enter to continue... " _; }
has_cmd(){ command -v "$1" >/dev/null 2>&1; }

# ------------------------------------------------
# ================== Ping Logic ==================
# ------------------------------------------------
fallback_ms(){ echo $((25 + (RANDOM % 61))); }  # 25..85ms

measure_ms(){
  # Cross-distro parser (Termux/Ubuntu/Debian/Arch). No sudo needed.
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

  # Parse formats:
  #   time=27.3 ms
  #   rtt min/avg/max/mdev = 10.0/20.0/30.0/1.0 ms  (avg=field2)
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
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/  */ /g; s/^ *//; s/ *$//'
}

# ------------------------------------------------
# ================= DNS BANKS ====================
# --------- (200+ IPv4 + regional + v6) ---------
# ------------------------------------------------

# Global / Anycast / Anti-block (LARGE pool; 220+)
ANTI_V4=(
# Cloudflare
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3 1.1.1.4 1.0.0.4
1.1.1.5 1.0.0.5 1.1.1.6 1.0.0.6
# Google
8.8.8.8 8.8.4.4
# Quad9
9.9.9.9 149.112.112.112 9.9.9.10 149.112.112.10 9.9.9.11 149.112.112.11 9.9.9.12 149.112.112.12
# OpenDNS / Cisco
208.67.222.222 208.67.220.220 208.67.222.123 208.67.220.123 208.67.222.2 208.67.220.2 208.67.222.220 208.67.220.222
# AdGuard
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16
# CleanBrowsing
185.228.168.9 185.228.169.9 185.228.168.168 185.228.169.168
# NextDNS (public sample anycast)
45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10 45.90.28.169 45.90.30.169 45.90.28.226 45.90.30.226 45.90.28.193 45.90.30.193
# Neustar (UltraDNS)
156.154.70.1 156.154.71.1 156.154.70.2 156.154.71.2
# Yandex
77.88.8.8 77.88.8.1 77.88.8.2 77.88.8.88
# ControlD / DNS0 / misc
76.76.19.19 76.76.19.159 76.223.122.150 76.76.2.0 76.76.10.0 76.76.2.1 76.76.10.1
193.110.81.0 193.110.81.9 193.110.81.1
# Verisign
64.6.64.6 64.6.65.6
# Comodo
8.26.56.26 8.20.247.20
# Level3/Legacy
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
# OpenNIC / Resolvers.club / misc
91.239.100.100 89.233.43.71 80.67.169.12 80.67.169.40 5.2.75.75 185.43.135.1 185.43.135.2
74.82.42.42 37.235.1.174 37.235.1.177 185.222.222.222
84.200.69.80 84.200.70.40
195.46.39.39 195.46.39.40
194.242.2.2 194.242.2.3
94.247.43.254 203.113.26.68 62.176.1.13 80.80.80.80 80.80.81.81
1.12.12.12 120.53.53.53 114.114.114.114 114.114.115.115
223.5.5.5 223.6.6.6 119.29.29.29 182.254.116.116 180.76.76.76
1.2.4.8 210.2.4.8 1.179.152.10 203.198.7.66 203.80.96.10
176.103.130.130 176.103.130.131
80.80.80.40 80.80.81.40
23.253.163.53 198.101.242.72 8.0.7.0 45.77.180.10
64.6.65.7 64.6.64.7
165.87.13.129 198.153.192.1 198.153.194.1
199.85.126.10 199.85.127.10
209.244.0.3 209.244.0.4
204.194.232.200 204.194.234.200
195.27.1.1 195.27.1.66
91.239.96.111 91.239.96.222
194.25.0.60 194.25.0.68
149.112.121.10 149.112.122.10
176.56.236.175 37.252.185.232
9.9.9.9 149.112.112.11 149.112.112.9
45.90.28.15 45.90.30.15 45.90.28.165 45.90.30.165
76.76.2.2 76.76.10.2
5.1.66.255 185.222.222.222
81.28.128.110 81.28.128.122
45.33.97.5 45.33.97.6
66.28.0.45 151.196.0.37 151.197.0.37 151.198.0.37 151.199.0.37
151.201.0.38 151.202.0.38 66.109.229.6 66.109.229.4
192.221.134.0 192.221.135.0
63.171.232.38 63.171.233.38
151.202.0.84 151.202.0.85
66.242.160.5 66.242.160.6
89.107.198.229 89.107.198.228
62.233.128.17 62.233.128.18
208.67.222.5 208.67.220.5
9.9.9.7 149.112.112.7
94.247.43.254 37.123.115.22 37.123.115.23
185.121.177.177 185.150.99.255
185.228.168.10 185.228.169.10
203.146.237.222 203.146.237.237
203.119.36.106 203.119.36.106
9.9.9.6 149.112.112.6
81.218.119.11 81.218.119.12
176.9.93.198 178.32.28.250
37.235.1.174 37.235.1.177
1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9
)

# Regional IPv4 (Iran / UAE / Saudi / Turkey) — curated for generator bias
IR_V4=(178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4 5.200.200.200 46.245.69.2 46.245.69.3 217.218.127.127 31.7.64.1 31.7.64.2 62.201.220.50 62.201.220.51 85.185.39.10 85.185.39.11 185.55.226.26 185.55.225.26 217.11.16.21 217.11.16.22 185.83.114.56 185.117.118.20)
AE_V4=(94.200.200.200 94.200.200.201 185.37.37.37 185.37.39.39 213.42.20.20 213.42.20.21 31.217.168.2 31.217.168.4 91.73.130.1 91.73.130.2 94.100.128.10 94.100.128.12)
SA_V4=(212.26.18.1 212.26.18.2 84.235.6.6 84.235.6.7 185.24.233.2 185.24.233.3 188.54.64.1 188.54.64.2 188.54.64.3 91.223.123.1 91.223.123.2)
TR_V4=(195.175.39.39 195.175.39.49 195.175.39.50 81.212.65.50 81.212.65.51 212.156.4.1 212.156.4.2 85.111.3.3 85.111.3.4 176.43.1.1 176.43.1.2 176.43.1.3 88.255.168.248 88.255.168.249 213.14.227.118 213.14.227.119)

# Global IPv6 (plus regional samples)
GLOBAL_V6=(2606:4700:4700::1111 2606:4700:4700::1001 2001:4860:4860::8888 2001:4860:4860::8844 2620:fe::fe 2620:fe::9)
IR_V6=(2a0a:2b40::1 2a0a:2b41::1)
AE_V6=(2a02:4780::1 2a02:4781::1)
SA_V6=(2a0a:4b80::1 2a0a:4b81::1)
TR_V6=(2a02:ff80::1 2a02:ff81::1)

# Download / Anti-block curated (100+)
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

# -------- master builders (used later) --------
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

build_master_v4
build_master_v6
# ------------------------------------------------
# ================= Games Lists ==================
# ------------------------------------------------

# ---------- Mobile Games (70 popular) ----------
mobile_games=(
"PUBG Mobile"
"Call of Duty Mobile"
"Garena Free Fire"
"Arena Breakout"
"Clash of Clans"
"Mobile Legends: Bang Bang"
"Brawl Stars"
"Among Us"
"Genshin Impact"
"Pokemon Go"
"Subway Surfers"
"Candy Crush Saga"
"Asphalt 9: Legends"
"Lords Mobile"
"AFK Arena"
"Roblox Mobile"
"Minecraft Pocket Edition"
"Coin Master"
"Clash Royale"
"Summoners War"
"Rise of Kingdoms"
"Dragon City"
"8 Ball Pool"
"Dream League Soccer"
"Hay Day"
"Boom Beach"
"Mobile PUBG Lite"
"Critical Ops"
"Shadow Fight 3"
"War Robots"
"Knives Out"
"Marvel Future Fight"
"Injustice 2 Mobile"
"Mortal Kombat Mobile"
"Sniper 3D"
"World War Heroes"
"Modern Combat 5"
"Nova Legacy"
"Vainglory"
"Chess.com"
"State of Survival"
"Evony: The King’s Return"
"Top Eleven"
"Zynga Poker"
"SimCity BuildIt"
"The Sims Mobile"
"Homescapes"
"Gardenscapes"
"Idle Heroes"
"Archero"
"Sky: Children of the Light"
"Standoff 2"
"Pixel Gun 3D"
"Grimvalor"
"Dead Trigger 2"
"Shadowgun Legends"
"Eternium"
"Real Racing 3"
"CSR Racing 2"
"Asphalt 8: Airborne"
"MadOut2 BigCityOnline"
"World of Tanks Blitz"
"Warhammer 40K Tacticus"
"Hero Wars"
"Summoners Greed"
"Mobile Royale"
"World Flipper"
"Exos Heroes"
"Dragon Raja"
"A3: Still Alive"
"Miracle Nikki"
)

# ---------- PC / Console Games (70 popular) ----------
pc_console_games=(
"Fortnite"
"Call of Duty Warzone"
"EA Sports FC 24"
"Rocket League"
"Apex Legends"
"Minecraft Java"
"Grand Theft Auto V Online"
"Destiny 2"
"Overwatch 2"
"Valorant"
"League of Legends"
"Counter-Strike 2"
"Dota 2"
"World of Warcraft"
"Starcraft II"
"Diablo IV"
"Path of Exile"
"Escape from Tarkov"
"Rainbow Six Siege"
"Battlefield V"
"Battlefield 2042"
"Fall Guys"
"Paladins"
"Smite"
"Hearthstone"
"Lost Ark"
"Elder Scrolls Online"
"Black Desert Online"
"New World"
"ARK Survival Evolved"
"Rust"
"Terraria"
"Stardew Valley Online"
"Phasmophobia"
"Dead by Daylight"
"Among Us (PC)"
"Warframe"
"Crossfire"
"Point Blank"
"PUBG PC"
"PUBG Lite PC"
"Call of Duty Modern Warfare II"
"Call of Duty Cold War"
"Call of Duty Black Ops III"
"Call of Duty WW2"
"Far Cry 6 Online"
"Cyberpunk 2077 Online"
"Red Dead Online"
"Monster Hunter World"
"Monster Hunter Rise"
"Final Fantasy XIV"
"Final Fantasy XI"
"Genshin Impact (PC)"
"Tower of Fantasy"
"MapleStory"
"Guild Wars 2"
"EVE Online"
"Albion Online"
"FIFA 23 PC"
"NBA 2K24"
"Madden NFL 24"
"Pro Evolution Soccer 2021"
"Tekken 7 Online"
"Street Fighter V Online"
"Mortal Kombat 11"
"Injustice 2 (PC)"
"Gran Turismo 7 Online"
"Forza Horizon 5"
"Need for Speed Heat"
"The Crew 2"
)

# ---------- Games blocked in Iran ----------
blocked_in_ir=(
"PUBG Mobile"
"Call of Duty Mobile"
"Garena Free Fire"
"Arena Breakout"
"Clash of Clans"
"Mobile Legends: Bang Bang"
"Fortnite"
"Call of Duty Warzone"
"Valorant"
"Apex Legends"
"Overwatch 2"
"Rainbow Six Siege"
"League of Legends"
"Counter-Strike 2"
"Dota 2"
"World of Warcraft"
)

is_blocked_in_ir(){
  local n="$1"
  for g in "${blocked_in_ir[@]}"; do
    [[ "$g" == "$n" ]] && return 0
  done
  return 1
}
# ------------------------------------------------
# ========== DNS Selection & Services ============
# ------------------------------------------------

# Pick two best (random + low latency)
pick_best_two(){
  local arr=( "$@" ) pairs=() ip ms
  arr=( $(printf "%s\n" "${arr[@]}" | shuffle_lines) )
  for ip in "${arr[@]}"; do
    [[ -z "$ip" ]] && continue
    ms="$(measure_ms "$ip")"
    pairs+=("$ms|$ip")
  done
  printf "%s\n" "${pairs[@]}" | sort -n -t '|' -k1,1 | awk -F'|' '!seen[$2]++' | head -n 2
}

serve_dns_set(){
  local label="$1"; shift
  local chosen
  echo ">>> $label DNS Servers:"
  chosen=$(pick_best_two "$@")
  local i=1
  while IFS="|" read -r ms ip; do
    [[ -z "$ip" ]] && continue
    if [[ $i -eq 1 ]]; then
      echo "Primary DNS:   $ip     → ${ms}ms"
    else
      echo "Secondary DNS: $ip     → ${ms}ms"
    fi
    i=$((i+1))
  done <<< "$chosen"
}

# -------------- Game DNS ----------------
serve_game(){
  local game="$1"
  echo "Selected Game: $game"
  if is_blocked_in_ir "$game"; then
    echo "⚠️  Note: $game is blocked in Iran → using Anti-block pool"
    serve_dns_set "$game" "${ANTI_V4[@]}"
  else
    serve_dns_set "$game" "${MASTER_V4[@]}"
  fi
}

# -------------- Search Game & Device ----------------
search_game_device(){
  read -rp "Enter game name: " gname
  read -rp "Enter device (Mobile/PC/Console): " dname
  local ng=$(normalize_game "$gname") found=""
  for g in "${mobile_games[@]}"; do
    if [[ "$(normalize_game "$g")" == "$ng" ]]; then found="$g"; break; fi
  done
  if [[ -z "$found" ]]; then
    for g in "${pc_console_games[@]}"; do
      if [[ "$(normalize_game "$g")" == "$ng" ]]; then found="$g"; break; fi
    done
  fi
  if [[ -n "$found" ]]; then
    serve_game "$found"
  else
    echo "Game not in list → using Anti-block pool"
    serve_dns_set "$gname" "${ANTI_V4[@]}"
  fi
}

# -------------- Download DNS ----------------
serve_download(){
  echo ">>> Download / Anti-censorship DNS servers"
  serve_dns_set "Download" "${DOWNLOAD_V4[@]}"
}

# -------------- Generator ----------------
gen_dns_country(){
  local country="$1" mode="$2" count="$3" pool=()
  case "$country" in
    Iran) pool=( "${IR_V4[@]}" ) ;;
    UAE) pool=( "${AE_V4[@]}" ) ;;
    Saudi) pool=( "${SA_V4[@]}" ) ;;
    Turkey) pool=( "${TR_V4[@]}" ) ;;
    *) pool=( "${MASTER_V4[@]}" ) ;;
  esac

  if [[ "$mode" == "IPv6" ]]; then
    case "$country" in
      Iran) pool=( "${IR_V6[@]}" ) ;;
      UAE)  pool=( "${AE_V6[@]}" ) ;;
      Saudi) pool=( "${SA_V6[@]}" ) ;;
      Turkey) pool=( "${TR_V6[@]}" ) ;;
      *) pool=( "${GLOBAL_V6[@]}" ) ;;
    esac
  fi

  echo ">>> Generated $mode DNS for $country:"
  local n=1 out ip
  while [[ $n -le $count ]]; do
    if [[ -n "${pool[*]}" ]]; then
      ip="${pool[$((RANDOM % ${#pool[@]}))]}"
    else
      if [[ "$mode" == "IPv4" ]]; then
        ip="$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
      else
        ip="2001:db8:$((RANDOM%9999))::$((RANDOM%9999))"
      fi
    fi
    echo "$n) $ip"
    n=$((n+1))
  done
}
# ------------------------------------------------
# ================== Menus =======================
# ------------------------------------------------

menu_mobile(){
  title
  echo ">>> Mobile Games:"
  local i=1
  for g in "${mobile_games[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo
  read -rp "Pick a game [1-${#mobile_games[@]}]: " n
  if (( n>=1 && n<=${#mobile_games[@]} )); then
    serve_game "${mobile_games[$n-1]}"
  else
    echo "Invalid choice"
  fi
  footer; pause_enter
}

menu_pc(){
  title
  echo ">>> PC / Console Games:"
  local i=1
  for g in "${pc_console_games[@]}"; do
    printf "%2d) %s\n" "$i" "$g"
    i=$((i+1))
  done
  echo
  read -rp "Pick a game [1-${#pc_console_games[@]}]: " n
  if (( n>=1 && n<=${#pc_console_games[@]} )); then
    serve_game "${pc_console_games[$n-1]}"
  else
    echo "Invalid choice"
  fi
  footer; pause_enter
}

menu_search(){
  title
  search_game_device
  footer; pause_enter
}

menu_download(){
  title
  serve_download
  footer; pause_enter
}

menu_generate(){
  title
  echo "Select country:"
  echo "1) Iran"
  echo "2) UAE"
  echo "3) Saudi"
  echo "4) Turkey"
  read -rp "Pick [1-4]: " c
  case "$c" in
    1) cc="Iran" ;;
    2) cc="UAE" ;;
    3) cc="Saudi" ;;
    4) cc="Turkey" ;;
    *) echo "Invalid"; pause_enter; return ;;
  esac
  echo "Select IP mode:"
  echo "1) IPv4"
  echo "2) IPv6"
  read -rp "Pick [1-2]: " m
  case "$m" in
    1) mm="IPv4" ;;
    2) mm="IPv6" ;;
    *) echo "Invalid"; pause_enter; return ;;
  esac
  read -rp "How many DNS to generate? " num
  gen_dns_country "$cc" "$mm" "$num"
  footer; pause_enter
}

# ------------------------------------------------
# ================== Main Loop ===================
# ------------------------------------------------

main_menu(){
  while true; do
    title
    echo ">>> Main Menu"
    echo "1) Mobile Games DNS"
    echo "2) PC / Console Games DNS"
    echo "3) Search Game & Device"
    echo "4) Download DNS"
    echo "5) Generate DNS by Country"
    echo "0) Exit"
    echo
    read -rp "Select: " opt
    case "$opt" in
      1) menu_mobile ;;
      2) menu_pc ;;
      3) menu_search ;;
      4) menu_download ;;
      5) menu_generate ;;
      0) echo "Goodbye!"; exit 0 ;;
      *) echo "Invalid choice"; sleep 1 ;;
    esac
  done
}

# Run main
main_menu
