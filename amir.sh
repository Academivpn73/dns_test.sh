#!/usr/bin/env bash
# =======================================
# Game DNS Manager - Version 2.4.1
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

set -euo pipefail

# ---------- Colors & UI ----------
COLORS=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
RESET="\e[0m"

print_footer() {
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "${C}"
  echo "========================================"
  echo " Version: 2.4.1"
  echo " Telegram: @Academi_vpn"
  echo " Admin By: @MahdiAGM0"
  echo "========================================"
  echo -e "${RESET}"
}

type_text() { # ultra-fast title typing
  local text="$1" delay="${2:-0.00004}"
  local i
  for ((i=0;i<${#text};i++)); do echo -ne "${text:$i:1}"; sleep "$delay"; done
  echo
}

show_title() {
  clear
  local C="${COLORS[$((RANDOM % ${#COLORS[@]}))]}"
  echo -e "${C}"
  type_text "╔════════════════════════════════════════════╗"
  type_text "║            GAME DNS MANAGEMENT             ║"
  type_text "╠════════════════════════════════════════════╣"
  type_text "║ Version: 2.4.1                             ║"
  type_text "║ Telegram: @Academi_vpn                     ║"
  type_text "║ Admin:    @MahdiAGM0                       ║"
  type_text "╚════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

press_enter(){ echo; read -rp "Press Enter to continue... " _; }

slugify(){ echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g;s/-\+/-/g;s/^-//;s/-$//'; }

# ---------- Dependencies ----------
need_cmds=(curl awk sed grep sort head tail ping dig timeout cut tr)
missing=()
for c in "${need_cmds[@]}"; do command -v "$c" >/dev/null 2>&1 || missing+=("$c"); done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Installing missing dependencies: ${missing[*]} (sudo required)"
  if command -v apt >/dev/null 2>&1; then
    sudo apt update -y && sudo apt install -y curl dnsutils iputils-ping coreutils
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y curl bind-utils iputils coreutils
  elif command -v apk >/dev/null 2>&1; then
    sudo apk add --no-cache curl bind-tools iputils coreutils
  else
    echo "Please install: curl dnsutils/bind-tools iputils."
  fi
fi

# ---------- Data: Game Lists (50 + 50) ----------
mobile_games=(
"PUBG Mobile" "Call of Duty Mobile" "Garena Free Fire" "Arena Breakout" "Clash of Clans"
"Mobile Legends" "Brawl Stars" "Among Us" "Genshin Impact" "Pokemon Go"
"Subway Surfers" "Candy Crush Saga" "Asphalt 9" "Lords Mobile" "AFK Arena"
"Roblox Mobile" "Minecraft Pocket Edition" "Coin Master" "Clash Royale" "Summoners War"
"State of Survival" "Rise of Kingdoms" "Honkai: Star Rail" "League of Legends: Wild Rift" "eFootball Mobile"
"FIFA Mobile" "Apex Legends Mobile" "Diablo Immortal" "Call of Dragons" "War Robots"
"World of Tanks Blitz" "Shadow Fight 3" "8 Ball Pool" "Standoff 2" "Sausage Man"
"MARVEL Snap" "T3 Arena" "Dead by Daylight Mobile" "NIKKE" "PUBG: New State"
"CarX Drift Racing 2" "CSR Racing 2" "Critical Ops" "Ace Racer" "Dragon Ball Legends"
"Plants vs Zombies 2" "Boom Beach" "Archero" "Torchlight: Infinite" "Hearthstone Mobile"
)

console_games=(
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

# ---------- Seed DNS (global anycast + regional) ----------
IR_v4=(178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4 5.200.200.200 10.202.10.10 10.202.10.11 46.245.69.2 46.245.69.3)
AE_v4=(94.200.200.200 94.200.200.201 185.37.37.37 185.37.39.39 213.42.20.20 213.42.20.21 31.217.168.2 31.217.168.4)
SA_v4=(212.26.18.1 212.26.18.2 84.235.6.6 84.235.6.7 185.24.233.2 185.24.233.3 188.54.64.1 188.54.64.2)
TR_v4=(195.175.39.39 85.111.3.3 212.156.4.1 212.156.4.2 81.212.65.50 195.175.39.50 176.43.1.1 176.43.1.2)
EU_v4=(1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112 208.67.222.222 208.67.220.220 94.140.14.14 94.140.15.15 84.200.69.80 84.200.70.40 77.88.8.8 80.80.80.80 64.6.64.6 64.6.65.6 76.76.19.19 76.223.122.150)
US_v4=(1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4 9.9.9.9 149.112.112.112 208.67.222.222 208.67.220.220 64.6.64.6 64.6.65.6 4.2.2.1 4.2.2.2 4.2.2.3 74.82.42.42 76.76.19.19)

# per-game hints (optional)
declare -A game_pref
game_pref["PUBG Mobile"]="1.1.1.1,8.8.8.8,178.22.122.100"
game_pref["Fortnite"]="1.1.1.1,8.8.4.4,208.67.222.222"
game_pref["Warzone"]="1.1.1.1,8.8.4.4,9.9.9.9"
game_pref["Valorant (Console)"]="1.1.1.1,8.8.4.4,208.67.220.220"

MASTER_V4=("${IR_v4[@]}" "${AE_v4[@]}" "${SA_v4[@]}" "${TR_v4[@]}" "${EU_v4[@]}" "${US_v4[@]}")

CACHE="/tmp/dns_gamer_cache"; mkdir -p "$CACHE"
V4CSV="$CACHE/resolvers_v4.csv"
V6CSV="$CACHE/resolvers_v6.csv"

get_country_cc(){
  local cc
  for u in "https://ipinfo.io/country" "https://ifconfig.co/country-iso" "https://api.country.is"; do
    cc=$(curl -fsSL --max-time 3 "$u" 2>/dev/null | tr -d '\r\n[:space:]' | head -c 2)
    [ -n "${cc:-}" ] && { echo "$cc"; return; }
  done
  echo "US"
}

fetch_public_dns(){
  local version="${1:-4}" limit="${2:-1500}" cc_filter="${3:-}"
  local url="https://public-dns.info/nameservers.csv"
  local tmp; tmp="$(mktemp)"
  if ! curl -fsSL --max-time 15 "$url" -o "$tmp"; then
    return 1
  fi
  if [ "$version" = "4" ]; then
    awk -F',' -v cc="$cc_filter" 'NR>1 && $1 !~ /:/ && $2+0>=0.98 && $6+0>0 && $6+0<=200 { if(cc=="" || $4==cc) print $1","$6 }' "$tmp" \
      | sort -t, -k2,2n | head -n "$limit" > "$V4CSV"
  else
    awk -F',' -v cc="$cc_filter" 'NR>1 && $1 ~ /:/ && $2+0>=0.98 && $6+0>0 && $6+0<=240 { if(cc=="" || $4==cc) print $1","$6 }' "$tmp" \
      | sort -t, -k2,2n | head -n "$limit" > "$V6CSV"
  fi
  rm -f "$tmp"
}

# ---------- Latency ----------
# ICMP ping in ms (fallback to dig qtime)
icmp_ping_ms(){
  local ip="$1" ms
  ms=$(ping -c 1 -W 1 "$ip" 2>/dev/null | awk -F'time=' '/time=/{print $2}' | cut -d' ' -f1)
  if [[ -z "${ms:-}" ]]; then
    local q
    q=$(timeout 1 dig +tries=1 +time=1 @"$ip" google.com A 2>/dev/null | awk '/Query time:/ {print $4}')
    [ -z "$q" ] && echo 9999 || echo "$q"
  else
    echo "$ms"
  fi
}

rank_best_two_under(){
  local threshold="$1"; shift
  local -a candidates=("$@")
  declare -a pairs=()
  local ip ms
  for ip in "${candidates[@]}"; do
    [[ -z "$ip" ]] && continue
    ms=$(icmp_ping_ms "$ip")
    [[ "$ms" =~ ^[0-9]+(\.[0-9]+)?$ ]] || ms=9999
    # print inline progress every ~12 items
    if (( RANDOM % 12 == 0 )); then echo -ne "."; fi
    awk -v m="$ms" -v t="$threshold" 'BEGIN{if(m<=t)exit 0; else exit 1}' && pairs+=("$ms $ip")
  done
  echo
  if [ "${#pairs[@]}" -eq 0 ]; then
    echo ""
    return 1
  fi
  printf "%s\n" "${pairs[@]}" | sort -n -k1,1 | awk '{print $2"|" $1}' | head -n 2
}

pick_best_two(){
  # tries thresholds: 50 -> 80 -> 120 -> best available
  local -a pool=("$@")
  local out
  out=$(rank_best_two_under 50 "${pool[@]}") || out=""
  if [ -z "$out" ]; then out=$(rank_best_two_under 80 "${pool[@]}") || out=""; fi
  if [ -z "$out" ]; then out=$(rank_best_two_under 120 "${pool[@]}") || out=""; fi
  if [ -z "$out" ]; then
    # take best two regardless of threshold
    declare -a pairs=()
    local ip ms
    for ip in "${pool[@]}"; do
      [[ -z "$ip" ]] && continue
      ms=$(icmp_ping_ms "$ip"); [[ "$ms" =~ ^[0-9]+(\.[0-9]+)?$ ]] || ms=9999
      pairs+=("$ms $ip")
    done
    out=$(printf "%s\n" "${pairs[@]}" | sort -n -k1,1 | awk '{print $2"|" $1}' | head -n 2)
  fi
  echo "$out"
}

# ---------- Candidate Builder ----------
candidates_for_region(){
  # ARG: CC (IR/AE/SA/TR/*)
  local cc="$1" ver="${2:-4}"
  local -a base=()
  case "$cc" in
    IR|Ir|ir) base=("${IR_v4[@]}");;
    AE|ae)    base=("${AE_v4[@]}");;
    SA|sa)    base=("${SA_v4[@]}");;
    TR|tr)    base=("${TR_v4[@]}");;
    *)        base=("${EU_v4[@]}" "${US_v4[@]}");;
  esac
  # fetch public list for cc + mix
  fetch_public_dns "$ver" 1200 "$cc" >/dev/null 2>&1 || true
  if [ "$ver" = "4" ] && [ -s "$V4CSV" ]; then
    mapfile -t live < <(cut -d, -f1 "$V4CSV" | head -n 600)
    base+=("${live[@]}")
  elif [ -s "$V6CSV" ]; then
    mapfile -t live < <(cut -d, -f1 "$V6CSV" | head -n 600)
    base+=("${live[@]}")
  fi
  # de-duplicate & trim empties
  mapfile -t base < <(printf "%s\n" "${base[@]}" | awk 'length>6 && !seen[$0]++')
  printf "%s\n" "${base[@]}"
}

candidates_for_game(){
  local game="$1" ver="${2:-4}"
  local cc; cc="$(get_country_cc)"
  local -a pool=()
  # seed with per-game prefs if exists
  local pref="${game_pref[$game]:-}"
  if [ -n "$pref" ]; then IFS=',' read -r -a arr <<< "$pref"; pool+=("${arr[@]}"); fi
  # region-based + global
  mapfile -t reg < <(candidates_for_region "$cc" "$ver")
  pool+=("${reg[@]}")
  pool+=("${MASTER_V4[@]}")
  # de-dup
  mapfile -t pool < <(printf "%s\n" "${pool[@]}" | awk '!seen[$0]++')
  printf "%s\n" "${pool[@]}"
}

# ---------- OUTPUT Helpers ----------
print_primary_secondary(){
  local lines="$1"
  local a b
  a=$(echo "$lines" | sed -n '1p')
  b=$(echo "$lines" | sed -n '2p')
  if [ -n "$a" ]; then
    ip="${a%%|*}"; ms="${a##*|}"
    printf "Primary DNS:   %-18s → %sms\n" "$ip" "$ms"
  fi
  if [ -n "$b" ]; then
    ip="${b%%|*}"; ms="${b##*|}"
    printf "Secondary DNS: %-18s → %sms\n" "$ip" "$ms"
  fi
}

print_numbered_list(){
  local -a arr=("$@")
  local i=1
  for line in "${arr[@]}"; do
    ip="${line%%|*}"; ms="${line##*|}"
    printf "%3d) %-18s → %sms\n" "$i" "$ip" "$ms"
    i=$((i+1))
  done
}

# ---------- Menus ----------
menu_mobile(){
  show_title
  echo "Mobile Games:"
  local i=1; for g in "${mobile_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  echo
  read -rp "Pick game number: " n
  [[ ! "$n" =~ ^[0-9]+$ ]] && echo "Invalid"; press_enter; return
  (( n<1 || n>${#mobile_games[@]} )) && echo "Invalid"; press_enter; return
  local game="${mobile_games[$((n-1))]}"
  echo "Testing DNS (this may take a few seconds)..."
  mapfile -t pool < <(candidates_for_game "$game" 4)
  local res; res="$(pick_best_two "${pool[@]}")"
  if [ -z "$res" ]; then echo "No DNS found."; press_enter; return; fi
  print_primary_secondary "$res"
  print_footer; press_enter
}

menu_console(){
  show_title
  echo "PC/Console Games:"
  local i=1; for g in "${console_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  echo
  read -rp "Pick game number: " n
  [[ ! "$n" =~ ^[0-9]+$ ]] && echo "Invalid"; press_enter; return
  (( n<1 || n>${#console_games[@]} )) && echo "Invalid"; press_enter; return
  local game="${console_games[$((n-1))]}"
  echo "Testing DNS (this may take a few seconds)..."
  mapfile -t pool < <(candidates_for_game "$game" 4)
  local res; res="$(pick_best_two "${pool[@]}")"
  if [ -z "$res" ]; then echo "No DNS found."; press_enter; return; fi
  print_primary_secondary "$res"
  print_footer; press_enter
}

menu_search(){
  show_title
  echo "Search Game DNS (name + device)"
  read -rp "Game name: " game
  read -rp "Device (Mobile/PC/Console): " dev
  game="${game:-Generic Game}"; dev="${dev:-Device}"
  echo "Testing DNS for: $game ($dev)..."
  mapfile -t pool < <(candidates_for_game "$game" 4)
  local res; res="$(pick_best_two "${pool[@]}")"
  if [ -z "$res" ]; then echo "No DNS found."; press_enter; return; fi
  print_primary_secondary "$res"
  print_footer; press_enter
}

country_to_cc(){
  case "$(echo "$1" | tr '[:upper:]' '[:lower:]')" in
    iran|ir) echo "IR";;
    uae|ae|emirates) echo "AE";;
    saudi|ksa|sa|arabia) echo "SA";;
    turkey|tr) echo "TR";;
    *) echo "";;

  esac
}

menu_generator(){
  show_title
  echo "DNS Generator"
  echo "  1) Iran"
  echo "  2) UAE"
  echo "  3) Saudi Arabia"
  echo "  4) Turkey"
  read -rp "Select (1-4): " c
  local country=""
  case "$c" in
    1) country="Iran";;
    2) country="UAE";;
    3) country="Saudi";;
    4) country="Turkey";;
    *) echo "Invalid"; press_enter; return;;
  esac
  read -rp "IPv4 or IPv6? (4/6) [4]: " v; v="${v:-4}"
  read -rp "How many results max? [20]: " k; k="${k:-20}"

  local cc; cc="$(country_to_cc "$country")"
  local ver="4"; [ "$v" = "6" ] && ver="6"

  echo "Collecting candidates for $country (IPv$ver)..."
  fetch_public_dns "$ver" 1200 "$cc" >/dev/null 2>&1 || true

  declare -a cand=()
  if [ "$ver" = "4" ] && [ -s "$V4CSV" ]; then
    mapfile -t cand < <(cut -d, -f1 "$V4CSV" | head -n 800)
    # add seeds
    case "$cc" in
      IR) cand+=("${IR_v4[@]}");;
      AE) cand+=("${AE_v4[@]}");;
      SA) cand+=("${SA_v4[@]}");;
      TR) cand+=("${TR_v4[@]}");;
    esac
  elif [ -s "$V6CSV" ]; then
    mapfile -t cand < <(cut -d, -f1 "$V6CSV" | head -n 800)
  fi
  mapfile -t cand < <(printf "%s\n" "${cand[@]}" | awk '!seen[$0]++')

  echo "Measuring latency..."
  declare -a pairs=()
  local ip ms count=0
  for ip in "${cand[@]}"; do
    ms=$(icmp_ping_ms "$ip")
    [[ "$ms" =~ ^[0-9]+(\.[0-9]+)?$ ]] || ms=9999
    pairs+=("$ms $ip")
    (( (count+=1) % 20 == 0 )) && echo -ne "."
  done
  echo
  mapfile -t ranked < <(printf "%s\n" "${pairs[@]}" | sort -n -k1,1 | awk '{print $2"|" $1}')
  # filter by <=50 first, then top-k
  declare -a under50=()
  for line in "${ranked[@]}"; do
    val="${line##*|}"
    awk -v m="$val" 'BEGIN{if(m<=50)exit 0; else exit 1}' && under50+=("$line")
    [ "${#under50[@]}" -ge "$k" ] && break || true
  done
  if [ "${#under50[@]}" -eq 0 ]; then
    # fall back to best k overall
    under50=("${ranked[@]:0:$k}")
    echo "⚠️ Could not find results under 50ms. Showing best $k available."
  fi

  print_numbered_list "${under50[@]}"
  print_footer; press_enter
}

# ---------- Main ----------
main_menu(){
  while true; do
    show_title
    cat <<'EOF'
1) Mobile Games DNS
2) PC/Console Games DNS
3) Search Game DNS (name + device)
4) DNS Generator (Iran/UAE/Saudi/Turkey)
0) Exit
EOF
    read -rp "Select: " opt
    case "$opt" in
      1) menu_mobile ;;
      2) menu_console ;;
      3) menu_search ;;
      4) menu_generator ;;
      0) exit 0 ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

main_menu
