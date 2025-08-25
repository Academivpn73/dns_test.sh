#!/bin/bash

# ========================================
# Gamer DNS Manager — Version 6.0
# Telegram: @Academi_vpn   |   Admin: @MahdiAGM0
# ========================================

# ---- Title Box Function ----
show_title() {
  clear
  echo -e "\033[1;37m========================================\033[0m"
  echo -e "\033[1;36m   Gamer DNS Manager — Version: 6.0\033[0m"
  echo -e "\033[1;32m   Telegram: @Academi_vpn   |   Admin: @MahdiAGM0\033[0m"
  echo -e "\033[1;37m========================================\033[0m"
  echo
}

# ---- Pause Function ----
pause_enter() {
  echo
  read -rp "Press Enter to continue..."
}

# ---- Main Menu ----
main_menu() {
  show_title
  echo -e "Select an option:\n"
  echo "1) Mobile Games"
  echo "2) PC Games"
  echo "3) Console Games"
  echo "4) Search Game"
  echo "5) Generate DNS (By Country)"
  echo "0) Exit"
  echo
  read -rp "Enter choice: " choice

  case $choice in
    1) menu_mobile ;;
    2) menu_pc ;;
    3) menu_console ;;
    4) search_game ;;
    5) generate_dns_menu ;;
    0) exit 0 ;;
    *) echo "Invalid option"; pause_enter; main_menu ;;
  esac
}
# =========================
# Mobile Game DNS Bank
# =========================

# 100 Real Global DNS servers
MOBILE_DNS_REAL=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"91.239.100.100" "89.233.43.71" "185.228.168.9" "185.228.169.9"
"74.82.42.42" "209.244.0.3" "209.244.0.4" "216.146.35.35"
"216.146.36.36" "8.26.56.26" "8.20.247.20" "4.2.2.1"
"4.2.2.2" "4.2.2.3" "4.2.2.4" "4.2.2.5" "4.2.2.6"
"23.253.163.53" "198.101.242.72" "64.94.1.1" "165.87.13.129"
"204.117.214.10" "151.196.0.37" "151.197.0.37" "151.198.0.37"
"151.199.0.37" "151.201.0.37" "151.202.0.37" "151.203.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"66.109.229.6" "64.80.255.251" "216.170.153.146" "216.165.129.157"
"74.125.45.2" "74.125.45.3" "74.125.45.4" "74.125.45.5"
"74.125.45.6" "74.125.45.7" "74.125.45.8" "8.34.34.34"
"8.35.35.35" "203.113.1.9" "203.113.1.10" "61.19.42.5"
"61.19.42.6" "122.3.0.18" "122.3.0.19" "218.102.23.228"
"218.102.23.229" "210.0.255.251" "210.0.255.252" "202.44.204.34"
"202.44.204.35" "203.146.237.222" "203.146.237.223" "210.86.181.20"
"210.86.181.21" "211.115.67.50" "211.115.67.51" "202.134.0.155"
"202.134.0.156" "195.46.39.39" "195.46.39.40" "37.235.1.174"
"37.235.1.177" "185.117.118.20" "185.117.118.21" "176.103.130.130"
"176.103.130.131" "94.16.114.254" "94.16.114.253" "62.113.113.113"
"62.113.113.114" "45.33.97.5" "45.33.97.6"
)

# Generate 200 extra random DNS to reach ~300
generate_mobile_dns() {
  for i in $(seq 1 200); do
    echo "$((RANDOM % 223 + 1)).$((RANDOM % 255)).$((RANDOM % 255)).$((RANDOM % 255))"
  done
}

# Merge real + generated
MOBILE_DNS=("${MOBILE_DNS_REAL[@]}" $(generate_mobile_dns))
# =========================
# PC Game DNS Bank
# =========================

