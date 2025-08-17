#!/usr/bin/env bash
# =======================================
# Game DNS Manager - Version 6.0.0
# Telegram: @Academi_vpn
# Admin: @MahdiAGM0
# =======================================

set -euo pipefail

# ---------- Colors & Fast Title ----------
colors=(31 32 33 34 35 36)
color_index=0

fast_title() {
  local text="=== Game DNS Manager ==="
  echo -ne "\n"
  for ((i=0; i<${#text}; i++)); do
    local color=${colors[$color_index]}
    printf "\e[%sm%s\e[0m" "$color" "${text:$i:1}"
    color_index=$(( (color_index + 1) % ${#colors[@]} ))
    usleep 18000   # ~0.018s per char (سریع‌تر از قبل)
  done
  echo -e "\n"
}

print_footer() {
  local color=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -e "\e[${color}m"
  echo "========================================"
  echo " Version: 6.0.0 | Telegram: @Academi_vpn"
  echo " Admin: @MahdiAGM0"
  echo "========================================"
  echo -e "\e[0m"
}

pause() { read -rp "Press Enter to continue..."; }

# ---------- Dependency Check (no sudo) ----------
need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# we won't use sudo. just best-effort suggestions if missing.
ensure_tools() {
  local missing=()
  need_cmd ping      || missing+=("ping")
  need_cmd timeout   || missing+=("timeout")
  need_cmd awk       || missing+=("awk")
  need_cmd sed       || missing+=("sed")
  need_cmd tr        || missing+=("tr")
  need_cmd head      || missing+=("head")
  need_cmd shuf      || missing+=("shuf")
  if ((${#missing[@]})); then
    echo "[!] Missing tools: ${missing[*]}"
    echo "    Please install them. On Termux:"
    echo "      pkg install iputils coreutils procps"
    echo "    On Debian/Ubuntu:"
    echo "      apt-get install iputils-ping coreutils"
    echo "Continuing anyway with fallbacks..."
  fi
}

# ---------- RTT Measurement ----------
# Try ICMP ping (1 probe, short timeout). If not available/blocked, try TCP to port 53.
rtt_ms() {
  local ip="$1" out ms
  if need_cmd ping; then
    # Linux ping: -c 1 (1 packet), -w 1 (deadline 1s), -n numeric
    out=$(ping -c 1 -w 1 -n "$ip" 2>/dev/null || true)
    ms=$(echo "$out" | awk -F'time=' '/time=/{print $2}' | awk '{print $1}')
    if [[ -n "${ms:-}" ]]; then
      echo "$ms"
      return 0
    fi
  fi
  # Fallback TCP connect time to 53 using bash's /dev/tcp (coarse)
  # Try to measure time roughly:
  local start end delta
  start=$(date +%s%3N 2>/dev/null || date +%s)
  # try 200ms timeout using timeout if present
  if need_cmd timeout; then
    (echo > /dev/tcp/"$ip"/53) >/dev/null 2>&1 || true | timeout 0.2 cat >/dev/null 2>&1 || true
  else
    (echo > /dev/tcp/"$ip"/53) >/dev/null 2>&1 || true
  fi
  end=$(date +%s%3N 2>/dev/null || date +%s)
  delta=$((end-start))
  # if delta is huge, treat as timeout
  if (( delta <= 0 || delta > 2000 )); then
    echo "timeout"
  else
    echo "$delta"
  fi
}

# Pretty print pair with RTT and numbering
print_dns_pair() {
  local p="$1" s="$2"
  local rp rs
  rp=$(rtt_ms "$p"); rs=$(rtt_ms "$s")
  printf "Primary DNS:   %-15s → %s ms\n" "$p" "${rp:-timeout}"
  printf "Secondary DNS: %-15s → %s ms\n" "$s" "${rs:-timeout}"
}

# helper to uniquify and shuffle an array, return n items
# usage: best_n_from_array "arrayname" N
best_n_from_array() {
  local arr_name="$1" want="$2"
  local -n _arr="$arr_name"
  # shuffle first to randomize
  if need_cmd shuf; then
    mapfile -t _sh < <(printf "%s\n" "${_arr[@]}" | awk 'NF' | sort -u | shuf)
  else
    mapfile -t _sh < <(printf "%s\n" "${_arr[@]}" | awk 'NF' | sort -u)
  fi
  local picked=()
  local i=0
  for ip in "${_sh[@]}"; do
    picked+=("$ip")
    ((++i >= want)) && break
  done
  printf "%s\n" "${picked[@]}"
}
# ---------- Country Bank Builders (300+ each) ----------
IR_V4=()
SA_V4=()
TR_V4=()
AE_V4=()

# add_range "ARRAY_NAME" "A.B.C.D" "A.B.C.D" "hostlist"
# hostlist default: "10 11 12 13"
add_range() {
  local arr="$1" start="$2" stop="$3" hosts="${4:-"10 11 12 13"}"
  local -n _dst="$arr"
  # iterate last octet block or third octet block depending on inputs
  # Expect ranges like 5.52.0.0 to 5.52.15.255 (we'll vary 3rd octet 0..x)
  local a b c d
  IFS='.' read -r a b c d <<<"$start"
  local a2 b2 c2 d2
  IFS='.' read -r a2 b2 c2 d2 <<<"$stop"

  # only support same A.B and c from c..c2
  if [[ "$a.$b" != "$a2.$b2" ]]; then return; fi
  local ccur
  for ((ccur=c; ccur<=c2; ccur++)); do
    for h in $hosts; do
      _dst+=( "$a.$b.$ccur.$h" )
    done
  done
}

# ---- Iran common prefixes ----
# (MCI/MTN/Rightel/Asiatech/FCPs; real-world-ish ranges)
build_ir() {
  add_range IR_V4 "5.52.0.0"   "5.52.15.0"
  add_range IR_V4 "5.106.0.0"  "5.106.15.0"
  add_range IR_V4 "37.156.0.0" "37.156.31.0"
  add_range IR_V4 "37.255.0.0" "37.255.15.0"
  add_range IR_V4 "79.132.0.0" "79.132.15.0"
  add_range IR_V4 "78.38.0.0"  "78.38.15.0"
  add_range IR_V4 "81.12.0.0"  "81.12.15.0"
  add_range IR_V4 "188.212.0.0" "188.212.15.0"
  add_range IR_V4 "188.215.0.0" "188.215.15.0"
}

# ---- Saudi Arabia prefixes ----
build_sa() {
  add_range SA_V4 "85.194.0.0"  "85.194.31.0"
  add_range SA_V4 "95.210.0.0"  "95.210.31.0"
  add_range SA_V4 "188.54.64.0" "188.54.67.0"
  add_range SA_V4 "188.55.128.0" "188.55.131.0"
  add_range SA_V4 "188.60.0.0"   "188.60.3.0"
  add_range SA_V4 "188.61.64.0"  "188.61.67.0"
  add_range SA_V4 "188.62.128.0" "188.62.131.0"
  add_range SA_V4 "188.65.192.0" "188.65.195.0"
  add_range SA_V4 "188.72.64.0"  "188.72.67.0"
  add_range SA_V4 "188.73.128.0" "188.73.131.0"
  add_range SA_V4 "188.74.0.0"   "188.74.3.0"
  add_range SA_V4 "188.75.64.0"  "188.75.67.0"
  add_range SA_V4 "188.76.128.0" "188.76.131.0"
}

# ---- Turkey prefixes ----
build_tr() {
  add_range TR_V4 "85.99.0.0"   "85.99.3.0"
  add_range TR_V4 "88.255.0.0"  "88.255.3.0"
  add_range TR_V4 "95.0.0.0"    "95.0.3.0"
  add_range TR_V4 "95.6.0.0"    "95.6.3.0"
  add_range TR_V4 "95.70.0.0"   "95.70.3.0"
  add_range TR_V4 "176.33.0.0"  "176.33.3.0"
  add_range TR_V4 "176.40.0.0"  "176.40.3.0"
  add_range TR_V4 "176.41.0.0"  "176.41.3.0"
  add_range TR_V4 "176.42.0.0"  "176.42.3.0"
  add_range TR_V4 "176.43.64.0" "176.43.67.0"
  add_range TR_V4 "176.216.0.0" "176.216.3.0"
  add_range TR_V4 "176.217.0.0" "176.217.3.0"
  add_range TR_V4 "176.218.0.0" "176.218.3.0"
  add_range TR_V4 "176.219.64.0" "176.219.67.0"
  add_range TR_V4 "176.220.128.0" "176.220.131.0"
  add_range TR_V4 "176.221.0.0"   "176.221.3.0"
  add_range TR_V4 "176.222.64.0"  "176.222.67.0"
  add_range TR_V4 "176.223.0.0"   "176.223.3.0"
  add_range TR_V4 "85.96.0.0"     "85.96.3.0"
}

# ---- UAE prefixes ----
build_ae() {
  add_range AE_V4 "2.49.0.0"    "2.49.15.0"     # etisalat
  add_range AE_V4 "5.36.0.0"    "5.36.31.0"
  add_range AE_V4 "5.38.0.0"    "5.38.31.0"
  add_range AE_V4 "86.96.0.0"   "86.96.31.0"
  add_range AE_V4 "86.98.0.0"   "86.98.31.0"
  add_range AE_V4 "94.200.0.0"  "94.200.31.0"   # du/etisalat blocks
  add_range AE_V4 "94.204.0.0"  "94.204.31.0"
  add_range AE_V4 "185.54.0.0"  "185.54.15.0"
  add_range AE_V4 "217.165.0.0" "217.165.15.0"
}

# Build all
build_banks() {
  build_ir; build_sa; build_tr; build_ae
  # Unique-ify (safety)
  IR_V4=($(printf "%s\n" "${IR_V4[@]}" | awk 'NF' | sort -u))
  SA_V4=($(printf "%s\n" "${SA_V4[@]}" | awk 'NF' | sort -u))
  TR_V4=($(printf "%s\n" "${TR_V4[@]}" | awk 'NF' | sort -u))
  AE_V4=($(printf "%s\n" "${AE_V4[@]}" | awk 'NF' | sort -u))
}# ---------- Games ----------
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Arena Breakout" "Clash of Clans"
"Mobile Legends" "Brawl Stars" "Among Us" "Genshin Impact" "Pokemon Go"
"Subway Surfers" "Candy Crush Saga" "Asphalt 9" "Lords Mobile" "AFK Arena"
"Roblox" "Minecraft PE" "Coin Master" "Clash Royale" "Summoners War"
"League of Legends: Wild Rift" "Apex Legends Mobile" "Fortnite Mobile" "Valorant Mobile (beta)"
"Diablo Immortal" "Honkai: Star Rail" "Rise of Kingdoms" "Marvel Snap" "FIFA Mobile"
"eFootball 2024" "NBA Live Mobile" "PUBG: New State" "Call of Dragons" "Naruto Slugfest"
"Dragon Ball Legends" "Bleach Brave Souls" "One Piece Bounty Rush" "Legends of Runeterra"
"ARK Mobile" "War Robots" "World of Tanks Blitz" "Shadowgun Legends" "Critical Ops"
"Modern Combat" "Dead by Daylight Mobile" "Identity V" "Ni no Kuni: Cross Worlds"
"Black Desert Mobile" "Lineage 2M" "Ragnarok M" "MapleStory M" "Tower of Fantasy"
"Albion Online Mobile" "RuneScape Mobile" "Old School RuneScape" "TERA Classic"
"Lost Light" "CarX Drift Racing 2" "Real Racing 3" "CSR Racing 2" "Need for Speed No Limits"
"Asphalt 8" "Clash Mini" "Clash Quest" "Boom Beach" "Hay Day"
"Fishdom" "Gardenscapes" "Homescapes" "EVE Echoes" "Standoff 2"
)

pc_console_games=(
"Valorant" "Counter-Strike 2" "Dota 2" "League of Legends" "Overwatch 2"
"Apex Legends" "PUBG PC" "Call of Duty Warzone" "Fortnite" "Rainbow Six Siege"
"Rocket League" "FIFA 24" "eFootball PC" "PES 2021" "EA FC Online"
"Path of Exile" "Diablo IV" "Lost Ark" "Elden Ring" "Naruto Storm Connections"
"GTA Online" "RDR2 Online" "Forza Horizon 5" "Gran Turismo 7" "The Crew Motorfest"
"WRC" "iRacing" "Assetto Corsa" "ACC" "Need for Speed Heat"
"Battlefield 2042" "Halo Infinite" "Destiny 2" "Splitgate" "Paladins"
"Smite" "Warframe" "World of Warcraft" "FFXIV" "Elder Scrolls Online"
"Star Wars Battlefront II" "The Division 2" "Ghost Recon Breakpoint"
"Monster Hunter World" "Ark: Survival Evolved" "DayZ" "Rust" "Escape from Tarkov"
"Sea of Thieves" "New World" "Black Desert Online" "Albion Online" "RuneScape"
"MapleStory" "Ragnarok Online" "Metin2" "CrossFire" "Point Blank"
"Valorant PBE" "CS2 Faceit" "Dota 2 SEA" "LoL EUW" "LoL EUNE"
"LoL TR" "LoL MENA" "Overwatch PTR" "Warzone Mobile Test" "XDefiant"
)

# Map each game to a preferred country pool (for latency/regional compatibility)
declare -A game_country_pref
for g in "${mobile_games[@]}"; do game_country_pref["$g"]="IR SA TR AE"; done
for g in "${pc_console_games[@]}"; do game_country_pref["$g"]="IR SA TR AE"; done
# You can specialize e.g.:
game_country_pref["Valorant"]="TR AE IR SA"
game_country_pref["League of Legends"]="TR AE IR SA"
game_country_pref["PUBG PC"]="IR TR AE SA"
game_country_pref["Fortnite"]="AE TR IR SA"
# Pick best 2 DNS for a given game from its preferred country pools
serve_game_dns() {
  local game="$1"
  local pref="${game_country_pref[$game]:-IR SA TR AE}"

  # Collect candidates from preferred countries (limit to avoid huge pings)
  local pool=()
  for c in $pref; do
    case "$c" in
      IR) pool+=( $(best_n_from_array IR_V4 200) );;
      SA) pool+=( $(best_n_from_array SA_V4 200) );;
      TR) pool+=( $(best_n_from_array TR_V4 200) );;
      AE) pool+=( $(best_n_from_array AE_V4 200) );;
    esac
  done

  # Measure RTT for a subset (e.g., 40) to keep speed OK
  local candidates=()
  local n=0
  for ip in "${pool[@]}"; do
    candidates+=("$ip")
    ((++n >= 40)) && break
  done

  # Score: collect (ms, ip), sort, pick top 2
  local scored=()
  for ip in "${candidates[@]}"; do
    local r=$(rtt_ms "$ip")
    [[ "$r" == "timeout" || -z "$r" ]] && continue
    # keep only plausible values
    if [[ "$r" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
      scored+=( "$(printf "%07.2f %s" "$r" "$ip")" )
    fi
  done

  if ((${#scored[@]}==0)); then
    echo "[!] Could not find responsive DNS right now. Trying generic anycast..."
    print_dns_pair "1.1.1.1" "8.8.8.8"
    return
  fi

  IFS=$'\n' scored_sorted=($(printf "%s\n" "${scored[@]}" | sort))
  local best="${scored_sorted[0]#* }"
  local second="${scored_sorted[1]#* }"
  # If only 1 available, fallback
  if ((${#scored_sorted[@]}<2)); then
    second="8.8.4.4"
  fi

  print_dns_pair "$best" "$second"
}
menu_list() {
  local -n arr="$1"
  local title="$2"
  while true; do
    clear; fast_title
    echo "*** $title ***"
    local i=1
    for g in "${arr[@]}"; do printf "%2d) %s\n" "$i" "$g"; ((i++)); done
    echo " 0) Back"
    read -rp "Pick: " n
    [[ "$n" == "0" ]] && return
    if (( n>=1 && n<=${#arr[@]} )); then
      local game="${arr[$((n-1))]}"
      echo "Game: $game"
      serve_game_dns "$game"
      print_footer; pause
    fi
  done
}

menu_search() {
  while true; do
    clear; fast_title
    echo "*** Search Game + Device ***"
    echo "Enter game name (or '0' to back):"
    read -r q
    [[ "$q" == "0" ]] && return
    echo "Enter device (PC/Console/Mobile):"
    read -r dev
    # Try exact in lists; else fallback pools by device
    local found=""
    for g in "${mobile_games[@]}"; do [[ "$g" == "$q" ]] && found="$g" && break; done
    if [[ -z "$found" ]]; then
      for g in "${pc_console_games[@]}"; do [[ "$g" == "$q" ]] && found="$g" && break; done
    fi
    if [[ -n "$found" ]]; then
      echo "Matched: $found ($dev)"
      serve_game_dns "$found"
    else
      echo "Not predefined. Picking best from suitable pools..."
      case "${dev,,}" in
        pc|console)
          # prefer TR/AE for many PC shooters; adjust if you want
          game_country_pref["$q"]="TR AE IR SA"
          ;;
        mobile|android|ios)
          game_country_pref["$q"]="IR SA TR AE"
          ;;
        *)
          game_country_pref["$q"]="IR SA TR AE"
          ;;
      esac
      serve_game_dns "$q"
    fi
    print_footer; pause
  done
}
# Country-specific random IPv4 generator within plausible ISP ranges
rand_ipv4_ir() { # Iran
  case $((RANDOM%6)) in
    0) echo "5.$((52+RANDOM%60)).$((RANDOM%32)).$((RANDOM%254))";;
    1) echo "37.$((156+RANDOM%100)).$((RANDOM%64)).$((RANDOM%254))";;
    2) echo "78.$((36+RANDOM%4)).$((RANDOM%64)).$((RANDOM%254))";;
    3) echo "79.$((132+RANDOM%8)).$((RANDOM%64)).$((RANDOM%254))";;
    4) echo "81.$((10+RANDOM%6)).$((RANDOM%64)).$((RANDOM%254))";;
    5) echo "188.$((212+RANDOM%8)).$((RANDOM%64)).$((RANDOM%254))";;
  esac
}

rand_ipv4_sa() { # Saudi
  case $((RANDOM%6)) in
    0) echo "85.$((194+RANDOM%2)).$((RANDOM%64)).$((RANDOM%254))";;
    1) echo "95.$((210+RANDOM%2)).$((RANDOM%64)).$((RANDOM%254))";;
    2) echo "188.$((54+RANDOM%2)).$((64+RANDOM%4)).$((RANDOM%254))";;
    3) echo "188.$((55+RANDOM%1)).$((128+RANDOM%4)).$((RANDOM%254))";;
    4) echo "188.$((60+RANDOM%2)).$((RANDOM%64)).$((RANDOM%254))";;
    5) echo "188.$((61+RANDOM%2)).$((64+RANDOM%4)).$((RANDOM%254))";;
  esac
}

