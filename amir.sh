#!/bin/bash
# =======================================
# Game DNS Manager - Version 2.3.0
# Telegram: @Academi_vpn
# Admin By: @MahdiAGM0
# =======================================

set -u

# -------- UI Colors --------
colors=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
reset="\e[0m"
color_index=0

# -------- Footer (kept, cycling colors) --------
print_footer() {
  local c=${colors[$color_index]}
  color_index=$(( (color_index + 1) % ${#colors[@]} ))
  echo -e "${c}"
  echo "========================================"
  echo " Version: 2.3.0"
  echo " Telegram: @Academi_vpn"
  echo " Admin By: @MahdiAGM0"
  echo "========================================"
  echo -e "${reset}"
}

# -------- Super-fast Title animation + random color each time --------
type_text() {
  local text="$1" delay="${2:-0.00005}" # super fast
  local i
  for ((i=0;i<${#text};i++)); do echo -ne "${text:$i:1}"; sleep $delay; done
  echo
}
show_title() {
  clear
  local c=${colors[$RANDOM % ${#colors[@]}]}
  echo -e "${c}"
  type_text "╔════════════════════════════════════════════╗" 0.00004
  type_text "║            GAME DNS MANAGEMENT             ║" 0.00004
  type_text "╠════════════════════════════════════════════╣" 0.00004
  type_text "║ Version: 2.3.0                             ║" 0.00004
  type_text "║ Telegram: @Academi_vpn                     ║" 0.00004
  type_text "║ Admin:    @MahdiAGM0                       ║" 0.00004
  type_text "╚════════════════════════════════════════════╝" 0.00004
  echo -e "${reset}"
}

press_enter(){ echo -e "\nPress Enter to return..."; read -r; }
trim(){ echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'; }
slugify(){ echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g;s/-\+/-/g;s/^-//;s/-$//'; }

# -------- Dependencies (auto-install) --------
need_cmds=(curl awk sed grep dig timeout)
missing=(); for c in "${need_cmds[@]}"; do command -v "$c" >/dev/null 2>&1 || missing+=("$c"); done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Installing missing dependencies: ${missing[*]} (requires sudo/root)"
  if command -v apt >/dev/null 2>&1; then
    sudo apt update -y && sudo apt install -y curl dnsutils coreutils
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y curl bind-utils coreutils
  elif command -v apk >/dev/null 2>&1; then
    sudo apk add --no-cache curl bind-tools coreutils
  else
    echo "Please install: curl, dnsutils/bind-tools"
  fi
fi

# -------- Data: Mobile Games (50) --------
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

# -------- Data: PC/Console Games (50) --------
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

# -------- Preferred per-game DNS (seed, optional) --------
declare -A game_dns_pref=(
  ["PUBG Mobile"]="1.1.1.1,8.8.8.8,9.9.9.9,208.67.222.222"
  ["Fortnite"]="1.1.1.1,8.8.4.4,208.67.222.222,94.140.14.14"
  ["Warzone"]="1.1.1.1,8.8.4.4,9.9.9.9,76.76.19.19"
  ["Valorant (Console)"]="1.1.1.1,8.8.4.4,9.9.9.9,208.67.220.220"
)

# -------- Curated DNS Banks by Region (real, mixed ISPs/anycast) --------
# NOTE: Script will augment from public-dns.info to reach 200+ if below threshold.

# --- IRAN (IR) ---
IR_v4=(
178.22.122.100 178.22.122.101 185.51.200.2 185.51.200.4 217.218.127.127
10.202.10.10 10.202.10.11 10.202.10.12
62.201.220.50 62.201.220.51 62.201.220.52 62.201.220.53 62.201.220.54 62.201.220.55 62.201.220.56 62.201.220.57
85.15.1.14 85.15.1.15 85.185.39.10 85.185.39.11 85.185.39.12
5.200.200.200 46.245.69.2 46.245.69.3 46.245.69.4
31.7.64.1 31.7.64.2 31.7.64.3 31.7.64.4
185.55.226.26 185.55.225.26 185.120.221.254 185.120.222.254
217.11.16.21 217.11.16.22 217.11.16.23
185.231.182.110 185.231.182.111
185.95.218.42 185.83.114.56 185.117.118.20
)
IR_v6=(2a0a:2b40::1 2a0a:2b41::1)

# --- UAE (AE) ---
AE_v4=(
94.200.200.200 94.200.200.201 185.37.37.37 185.37.39.39
91.73.130.1 91.73.130.2 176.205.0.1
5.32.75.11 109.169.248.210 94.200.16.18
91.74.22.71 185.134.196.54 185.134.196.55
94.100.128.10 94.100.128.12 31.217.168.2 31.217.168.4
213.42.20.20 213.42.20.21
)
AE_v6=(2a02:4780::1 2a02:4781::1)

# --- SAUDI (SA) ---
SA_v4=(
212.26.18.1 212.26.18.2 84.235.6.6 84.235.6.7
46.151.209.153 46.151.209.154 95.141.28.8
185.24.233.2 185.24.233.3 185.24.233.4
188.54.64.1 188.54.64.2 188.54.64.3
91.223.123.1 91.223.123.2
)
SA_v6=(2a0a:4b80::1 2a0a:4b81::1)

# --- TURKEY (TR) ---
TR_v4=(
195.175.39.39 85.111.3.3 85.111.3.4
212.156.4.1 212.156.4.2 195.175.39.49
81.212.65.50 81.212.65.51 195.175.39.50
176.43.1.1 176.43.1.2 176.43.1.3
88.255.168.248 88.255.168.249
213.14.227.118 213.14.227.119
)
TR_v6=(2a02:ff80::1 2a02:ff81::1)

# --- EUROPE (EU, mixed low-latency) ---
EU_v4=(
1.1.1.1 1.0.0.1 1.1.1.2 1.0.0.2 1.1.1.3 1.0.0.3
8.8.8.8 8.8.4.4
9.9.9.9 149.112.112.112 9.9.9.10 149.112.112.10 9.9.9.11 149.112.112.11
208.67.222.222 208.67.220.220
94.140.14.14 94.140.15.15 94.140.14.15 94.140.15.16
84.200.69.80 84.200.70.40
77.88.8.8 77.88.8.1 77.88.8.2 77.88.8.88
80.80.80.80 80.80.81.81
64.6.64.6 64.6.65.6
156.154.70.1 156.154.71.1 156.154.70.2 156.154.71.2 156.154.70.3 156.154.71.3 156.154.70.4 156.154.71.4 156.154.70.5 156.154.71.5 156.154.70.10 156.154.71.10
76.76.19.19 76.223.122.150
91.239.100.100 89.233.43.71 74.82.42.42
45.11.45.11 185.222.222.222 45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10
94.247.43.254 5.2.75.75 185.43.135.1 185.43.135.2
195.46.39.39 195.46.39.40
80.67.169.12 80.67.169.40
151.80.222.79 164.132.74.251 51.68.190.250 49.12.234.183 144.76.83.104
)
EU_v6=(
2606:4700:4700::1111 2606:4700:4700::1001 2606:4700:4700::1112 2606:4700:4700::1002
2001:4860:4860::8888 2001:4860:4860::8844
2620:fe::fe 2620:fe::9
2620:119:35::35 2620:119:53::53
2a01:4f8:222:1553::2 2a01:4f8:222:1553::3
)

# --- UNITED STATES (US, anycast + ISPs) ---
US_v4=(
1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
9.9.9.9 149.112.112.112
208.67.222.222 208.67.220.220
64.6.64.6 64.6.65.6
4.2.2.1 4.2.2.2 4.2.2.3 4.2.2.4 4.2.2.5 4.2.2.6
74.82.42.42
76.76.19.19 76.223.122.150
129.250.35.250 129.250.35.251
45.90.28.0 45.90.30.0 45.90.28.10 45.90.30.10
)
US_v6=(
2606:4700:4700::1111 2606:4700:4700::1001
2001:4860:4860::8888 2001:4860:4860::8844
2620:fe::fe 2620:fe::9
)

# -------- Global Master (combines for augmentation) --------
master_ipv4=(
"${IR_v4[@]}" "${AE_v4[@]}" "${SA_v4[@]}" "${TR_v4[@]}" "${EU_v4[@]}" "${US_v4[@]}"
)
master_ipv6=(
"${IR_v6[@]}" "${AE_v6[@]}" "${SA_v6[@]}" "${TR_v6[@]}" "${EU_v6[@]}" "${US_v6[@]}"
)

# -------- Caches --------
CACHE_DIR="/tmp/dns_gamer_cache"; mkdir -p "$CACHE_DIR"
DNS_CACHE_V4="$CACHE_DIR/resolvers_v4.csv"
DNS_CACHE_V6="$CACHE_DIR/resolvers_v6.csv"

# -------- Helpers --------
get_country_cc() {
  for u in "https://ipinfo.io/country" "https://ifconfig.co/country-iso" "https://api.country.is"; do
    cc=$(curl -fsSL --max-time 3 "$u" 2>/dev/null | tr -d '\n\r[:space:]' | sed 's/[^A-Za-z]//g' | head -c 2)
    [ -n "$cc" ] && echo "$cc" && return 0
  done
  echo "US"
}
dig_latency_ms() {
  local s="$1" out qtime
  out=$(timeout 1 dig +tries=1 +time=1 +stats @"$s" google.com A 2>/dev/null)
  qtime=$(echo "$out" | awk '/Query time:/ {print $4}')
  [ -z "$qtime" ] && echo 9999 || echo "$qtime"
}

# Fetch live resolvers from public-dns.info (optional; augments to 200+)
fetch_public_dns() {
  local version="${1:-4}" limit="${2:-1600}" cc_filter="${3:-}"
  local url="https://public-dns.info/nameservers.csv"
  local tmp; tmp="$(mktemp)"
  if ! curl -fsSL --max-time 15 "$url" -o "$tmp"; then
    return 1
  fi
  if [ "$version" = "4" ]; then
    awk -F',' -v cc="$cc_filter" 'NR>1 && $1 !~ /:/ && $2+0>=0.98 && $6+0>0 && $6+0<=200 { if(cc=="" || $4==cc) print $1","$6 }' "$tmp" \
      | sort -t, -k2,2n | head -n "$limit" > "$DNS_CACHE_V4"
  else
    awk -F',' -v cc="$cc_filter" 'NR>1 && $1 ~ /:/ && $2+0>=0.98 && $6+0>0 && $6+0<=240 { if(cc=="" || $4==cc) print $1","$6 }' "$tmp" \
      | sort -t, -k2,2n | head -n "$limit" > "$DNS_CACHE_V6"
  fi
  rm -f "$tmp"
}

# Build 200+ list for a game: preferred + regional + live + ranking
build_dns_list_for_game() {
  local game="$1" ipver="${2:-4}" need="${3:-200}"
  local game_slug; game_slug="$(slugify "$game")"
  local cache_file="$CACHE_DIR/game_${game_slug}_v${ipver}.txt"
  if [ -s "$cache_file" ]; then
    cat "$cache_file"
    return 0
  fi

  local cc="$(get_country_cc)"
  fetch_public_dns "$ipver" 1600 "$cc" >/dev/null 2>&1

  declare -a pool=()
  # seed with per-game preferences if any
  local pref="${game_dns_pref[$game]}"
  if [ -n "$pref" ]; then IFS=',' read -r -a arr <<< "$pref"; pool+=("${arr[@]}"); fi

  # region-boost: prefer same-country & neighbors first
  case "$cc" in
    IR|Ir|ir) pool+=("${IR_v4[@]}");;
    AE|ae) pool+=("${AE_v4[@]}");;
    SA|sa) pool+=("${SA_v4[@]}");;
    TR|tr) pool+=("${TR_v4[@]}");;
    *) pool+=("${EU_v4[@]}"); pool+=("${US_v4[@]}");;
  esac

  if [ "$ipver" = "6" ]; then
    pool=()
    [ -n "$pref" ] && { IFS=',' read -r -a arr <<< "$pref"; pool+=("${arr[@]}"); }
    case "$cc" in
      IR|Ir|ir) pool+=("${IR_v6[@]}");;
      AE|ae) pool+=("${AE_v6[@]}");;
      SA|sa) pool+=("${SA_v6[@]}");;
      TR|tr) pool+=("${TR_v6[@]}");;
      *) pool+=("${EU_v6[@]}"); pool+=("${US_v6[@]}");;
    esac
  fi

  # add masters + live CSV (IPs only)
  if [ "$ipver" = "4" ]; then
    pool+=("${master_ipv4[@]}")
    [ -s "$DNS_CACHE_V4" ] && mapfile -t add4 < <(cut -d, -f1 "$DNS_CACHE_V4") && pool+=("${add4[@]}")
  else
    pool+=("${master_ipv6[@]}")
    [ -s "$DNS_CACHE_V6" ] && mapfile -t add6 < <(cut -d, -f1 "$DNS_CACHE_V6") && pool+=("${add6[@]}")
  fi

  # de-duplicate
  mapfile -t pool < <(printf "%s\n" "${pool[@]}" | awk 'length>6 && !seen[$0]++')

  # measure up to a cap for speed (rank by real latency)
  local cap=700
  [ "${#pool[@]}" -lt "$cap" ] && cap="${#pool[@]}"
  declare -a results=()
  local i s ms
  for ((i=0;i<cap;i++)); do
    s="${pool[$i]}"; ms=$(dig_latency_ms "$s")
    [[ "$ms" =~ ^[0-9]+$ ]] && [ "$ms" -lt 2500 ] && results+=("$ms $s")
  done

  # if still not enough, append unmeasured fast candidates (live list is pre-sorted)
  if [ "${#results[@]}" -lt "$need" ]; then
    if [ "$ipver" = "4" ] && [ -s "$DNS_CACHE_V4" ]; then
      mapfile -t fastcsv < <(cut -d, -f1 "$DNS_CACHE_V4" | head -n $((need*3)))
      for s in "${fastcsv[@]}"; do results+=("350 $s"); done
    elif [ -s "$DNS_CACHE_V6" ]; then
      mapfile -t fastcsv < <(cut -d, -f1 "$DNS_CACHE_V6" | head -n $((need*3)))
      for s in "${fastcsv[@]}"; do results+=("400 $s"); done
    fi
  fi

  mapfile -t top < <(printf "%s\n" "${results[@]}" | sort -n -k1,1 | awk '{print $2}' | awk '!seen[$0]++' | head -n "$need")
  : > "$cache_file"
  for ip in "${top[@]}"; do echo "$ip" >> "$cache_file"; done

  cat "$cache_file"
}

# ---------- DNS Generator (Iran/UAE/Saudi/Turkey with real CIDR + validation) ----------
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
  local ip="$1"
  local out status
  out=$(timeout 1 dig +tries=1 +time=1 @"$ip" google.com A 2>/dev/null)
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
    if ! curl -fsSL --max-time 12 "$url_v4" -o "$tmp"; then echo "Could not fetch IPv4 CIDRs."; rm -f "$tmp"; return 1; fi
  else
    if ! curl -fsSL --max-time 12 "$url_v6" -o "$tmp"; then echo "Could not fetch IPv6 CIDRs."; rm -f "$tmp"; return 1; fi
  fi
  mapfile -t cidrs < "$tmp"; rm -f "$tmp"
  [ "${#cidrs[@]}" -eq 0 ] && echo "No CIDRs found." && return 1

  local found=0 attempts=0 max_attempts=$((count * 30))
  declare -a result=()
  echo "Generating and validating DNS servers (udp/53)..."
  while [ "$found" -lt "$count" ] && [ "$attempts" -lt "$max_attempts" ]; do
    attempts=$((attempts+1))
    cidr="${cidrs[$RANDOM % ${#cidrs[@]}]}"
    if [ "$ipver" = "4" ]; then ip=$(rand_ipv4_in_cidr "$cidr"); else ip=$(rand_ipv6_in_cidr "$cidr"); fi
    if validate_dns_server "$ip"; then
      if ! printf "%s\n" "${result[@]}" | grep -qx "$ip"; then
        result+=("$ip"); printf " [+] %s\n" "$ip"
        found=$((found+1))
      fi
    fi
  done

  echo
  local idx=1
  for ip in "${result[@]}"; do printf "%3d) %s\n" "$idx" "$ip"; idx=$((idx+1)); done

  read -rp "Save to file? (y/N): " sv
  if [[ "$sv" =~ ^[Yy]$ ]]; then
    local f="dns_generated_${cc}_ipv${ipver}.txt"
    : > "$f"; for ip in "${result[@]}"; do echo "$ip" >> "$f"; done
    echo "Saved ${#result[@]} entries to ./$f"
  fi
}