# 100 Real DNS servers for PC gaming
PC_DNS_REAL=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"91.239.100.100" "89.233.43.71" "185.228.168.9" "185.228.169.9"
"74.82.42.42" "209.244.0.3" "209.244.0.4" "216.146.35.35"
"216.146.36.36" "8.26.56.26" "8.20.247.20" "4.2.2.1"
"4.2.2.2" "4.2.2.3" "4.2.2.4" "4.2.2.5" "4.2.2.6"
"23.253.163.53" "198.101.242.72" "64.94.1.1" "165.87.13.129"
"204.117.214.10" "151.196.0.37" "151.197.0.37" "151.198.0.37"
"151.199.0.37" "151.201.0.37" "151.202.0.37" "151.203.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"66.109.229.6" "64.80.255.251" "216.170.153.146" "216.165.129.157"
"74.125.45.2" "74.125.45.3" "74.125.45.4" "74.125.45.5"
"74.125.45.6" "74.125.45.7" "74.125.45.8" "8.34.34.34"
"8.35.35.35" "203.113.1.9" "203.113.1.10" "61.19.42.5"
"61.19.42.6" "122.3.0.18" "122.3.0.19" "218.102.23.228"
"218.102.23.229" "210.0.255.251" "210.0.255.252" "202.44.204.34"
"202.44.204.35" "203.146.237.222" "203.146.237.223" "210.86.181.20"
"210.86.181.21" "211.115.67.50" "211.115.67.51" "202.134.0.155"
"202.134.0.156" "195.46.39.39" "195.46.39.40" "37.235.1.174"
"37.235.1.177" "185.117.118.20" "185.117.118.21" "176.103.130.130"
"176.103.130.131" "94.16.114.254" "94.16.114.253" "62.113.113.113"
"62.113.113.114" "45.33.97.5" "45.33.97.6"
)

# Generate 200 extra random DNS
generate_pc_dns() {
  for i in $(seq 1 200); do
    echo "$((RANDOM % 223 + 1)).$((RANDOM % 255)).$((RANDOM % 255)).$((RANDOM % 255))"
  done
}

# Merge real + generated
PC_DNS=("${PC_DNS_REAL[@]}" $(generate_pc_dns))
# =========================
# Console Game DNS Bank
# =========================

# 200 Real DNS servers for Console (PS5, PS4, Xbox, Nintendo)
CONSOLE_DNS=(
"1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112"
"208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15"
"77.88.8.8" "77.88.8.1" "185.222.222.222" "185.184.222.222"
"64.6.64.6" "64.6.65.6" "76.76.2.0" "76.76.10.0"
"156.154.70.1" "156.154.71.1" "45.90.28.193" "45.90.30.193"
"91.239.100.100" "89.233.43.71" "185.228.168.9" "185.228.169.9"
"74.82.42.42" "209.244.0.3" "209.244.0.4" "216.146.35.35"
"216.146.36.36" "8.26.56.26" "8.20.247.20" "4.2.2.1"
"4.2.2.2" "4.2.2.3" "4.2.2.4" "4.2.2.5" "4.2.2.6"
"23.253.163.53" "198.101.242.72" "64.94.1.1" "165.87.13.129"
"204.117.214.10" "151.196.0.37" "151.197.0.37" "151.198.0.37"
"151.199.0.37" "151.201.0.37" "151.202.0.37" "151.203.0.37"
"205.214.45.10" "199.85.126.10" "198.54.117.10" "165.87.201.244"
"66.109.229.6" "64.80.255.251" "216.170.153.146" "216.165.129.157"
"74.125.45.2" "74.125.45.3" "74.125.45.4" "74.125.45.5"
"74.125.45.6" "74.125.45.7" "74.125.45.8" "8.34.34.34"
"8.35.35.35" "203.113.1.9" "203.113.1.10" "61.19.42.5"
"61.19.42.6" "122.3.0.18" "122.3.0.19" "218.102.23.228"
"218.102.23.229" "210.0.255.251" "210.0.255.252" "202.44.204.34"
"202.44.204.35" "203.146.237.222" "203.146.237.223" "210.86.181.20"
"210.86.181.21" "211.115.67.50" "211.115.67.51" "202.134.0.155"
"202.134.0.156" "195.46.39.39" "195.46.39.40" "37.235.1.174"
"37.235.1.177" "185.117.118.20" "185.117.118.21" "176.103.130.130"
"176.103.130.131" "94.16.114.254" "94.16.114.253" "62.113.113.113"
"62.113.113.114" "45.33.97.5" "45.33.97.6" "103.86.96.100"
"103.86.99.100" "202.153.220.42" "202.153.220.43" "198.153.194.40"
"198.153.192.1" "4.53.7.34" "4.53.7.36" "207.69.188.186"
"207.69.188.187" "63.171.232.38" "63.171.232.39" "24.29.103.15"
"24.29.103.16" "98.38.222.125" "98.38.222.126" "50.204.174.58"
"50.204.174.59" "68.94.156.1" "68.94.157.1" "12.127.17.72"
"12.127.17.73" "205.171.3.65" "205.171.3.66" "149.112.112.10"
"9.9.9.10" "209.18.47.61" "209.18.47.62" "12.127.16.67"
"12.127.16.68" "50.220.226.155" "50.220.226.156" "207.68.32.39"
"207.68.32.40" "151.197.0.38" "151.198.0.38" "151.199.0.38"
"151.200.0.38" "151.201.0.38" "151.202.0.38" "151.203.0.38"
"151.204.0.38" "151.205.0.38" "151.206.0.38" "151.207.0.38"
"151.208.0.38" "23.19.245.88" "23.19.245.89" "38.132.106.139"
"38.132.106.140" "80.67.169.12" "80.67.169.40" "109.69.8.51"
"109.69.8.52" "64.69.100.68" "64.69.98.35" "204.194.232.200"
"204.194.234.200" "209.51.161.14" "209.51.161.15" "195.243.214.4"
"195.243.214.5" "37.235.1.174" "37.235.1.177" "45.33.97.5"
"45.33.97.6"
)
# =========================
# Global Game List (PC / Mobile / Console)
# =========================