rand_ipv4_tr() { # Turkey
  case $((RANDOM%8)) in
    0) echo "85.$((96+RANDOM%4)).$((RANDOM%64)).$((RANDOM%254))";;
    1) echo "85.$((99)).$((RANDOM%64)).$((RANDOM%254))";;
    2) echo "88.$((255)).$((RANDOM%64)).$((RANDOM%254))";;
    3) echo "95.$((0+RANDOM%8)).$((RANDOM%64)).$((RANDOM%254))";;
    4) echo "176.$((33+RANDOM%12)).$((RANDOM%64)).$((RANDOM%254))";;
    5) echo "176.$((40+RANDOM%4)).$((RANDOM%64)).$((RANDOM%254))";;
    6) echo "176.$((216+RANDOM%8)).$((RANDOM%64)).$((RANDOM%254))";;
    7) echo "176.$((220+RANDOM%4)).$((RANDOM%64)).$((RANDOM%254))";;
  esac
}

rand_ipv4_ae() { # UAE
  case $((RANDOM%8)) in
    0) echo "2.$((49)).$((RANDOM%64)).$((RANDOM%254))";;
    1) echo "5.$((36+RANDOM%4)).$((RANDOM%64)).$((RANDOM%254))";;
    2) echo "86.$((96+RANDOM%4)).$((RANDOM%64)).$((RANDOM%254))";;
    3) echo "86.$((98+RANDOM%4)).$((RANDOM%64)).$((RANDOM%254))";;
    4) echo "94.$((200+RANDOM%8)).$((RANDOM%64)).$((RANDOM%254))";;
    5) echo "185.$((54)).$((RANDOM%16)).$((RANDOM%254))";;
    6) echo "217.$((165)).$((RANDOM%16)).$((RANDOM%254))";;
    7) echo "94.$((204+RANDOM%8)).$((RANDOM%64)).$((RANDOM%254))";;
  esac
}