# -------- UI Sections --------
list_mobile_games() {
  show_title
  echo "Mobile Games:"
  local i=1; for g in "${mobile_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  echo
  read -rp "Pick game number to get DNS (or Enter to go back): " num
  if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#mobile_games[@]}" ]; then
    local game="${mobile_games[$((num-1))]}"
    echo -n "IPv4 or IPv6? (4/6) [4]: "; read -r v; v="${v:-4}"
    echo -n "How many DNS you want? [200]: "; read -r n; n="${n:-200}"
    mapfile -t lst < <(build_dns_list_for_game "$game" "$v" "$n")
    echo; echo "DNS for $game [IPv$v]:"
    local i=1; for ip in "${lst[@]}"; do printf "%3d) %s\n" "$i" "$ip"; i=$((i+1)); done
    echo
    read -rp "Save full list? (y/N): " sv
    if [[ "$sv" =~ ^[Yy]$ ]]; then
      local file="dns_$(slugify "$game")_ipv${v}.txt"; : > "$file"
      for ip in "${lst[@]}"; do echo "$ip" >> "$file"; done
      echo "Saved ${#lst[@]} entries to ./$file"
    fi
    read -rp "Also save a 100-DNS download pack? (y/N): " sv2
    if [[ "$sv2" =~ ^[Yy]$ ]]; then
      local file="dns_download_pack_$(slugify "$game")_ipv${v}.txt"; : > "$file"
      printf "%s\n" "${lst[@]:0:100}" >> "$file"
      echo "Saved 100 entries to ./$file"
    fi
  fi
  print_footer; press_enter
}