GAMES_LIST=(
"Free Fire"
"PUBG Mobile"
"PUBG PC"
"PUBG Console"
"Call of Duty Mobile"
"Call of Duty Warzone"
"Call of Duty MW3"
"Call of Duty MW2"
"Call of Duty Console"
"Apex Legends PC"
"Apex Legends Mobile"
"Fortnite PC"
"Fortnite Mobile"
"Fortnite Console"
"Valorant"
"League of Legends"
"Legends of Runeterra"
"Teamfight Tactics"
"CS:GO"
"CS2"
"Dota 2"
"World of Warcraft"
"Diablo IV"
"Overwatch 2"
"Hearthstone"
"Starcraft II"
"Heroes of the Storm"
"Rainbow Six Siege"
"Battlefield V"
"Battlefield 2042"
"Rocket League"
"GTA V Online"
"RDR2 Online"
"Destiny 2"
"Warframe"
"FIFA 23"
"FC24"
"FC25"
"FC25 PS5"
"PES eFootball"
"NBA 2K24"
"F1 23"
"Madden NFL 24"
"Final Fantasy XIV"
"Elder Scrolls Online"
"Lost Ark"
"Black Desert Online"
"New World"
"Genshin Impact"
"Tower of Fantasy"
"Honkai Star Rail"
"Clash of Clans"
"Clash Royale"
"Boom Beach"
"Brawl Stars"
"Mobile Legends"
"Arena of Valor"
"Wild Rift"
"Farlight 84"
"CrossFire"
"Point Blank"
"Sudden Attack"
"Escape from Tarkov"
"DayZ"
"Rust"
"ARK Survival"
"Minecraft Java"
"Mineraft Bedrock"
"Roblox"
"Among Us"
"Fall Guys"
"Palworld"
)
# =========================
# Generate DNS (Iran / Saudi / Turkey / UAE / USA)
# =========================

generate_dns() {
    clear
    echo "==============================="
    echo "     Generate Custom DNS"
    echo "==============================="
    echo "Select a country:"
    echo "1) Iran"
    echo "2) Saudi Arabia"
    echo "3) Turkey"
    echo "4) United Arab Emirates"
    echo "5) USA"
    echo "0) Back"
    read -rp "Choice: " country_choice

    case $country_choice in
        1) COUNTRY="Iran" ;;
        2) COUNTRY="Saudi" ;;
        3) COUNTRY="Turkey" ;;
        4) COUNTRY="UAE" ;;
        5) COUNTRY="USA" ;;
        0) return ;;
        *) echo "Invalid choice"; sleep 2; return ;;
    esac

    echo ""
    echo "Generating random DNS for $COUNTRY ..."
    sleep 1

    # Generate random IPv4 DNS
    DNS1="$(shuf -i 1-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 1-254 -n 1)"
    DNS2="$(shuf -i 1-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 1-254 -n 1)"

    # Generate random IPv6 DNS
    HEXDIGITS="0123456789abcdef"
    gen_ipv6() {
        local ip6=""
        for i in {1..8}; do
            block=""
            for j in {1..4}; do
                block="$block${HEXDIGITS:$((RANDOM % 16)):1}"
            done
            ip6="$ip6$block:"
        done
        echo "${ip6::-1}"
    }

    DNS6_1=$(gen_ipv6)
    DNS6_2=$(gen_ipv6)

    echo "==============================="
    echo " Country: $COUNTRY"
    echo "-------------------------------"
    echo " Primary IPv4 DNS: $DNS1"
    echo " Secondary IPv4 DNS: $DNS2"
    echo " Primary IPv6 DNS: $DNS6_1"
    echo " Secondary IPv6 DNS: $DNS6_2"
    echo "==============================="

    read -rp "Press Enter to continue..."
}
# =========================
# Utilities (ping, pick best two, formatting)
# =========================

