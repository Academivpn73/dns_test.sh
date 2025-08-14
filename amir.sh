#!/bin/bash
# =======================================
# Game DNS Manager - Version 1.2.6
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

# ----------------------------
# Colors & Footer (kept, faster)
colors=(31 32 33 34 35 36)
color_index=0
print_footer() {
  local color=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -e "\e[${color}m"
  echo "========================================"
  echo " Version: 1.2.6"
  echo " Telegram: @Academi_vpn"
  echo " Admin By: @MahdiAGM0"
  echo "========================================"
  echo -e "\e[0m"
}

# ----------------------------
# Fast title animation
type_text() {
  local text="$1" delay="${2:-0.00016}"
  for ((i=0;i<${#text};i++)); do echo -ne "${text:$i:1}"; sleep $delay; done
  echo
}
show_title() {
  clear
  echo
  type_text "╔════════════════════════════════════════════╗" 0.00014
  type_text "║            GAME DNS MANAGEMENT             ║" 0.00014
  type_text "╠════════════════════════════════════════════╣" 0.00014
  type_text "║ Version: 1.2.6                             ║" 0.00014
  type_text "║ Telegram: @Academi_vpn                     ║" 0.00014
  type_text "║ Admin:    @MahdiAGM0                       ║" 0.00014
  type_text "╚════════════════════════════════════════════╝" 0.00014
  echo
}

press_enter(){ echo -e "\nPress Enter to return..."; read -r; }
trim(){ echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'; }

# ----------------------------
# Dependencies (auto-install if missing)
need_cmds=(curl awk sed grep dig)
missing=()
for c in "${need_cmds[@]}"; do command -v "$c" >/dev/null 2>&1 || missing+=("$c"); done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Installing missing dependencies: ${missing[*]} (requires sudo/root)"
  if command -v apt >/dev/null 2>&1; then
    sudo apt update -y && sudo apt install -y curl dnsutils
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y curl bind-utils
  elif command -v apk >/dev/null 2>&1; then
    sudo apk add --no-cache curl bind-tools
  else
    echo "Please install: curl, dnsutils/bind-tools"; fi
fi

# ----------------------------
# DATA — 50 Mobile Games
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

# DATA — 50 PC/Console Games (DNS Console)
console_games=(
"Fortnite (Console)" "Warzone (Console)" "EA FC 24 (Console)" "Rocket League (Console)" "Apex Legends (Console)"
"Minecraft (Console)" "GTA V Online (Console)" "Red Dead Online (Console)" "Battlefield 2042 (Console)" "Destiny 2 (Console)"
"Overwatch 2 (Console)" "NBA 2K24" "NHL 24" "Forza Horizon 5" "Gran Turismo 7"
"Need for Speed Heat" "Rainbow Six Siege (Console)" "Call of Duty MWII" "Call of Duty Cold War" "The Division 2"
"Sea of Thieves (Console)" "Fall Guys (Console)" "Halo Infinite" "Paladins (Console)" "Diablo IV (Console)"
"SMITE (Console)" "ARK: Survival Ascended (Console)" "Roblox (Console)" "Genshin Impact (Console)" "World of Tanks (Console)"
"World of Warships (Console)" "eFootball 2024 (Console)" "Madden NFL 24" "MLB The Show 24" "WWE 2K24"
"The Crew Motorfest" "Mortal Kombat 1" "Street Fighter 6" "Tekken 8" "For Honor"
"Hunt: Showdown (Console)" "THE FINALS (Console)" "Helldivers 2" "Tower of Fantasy (Console)" "Tom Clancy's XDefiant"
"Counter-Strike 2 (Console/Steam Deck)" "Valorant (Console)" "Elden Ring (Console)" "Cyberpunk 2077 (Console)" "Granblue Fantasy Versus"
)

# Optional per-game preferred DNS (used first if exists)
declare -A game_dns_pref=(
  ["Fortnite (Console)"]="1.1.1.1,8.8.8.8,9.9.9.9"
  ["Warzone (Console)"]="1.1.1.1,8.8.4.4,208.67.222.222"
  ["Valorant (Console)"]="1.1.1.1,8.8.4.4,9.9.9.9"
  ["PUBG Mobile"]="1.1.1.1,8.8.8.8,208.67.220.220"
)

# ----------------------------
# Built-in DNS seeds (100+ IPv4, several IPv6) — reputable anycast + regional
dns_ipv4_seed=(
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3
8.8.8.8 8.8.4.4
9.9.9.9 149.112.112.112 9.9.9.10 149.112.112.10 9.9.9.11 149.112.112.11
208.67.222.222 208.67.220.220 208.67.222.123 208.67.220.123
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16 176.103.130.130 176.103.130.131
185.228.168.9 185.228.169.9 185.228.168.10 185.228.169.11 185.228.168.168
84.200.69.80 84.200.70.40
77.88.8.8 77.88.8.1 77.88.8.2 77.88.8.88
64.6.64.6 64.6.65.6
156.154.70.1 156.154.71.1 156.154.70.2 156.154.71.2 156.154.70.3 156.154.71.3 156.154.70.4 156.154.71.4 156.154.70.5 156.154.71.5 156.154.70.10 156.154.71.10
76.76.19.19 76.223.122.150
91.239.100.100 89.233.43.71
74.82.42.42
80.80.80.80 80.80.81.81
195.46.39.39 195.46.39.40
8.26.56.26 8.20.247.20
185.222.222.222 45.11.45.11
101.101.101.101 101.102.103.104
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
129.250.35.250 129.250.35.251
168.95.1.1 168.95.192.1
178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4
1.232.188.2 1.232.188.6 23.253.163.53 45.90.28.0 45.90.30.0
208.67.222.2 208.67.220.2 94.247.43.254 62.212.67.196 62.201.220.50 62.201.220.51 62.201.220.52 62.201.220.53 62.201.220.54 62.201.220.55 62.201.220.56 62.201.220.57
)

dns_ipv6_seed=(
2606:4700:4700::1111 2606:4700:4700::1001 2606:4700:4700::1112 2606:4700:4700::1002 2606:4700:4700::1113 2606:4700:4700::1003
2001:4860:4860::8888 2001:4860:4860::8844
2620:fe::fe 2620:fe::9
2620:119:35::35 2620:119:53::53
2a10:50c0::ad1:ff 2a10:50c0::ad2:ff
2a0d:2a00:1::2 2a0d:2a00:2::2
2a01:4f8:222:1553::2 2a01:4f8:222:1553::3
)

# ----------------------------
# DNS Download (100 curated resolvers) — will be offered for save
dns_download=(
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3
8.8.8.8 8.8.4.4
9.9.9.9 149.112.112.112 9.9.9.10 149.112.112.10 9.9.9.11 149.112.112.11
208.67.222.222 208.67.220.220 208.67.222.123 208.67.220.123
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16
185.228.168.9 185.228.169.9 185.228.168.10 185.228.169.11 185.228.168.168
84.200.69.80 84.200.70.40
77.88.8.8 77.88.8.1 77.88.8.2 77.88.8.88
64.6.64.6 64.6.65.6
156.154.70.1 156.154.71.1 156.154.70.2 156.154.71.2 156.154.70.3 156.154.71.3 156.154.70.4 156.154.71.4 156.154.70.5 156.154.71.5 156.154.70.10 156.154.71.10
76.76.19.19 76.223.122.150
91.239.100.100 89.233.43.71
74.82.42.42
80.80.80.80 80.80.81.81
195.46.39.39 195.46.39.40
8.26.56.26 8.20.247.20
185.222.222.222 45.11.45.11
101.101.101.101 101.102.103.104
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
129.250.35.250 129.250.35.251
168.95.1.1 168.95.192.1
178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4
62.201.220.50 62.201.220.51 62.201.220.52 62.201.220.53 62.201.220.54 62.201.220.55 62.201.220.56 62.201.220.57
64.233.217.2 64.233.219.2 64.233.223.2 64.233.171.2
1.232.188.2 1.232.188.6
23.253.163.53 74.82.42.42 208.67.222.2 208.67.220.2
45.90.28.0 45.90.30.0 94.247.43.254 80.67.169.12 80.67.169.40
176.103.130.130 176.103.130.131
1.1.1.1 9.9.9.11 9.9.9.12 49.156.20.6 1.0.0.1
)

# ----------------------------
# Live DNS cache (from public-dns.info)
DNS_CACHE_DIR="/tmp/dns_cache"; mkdir -p "$DNS_CACHE_DIR"
DNS_CACHE_V4="$DNS_CACHE_DIR/resolvers_v4.txt"
DNS_CACHE_V6="$DNS_CACHE_DIR/resolvers_v6.txt"

# ----------------------------
# Net helpers
get_country_cc() {
  for u in "https://ipinfo.io/country" "https://ifconfig.co/country-iso" "https://api.country.is"; do
    cc=$(curl -fsSL --max-time 3 "$u" 2>/dev/null | tr -d '\n\r[:space:]' | sed 's/[^A-Za-z]//g' | head -c 2)
    [ -n "$cc" ] && echo "$cc" && return 0
  done
  echo "US"
}
dig_latency_ms() {
  local server="$1"
  local out qtime
  out=$(dig +tries=1 +time=1 +stats @"$server" google.com A 2>/dev/null)
  qtime=$(echo "$out" | awk '/Query time:/ {print $4}')
  [ -z "$qtime" ] && echo "Timeout" || echo "$qtime"
}

# Fetch live resolvers (filter by reliability & RTT; optional country ISO)
fetch_public_dns() {
  local limit="${1:-200}" version="${2:-4}" country_filter="${3:-}"
  local url="https://public-dns.info/nameservers.csv"
  local tmpfile; tmpfile="$(mktemp)"
  if ! curl -fsSL --max-time 15 "$url" -o "$tmpfile"; then
    echo "Could not fetch live DNS list; using seeds only."
    return 1
  fi
  if [ "$version" = "4" ]; then
    awk -F',' -v cc="$country_filter" 'NR>1 && $1 !~ /:/ && $2+0>=0.98 && $6+0>0 && $6+0<=100 { if(cc=="" || $4==cc) print $1","$6 }' "$tmpfile" \
      | sort -t, -k2,2n | cut -d, -f1 | head -n "$limit" > "$DNS_CACHE_V4"
  else
    awk -F',' -v cc="$country_filter" 'NR>1 && $1 ~ /:/ && $2+0>=0.98 && $6+0>0 && $6+0<=120 { if(cc=="" || $4==cc) print $1","$6 }' "$tmpfile" \
      | sort -t, -k2,2n | cut -d, -f1 | head -n "$limit" > "$DNS_CACHE_V6"
  fi
  rm -f "$tmpfile"
}

# Merge seeds + live, test latency, return top N
get_best_dns() {
  local version="${1:-4}" count="${2:-5}"
  local -a list=()
  if [ "$version" = "4" ]; then
    list+=("${dns_ipv4_seed[@]}"); [ -s "$DNS_CACHE_V4" ] && mapfile -t add < "$DNS_CACHE_V4" && list+=("${add[@]}")
  else
    list+=("${dns_ipv6_seed[@]}"); [ -s "$DNS_CACHE_V6" ] && mapfile -t add < "$DNS_CACHE_V6" && list+=("${add[@]}")
  fi
  mapfile -t list < <(printf "%s\n" "${list[@]}" | awk '!seen[$0]++')  # de-dup
  declare -a results=()
  for s in "${list[@]}"; do
    ms=$(dig_latency_ms "$s"); [[ "$ms" =~ ^[0-9]+$ ]] && results+=("$ms $s")
  done
  printf "%s\n" "${results[@]}" | sort -n | head -n "$count" | awk '{print $2}'
}

# ----------------------------
# Game → DNS recommendation
recommend_dns_for_game() {
  local game="$1" console="$2" ipver="${3:-4}" count="${4:-5}"
  local key="$game"; [ -n "$console" ] && key="$game ($console)"
  local pref="${game_dns_pref[$key]}"; [ -z "$pref" ] && pref="${game_dns_pref[$game]}"
  local cc="$(get_country_cc)"
  if [ -z "$pref" ]; then
    fetch_public_dns 200 "$ipver" "$cc" >/dev/null 2>&1
    get_best_dns "$ipver" "$count"
  else
    IFS=',' read -r -a p <<< "$pref"; for i in "${p[@]}"; do echo "$i"; done
    local remain=$((count - ${#p[@]})); [ "$remain" -gt 0 ] && get_best_dns "$ipver" "$remain"
  fi
}

# ----------------------------
# DNS Generator — real CIDRs + validation with dig
country_to_cc() {
  case "$(echo "$1" | tr '[:upper:]' '[:lower:]')" in
    iran|ir) echo "ir" ;;
    uae|ae|emirates) echo "ae" ;;
    saudi|ksa|sa|arabia) echo "sa" ;;
    turkey|tr) echo "tr" ;;
    *) echo "" ;;
  esac
}
rand_ipv4_in_cidr() {
  local cidr="$1" ip=$(echo "$cidr" | cut -d/ -f1) pre=$(echo "$cidr" | cut -d/ -f2)
  IFS=. read -r a b c d <<< "$ip"
  local ipnum=$(( (a<<24) + (b<<16) + (c<<8) + d ))
  local mask=$(( 0xFFFFFFFF << (32-pre) & 0xFFFFFFFF ))
  local net=$(( ipnum & mask ))
  local hostmax=$(( (1<<(32-pre)) - 2 )); [ "$hostmax" -lt 1 ] && hostmax=1
  local off=$(( RANDOM % hostmax + 1 ))
  local out=$(( net + off ))
  printf "%d.%d.%d.%d\n" $(( (out>>24)&255 )) $(( (out>>16)&255 )) $(( (out>>8)&255 )) $(( out&255 ))
}
rand_ipv6_in_cidr() {
  local cidr="$1" base="${cidr%/*}"; printf "%s:%x\n" "$base" "$((RANDOM & 0xFFFF))"
}
validate_dns_server() {
  local ip="$1" out status
  out=$(dig +tries=1 +time=1 @"$ip" google.com A 2>/dev/null)
  status=$(echo "$out" | awk -F'[, ]+' '/status: /{print $6}')
  [ "$status" = "NOERROR" -o "$status" = "SERVFAIL" ]
}
generate_dns_list() {
  local country="$1" ipver="$2" count="$3"
  local cc=$(country_to_cc "$country"); [ -z "$cc" ] && echo "Invalid country. Use: Iran, UAE, Saudi, Turkey." && return 1
  local url_v4="https://www.ipdeny.com/ipblocks/data/aggregated/${cc}-aggregated.zone"
  local url_v6="https://www.ipdeny.com/ipv6/ipaddresses/aggregated/${cc}-aggregated.zone"
  local tmp="$(mktemp)"
  if [ "$ipver" = "4" ]; then
    curl -fsSL --max-time 12 "$url_v4" -o "$tmp" || { echo "Could not fetch IPv4 CIDRs."; rm -f "$tmp"; return 1; }
  else
    curl -fsSL --max-time 12 "$url_v6" -o "$tmp" || { echo "Could not fetch IPv6 CIDRs."; rm -f "$tmp"; return 1; }
  fi
  mapfile -t cidrs < "$tmp"; rm -f "$tmp"
  [ "${#cidrs[@]}" -eq 0 ] && echo "No CIDRs found." && return 1

  local found=0 attempts=0 max_attempts=$((count * 25))
  declare -a result=()
  echo "Generating and validating DNS servers (port 53)..."
  while [ "$found" -lt "$count" ] && [ "$attempts" -lt "$max_attempts" ]; do
    attempts=$((attempts+1))
    cidr="${cidrs[$RANDOM % ${#cidrs[@]}]}"
    if [ "$ipver" = "4" ]; then ip=$(rand_ipv4_in_cidr "$cidr"); else ip=$(rand_ipv6_in_cidr "$cidr"); fi
    if validate_dns_server "$ip"; then
      if ! printf "%s\n" "${result[@]}" | grep -qx "$ip"; then
        result+=("$ip"); echo " [+] $ip"; found=$((found+1))
      fi
    fi
  done
  echo
  if [ "$found" -lt "$count" ]; then echo "Found ${found}/${count}. (CIDRs limited or firewalled)"; fi
  local idx=1; for ip in "${result[@]}"; do printf "%2d) %s\n" "$idx" "$ip"; idx=$((idx+1)); done
}

# ----------------------------
# Menus
list_mobile_games() {
  show_title
  echo "Mobile Games (50):"
  local i=1; for g in "${mobile_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  print_footer; press_enter
}
list_console_games() {
  show_title
  echo "DNS Console — PC/Console Games (50):"
  local i=1; for g in "${console_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  echo; echo "Tip: Use 'Search & Recommend DNS' to get per-game suggestions."
  print_footer; press_enter
}
search_recommend_dns() {
  show_title
  echo -n "Game name: "; read -r game
  echo -n "Console/Platform (PC/PS/Xbox/etc.): "; read -r console
  echo -n "IPv4 or IPv6? (4/6): "; read -r v; v=$(trim "$v"); [ "$v" = "6" ] && ipver="6" || ipver="4"
  echo -n "How many DNS addresses? [5]: "; read -r c; c=${c:-5}
  echo "Preparing recommendations..."
  mapfile -t dnslist < <(recommend_dns_for_game "$game" "$console" "$ipver" "$c")
  if [ "${#dnslist[@]}" -eq 0 ]; then
    echo "Nothing found. Try 'Update Live DNS' first."
  else
    echo; echo "Suggested DNS for \"$game\" ($console) [IPv$ipver]:"
    local i=1; for d in "${dnslist[@]}"; do printf "%2d) %s\n" "$i" "$d"; i=$((i+1)); done
  fi
  print_footer; press_enter
}
dns_generator_menu() {
  show_title
  echo "DNS Generator (Real CIDRs) — Countries: Iran, UAE, Saudi, Turkey"
  echo -n "Country: "; read -r country
  echo -n "IPv4 or IPv6? (4/6): "; read -r v; v=$(trim "$v"); [ "$v" = "6" ] && ipver="6" || ipver="4"
  echo -n "How many DNS addresses? [5]: "; read -r cnt; cnt=${cnt:-5}
  generate_dns_list "$country" "$ipver" "$cnt"
  print_footer; press_enter
}
update_live_dns_menu() {
  show_title
  local cc="$(get_country_cc)"
  echo "Detected country (ISO): $cc"
  echo -n "How many IPv4 to cache? [200]: "; read -r n4; n4=${n4:-200}
  echo -n "How many IPv6 to cache? [100]: "; read -r n6; n6=${n6:-100}
  fetch_public_dns "$n4" "4" "$cc"
  fetch_public_dns "$n6" "6" "$cc"
  echo "Live DNS lists updated."
  print_footer; press_enter
}
quick_best_dns_menu() {
  show_title
  echo "Top 5 low-latency DNS (auto) [IPv4]:"
  fetch_public_dns 200 4 "$(get_country_cc)" >/dev/null 2>&1
  mapfile -t best4 < <(get_best_dns 4 5)
  local i=1; for d in "${best4[@]}"; do printf "%2d) %s\n" "$i" "$d"; i=$((i+1)); done
  echo; echo "Top 5 low-latency DNS (auto) [IPv6]:"
  fetch_public_dns 100 6 "$(get_country_cc)" >/dev/null 2>&1
  mapfile -t best6 < <(get_best_dns 6 5)
  i=1; for d in "${best6[@]}"; do printf "%2d) %s\n" "$i" "$d"; i=$((i+1)); done
  print_footer; press_enter
}
dns_download_menu() {
  show_title
  echo "DNS Download (100 curated resolvers)"
  echo "1) Show list"
  echo "2) Save to file (dns_download.txt)"
  echo "0) Back"
  echo -n "Select: "; read -r o
  case "$o" in
    1)
      local i=1; for d in "${dns_download[@]}"; do printf "%3d) %s\n" "$i" "$d"; i=$((i+1)); done
      ;;
    2)
      local f="dns_download.txt"
      : > "$f"
      local i=1; for d in "${dns_download[@]}"; do printf "%s\n" "$d" >> "$f"; i=$((i+1)); done
      echo "Saved $(wc -l < "$f") entries to ./$f"
      ;;
    0) ;;
    *) echo "Invalid option." ;;
  esac
  print_footer; press_enter
}

main_menu() {
  while true; do
    show_title
    cat <<EOF
Main Menu:
  1) Mobile Games (50)
  2) DNS Console (PC/Console 50)
  3) Search & Recommend DNS (by Game + Console)
  4) DNS Generator (Iran/UAE/Saudi/Turkey | IPv4/IPv6)
  5) Update Live DNS (public-dns.info)
  6) Quick Top-5 DNS (auto)
  7) DNS Download (100 curated)
  0) Exit
EOF
    echo -n "Select: "; read -r opt
    case "$opt" in
      1) list_mobile_games ;;
      2) list_console_games ;;
      3) search_recommend_dns ;;
      4) dns_generator_menu ;;
      5) update_live_dns_menu ;;
      6) quick_best_dns_menu ;;
      7) dns_download_menu ;;
      0) exit 0 ;;
      *) echo "Invalid option."; sleep 1 ;;
    esac
  done
}

# ----------------------------
# Start
main_menu