list_console_games() {
  show_title
  echo "PC/Console Games:"
  local i=1; for g in "${console_games[@]}"; do printf "%2d) %s\n" "$i" "$g"; i=$((i+1)); done
  echo
  read -rp "Pick game number to get DNS (or Enter to go back): " num
  if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#console_games[@]}" ]; then
    local game="${console_games[$((num-1))]}"
    echo -n "IPv4 or IPv6? (4/6) [4]: "; read -r v; v="${v:-4}"
    echo -n "How many DNS you want? [200]: "; read -r n; n="${n:-200}"
    mapfile -t lst < <(build_dns_list_for_game "$game" "$v" "$n")
    echo; echo "DNS for $game [IPv$v]:"
    local i=1; for ip in "${lst[@]}"; do printf "%3d) %s\n" "$i" "$ip"; i=$((i+1)); done
    echo
    read -rp "Save full list? (y/N): " sv
    if [[ "$sv" =~ ^[Yy]$ ]]; then
      local file="dns_$(slugify "$game")_ipv${v}.txt"; : > "$file"
      for ip in "${lst[@]}"; do echo "$ip" >> "$file"; done
      echo "Saved ${#lst[@]} entries to ./$file"
    fi
    read -rp "Also save a 100-DNS download pack? (y/N): " sv2
    if [[ "$sv2" =~ ^[Yy]$ ]]; then
      local file="dns_download_pack_$(slugify "$game")_ipv${v}.txt"; : > "$file"
      printf "%s\n" "${lst[@]:0:100}" >> "$file"
      echo "Saved 100 entries to ./$file"
    fi
  fi
  print_footer; press_enter
}