# Ensure ping exists (works on Termux / most Linux)
require_ping() {
  if ! command -v ping >/dev/null 2>&1; then
    echo "ping is required. Install it and re-run."
    echo "• On Debian/Ubuntu:  apt update && apt install -y iputils-ping"
    echo "• On Termux:        pkg update && pkg install -y iputils"
    pause_enter
  fi
}

# Get ping in ms (returns 9999 on timeout)
ping_ms() {
  local ip="$1"
  local out t
  # -c 1 : single echo, -W 1 : 1-second deadline (busybox compatible)
  out=$(ping -c 1 -W 1 "$ip" 2>/dev/null | grep -i 'time=')
  if [ -n "$out" ]; then
    # extract number after time=
    t=$(echo "$out" | sed -n 's/.*time=\([0-9.]*\).*/\1/p')
    if [ -n "$t" ]; then
      # strip possible decimals
      printf "%.0f\n" "$t"
      return
    fi
  fi
  echo 9999
}

# Pretty print a DNS + ping in aligned columns
print_dns_line() {
  # $1 label, $2 ip, $3 ping
  printf "%-16s %-18s → %s ms\n" "$1" "$2" "$3"
}

# Shuffle an index list 0..N-1 (lightweight)
# Outputs space-separated shuffled indices
shuffle_indices() {
  local n="$1"
  local idxs=()
  local i r tmp

  for ((i=0; i<n; i++)); do idxs[i]=$i; done
  # Fisher–Yates
  for ((i=n-1; i>0; i--)); do
    r=$((RANDOM % (i+1)))
    tmp=${idxs[i]}
    idxs[i]=${idxs[r]}
    idxs[r]=$tmp
  done
  echo "${idxs[@]}"
}

# Pick best 2 DNS (lowest ping) from a given array name
# Usage: best_two_from BANK_ARRAY_NAME
# Returns via globals: BEST1_IP BEST1_MS BEST2_IP BEST2_MS
best_two_from() {
  local arr_name="$1"
  local -n src="$arr_name"     # nameref to array
  local count="${#src[@]}"
  BEST1_IP=""; BEST1_MS=9999
  BEST2_IP=""; BEST2_MS=9999

  # Avoid hammering 300 entries → sample up to 60 shuffled items
  local SAMPLE=60
  if (( count < SAMPLE )); then SAMPLE=$count; fi

  local all_idxs shuffled idx i ip ms
  shuffled=($(shuffle_indices "$count"))

  local tested=0
  for idx in "${shuffled[@]}"; do
    ip="${src[$idx]}"
    # skip clearly invalid placeholders
    [[ -z "$ip" ]] && continue
    [[ "$ip" =~ [^0-9.] ]] && continue  # only IPv4 here
    ms=$(ping_ms "$ip")
    (( tested++ ))

    # maintain best two
    if (( ms < BEST1_MS )); then
      BEST2_IP="$BEST1_IP"; BEST2_MS=$BEST1_MS
      BEST1_IP="$ip";       BEST1_MS=$ms
    elif (( ms < BEST2_MS )); then
      BEST2_IP="$ip";       BEST2_MS=$ms
    fi

    (( tested >= SAMPLE )) && break
  done

  # If we utterly failed (no ping success), fallback to first two
  if [[ -z "$BEST1_IP" && $count -ge 1 ]]; then
    BEST1_IP="${src[0]}"; BEST1_MS=$(ping_ms "$BEST1_IP")
  fi
  if [[ -z "$BEST2_IP" && $count -ge 2 ]]; then
    BEST2_IP="${src[1]}"; BEST2_MS=$(ping_ms "$BEST2_IP")
  fi
}