# Random IPv6 realistic-looking generators (not guaranteed resolvers; variety hextets)
hex4() { printf "%x" "$((RANDOM%65536))"; }
rand_ipv6_pref() {
  local country="$1"
  case "$country" in
    IR) echo "2a0a:$(hex4):$(hex4):$(hex4)";;   # sample regional allocations
    SA) echo "2a02:$(hex4):$(hex4):$(hex4)";;
    TR) echo "2a03:$(hex4):$(hex4):$(hex4)";;
    AE) echo "2a01:$(hex4):$(hex4):$(hex4)";;
  esac
}

rand_ipv6() {
  local pre="$1"
  printf "%s:%s:%s:%s:%s\n" \
    "$pre" "$(hex4)" "$(hex4)" "$(hex4)" "$(hex4)"
}

generate_dns_menu() {
  while true; do
    clear; fast_title
    echo "*** Generate DNS ***"
    echo "1) Iran"
    echo "2) Saudi Arabia"
    echo "3) Turkey"
    echo "4) UAE"
    echo "0) Back"
    read -rp "Choose country: " c
    [[ "$c" == "0" ]] && return
    echo "IP Version: 1) IPv4  2) IPv6"
    read -rp "Choose: " v
    read -rp "How many (e.g., 5): " k
    [[ -z "${k:-}" ]] && k=5
    echo "---------------------------------"
    echo " Generated DNS:"
    echo "---------------------------------"

    case "$v" in
      1)
        for ((i=1;i<=k;i++)); do
          case "$c" in
            1) ip=$(rand_ipv4_ir);;
            2) ip=$(rand_ipv4_sa);;
            3) ip=$(rand_ipv4_tr);;
            4) ip=$(rand_ipv4_ae);;
            *) ip="1.1.1.1";;
          esac
          printf "%2d) %s  → %s ms\n" "$i" "$ip" "$(rtt_ms "$ip")"
        done
        ;;
      2)
        case "$c" in
          1) pre=$(rand_ipv6_pref IR);;
          2) pre=$(rand_ipv6_pref SA);;
          3) pre=$(rand_ipv6_pref TR);;
          4) pre=$(rand_ipv6_pref AE);;
          *) pre=$(rand_ipv6_pref IR);;
        esac
        for ((i=1;i<=k;i++)); do
          ip=$(rand_ipv6 "$pre")
          printf "%2d) %s  → %s ms\n" "$i" "$ip" "$(rtt_ms "$ip")"
        done
        ;;
      *)
        echo "Invalid."
        ;;
    esac
    print_footer; pause
  done
}
# ---------- Download DNS (100 curated anycast/public) ----------
DOWNLOAD_V4=(
1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112
208.67.222.222 208.67.220.220 94.140.14.14 94.140.15.15
76.76.2.0 76.76.10.0 156.154.70.1 156.154.71.1 64.6.64.6
64.6.65.6 185.228.168.9 185.228.169.9 45.90.28.0 45.90.30.0
1.1.1.2 1.0.0.2 8.26.56.26 8.20.247.20 84.200.69.80 84.200.70.40
208.67.222.123 208.67.220.123 64.6.65.5 64.6.64.6 77.88.8.8
77.88.8.1 77.88.8.2 77.88.8.7 194.242.2.2 90.83.182.1
80.67.169.12 80.67.169.40 193.110.81.0 176.103.130.130 176.103.130.131
185.228.168.168 185.228.169.168 9.9.9.10 149.112.112.10 9.9.9.11
149.112.112.11 9.9.9.12 149.112.112.12 76.223.122.150 205.251.198.30
205.251.199.30 205.251.194.30 205.251.195.30 45.11.45.11 45.11.45.12
208.76.50.50 208.76.51.51 74.82.42.42 94.247.43.254 185.117.118.20
94.130.180.225 95.85.95.85 176.103.130.134 176.103.130.136 176.103.130.137
193.17.47.1 185.95.218.42 80.80.80.80 80.80.81.81 8.8.8.1
1.1.1.3 1.0.0.3 208.67.220.222 208.67.222.220 9.9.9.9
185.222.222.222 185.121.177.177 45.11.45.5 45.11.45.6 76.76.19.19
76.76.2.38 76.76.10.5 76.76.10.4 194.146.106.46 172.64.36.0
172.64.36.1 172.64.36.2 172.64.36.3 172.64.36.4 172.64.36.5
172.64.36.6 172.64.36.7 172.64.36.8 172.64.36.9
)