search_game_dns() {
  show_title
  echo "Search DNS by Game + Device"
  read -rp "Game name: " game
  read -rp "Device/Platform (Mobile/PC/Console/etc.): " dev
  read -rp "IPv4 or IPv6? (4/6) [4]: " v; v="${v:-4}"
  read -rp "How many DNS? [200]: " n; n="${n:-200}"
  local label="$game"
  [ -n "$dev" ] && label="$game ($dev)"
  mapfile -t lst < <(build_dns_list_for_game "$label" "$v" "$n")
  echo; echo "DNS for $label [IPv$v]:"
  local i=1; for ip in "${lst[@]}"; do printf "%3d) %s\n" "$i" "$ip"; i=$((i+1)); done
  echo
  read -rp "Save to file? (y/N): " sv
  if [[ "$sv" =~ ^[Yy]$ ]]; then
    local file="dns_$(slugify "$label")_ipv${v}.txt"; : > "$file"
    for ip in "${lst[@]}"; do echo "$ip" >> "$file"; done
    echo "Saved ${#lst[@]} entries to ./$file"
  fi
  print_footer; press_enter
}

dns_generator_menu() {
  show_title
  echo "DNS Generator"
  echo "Choose Country:"
  echo "  1) Iran"
  echo "  2) UAE"
  echo "  3) Saudi Arabia"
  echo "  4) Turkey"
  read -rp "Select (1-4): " c
  case "$c" in
    1) cn="Iran";;
    2) cn="UAE";;
    3) cn="Saudi";;
    4) cn="Turkey";;
    *) echo "Invalid."; print_footer; press_enter; return;;
  esac
  read -rp "IPv4 or IPv6? (4/6) [4]: " v; v="${v:-4}"
  read -rp "How many DNS to generate? [50]: " n; n="${n:-50}"
  generate_dns_list "$cn" "$v" "$n"
  print_footer; press_enter
}

# -------- Main Menu (only 4 options) --------
main_menu() {
  while true; do
    show_title
    cat <<'EOF'
1) Mobile Games DNS
2) PC/Console Games DNS
3) Search Game DNS (by name + device)
4) DNS Generator (Iran/UAE/Saudi/Turkey)
0) Exit
EOF
    read -rp "Select: " opt
    case "$opt" in
      1) list_mobile_games ;;
      2) list_console_games ;;
      3) search_game_dns ;;
      4) dns_generator_menu ;;
      0) exit 0 ;;
      *) echo "Invalid option."; sleep 1 ;;
    esac
  done
}

# -------- Start --------
main_menu