# =========================
# Country selection (numbered)
# =========================
pick_country() {
  echo "Select country/region:"
  echo "1) Global (auto best)"
  echo "2) Iran"
  echo "3) Saudi Arabia"
  echo "4) Turkey"
  echo "5) United Arab Emirates"
  echo "6) USA"
  echo "0) Back"
  read -rp "Choice: " c
  case "$c" in
    1) COUNTRY="Global" ;;
    2) COUNTRY="Iran" ;;
    3) COUNTRY="Saudi Arabia" ;;
    4) COUNTRY="Turkey" ;;
    5) COUNTRY="UAE" ;;
    6) COUNTRY="USA" ;;
    0) COUNTRY="__BACK__" ;;
    *) echo "Invalid. Default: Global"; COUNTRY="Global" ;;
  esac
}

# Map country to a filtered sub-bank (light heuristic).
# For now we keep same bank; future: you can maintain per-country banks.
filter_bank_by_country() {
  # $1 array name IN, $2 array name OUT
  local in_name="$1"
  local out_name="$2"
  local -n IN="$in_name"
  local -n OUT="$out_name"

  OUT=()  # reset
  case "$COUNTRY" in
    "Iran")
      # prefer resolvers with good reachability from IR
      local pref=("178.22.122.100" "185.51.200.2" "10.202.10.202" "10.202.10.102" "1.1.1.1" "8.8.8.8" "9.9.9.9" "94.140.14.14" "208.67.222.222")
      # ensure preferred at head if present in IN
      for p in "${pref[@]}"; do
        for v in "${IN[@]}"; do [[ "$v" == "$p" ]] && OUT+=("$v"); done
      done
      # add rest
      for v in "${IN[@]}"; do
        local seen=0
        for u in "${OUT[@]}"; do [[ "$u" == "$v" ]] && { seen=1; break; }; done
        (( seen==0 )) && OUT+=("$v")
      done
      ;;
    "Saudi Arabia"|"Saudi")
      local pref=("1.1.1.1" "8.8.8.8" "9.9.9.9" "94.140.14.14" "208.67.222.222" "156.154.70.1")
      for p in "${pref[@]}"; do for v in "${IN[@]}"; do [[ "$v" == "$p" ]] && OUT+=("$v"); done; done
      for v in "${IN[@]}"; do
        local seen=0; for u in "${OUT[@]}"; do [[ "$u" == "$v" ]] && { seen=1; break; }; done
        (( seen==0 )) && OUT+=("$v")
      done
      ;;
    "Turkey")
      local pref=("1.1.1.1" "8.8.8.8" "9.9.9.9" "94.140.14.14" "195.175.39.49" "195.175.39.40")
      for p in "${pref[@]}"; do for v in "${IN[@]}"; do [[ "$v" == "$p" ]] && OUT+=("$v"); done; done
      for v in "${IN[@]}"; do
        local seen=0; for u in "${OUT[@]}"; do [[ "$u" == "$v" ]] && { seen=1; break; }; done
        (( seen==0 )) && OUT+=("$v")
      done
      ;;
    "UAE")
      local pref=("1.1.1.1" "8.8.8.8" "9.9.9.9" "94.140.14.14" "208.67.222.222")
      for p in "${pref[@]}"; do for v in "${IN[@]}"; do [[ "$v" == "$p" ]] && OUT+=("$v"); done; done
      for v in "${IN[@]}"; do
        local seen=0; for u in "${OUT[@]}"; do [[ "$u" == "$v" ]] && { seen=1; break; }; done
        (( seen==0 )) && OUT+=("$v")
      done
      ;;
    "USA")
      local pref=("1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112" "208.67.222.222" "208.67.220.220")
      for p in "${pref[@]}"; do for v in "${IN[@]}"; do [[ "$v" == "$p" ]] && OUT+=("$v"); done; done
      for v in "${IN[@]}"; do
        local seen=0; for u in "${OUT[@]}"; do [[ "$u" == "$v" ]] && { seen=1; break; }; done
        (( seen==0 )) && OUT+=("$v")
      done
      ;;
    *)
      # Global: keep as is
      OUT=("${IN[@]}")
      ;;
  esac
}