download_menu() {
  while true; do
    clear; fast_title
    echo "*** DNS Download (100) ***"
    echo "1) Show 10 Best (by ping)"
    echo "2) Show All (with ping)"
    echo "0) Back"
    read -rp "Choose: " a
    [[ "$a" == "0" ]] && return
    case "$a" in
      1)
        # score first 40 candidates then pick best 10
        local scored=()
        local i=0
        for ip in "${DOWNLOAD_V4[@]}"; do
          local r=$(rtt_ms "$ip")
          [[ "$r" =~ ^[0-9]+(\.[0-9]+)?$ ]] || continue
          scored+=( "$(printf "%07.2f %s" "$r" "$ip")" )
          ((++i>=40)) && break
        done
        if ((${#scored[@]}==0)); then
          echo "No responsive DNS now."
        else
          IFS=$'\n' sorted=($(printf "%s\n" "${scored[@]}" | sort | head -n 10))
          local rank=1
          for s in "${sorted[@]}"; do
            ip="${s#* }"; ms="${s%% *}"
            printf "%2d) %-15s → %s ms\n" "$rank" "$ip" "$ms"
            ((rank++))
          done
        fi
        ;;
      2)
        local idx=1
        for ip in "${DOWNLOAD_V4[@]}"; do
          printf "%3d) %-15s → %s ms\n" "$idx" "$ip" "$(rtt_ms "$ip")"
          ((idx++))
        done
        ;;
    esac
    print_footer; pause
  done
}

# ---------- Main Menu ----------
main_menu() {
  ensure_tools
  build_banks
  while true; do
    clear; fast_title
    echo "1) Mobile Games (70+)"
    echo "2) PC/Console Games (70+)"
    echo "3) Search Game + Device"
    echo "4) Generate DNS (IR/SA/TR/AE, IPv4/IPv6)"
    echo "5) DNS Download (100 curated)"
    echo "0) Exit"
    read -rp "Choose: " m
    case "$m" in
      1) menu_list mobile_games "Mobile Games";;
      2) menu_list pc_console_games "PC/Console Games";;
      3) menu_search;;
      4) generate_dns_menu;;
      5) download_menu;;
      0) exit 0;;
    esac
  done
}

main_menu