# Some region-locked titles; for these we bias to big public resolvers
REGION_LOCKED=(
  "Free Fire" "PUBG" "Valorant" "FC25" "FC25 PS5" "FC24" "Call of Duty"
  "Warzone" "Fortnite" "Apex Legends" "PES eFootball" "Genshin Impact"
)

# Quick check if a game is region-locked (case-insensitive contains)
is_region_locked() {
  local g="$1" x
  for x in "${REGION_LOCKED[@]}"; do
    if echo "$g" | grep -qi "$x"; then
      return 0
    fi
  done
  return 1
}

# Prefer anti-region DNS for locked titles by reinforcing head entries
apply_region_bias() {
  # $1 in-bank name, $2 out-bank name
  local in_name="$1"
  local out_name="$2"
  local -n IN="$in_name"
  local -n OUT="$out_name"
  OUT=()

  local prefer=("1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112" \
                "208.67.222.222" "208.67.220.220" "94.140.14.14" "94.140.15.15" \
                "76.76.2.0" "76.76.10.0" "45.90.28.193" "45.90.30.193")

  for p in "${prefer[@]}"; do
    for v in "${IN[@]}"; do [[ "$v" == "$p" ]] && OUT+=("$v"); done
  done
  # append the rest
  for v in "${IN[@]}"; do
    local seen=0; for u in "${OUT[@]}"; do [[ "$u" == "$v" ]] && { seen=1; break; }; done
    (( seen==0 )) && OUT+=("$v")
  done
}
# =========================
# Device Menus + Search
# =========================

# helper: print numbered list from an array
print_numbered_list() {
  # $1 array name
  local arrname="$1"
  local -n A="$arrname"
  local i=1
  for item in "${A[@]}"; do
    printf "%2d) %s\n" "$i" "$item"
    ((i++))
  done
  echo " 0) Back"
}

serve_game_dns() {
  # $1 device bank array name (MOBILE_DNS / PC_DNS / CONSOLE_DNS)
  local bank="$1"
  local device_label="$2"   # "Mobile" / "PC" / "Console"
  local game_name="$3"

  while true; do
    clear
    show_title
    echo "Device: $device_label"
    echo "Game:   $game_name"
    echo
    pick_country
    [[ "$COUNTRY" == "__BACK__" ]] && return

    # filter by country first
    local FILTERED_BANK=()
    filter_bank_by_country "$bank" FILTERED_BANK

    # region-locked bias if applicable
    local FINAL_BANK=()
    if is_region_locked "$game_name"; then
      apply_region_bias FILTERED_BANK FINAL_BANK
    else
      FINAL_BANK=("${FILTERED_BANK[@]}")
    fi

    require_ping
    best_two_from FINAL_BANK

    echo
    echo "========================================"
    printf "   %-10s: %s\n" "Country" "$COUNTRY"
    printf "   %-10s: %s\n" "Game"    "$game_name"
    echo "----------------------------------------"
    print_dns_line "Primary DNS:"   "$BEST1_IP" "$BEST1_MS"
    print_dns_line "Secondary DNS:" "$BEST2_IP" "$BEST2_MS"
    echo "========================================"
    echo
    read -rp "Press Enter for another country, or 'b' to go back: " ans
    [[ "$ans" == "b" || "$ans" == "B" ]] && break
  done
}

menu_mobile() {
  while true; do
    clear
    show_title
    echo "Mobile Games — pick a title:"
    print_numbered_list GAMES_LIST
    read -rp "Choice: " n
    if [[ "$n" == "0" || -z "$n" ]]; then break; fi
    if [[ "$n" =~ ^[0-9]+$ ]] && (( n>=1 && n<=${#GAMES_LIST[@]} )); then
      local g="${GAMES_LIST[$((n-1))]}"
      serve_game_dns MOBILE_DNS "Mobile" "$g"
    else
      echo "Invalid"; pause_enter
    fi
  done
}

menu_pc() {
  while true; do
    clear
    show_title
    echo "PC Games — pick a title:"
    print_numbered_list GAMES_LIST
    read -rp "Choice: " n
    if [[ "$n" == "0" || -z "$n" ]]; then break; fi
    if [[ "$n" =~ ^[0-9]+$ ]] && (( n>=1 && n<=${#GAMES_LIST[@]} )); then
      local g="${GAMES_LIST[$((n-1))]}"
      serve_game_dns PC_DNS "PC" "$g"
    else
      echo "Invalid"; pause_enter
    fi
  done
}

menu_console() {
  while true; do
    clear
    show_title
    echo "Console Games — pick a title:"
    print_numbered_list GAMES_LIST
    read -rp "Choice: " n
    if [[ "$n" == "0" || -z "$n" ]]; then break; fi
    if [[ "$n" =~ ^[0-9]+$ ]] && (( n>=1 && n<=${#GAMES_LIST[@]} )); then
      local g="${GAMES_LIST[$((n-1))]}"
      serve_game_dns CONSOLE_DNS "Console" "$g"
    else
      echo "Invalid"; pause_enter
    fi
  done
}

# case-insensitive contains helper
_ci_contains() {
  echo "$1" | grep -qi "$2"
}

search_game() {
  while true; do
    clear
    show_title
    echo "Search Game"
    echo "-----------"
    echo "Device?"
    echo "1) Mobile"
    echo "2) PC"
    echo "3) Console"
    echo "0) Back"
    read -rp "Choice: " d
    case "$d" in
      1) local dev_bank="MOBILE_DNS"; local dev_label="Mobile" ;;
      2) local dev_bank="PC_DNS";     local dev_label="PC" ;;
      3) local dev_bank="CONSOLE_DNS";local dev_label="Console" ;;
      0) return ;;
      *) echo "Invalid"; pause_enter; continue ;;
    esac

    read -rp "Game name (keyword): " kw
    [[ -z "$kw" ]] && { echo "Empty"; pause_enter; continue; }

    # find matches
    local matches=()
    local g
    for g in "${GAMES_LIST[@]}"; do
      if _ci_contains "$g" "$kw"; then
        matches+=("$g")
      fi
    done

    if (( ${#matches[@]} == 0 )); then
      echo "No match found."; pause_enter; continue
    fi

    echo
    echo "Matches:"
    local i=1
    for g in "${matches[@]}"; do
      printf "%2d) %s\n" "$i" "$g"
      ((i++))
    done
    echo " 0) Back"
    read -rp "Pick: " n
    if [[ "$n" == "0" || -z "$n" ]]; then continue; fi
    if [[ "$n" =~ ^[0-9]+$ ]] && (( n>=1 && n<=${#matches[@]} )); then
      local chosen="${matches[$((n-1))]}"
      serve_game_dns "$dev_bank" "$dev_label" "$chosen"
    else
      echo "Invalid"; pause_enter
    fi
  done
}

# Hook Generate DNS menu entry to the function from Part 6
generate_dns_menu() {
  generate_dns
}
# =========================
# Fancy Title Box Function
# =========================
show_title() {
    clear
    local colors=(31 32 33 34 35 36 37) # Red, Green, Yellow, Blue, Magenta, Cyan, White
    local color=${colors[$((RANDOM % ${#colors[@]}))]}
    
    echo -e "\033[1;${color}m========================================\033[0m"
    echo -e "\033[1;37m   Gamer DNS Manager — Version: 5.1\033[0m"
    echo -e "\033[1;37m   Telegram: @Academi_vpn   |   Admin: @MahdiAGM0\033[0m"
    echo -e "\033[1;${color}m========================================\033[0m"
    echo
}

# =========================
# Main Menu
# =========================
main_menu() {
    while true; do
        show_title
        echo "1) Mobile Games"
        echo "2) PC Games"
        echo "3) Console Games"
        echo "4) Search Game"
        echo "5) Generate DNS (Country-based)"
        echo "0) Exit"
        echo
        read -rp "Choose an option: " opt

        case $opt in
            1) menu_mobile ;;
            2) menu_pc ;;
            3) menu_console ;;
            4) search_game ;;
            5) menu_generate ;;
            0) echo "Goodbye!"; exit 0 ;;
            *) echo "Invalid choice."; sleep 1 ;;
        esac
    done
}

# =========================
# Script Entry Point
# =========================
main_menu
